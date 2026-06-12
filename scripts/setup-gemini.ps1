# ==============================================================================
# Setup Gemini/Antigravity CLI - Cross-Platform Deploy Script (Windows)
# ==============================================================================
# PowerShell script to run on Windows systems, leveraging windows-stow.ps1

Write-Host "=== Iniciando Configuração do Gemini/Antigravity CLI (Windows) ===" -ForegroundColor Blue

# 1. Detectar os CLIs disponíveis (pode possuir ambos instalados)
$available_clis = @()
if (Get-Command "gemini" -ErrorAction SilentlyContinue) {
    $available_clis += "gemini"
}
if (Get-Command "agy" -ErrorAction SilentlyContinue) {
    $available_clis += "agy"
}

if ($available_clis.Count -eq 0) {
    Write-Error "Nem 'gemini' CLI corporativo nem 'agy' (Antigravity CLI) foram detectados no PATH."
    Write-Host "Instale pelo menos um deles antes de rodar este script de setup." -ForegroundColor Red
    Exit 1
}

Write-Host "CLIs Ativos Detectados: $($available_clis -join ', ')" -ForegroundColor Green

# 2. Configurar Links Simbólicos delegando para o windows-stow.ps1 existente
Write-Host "`n[1/2] Criando Links Simbólicos via windows-stow.ps1..." -ForegroundColor Blue

$dotfiles_dir = Split-Path $PSScriptRoot -Parent
$windows_stow_script = Join-Path $dotfiles_dir "windows-stow.ps1"

if (Test-Path $windows_stow_script) {
    Write-Host "Executando windows-stow.ps1 para o pacote 'gemini'..." -ForegroundColor Gray
    # Executa o script de stow de forma nativa e segura
    & $windows_stow_script -Package gemini
} else {
    Write-Warning "O script windows-stow.ps1 não foi encontrado em: $windows_stow_script. Criando links de fallback manual..."
    
    $gemini_target = Join-Path $env:USERPROFILE ".gemini"
    $dotfiles_gemini = Join-Path $dotfiles_dir "gemini\.gemini"
    
    if (-not (Test-Path $gemini_target)) {
        New-Item -ItemType Directory -Path $gemini_target -Force | Out-Null
    }
    
    # fallback manual se windows-stow.ps1 não estiver lá
    $settings_src = Join-Path $dotfiles_gemini "settings.json"
    $settings_dest = Join-Path $gemini_target "settings.json"
    if (Test-Path $settings_src) {
        if (Test-Path $settings_dest) { Remove-Item $settings_dest -Force }
        New-Item -ItemType SymbolicLink -Path $settings_dest -Value $settings_src -Force | Out-Null
    }
    
    $agents_target = Join-Path $gemini_target "agents"
    if (-not (Test-Path $agents_target)) { New-Item -ItemType Directory -Path $agents_target -Force | Out-Null }
    
    $agents_src_folder = Join-Path $dotfiles_gemini "agents"
    if (Test-Path $agents_src_folder) {
        $agents = Get-ChildItem -Path $agents_src_folder -Filter *.md
        foreach ($agent in $agents) {
            $agent_dest = Join-Path $agents_target $agent.Name
            if (Test-Path $agent_dest) { Remove-Item $agent_dest -Force }
            New-Item -ItemType SymbolicLink -Path $agent_dest -Value $agent.FullName -Force | Out-Null
        }
    }
}

# 3. Instalar Extensões locais offline do ~/Projects/ para cada CLI ativo
Write-Host "`n[2/2] Instalando extensões locais do ~/Projects/ de forma offline..." -ForegroundColor Blue

$extensions = @("gemini-ext-backend-scalable", "gemini-ext-mobile-clean", "gemini-ext-modern-web-guidance", "gemini-ext-web-fsd")
$projects_folder = Join-Path $HOME "Projects"

foreach ($ext in $extensions) {
    $ext_path = Join-Path $projects_folder $ext
    if (Test-Path $ext_path) {
        foreach ($cli in $available_clis) {
            Write-Host "Instalando extensão via $cli de: $ext_path..." -ForegroundColor Yellow
            # Executa o CLI correto de forma nativa
            & $cli extensions install $ext_path --skip-settings --consent
            Write-Host "Extensão $ext instalada com sucesso no $cli!" -ForegroundColor Green
        }
    } else {
        Write-Host "[Aviso] Repositório da extensão não encontrado em: $ext_path" -ForegroundColor Red
    }
}

Write-Host "`n✔ Configuração concluída com sucesso!" -ForegroundColor Green
