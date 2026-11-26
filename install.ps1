param(
    [switch]$NoActivate
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$pkgSource = Join-Path $scriptDir "dist\subtext-ui-dark.sublime-package"

if (-not (Test-Path $pkgSource)) {
    & (Join-Path $scriptDir "build.ps1")
}

$stRoot = Join-Path $env:APPDATA "Sublime Text"
if (-not (Test-Path $stRoot)) {
    $stRoot3 = Join-Path $env:APPDATA "Sublime Text 3"
    if (Test-Path $stRoot3) {
        $stRoot = $stRoot3
    } else {
        New-Item -ItemType Directory -Force -Path $stRoot | Out-Null
    }
}

$installedPkgs = Join-Path $stRoot "Installed Packages"
$userDir = Join-Path $stRoot "Packages\User"

New-Item -ItemType Directory -Force -Path $installedPkgs | Out-Null
New-Item -ItemType Directory -Force -Path $userDir | Out-Null

# Limpiar instalaciones previas descomprimidas para evitar conflictos
foreach ($old in @("Antigravity Theme", "subtext-ui-dark")) {
    $oldPath = Join-Path $stRoot "Packages\$old"
    if (Test-Path $oldPath) { Remove-Item -Recurse -Force $oldPath }
}
$oldPkg = Join-Path $installedPkgs "Antigravity Theme.sublime-package"
if (Test-Path $oldPkg) { Remove-Item -Force $oldPkg }

$pkgDest = Join-Path $installedPkgs "subtext-ui-dark.sublime-package"
Copy-Item -Force $pkgSource $pkgDest
Write-Host "[OK] Paquete instalado en: $pkgDest" -ForegroundColor Green

if (-not $NoActivate) {
    $prefsPath = Join-Path $userDir "Preferences.sublime-settings"
    $prefs = [ordered]@{}

    if (Test-Path $prefsPath) {
        $raw = (Get-Content $prefsPath -Raw) -replace '(?m)^\s*//.*$', ''
        if ($raw.Trim().Length -gt 0) {
            try {
                $parsed = $raw | ConvertFrom-Json
                foreach ($prop in $parsed.PSObject.Properties) {
                    $prefs[$prop.Name] = $prop.Value
                }
            } catch {
                $backup = "$prefsPath.bak"
                Copy-Item -Force $prefsPath $backup
                Write-Warning "No se pudo parsear Preferences.sublime-settings; se guardo copia en $backup"
            }
        }
    }

    $prefs["theme"] = "Antigravity.sublime-theme"
    $prefs["color_scheme"] = "Antigravity.sublime-color-scheme"
    $prefs["themed_title_bar"] = $true
    $prefs["overlay_scroll_bars"] = "enabled"

    $prefs | ConvertTo-Json -Depth 10 | Set-Content -Path $prefsPath -Encoding UTF8
    Write-Host "[OK] Tema activado en: $prefsPath" -ForegroundColor Green
}

Write-Host "`nListo! Abre o reinicia Sublime Text para ver el tema." -ForegroundColor Cyan
