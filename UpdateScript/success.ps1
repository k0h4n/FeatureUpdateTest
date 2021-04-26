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

Write-LogEntry -Value "Success.ps1 Start"

### Clean up Default App Start
# White list of Features On Demand V2 packages
$WhiteListOnDemand = "NetFX3|DirectX|Tools.DeveloperMode.Core|Language|InternetExplorer|ContactSupport|OneCoreUAP|WindowsMediaPlayer|Hello.Face|Notepad|MSPaint|PowerShell.ISE|ShellComponents"

# White list of appx packages to keep installed
$WhiteListedApps = New-Object -TypeName System.Collections.ArrayList
$WhiteListedApps.AddRange(@(
    "Microsoft.DesktopAppInstaller",
    "Microsoft.Office.OneNote",
    "Microsoft.Messaging", 
    "Microsoft.MSPaint",
    "Microsoft.Windows.Photos",
    "Microsoft.StorePurchaseApp",
    "Microsoft.MicrosoftOfficeHub",
    "Microsoft.MicrosoftStickyNotes",
    "Microsoft.WindowsAlarms",
    "Microsoft.WindowsCalculator", 
    "Microsoft.WindowsCommunicationsApps", # Mail, Calendar etc
    "Microsoft.WindowsSoundRecorder", 
    "Microsoft.WindowsStore"
))

# Windows 10 version 1809
$WhiteListedApps.AddRange(@(
    "Microsoft.ScreenSketch",
    "Microsoft.HEIFImageExtension",
    "Microsoft.VP9VideoExtensions",
    "Microsoft.WebMediaExtensions",
    "Microsoft.WebpImageExtension"
))

# Windows 10 version 1903
# No new apps

# Windows 10 version 1909
$WhiteListedApps.AddRange(@(
    "Microsoft.Outlook.DesktopIntegrationServicess"
))

# Windows 10 version 2004
$WhiteListedApps.AddRange(@(
    "Microsoft.VCLibs.140.00"
))

# Windows 10 version 20H2
$WhiteListedApps.AddRange(@(
    "Microsoft.MicrosoftEdge.Stable"
))

# Initial logging
Write-LogEntry -Value "Starting built-in AppxPackage, AppxProvisioningPackage and Feature on Demand V2 removal process"

# Determine provisioned apps
$AppArrayList = Get-AppxProvisionedPackage -Online | Select-Object -ExpandProperty DisplayName

# Loop through the list of appx packages
foreach ($App in $AppArrayList) {
    Write-LogEntry -Value "Processing appx package: $($App)"

    # If application name not in appx package white list, remove AppxPackage and AppxProvisioningPackage
    if (($App -in $WhiteListedApps)) {
        Write-LogEntry -Value "Skipping excluded application package: $($App)"
    }
    else {
        # Gather package names
        $AppPackageFullName = Get-AppxPackage -Name $App | Select-Object -ExpandProperty PackageFullName -First 1
        $AppProvisioningPackageName = Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like $App } | Select-Object -ExpandProperty PackageName -First 1
        
        #Clean up old app from user profile
        Get-AppxPackage -Name $App -All  | Remove-AppPackage -AllUsers

        # Attempt to remove AppxPackage
        if ($AppPackageFullName -ne $null) {
            try {
                Write-LogEntry -Value "Removing AppxPackage: $($AppPackageFullName)"
                Remove-AppxPackage -Package $AppPackageFullName -ErrorAction Stop | Out-Null
            }
            catch [System.Exception] {
                Write-LogEntry -Value "Removing AppxPackage '$($AppPackageFullName)' failed: $($_.Exception.Message)"
            }
        }
        else {
            Write-LogEntry -Value "Unable to locate AppxPackage for current app: $($App)"
        }

        # Attempt to remove AppxProvisioningPackage
        if ($AppProvisioningPackageName -ne $null) {
            try {
                Write-LogEntry -Value "Removing AppxProvisioningPackage: $($AppProvisioningPackageName)"
                Remove-AppxProvisionedPackage -PackageName $AppProvisioningPackageName -Online -ErrorAction Stop | Out-Null
            }
            catch [System.Exception] {
                Write-LogEntry -Value "Removing AppxProvisioningPackage '$($AppProvisioningPackageName)' failed: $($_.Exception.Message)"
            }
        }
        else {
            Write-LogEntry -Value "Unable to locate AppxProvisioningPackage for current app: $($App)"
        }
    }
}

Write-LogEntry -Value "Starting Features on Demand V2 removal process"

# Get Features On Demand that should be removed
try {
    $OSBuildNumber = Get-WmiObject -Class "Win32_OperatingSystem" | Select-Object -ExpandProperty BuildNumber

    # Handle cmdlet limitations for older OS builds
    if ($OSBuildNumber -le "16299") {
        $OnDemandFeatures = Get-WindowsCapability -Online -ErrorAction Stop | Where-Object { $_.Name -notmatch $WhiteListOnDemand -and $_.State -like "Installed" } | Select-Object -ExpandProperty Name
    }
    else {
        $OnDemandFeatures = Get-WindowsCapability -Online -LimitAccess -ErrorAction Stop | Where-Object { $_.Name -notmatch $WhiteListOnDemand -and $_.State -like "Installed" } | Select-Object -ExpandProperty Name
    }

    foreach ($Feature in $OnDemandFeatures) {
        try {
            Write-LogEntry -Value "Removing Feature on Demand V2 package: $($Feature)"

            # Handle cmdlet limitations for older OS builds
            if ($OSBuildNumber -le "16299") {
                Get-WindowsCapability -Online -ErrorAction Stop | Where-Object { $_.Name -like $Feature } | Remove-WindowsCapability -Online -ErrorAction Stop | Out-Null
            }
            else {
                Get-WindowsCapability -Online -LimitAccess -ErrorAction Stop | Where-Object { $_.Name -like $Feature } | Remove-WindowsCapability -Online -ErrorAction Stop | Out-Null
            }
        }
        catch [System.Exception] {
            Write-LogEntry -Value "Removing Feature on Demand V2 package failed: $($_.Exception.Message)"
        }
    }    
}
catch [System.Exception] {
    Write-LogEntry -Value "Attempting to list Feature on Demand V2 packages failed: $($_.Exception.Message)"
}

# Complete
Write-LogEntry -Value "Completed built-in AppxPackage, AppxProvisioningPackage and Feature on Demand V2 removal process"

### Clean up Default App End

### Power Configuration Begin
$PreviousPower = Get-ItemPropertyValue -Path "HKLM:\Software\Pertamina\RFC\RFC00015" -Name "PreviousPower"

if ($PreviousPower -ne 'PHM 24/7'){
    $Set24 = Get-WMIObject -NameSpace root\cimv2\power -ClassName win32_PowerPlan -Filter "ElementName='$PreviousPower'"
    $set24.InstanceID -match '\w{8}-\w{4}-\w{4}-\w{4}-\w{12}'
    powercfg /S $matches[0]
}
### Power Configuration End

Write-LogEntry -Value "Success.ps1 Complete"
