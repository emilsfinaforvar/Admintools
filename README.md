Admintools är ett PowerShell inriktat verktyg utvecklat som en del av kursen adminscripting 
Du kan använda menyn för att köra olika administrativa och info relaterade skript.
Admintools innehåller flera moduler som kan köras via menyn.
[Project banner](Images/block.png)
## Systeminfo
Visa grundläggande info om datorn
Som datornamn operativsystem eller senaste tiden då det startades.
## Networkinfo
Visar nätverksinformation som
IVP4 adress eller Nätverkskort
Anslutningsinformation
## Running Services
Visar tjänster som kör nuvarande i Windows.
## Cpuinformation
Visar information om processorn
Modellnamn
Antal kärnor
Antal logiska processorer
Maximal klockfrekvens
## Projektstruktur

```text

adminToolkit/

│

├── scripts/

│ └── menu.ps1

│

├── modules/

│ ├── systeminfo.ps1

│ ├── network.ps1

│ ├── services.ps1

│ └── cpuinfo.ps1

│

├── logs/

│

└── README.md

│

└── .gitignore


```

---
## Loggningsinformation
Programmen använder loggfiler för att spara när programmen används.
Information som sparas
Datum och tid
Modulnamn
Användarnamn
Loggfiler sparas i denna mapp.
Loggfiler sparas i mappen:
```text
logs/

```

---
## Hur man kör skripten.
Öppna powershell eller visual studio code.
Navigera till projekt-mappen 
powershell 
cd admintoolkit
Gå till scripts mappen.
powershell
cd scripts
Starta programmet.
powershell 
.\menu.ps1

Välj senare ett alternativ ur listan.
## Tekniker som används
Projektet använder bland annat 
Powershell 
Get-Ciminstance
Get-Service
Get-NetIPAdress

## Författare.
Utvecklat som ett kursprojekt i adminscripting.