using namespace System.Management.Automation
using namespace System.Text

[CmdletBinding()]
param()
Write-Host "===Harddrivevolume===" -ForegroundColor Cyan
if (($PSVersionTable.PSVersion.Major -gt 5) -and
  ($PSVersionTable.Platform -ne 'WIN32NT')) {
  $PSCmdlet.ThrowTerminatingError(
    [ErrorRecord]::new(
      [PSInvalidOperationException]::new('This operating system is not supported.'),
      'OSNotSupported',
      [ErrorCategory]::InvalidOperation,
      [System.Environment]::OSVersion
    )
  )
}

$CSharp1 = @'
[DllImport("kernel32.dll", SetLastError = true)]
public static extern IntPtr FindFirstVolume(
  [Out] StringBuilder VolumeName,
  UInt32 BufferLength
);

[DllImport("kernel32.dll", SetLastError = true)]
public static extern bool FindNextVolume(
  IntPtr FindVolume,
  [Out] StringBuilder VolumeName,
  UInt32 BufferLength
);

[DllImport("kernel32.dll", SetLastError = true)]
public static extern bool FindVolumeClose(
  IntPtr FindVolume
);

[DllImport("kernel32.dll", SetLastError=true)]
[return: MarshalAs(UnmanagedType.Bool)]
public static extern bool GetVolumePathNamesForVolumeNameW(
  [MarshalAs(UnmanagedType.LPWStr)] string VolumeName,
  [MarshalAs(UnmanagedType.LPWStr)] [Out] StringBuilder VolumeNamePaths,
  UInt32 BufferLength,
  ref UInt32 ReturnLength
);

[DllImport("kernel32.dll", SetLastError = true)]
public static extern uint QueryDosDevice(
  string DeviceName,
  StringBuilder TargetPath,
  UInt32 BufferLength
);

'@
Add-Type -MemberDefinition $CSharp1 -Name Win32Utils -Namespace PInvoke -Using PInvoke, System.Text

[UInt32] $ReturnLength     = 0
[UInt32] $MountPointLength = 260 # 260 = MAX_PATH
[UInt32] $VolumeNameLength = 50  # 50 = 49 characters plus 1 for the null
[UInt32] $DevicePathLength = 30  # 30 = 22 for "\Device\HarddiskVolume", 1 for the null, 7 for index

# The StringBuilder's constructor has several overloads. If you call the constructor with o single
# parameter, PowerShell will ALWAYS invoke `new([string] value)`. To invoke `new ([int] capacity)`,
# explicitly cast the parameter to Int.
$MountPoint = [StringBuilder]::new([Int]$MountPointLength)
$VolumeName = [StringBuilder]::new([Int]$VolumeNameLength)
$DevicePath = [StringBuilder]::new([Int]$DevicePathLength)

# Populate $VolumeName
[IntPtr] $VolumeHandle = [PInvoke.Win32Utils]::FindFirstVolume($VolumeName, $VolumeNameLength)
# TO DO: Check $VolumeHandle isn't INVALID_HANDLE_VALUE.
try {
  do {
    # Populate $MountPoint from $VolumeName
    [void][PInvoke.Win32Utils]::GetVolumePathNamesForVolumeNameW(
      $VolumeName.ToString(),
      $MountPoint,
      $MountPointLength,
      [Ref] $ReturnLength)

    # Populate $DevicePath from $VolumeName
    [void][PInvoke.Win32Utils]::QueryDosDevice(
      $VolumeName.ToString(4, $VolumeName.Length - 5),
      $DevicePath,
      $DevicePathLength)

    # Build the results
    $o = [PSCustomObject]@{
      Index = [Int]-1
      MountPoint = $MountPoint.ToString()
      VolumeName = $VolumeName.ToString()
      DevicePath = $DevicePath.ToString()
    }
    If ($o.DevicePath -match '\\Device\\HarddiskVolume(\d+)') {
      $o.Index = [Int]$Matches[1]
    }

    # Return the results
    $o
  } while ([PInvoke.Win32Utils]::FindNextVolume([IntPtr] $VolumeHandle, $VolumeName, $VolumeNameLength))
}
finally {
  [void][PInvoke.Win32Utils]::FindVolumeClose([IntPtr] $VolumeHandle)
}
Write-Host "Finished printing harddrive" -ForegroundColor Yellow
Get-Date
$Time = Get-date
Write-Output "$Time"

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