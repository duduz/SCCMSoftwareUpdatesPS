# List of Updates to SoftwareUpdateGroup Script
# Dudu D / AgileIT
#

### Declare Parameters for the script
Param(
  [string]$Scan,            # Specify -Scan for scanning updates and retreveing UpdateID's from the SUP
  [string]$UpdatesFile      # Specify filename of with list of Updates to add into to an exisiting SoftwareUpdateGroup
  [string]$LogFile          # Specify a path for a log file - will contains SUCCESS or Failed messages
)

### Error Handling
$ErrorActionPreference = "SilentlyContinue"

### Load The SCCM 2012 Management Module
Set-ExecutionPolicy RemoteSigned -Force
$CMModulePath = $Env:SMS_ADMIN_UI_PATH.ToString().SubString(0,$Env:SMS_ADMIN_UI_PATH.Length - 5) + "\ConfigurationManager.psd1" 
If (-not (Get-Module ConfigurationManager)) { 
    Write-Host -ForegroundColor "Green" -BackgroundColor DarkGreen "Loading System Center Configuration Manager Module...." 
    Import-Module $CMModulePath -Verbose
    $CMPSDrive = Get-PSDrive -PSProvider CMSite
    Set-Location "$($CMPSDrive):"
}


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
        $Scan = $NULL
        Exit
    }
   }


If (!$UpdatesFile) { 
    Write-Host "$NULL"
    Write-Host "Please provide a filename with a list of Updates."
    Write-Host "Syntax usage is: .\SCCMSoftwareUpdateGroup.ps1 -UpdatesFile ""C:\Temp\updates.txt"" -SUG ""Updates for February 2014"" -Logfile ""C:\Temp\PSUpdates.log"""
    Exit
}

$Updates = Get-Content $UpdatesFile
foreach ($Update in $Updates) {
    Add-CMSoftwareUpdateToGroup -SoftwareUpdateGroupName $SUG -SoftwareUpdateName *$Update* -ErrorAction SilentlyContinue
    
    If ($?) {
        Write-Host -ForegroundColor "Green" -BackgroundColor DarkGreen KB$Update added sucessfully
        Write-Output "[OK] KB$Update added sucessfully" | Out-File -append -filepath $Logfile }
    Else {
        Write-Host -Background "Black" -ForegroundColor "Red" KB$Update failed to add.
        Write-Output "[BAD] KB$Update Failed." | Out-File -append -filepath $Logfile }
