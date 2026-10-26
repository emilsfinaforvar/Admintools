Write-Host "=== System Info ===" -ForegroundColor Cyan 
Write-Host "Hostname: $env:COMPUTERNAME" 
Write-Host "Last Boot Time: $((Get-CimInstance Win32_OperatingSystem).LastBootUpTime)"

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