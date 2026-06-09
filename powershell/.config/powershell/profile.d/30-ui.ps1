# Verify and load oh-my-posh
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    $ompThemePath = "$env:USERPROFILE\.config\powershell\gildofj-spaceship.omp.json"
    if (Test-Path $ompThemePath) {
        oh-my-posh init pwsh --config $ompThemePath | Invoke-Expression
    } else {
        # Fallback to remote config if not yet stowed locally
        oh-my-posh init pwsh --config "https://raw.githubusercontent.com/Gildofj/oh-my-posh-themes/main/gildofj-spaceship.omp.json" | Invoke-Expression
    }
} else {
    Write-Warning "oh-my-posh is not installed. Run 'winget install JanDeDobbeleer.OhMyPosh' to install it."
}
