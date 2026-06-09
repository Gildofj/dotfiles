# Bash-like aliases with argument forwarding
if (-not (Get-Command cat -ErrorAction SilentlyContinue)) {
    Set-Alias cat Get-Content
}
Set-Alias mv Move-Item
Set-Alias rm Remove-Item
Set-Alias ps Get-Process

# A safe, fully compatible touch implementation
function touch {
    if ($args.Count -eq 0) {
        Write-Warning "touch: missing file operand"
        return
    }
    foreach ($file in $args) {
        if (Test-Path $file) {
            # Linux touch updates timestamp of existing files
            (Get-Item $file).LastWriteTime = Get-Date
        } else {
            # Create parent folder if it doesn't exist
            $parentDir = Split-Path $file -Parent
            if ($parentDir -and -not (Test-Path $parentDir)) {
                New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
            }
            New-Item $file -ItemType File | Out-Null
        }
    }
}

function head {
    param(
        [Parameter(ValueFromPipeline=$true, Position=0)]
        [string]$Path,
        [Parameter(Position=1)]
        [int]$Lines = 10
    )
    if ($Path) {
        Get-Content $Path -TotalCount $Lines -ErrorAction SilentlyContinue
    }
}

function tail {
    param(
        [Parameter(ValueFromPipeline=$true, Position=0)]
        [string]$Path,
        [Parameter(Position=1)]
        [int]$Lines = 10
    )
    if ($Path) {
        Get-Content $Path -Tail $Lines -ErrorAction SilentlyContinue
    }
}

function kill {
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        $ProcessId
    )
    Stop-Process -Id $ProcessId -Force
}

function which {
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [string]$Name
    )
    $cmd = Get-Command $Name -ErrorAction SilentlyContinue
    if ($cmd) {
        $cmd.Source
    } else {
        Write-Warning "which: no $Name in ($env:PATH)"
    }
}

function whichdir {
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [string]$Name
    )
    $cmd = Get-Command $Name -ErrorAction SilentlyContinue
    if ($cmd) {
        Split-Path -Parent $cmd.Source
    } else {
        Write-Warning "whichdir: no $Name in ($env:PATH)"
    }
}

function ln {
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Target,
        [Parameter(Mandatory=$true, Position=1)]
        [string]$Link
    )
    New-Item -ItemType SymbolicLink -Path $Link -Target $Target -Force
}
