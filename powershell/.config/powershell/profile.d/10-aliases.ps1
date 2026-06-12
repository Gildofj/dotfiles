# Basic Aliases
Set-Alias c clear
if (Get-Command fastfetch -ErrorAction SilentlyContinue) {
    Set-Alias ff fastfetch
}
if (Get-Command nvim -ErrorAction SilentlyContinue) {
    Set-Alias v nvim -Force
    Set-Alias vim nvim -Force
    Set-Alias vi nvim -Force
} elseif (Get-Command vim -ErrorAction SilentlyContinue) {
    Set-Alias v vim -Force
    Set-Alias vi vim -Force
} else {
    Set-Alias v vi -Force
}
if (Get-Command git -ErrorAction SilentlyContinue) {
    Set-Alias g git -Force
}

# Quick Directory Navigation
function .. { Set-Location .. }
function ... { Set-Location ..\.. }
function .... { Set-Location ..\..\.. }

# Modern CLI Tool Replacements & Fallbacks
if (Get-Command bat -ErrorAction SilentlyContinue) {
    Set-Alias cat bat -Force -Option AllScope
} else {
    Set-Alias cat Get-Content -Force -Option AllScope
}

if (Get-Command eza -ErrorAction SilentlyContinue) {
    function ls { eza --icons --git $args }
    function la { eza -a --icons --git $args }
    function ll { eza -la --icons --git $args }
} elseif (Get-Command lsd -ErrorAction SilentlyContinue) {
    function ls { lsd $args }
    function la { lsd -a $args }
    function ll { lsd -la $args }
} else {
    # Fallback to standard ls behavior
    function la { Get-ChildItem -Force $args }
    function ll { Get-ChildItem -Force $args | Format-Table }
}

# Profile Management Utility
function reload-profile {
    Write-Host "Reloading PowerShell Profile..." -ForegroundColor Cyan
    . $PROFILE
    Write-Host "Profile reloaded successfully!" -ForegroundColor Green
}
Set-Alias rld reload-profile
