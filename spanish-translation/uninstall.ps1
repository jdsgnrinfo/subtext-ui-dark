$ErrorActionPreference = "Stop"

$stDefault = Join-Path $env:APPDATA "Sublime Text\Packages\Default"
if (-not (Test-Path $stDefault)) {
    Write-Host "No se encontro una traduccion instalada en: $stDefault" -ForegroundColor Yellow
    exit 0
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$srcDefault = Join-Path $scriptDir "Default"

Get-ChildItem $srcDefault -File | ForEach-Object {
    $target = Join-Path $stDefault $_.Name
    if (Test-Path $target) {
        Remove-Item -Force $target
    }
}

Write-Host "[OK] Traduccion al espanol desinstalada. Sublime Text volvera al ingles al reiniciar." -ForegroundColor Green
