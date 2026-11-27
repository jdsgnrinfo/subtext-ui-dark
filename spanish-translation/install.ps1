$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$srcDefault = Join-Path $scriptDir "Default"

if (-not (Test-Path $srcDefault)) {
    Write-Error "No se encontro la carpeta Default en: $srcDefault"
    exit 1
}

$stRoot = Join-Path $env:APPDATA "Sublime Text"
if (-not (Test-Path $stRoot)) {
    $stRoot3 = Join-Path $env:APPDATA "Sublime Text 3"
    if (Test-Path $stRoot3) { $stRoot = $stRoot3 } else { New-Item -ItemType Directory -Force -Path $stRoot | Out-Null }
}

$destDefault = Join-Path $stRoot "Packages\Default"
New-Item -ItemType Directory -Force -Path $destDefault | Out-Null
Copy-Item -Force "$srcDefault\*" $destDefault

Write-Host "[OK] Traduccion al espanol instalada en: $destDefault" -ForegroundColor Green
Write-Host "Reinicia Sublime Text para ver todos los menus y comandos en espanol." -ForegroundColor Cyan
