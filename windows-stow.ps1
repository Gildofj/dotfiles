#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Stow-like symlink manager for Windows
.DESCRIPTION
    Creates symlinks from package directories to home directory, mimicking GNU Stow behavior.
    Expected structure: dotfiles/package_name/target_structure
    Example: dotfiles/powershell/.config/powershell/profile.d/aliases.ps1
             -> ~\.config\powershell\profile.d\aliases.ps1
.PARAMETER Package
    Package name(s) to stow. If not specified, stows all packages.
.PARAMETER Unstow
    Remove symlinks instead of creating them.
.PARAMETER DryRun
    Show what would be done without making changes.
#>

param(
    [string[]]$Package,
    [switch]$Unstow,
    [switch]$DryRun
)

$dotfilesDir = $PSScriptRoot
$targetDir = $env:USERPROFILE

function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

function Get-RelativePath {
    param([string]$From, [string]$To)
    $fromUri = New-Object System.Uri($From + "\")
    $toUri = New-Object System.Uri($To)
    return $fromUri.MakeRelativeUri($toUri).ToString().Replace("/", "\")
}

function New-SymbolicLinkSafe {
    param(
        [string]$Path,
        [string]$Target,
        [bool]$IsDirectory
    )
    
    if ($DryRun) {
        $type = if ($IsDirectory) { "Directory" } else { "File" }
        Write-ColorOutput "[DRY RUN] Would create $type symlink: $Path -> $Target" "Cyan"
        return $true
    }
    
    # Create parent directory if it doesn't exist
    $parentDir = Split-Path $Path -Parent
    if (-not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
        Write-ColorOutput "Created directory: $parentDir" "Gray"
    }
    
    try {
        if ($IsDirectory) {
            New-Item -ItemType SymbolicLink -Path $Path -Target $Target -Force | Out-Null
        } else {
            New-Item -ItemType SymbolicLink -Path $Path -Target $Target -Force | Out-Null
        }
        return $true
    } catch {
        Write-ColorOutput "Failed to create symlink: $_" "Red"
        return $false
    }
}

function Remove-SymbolicLinkSafe {
    param([string]$Path)
    
    if (-not (Test-Path $Path)) {
        return $false
    }
    
    $item = Get-Item $Path -Force
    if ($item.LinkType -ne "SymbolicLink") {
        Write-ColorOutput "Skipping $Path (not a symlink)" "Yellow"
        return $false
    }
    
    if ($DryRun) {
        Write-ColorOutput "[DRY RUN] Would remove symlink: $Path" "Cyan"
        return $true
    }
    
    try {
        Remove-Item $Path -Force
        return $true
    } catch {
        Write-ColorOutput "Failed to remove symlink: $_" "Red"
        return $false
    }
}

function Stow-Package {
    param([string]$PackageName)
    
    $packagePath = Join-Path $dotfilesDir $PackageName
    
    if (-not (Test-Path $packagePath)) {
        Write-ColorOutput "Package not found: $PackageName" "Red"
        return
    }
    
    Write-ColorOutput "`nProcessing package: $PackageName" "Green"
    
    # Get all files and directories in the package
    $items = Get-ChildItem $packagePath -Recurse -Force
    
    foreach ($item in $items) {
        # Get relative path from package root
        $relativePath = $item.FullName.Substring($packagePath.Length + 1)
        $targetPath = Join-Path $targetDir $relativePath
        
        if ($Unstow) {
            # Remove symlink
            if (Test-Path $targetPath) {
                if (Remove-SymbolicLinkSafe $targetPath) {
                    Write-ColorOutput "Removed: $relativePath" "Yellow"
                }
            }
        } else {
            # Create symlink
            if (Test-Path $targetPath) {
                $existing = Get-Item $targetPath -Force
                if ($existing.LinkType -eq "SymbolicLink") {
                    Write-ColorOutput "Already linked: $relativePath" "Gray"
                    continue
                } else {
                    Write-ColorOutput "Target exists (not a symlink): $relativePath" "Yellow"
                    continue
                }
            }
            
            $isDirectory = $item.PSIsContainer
            if (New-SymbolicLinkSafe $targetPath $item.FullName $isDirectory) {
                Write-ColorOutput "Linked: $relativePath" "Green"
            }
        }
    }
}

# Main execution
Write-ColorOutput "=== Stow-like Symlink Manager ===" "Cyan"
Write-ColorOutput "Dotfiles directory: $dotfilesDir"
Write-ColorOutput "Target directory: $targetDir"

if ($DryRun) {
    Write-ColorOutput "`n*** DRY RUN MODE - No changes will be made ***`n" "Yellow"
}

# Get packages to process
if ($Package) {
    $packages = $Package
} else {
    $packages = Get-ChildItem $dotfilesDir -Directory | Select-Object -ExpandProperty Name
}

# Process each package
foreach ($pkg in $packages) {
    Stow-Package $pkg
}

if ($Unstow) {
    Write-ColorOutput "`nUnstow complete!" "Green"
} else {
    Write-ColorOutput "`nStow complete!" "Green"
}
