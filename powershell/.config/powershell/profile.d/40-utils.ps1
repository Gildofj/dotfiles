# Verify and load zoxide (smarter cd command)
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
} else {
    Write-Warning "zoxide is not installed. Run 'winget install ajeetdsouza.zoxide' to install it."
}
