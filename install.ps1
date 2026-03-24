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

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  Dart VS Code - Class Setup" -ForegroundColor Cyan
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

# Download
Write-Host "Downloading dart_inclass_test.zip ..." -ForegroundColor Green
try {
    $ProgressPreference = 'SilentlyContinue'  # Speeds up Invoke-WebRequest
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $ZipPath -UseBasicParsing
} catch {
    Write-Host "ERROR: Download failed." -ForegroundColor Red
    Write-Host "  URL: $DownloadUrl" -ForegroundColor Red
    Write-Host "  $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Try downloading manually from the URL above." -ForegroundColor Yellow
    exit 1
}

$zipSize = [math]::Round((Get-Item $ZipPath).Length / 1MB, 1)
Write-Host "Downloaded ${zipSize} MB" -ForegroundColor Green

# Extract
Write-Host "Extracting to Desktop ..." -ForegroundColor Green
try {
    Expand-Archive -Path $ZipPath -DestinationPath "$env:USERPROFILE\Desktop" -Force
} catch {
    Write-Host "ERROR: Extraction failed. $_" -ForegroundColor Red
    exit 1
}

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
