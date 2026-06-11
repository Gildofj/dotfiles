# Verify and load PSReadLine
if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module -Name PSReadLine
    
    # Configure PSReadLine Options for modern workflow (safely caught in non-VT/redirected contexts)
    try {
        Set-PSReadLineOption -PredictionSource HistoryAndPlugin
        Set-PSReadLineOption -PredictionViewStyle InlineView
        Set-PSReadLineOption -HistorySearchCursorMovesToEnd
    } catch {}
    
    # Keybindings for history search with Up/Down arrows (filters history by typed prefix)
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    
    # Tab completion menu (Ctrl+Space or Tab)
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
    
    # Color customizations to make it look premium and readable
    try {
        Set-PSReadLineOption -Colors @{
            InlinePrediction = 'DarkGray' # Subtle gray for autocomplete suggestions (respects theme)
        }
    } catch {}
} else {
    Write-Warning "PSReadLine module is not installed. Run 'Install-Module PSReadLine -Scope CurrentUser' to install it."
}

# Verify and load Terminal-Icons
if (Get-Module -ListAvailable -Name Terminal-Icons) {
    Import-Module -Name Terminal-Icons
} else {
    Write-Warning "Terminal-Icons module is not installed. Run 'Install-Module Terminal-Icons -Scope CurrentUser' to install it."
}
