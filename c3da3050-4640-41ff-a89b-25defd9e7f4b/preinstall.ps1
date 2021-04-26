# Functions
function Write-LogEntry {
    param(
        [parameter(Mandatory=$true, HelpMessage="Value added to the RemovedApps.log file.")]
        [ValidateNotNullOrEmpty()]
        [string]$Value,

        [parameter(Mandatory=$false, HelpMessage="Name of the log file that the entry will written to.")]
        [ValidateNotNullOrEmpty()]
        [string]$FileName = "MOTION-Update-PS.log"
    )
    # Determine log file location
    $LogFilePath = Join-Path -Path $env:windir -ChildPath "Temp\$($FileName)"

    # Add value to log file
    try {
        Out-File -InputObject $Value -Append -NoClobber -Encoding Default -FilePath $LogFilePath -ErrorAction Stop
    }
    catch [System.Exception] {
        Write-Warning -Message "Unable to append log entry to $($FileName) file"
    }
}

Write-LogEntry -Value "preinstall.ps1 Start"

### Power Configuration Begin
$CurrentPower = $(Get-WMIObject -NameSpace root\cimv2\power -ClassName win32_PowerPlan -Filter "IsActive=True").ElementName

if ($CurrentPower -ne 'PHM 24/7'){
    $Set24 = Get-WMIObject -NameSpace root\cimv2\power -ClassName win32_PowerPlan -Filter "ElementName='PHM 24/7'"
    $set24.InstanceID -match '\w{8}-\w{4}-\w{4}-\w{4}-\w{12}'
    powercfg /S $matches[0]
    
    Write-LogEntry -Value "Set power configuration to: PHM 24/7"
}

If(-Not $(Test-Path "HKLM:\Software\Pertamina\RFC")){
    New-Item -Path "HKLM:\Software\Pertamina" -Name "RFC"
}

If(-Not $(Test-Path "HKLM:\Software\Pertamina\RFC\RFC00015")){
    New-Item -Path "HKLM:\Software\Pertamina\RFC" -Name "RFC00015"
}

# Set registry properties
Set-ItemProperty -Path "HKLM:\Software\Pertamina\RFC\RFC00015" -Name "PreviousPower" -Value $CurrentPower
Write-LogEntry -Value "Set previous power configuration to: $($CurrentPower)"
### Power Configuration End


### Clean up Local Policy
If (Test-Path "C:\Windows\System32\GroupPolicy"){
    Remove-Item -Recurse -Force "C:\Windows\System32\GroupPolicy"
    Write-LogEntry -Value "Removing Local Machine Group Policy"
}


If (Test-Path "C:\Windows\System32\GroupPolicyUsers"){
    Remove-Item -Recurse -Force "C:\Windows\System32\GroupPolicyUsers"
    Write-LogEntry -Value "Removing Local User Group Policy"
}
###

Write-LogEntry -Value "preinstall.ps1 Complete"
