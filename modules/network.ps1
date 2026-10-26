Write-Host "=== Network Info ===" -ForegroundColor Cyan 
Get-NetIPAddress | Where-Object {$_.AddressFamily -eq "IPv4"} | 
Format-Table

# === Logging === 
$logPath = "..\logs"
# Create log folder if missing 
if (-not (Test-Path $logPath)) { 
New-Item -ItemType Directory -Path $logPath | Out-Null 
}

$moduleName = $MyInvocation.MyCommand.Name 
$logFile = Join-Path $logPath ($moduleName + ".log")
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss" 
$entry = "$timestamp - Ran module: $moduleName - User: $env:USERNAME"
Add-Content -Path $logFile -Value $entry