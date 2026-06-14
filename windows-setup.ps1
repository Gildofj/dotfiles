#Requires -RunAsAdministrator

# ============================================================================
# Windows Smart Setup Script (windows-setup.ps1)
# Implements visual interactive multi-select menu and deploys Windows dotfiles.
# ============================================================================

$logFile = "$HOME\setup.log"

# Logging function
function Log-Message {
    param([string]$Message, [string]$Color = "White")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $formattedMessage = "[$timestamp] $Message"
    Write-Host $formattedMessage -ForegroundColor $Color
    $formattedMessage | Out-File -FilePath $logFile -Append -Encoding utf8
}

# Check Administrator privileges
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Log-Message "Este script precisa ser executado como Administrador para criar os links simbólicos de forma segura." "Red"
    Log-Message "Por favor, abra o PowerShell como Administrador e execute novamente." "Red"
    Exit 1
}

# Interactive confirmation helper
function Ask-YesNo {
    param([string]$Prompt, [bool]$Default = $true)
    $suffix = if ($Default) { "[Y/n]" } else { "[y/N]" }
    Write-Host "$Prompt ${suffix}: " -NoNewline -ForegroundColor Yellow
    $resp = Read-Host
    if ([string]::IsNullOrWhiteSpace($resp)) {
        return $Default
    }
    if ($resp -match "^(y|yes|s|sim)$") {
        return $true
    }
    return $false
}

# Interactive visual multi-select using keyboard arrows & space
function Prompt-MultiSelect {
    param(
        [string]$Title,
        [string[]]$Options
    )

    $numOptions = $Options.Length
    $selected = [bool[]]::new($numOptions)
    for ($i = 0; $i -lt $numOptions; $i++) {
        $selected[$i] = $true # Selected by default
    }

    $cursor = 0
    
    # Hide cursor
    [Console]::CursorVisible = $false

    Write-Host "`n$Title" -ForegroundColor Cyan
    Write-Host "Use [↑/↓] para navegar, [Espaço] para marcar/desmarcar, [Enter] para confirmar." -ForegroundColor DarkGray

    # Pre-allocate blank lines to prevent scrolling issues when updating the menu
    for ($i = 0; $i -lt $numOptions; $i++) {
        Write-Host ""
    }
    $startRow = [Console]::CursorTop - $numOptions

    # Calculate max option length to pad options consistently and avoid trailing artifacts
    $maxWidth = 0
    foreach ($opt in $Options) {
        if ($opt.Length -gt $maxWidth) {
            $maxWidth = $opt.Length
        }
    }

    function Render-Options {
        [Console]::SetCursorPosition(0, $startRow)
        for ($i = 0; $i -lt $numOptions; $i++) {
            $checkbox = if ($selected[$i]) { "[✔]" } else { "[ ]" }
            $color = if ($selected[$i]) { "Green" } else { "White" }
            $paddedOption = $Options[$i].PadRight($maxWidth)

            if ($i -eq $cursor) {
                Write-Host " ➔ " -NoNewline -ForegroundColor Blue
                Write-Host $checkbox -NoNewline -ForegroundColor $color
                Write-Host " $paddedOption" -ForegroundColor Cyan
            } else {
                Write-Host "   " -NoNewline
                Write-Host $checkbox -NoNewline -ForegroundColor $color
                Write-Host " $paddedOption" -ForegroundColor Gray
            }
        }
    }

    Render-Options

    while ($true) {
        $key = [Console]::ReadKey($true)
        if ($key.Key -eq "UpArrow") {
            $cursor--
            if ($cursor -lt 0) { $cursor = $numOptions - 1 }
            Render-Options
        } elseif ($key.Key -eq "DownArrow") {
            $cursor++
            if ($cursor -ge $numOptions) { $cursor = 0 }
            Render-Options
        } elseif ($key.Key -eq "Spacebar") {
            $selected[$cursor] = -not $selected[$cursor]
            Render-Options
        } elseif ($key.Key -eq "Enter") {
            break
        }
    }

    # Restore cursor
    [Console]::CursorVisible = $true
    Write-Host ""

    # Return selected items
    $result = New-Object System.Collections.Generic.List[string]
    for ($i = 0; $i -lt $numOptions; $i++) {
        if ($selected[$i]) {
            $result.Add($Options[$i])
        }
    }
    return $result
}

# Winget Core Packages list
$WINGET_PACKAGES = @(
    "Neovim.Neovim"
    "Git.Git"
    "Microsoft.PowerShell"
    "Alacritty.Alacritty"
    "Wez.WezTerm"
    "junegunn.fzf"
    "BurntSushi.ripgrep"
    "sharkdp.bat"
    "sharkdp.fd"
    "ajeetdsouza.zoxide"
)

# Install packages
function Install-Packages {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Log-Message "[Aviso] 'winget' não foi encontrado neste sistema. Pulando a instalação de pacotes." "Yellow"
        return
    }

    $selected_pkgs = Prompt-MultiSelect "Selecione quais ferramentas você deseja instalar via Winget:" $WINGET_PACKAGES
    
    if ($selected_pkgs.Count -gt 0) {
        Log-Message "Instalando pacotes via Winget..." "Green"
        foreach ($pkg in $selected_pkgs) {
            Log-Message "Instalando ${pkg}..." "Cyan"
            try {
                winget install --id ${pkg} --silent --accept-package-agreements --accept-source-agreements | Out-Null
                Log-Message "${pkg} instalado com sucesso!" "Green"
            } catch {
                Log-Message "Falha ao instalar ${pkg}: $_" "Red"
            }
        }
    } else {
        Log-Message "Nenhum pacote selecionado para instalação." "Gray"
    }
}

# Stow packages matching Windows support
$STOW_PACKAGES = @(
    "editor-core"
    "nvim"
    "vim"
    "powershell"
    "glazewm"
    "alacritty"
    "wezterm"
)

# Setup dotfiles deploying
function Setup-Dotfiles {
    $selected_stow = Prompt-MultiSelect "Selecione quais pacotes você deseja configurar (linkar para o Home):" $STOW_PACKAGES

    if ($selected_stow.Count -eq 0) {
        Log-Message "Nenhum pacote selecionado para linkar." "Gray"
        return
    }

    # Dependency checking: if nvim or vim is selected, ensure editor-core is stowed first
    if ($selected_stow -contains "nvim" -or $selected_stow -contains "vim") {
        if (-not ($selected_stow -contains "editor-core")) {
            Log-Message "[Dependência] Vim/Neovim selecionados. Adicionando 'editor-core' automaticamente..." "Cyan"
            $selected_stow.Insert(0, "editor-core")
        }
    }

    Log-Message "Iniciando a configuração dos pacotes: [$(($selected_stow) -join ', ')]..." "Green"

    # Conflicting files mapping (Real files, not symlinks, to be cleaned up safely)
    $package_files = @{
        "editor-core" = @("$HOME\.editor_shared.vim", "$HOME\.exrc")
        "wezterm"     = @("$HOME\.wezterm.lua")
        "vim"         = @("$HOME\.vimrc", "$HOME\.ideavimrc")
    }

    $package_dirs = @{
        "nvim"       = "$HOME\.config\nvim"
        "alacritty"  = "$HOME\.config\alacritty"
        "powershell" = "$HOME\.config\powershell"
        "glazewm"    = "$HOME\.glzr"
    }

    # Safe Cleanup before link creation
    foreach ($config in $selected_stow) {
        # Check files
        if ($package_files.ContainsKey($config)) {
            foreach ($file in $package_files[$config]) {
                if (Test-Path $file) {
                    $item = Get-Item $file -Force
                    if ($item.LinkType -ne "SymbolicLink") {
                        Log-Message "Removendo arquivo existente real $file do pacote $config..." "Yellow"
                        Remove-Item $file -Force
                    }
                }
            }
        }

        # Check directories
        if ($package_dirs.ContainsKey($config)) {
            $dir = $package_dirs[$config]
            if (Test-Path $dir) {
                $item = Get-Item $dir -Force
                if ($item.LinkType -ne "SymbolicLink") {
                    Log-Message "Removendo diretório existente real $dir do pacote $config..." "Yellow"
                    Remove-Item $dir -Recurse -Force
                }
            }
        }
    }

    # Execute stowing by invoking windows-stow.ps1
    $stowScript = Join-Path $PSScriptRoot "windows-stow.ps1"
    if (Test-Path $stowScript) {
        foreach ($pkg in $selected_stow) {
            Log-Message "Linkando pacote via windows-stow: ${pkg}..." "Cyan"
            & $stowScript -Package $pkg
        }
    } else {
        Log-Message "Erro: Não foi possível encontrar o script 'windows-stow.ps1' na raiz!" "Red"
    }
}

# Main workflow
function Main {
    Log-Message "=== Iniciando Setup de Máquina Windows ===" "Cyan"
    
    if (Ask-YesNo "Deseja instalar as ferramentas de sistema recomendadas via Winget?") {
        Install-Packages
    }

    if (Ask-YesNo "Deseja linkar seus arquivos de configuração (dotfiles) usando o Stow Manager?") {
        Setup-Dotfiles
    }

    Log-Message "=== Setup do Windows finalizado! ===" "Green"
    Log-Message "Por favor, reinicie seu terminal para aplicar todas as mudanças." "Yellow"
}

# Run setup
Main
