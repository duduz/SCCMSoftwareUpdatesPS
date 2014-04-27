# List of Updates to SoftwareUpdateGroup Script
# Dudu D / AgileIT
#

### Declare Parameters for the script and validate they are not empty
Param(
  [ValidateNotNullorEmpty()]
  [string]$Scan,
  [ValidateNotNullorEmpty()]
  [string]$UpdatesFile,
  [ValidateNotNullorEmpty()]
  [string]$SUG,
  [ValidateNotNullorEmpty()]
  [string]$Logfile
)

### Verify PowerShell Version
$hostVersionInfo = (Get-Host).Version.Major
If ($hostVersionInfo -lt 3)
{
  Throw "You are using PowerShell $hostVersionInfo. In order to run this script it is required to use PowerShell 3 and up."
}

### Verify that PowerShell instance is x86
If ([Environment]::Is64BitProcess -eq $True) {
    Throw "ConfigMgr 2012 can be loaded only in PowerShell x86"
}

### Error Handling
$ErrorActionPreference = "SilentlyContinue"

### Load The SCCM 2012 Module
Set-ExecutionPolicy RemoteSigned -Force
$CMModulePath = $Env:SMS_ADMIN_UI_PATH.ToString().SubString(0,$Env:SMS_ADMIN_UI_PATH.Length - 5) + "\ConfigurationManager.psd1" 
If (-not (Get-Module ConfigurationManager)) { 
    Write-Host -ForegroundColor "Green" -BackgroundColor DarkGreen "Loading System Center Configuration Manager Module...." 
    Import-Module $CMModulePath -Verbose
    $CMPSDrive = Get-PSDrive -PSProvider CMSite
    Set-Location "$($CMPSDrive):"
}


#$Updates = Get-Content C:\Temp\updates.txt
#$LogFile = "C:\Temp\PSUpdates.log"
#$SUG = "Global Updates 04"

If($Scan) { 
    Write-Host "$NULL"
    Write-Host "Searching for Updates containing the following string: $Scan"
    Get-CMSoftwareUpdate -Name *$Scan* | Set-Variable ScanResults
    If (!$ScanResults) {
        Write-Host "No Updates for the following string were found $Scan"
        Exit
    }
    Else {
        $ScanResults | select LocalizedDisplayName, ArticleID, CI_ID | Format-Table -AutoSize
    Exit
    }
    $Scan = $NULL
}


If (!$UpdatesFile) { 
    Write-Host "$NULL"
    Write-Host "A path to gather a list of updates from must be specifed using -UpdatesFile"
    Write-Host "Syntax usage is: SCCMUpdatesV1.ps1 -UpdatesFile ""C:\temp\list1.txt"" -SUG ""Software Update Group 5"" -Logfile ""C:\Temp\Logfile.txt"""
    Exit
}
If (($UpdatesFile) -and (!$SUG)) {
    Write-Host "$NULL"
    Write-Host "Please provide a Software Update Group Name using -SUG"
    Write-Host "Syntax usage is: SCCMUpdatesV1.ps1 -UpdatesFile ""C:\temp\list1.txt"" -SUG ""Software Update Group 5"" -Logfile ""C:\Temp\Logfile.txt"""
    Exit
}
Else {  
        $CMPSDrive = Get-PSDrive -PSProvider CMSite
        $Updates = Get-Content $UpdatesFile | ? {$_.trim() -ne "" }
        foreach ($Update in $Updates) {
        If ($Logfile) {
                If ($?) {
            Write-Host -ForegroundColor "Green" -BackgroundColor DarkGreen KB$Update added sucessfully
            Write-Output "[OK] KB$Update added sucessfully" | Out-File -append -filepath $Logfile }
                Else {
            Write-Host -Background "Black" -ForegroundColor "Red" KB$Update failed to add.
            Write-Output "[BAD] KB$Update Failed." | Out-File -append -filepath $Logfile }
        }
        Else {
            If ($?) 
                 { Write-Host -ForegroundColor "Green" -BackgroundColor DarkGreen KB$Update added sucessfully }
            Else { Write-Host -Background "Black" -ForegroundColor "Red" KB$Update failed to add. }
        }
    }
}
