Clear-Host 
function Show-Menu {
Write-Host "==============================="
Write-Host " Admin Menu" -ForegroundColor Cyan
Write-Host "==============================="
Write-Host "1. System Information" -ForegroundColor Green
Write-Host "2. Network Information" -ForegroundColor Magenta
Write-Host "3. Running Services" -ForegroundColor Yellow
Write-Host "4. List harddrive volume" -ForegroundColor White
Write-Host "0. Exit" -ForegroundColor Red
Write-Host "==============================="
Write-Host "OS Version: $((Get-CimInstance Win32_OperatingSystem).Version)"
}


function Run-Choice {
param($choice)
switch ($choice) {
1 {
Write-Host "Running System Information..." -ForegroundColor Cyan
& "..\modules\systeminfo.ps1"
}

2 {
Write-Host "Running Network Information..." -ForegroundColor DarkCyan
& "..\modules\network.ps1"
}


3 {
Write-Host "Running Services..." -ForegroundColor Yellow
& "..\modules\services.ps1"
}

4 {
Write-Host "List harddrivevolume." -ForegroundColor White
& "..\modules\listharddrivevolume.ps1"
}

0 {
Write-Host "Exiting..." -ForegroundColor Yellow
Exit
}

default {
Write-Host "Invalid choice, try again." -ForegroundColor Red
      }
    }
}

# --- Main Loop ---
do {
Show-Menu
$choice = Read-Host "Enter your choice"
Run-Choice $choice
Write-Host ""
} while ($true)    