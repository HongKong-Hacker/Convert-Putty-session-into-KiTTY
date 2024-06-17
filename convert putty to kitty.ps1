# Get the system's temporary directory
$TempDirectory = [System.IO.Path]::GetTempPath()

# Check if the temporary directory exists, and create it if not
if (-not (Test-Path -Path $TempDirectory)) {
    Write-Host "The temporary directory does not exist. Creating it..." -ForegroundColor Cyan
    New-Item -Path $TempDirectory -ItemType Directory | Out-Null
    Write-Host "Directory created successfully." -ForegroundColor Green
    Write-Host ""
}

# Check if the PuTTYSettings.reg file exists and delete it if it does
$RegistryExportFile = "$TempDirectory\PuTTYSettings.reg"
if (Test-Path -Path $RegistryExportFile) {
    Write-Host "Deleting existing PuTTYSettings.reg file..." -ForegroundColor Cyan
    Remove-Item -Path $RegistryExportFile
    Write-Host "Existing file deleted." -ForegroundColor Green
    Write-Host ""
}

# Export the HKEY_CURRENT_USER\Software\SimonTatham\PuTTY registry key to a file
Write-Host "Exporting HKEY_CURRENT_USER\Software\SimonTatham\PuTTY registry key to a file..." -ForegroundColor Cyan
$SourceKey = "HKEY_CURRENT_USER\Software\SimonTatham\PuTTY"
$DestinationKey = "HKEY_CURRENT_USER\Software\9bis.com\KiTTY"
reg export $SourceKey $RegistryExportFile
Write-Host "Registry key exported to $RegistryExportFile" -ForegroundColor Green
Write-Host ""

# Replace the "SimonTatham\PuTTY" text with "9bis.com\KiTTY" in the exported file
Write-Host "Replacing 'SimonTatham\PuTTY' with '9bis.com\KiTTY' in the exported file..." -ForegroundColor Cyan
$RegistryContent = Get-Content -Path $RegistryExportFile -Encoding Unicode
$RegistryContent = $RegistryContent.Replace("SimonTatham\PuTTY", "9bis.com\KiTTY")
Set-Content -Path $RegistryExportFile -Value $RegistryContent -Encoding Unicode
Write-Host "Text replacement complete." -ForegroundColor Green
Write-Host ""

# Ask for confirmation before clearing the HKEY_CURRENT_USER\Software\9bis.com\KiTTY registry key
Write-Host "Do you want to clear the KiTTY session before import from PuTTY? (Y/N)" -ForegroundColor Red -NoNewline
$ConfirmClear = Read-Host
if ($ConfirmClear.ToUpper() -eq "Y") {
    # Clear the HKEY_CURRENT_USER\Software\9bis.com\KiTTY registry key
    Write-Host "Clearing HKEY_CURRENT_USER\Software\9bis.com\KiTTY registry key..." -ForegroundColor Cyan
    reg delete $DestinationKey /f
    Write-Host "HKEY_CURRENT_USER\Software\9bis.com\KiTTY registry key cleared." -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host "Skipping the clearing of HKEY_CURRENT_USER\Software\9bis.com\KiTTY registry key." -ForegroundColor Yellow
    Write-Host ""
}

# Import the modified registry file into the destination key
Write-Host "Importing the modified registry file into HKEY_CURRENT_USER\Software\9bis.com\KiTTY..." -ForegroundColor Cyan
reg import $RegistryExportFile
Write-Host "Registry file imported successfully." -ForegroundColor Green
Write-Host ""

# Delete the temporary registry export file
Write-Host "Deleting the temporary registry export file..." -ForegroundColor Cyan
Remove-Item -Path $RegistryExportFile
Write-Host "Temporary file deleted." -ForegroundColor Green
Write-Host ""

Write-Host "Script execution complete." -ForegroundColor Green