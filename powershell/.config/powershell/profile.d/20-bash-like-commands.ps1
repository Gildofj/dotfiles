Set-Alias cat Get-Content  
Set-Alias mv Move-Item
Set-Alias rm Remove-Item
Set-Alias ps Get-Process

function touch($file) {
  New-Item $file -ItemType File
}

function head($file) {
  (Get-Content $file -TotalCount 10)
}

function tail($file) {
  (Get-Content $file -Tail 10)
}

function kill($processId) {
  Stop-Process -Id $processId
}

function which($name) {
  Get-Command $name | Select-Object -ExpandProperty Definition
}

function whichdir($name) {
  $directory = Split-Path -Parent (Get-Command $name | Select-Object -ExpandProperty Definition)
  return $directory
}

function ln($target, $link) {
    New-Item -ItemType SymbolicLink -Path $link -Target $target
}
