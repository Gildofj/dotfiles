# Fuzzy finding integration using the native fzf binary

if (Get-Command fzf -ErrorAction SilentlyContinue) {
    
    # 1. Fuzzy shell history search (Ctrl+R)
    # Reads the PSReadLine persistent history, queries with what has already been typed,
    # and updates the prompt buffer with the selected command.
    function Invoke-FzfHistory {
        $line = ""
        $cursor = 0
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
        
        $historyFile = [Microsoft.PowerShell.PSConsoleReadLine]::GetHistorySavePath()
        $historyList = @()
        
        # Load from persistent history file
        if (Test-Path $historyFile) {
            $historyList = Get-Content $historyFile -Tail 2000 | Select-Object -Unique
            [array]::Reverse($historyList)
        }
        
        # Load from current session history
        $sessionHistory = Get-History -Count 1000 | Select-Object -ExpandProperty CommandLine
        if ($sessionHistory) {
            [array]::Reverse($sessionHistory)
            $historyList = ($sessionHistory + $historyList) | Select-Object -Unique
        }
        
        if ($historyList) {
            # Run fzf with reverse layout, height matching prompt, pre-filtered with current buffer
            $selected = $historyList | fzf --height=40% --layout=reverse --border --query=$line --prompt="History Search > "
            if ($selected) {
                [Microsoft.PowerShell.PSConsoleReadLine]::DeleteLine()
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert($selected)
            }
        }
    }
    
    # Bind Ctrl+R to the fuzzy history function
    if (Get-Module -ListAvailable -Name PSReadLine) {
        Set-PSReadLineKeyHandler -Key Ctrl+r -ScriptBlock { Invoke-FzfHistory }
    }

    # 2. Fuzzy Change Directory (fcd)
    # Search directories up to 3 levels deep, excluding hidden/git folders, and cd into selection
    function fcd {
        $dir = Get-ChildItem -Directory -Recurse -Depth 3 -ErrorAction SilentlyContinue | 
            Where-Object { $_.FullName -notlike '*\.git\*' } |
            Select-Object -ExpandProperty FullName |
            fzf --height=40% --layout=reverse --border --prompt="Change Directory > "
        if ($dir) {
            Set-Location $dir
        }
    }

    # 3. Fuzzy Open File (fv)
    # Search files up to 4 levels deep, excluding git and node_modules, and open with Neovim or VS Code
    function fv {
        $file = Get-ChildItem -File -Recurse -Depth 4 -ErrorAction SilentlyContinue |
            Where-Object { $_.FullName -notlike '*\.git\*' -and $_.FullName -notlike '*\node_modules\*' } |
            Select-Object -ExpandProperty FullName |
            fzf --height=40% --layout=reverse --border --prompt="Open with Editor > "
        if ($file) {
            if (Get-Command nvim -ErrorAction SilentlyContinue) {
                nvim $file
            } elseif (Get-Command code -ErrorAction SilentlyContinue) {
                code $file
            } else {
                Start-Process $file
            }
        }
    }

} else {
    Write-Warning "fzf is not installed. Run 'winget install junkvale.fzf' to install it and enable fuzzy utilities."
}
