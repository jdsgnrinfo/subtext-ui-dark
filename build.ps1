$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$rootDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$distDir = Join-Path $rootDir "dist"
$pkgPath = Join-Path $distDir "subtext-ui-dark.sublime-package"

New-Item -ItemType Directory -Force -Path $distDir | Out-Null
if (Test-Path $pkgPath) { Remove-Item -Force $pkgPath }

$includeFiles = @(
    "Antigravity.sublime-color-scheme",
    "Antigravity.sublime-theme"
)

$zip = [System.IO.Compression.ZipFile]::Open($pkgPath, [System.IO.Compression.ZipArchiveMode]::Create)
try {
    foreach ($file in $includeFiles) {
        $full = Join-Path $rootDir $file
        [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $full, $file, [System.IO.Compression.CompressionLevel]::Optimal) | Out-Null
    }
    $assetsDir = Join-Path $rootDir "assets"
    Get-ChildItem -Path $assetsDir -Recurse -File | ForEach-Object {
        $rel = "assets/" + $_.FullName.Substring($assetsDir.Length + 1).Replace('\', '/')
        [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $_.FullName, $rel, [System.IO.Compression.CompressionLevel]::Optimal) | Out-Null
    }
} finally {
    $zip.Dispose()
}

Write-Host "[OK] Paquete generado en: $pkgPath" -ForegroundColor Green
