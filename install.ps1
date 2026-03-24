<#
.SYNOPSIS
    Downloads and extracts the portable Dart VS Code environment for class.
.DESCRIPTION
    Students run this script with a single PowerShell command.
    It downloads the zip, extracts it to the Desktop, and launches the editor.
.USAGE
    From PowerShell:
      irm https://raw.githubusercontent.com/manighahrmani/dart_inclass_test_vscode/main/install.ps1 | iex

    Or if downloaded locally:
      .\install.ps1
#>

$ErrorActionPreference = "Stop"

$DownloadUrl = "https://github.com/manighahrmani/dart_inclass_test_vscode/releases/latest/download/dart_inclass_test.zip"
$DestFolder = "$env:USERPROFILE\Desktop\dart_inclass_test"
$ZipPath = "$env:TEMP\dart_inclass_test.zip"
$FallbackUrl = "https://github.com/manighahrmani/dart_inclass_test_vscode/releases/latest"

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  Dart VS Code - In-Class Test Setup" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Check if already installed
if (Test-Path $DestFolder) {
    Write-Host "Found existing installation at: $DestFolder" -ForegroundColor Yellow
    $response = Read-Host "Overwrite? (y/N)"
    if ($response -ne 'y' -and $response -ne 'Y') {
        Write-Host "Cancelled. Launching existing installation..." -ForegroundColor Yellow
        Start-Process "$DestFolder\DOUBLE_CLICK_ME_TO_START_TEST.bat"
        exit 0
    }
    Remove-Item $DestFolder -Recurse -Force
}

# Download with progress (curl.exe is built into Windows 10/11)
Write-Host "Downloading dart_inclass_test.zip ..." -ForegroundColor Green
$downloadTimer = [System.Diagnostics.Stopwatch]::StartNew()
try {
    & curl.exe -L -o $ZipPath --progress-bar $DownloadUrl
    if ($LASTEXITCODE -ne 0) { throw "curl.exe exited with code $LASTEXITCODE" }
} catch {
    Write-Host ""
    Write-Host "ERROR: Download failed. $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "BACKUP METHOD:" -ForegroundColor Yellow
    Write-Host "  1. Open in browser: $FallbackUrl" -ForegroundColor Yellow
    Write-Host "  2. Download dart_inclass_test.zip manually" -ForegroundColor Yellow
    Write-Host "  3. Extract the zip to your Desktop" -ForegroundColor Yellow
    Write-Host "  4. Double-click DOUBLE_CLICK_ME_TO_START_TEST.bat" -ForegroundColor Yellow
    exit 1
}
$downloadTimer.Stop()

$zipSize = [math]::Round((Get-Item $ZipPath).Length / 1MB, 1)
Write-Host "Downloaded ${zipSize} MB in $([math]::Round($downloadTimer.Elapsed.TotalSeconds, 1))s" -ForegroundColor Green

# Extract with tar (much faster than Expand-Archive)
Write-Host "Extracting to Desktop ..." -ForegroundColor Green
$extractTimer = [System.Diagnostics.Stopwatch]::StartNew()
try {
    & tar -xf $ZipPath -C "$env:USERPROFILE\Desktop"
    if ($LASTEXITCODE -ne 0) { throw "tar exited with code $LASTEXITCODE" }
} catch {
    Write-Host "tar failed, falling back to Expand-Archive (slower) ..." -ForegroundColor Yellow
    try {
        Expand-Archive -Path $ZipPath -DestinationPath "$env:USERPROFILE\Desktop" -Force
    } catch {
        Write-Host ""
        Write-Host "ERROR: Extraction failed. $_" -ForegroundColor Red
        Write-Host ""
        Write-Host "BACKUP METHOD:" -ForegroundColor Yellow
        Write-Host "  1. The zip is at: $ZipPath" -ForegroundColor Yellow
        Write-Host "  2. Right-click it -> Extract All -> choose Desktop" -ForegroundColor Yellow
        Write-Host "  3. Double-click DOUBLE_CLICK_ME_TO_START_TEST.bat" -ForegroundColor Yellow
        exit 1
    }
}
$extractTimer.Stop()
Write-Host "Extracted in $([math]::Round($extractTimer.Elapsed.TotalSeconds, 1))s" -ForegroundColor Green

# Cleanup zip
Remove-Item $ZipPath -Force -ErrorAction SilentlyContinue

# Verify
if (-not (Test-Path "$DestFolder\DOUBLE_CLICK_ME_TO_START_TEST.bat")) {
    Write-Host "ERROR: Extraction succeeded but expected files not found." -ForegroundColor Red
    Write-Host "Check $env:USERPROFILE\Desktop for the extracted folder." -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Done! Installed to: $DestFolder" -ForegroundColor Green
Write-Host "Launching editor..." -ForegroundColor Green
Write-Host ""

# Launch
Start-Process "$DestFolder\DOUBLE_CLICK_ME_TO_START_TEST.bat"
