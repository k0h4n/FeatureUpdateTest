#Version            : 1.0
#RFC Number         : RFC00015
#Script Objective   : First Login Settings
#Author             : Henry Thomas
#Last Update        : 27 April 2021

$ErrorActionPreference = 'Stop'

#Check the flag for RFC00015
If(-Not $(Get-ItemProperty -Path "HKCU:\Software\Pertamina\RFC" -Name RFC00015-FirstLogin -ErrorAction SilentlyContinue)){
	
    $path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    
    If(-Not $(Test-Path $path)){
		New-Item -Path $path -Force
	}

    Set-ItemProperty -Path $path -Name "ShowCortanaButton" -Value 0

    $path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search"

	Add-AppxPackage -DisableDevelopmentMode -Register "C:\Program Files\WindowsApps\Microsoft.WindowsCalculator_10.1906.55.0_x64__8wekyb3d8bbwe\AppXManifest.xml"
	Add-AppxPackage -DisableDevelopmentMode -Register "C:\Program Files\WindowsApps\Microsoft.ScreenSketch_10.1907.2471.0_x64__8wekyb3d8bbwe\AppXManifest.xml"
	Add-AppxPackage -DisableDevelopmentMode -Register "C:\Program Files\WindowsApps\Microsoft.WindowsAlarms_10.1906.2182.0_x64__8wekyb3d8bbwe\AppXManifest.xml"
	Add-AppxPackage -DisableDevelopmentMode -Register "C:\Program Files\WindowsApps\Microsoft.WindowsSoundRecorder_10.1906.1972.0_x64__8wekyb3d8bbwe\AppXManifest.xml"
	Add-AppxPackage -DisableDevelopmentMode -Register "C:\Program Files\WindowsApps\Microsoft.MicrosoftStickyNotes_3.6.73.0_x64__8wekyb3d8bbwe\AppXManifest.xml"

	### Change to Best Performance
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2
	Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name UserPreferencesMask -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00))
	###
    
    If(-Not $(Test-Path $path)){
		New-Item -Path $path -Force
	}

    Set-ItemProperty -Path $path -Name "SearchboxTaskbarMode" -Value 0

    #If registry key doesnt exist, create one
	If(-Not $(Test-Path "HKCU:\Software\Pertamina")){
		New-Item -Path "HKCU:\Software" -Name "Pertamina"
	}
    
    If(-Not $(Test-Path "HKCU:\Software\Pertamina\RFC")){
		New-Item -Path "HKCU:\Software\Pertamina" -Name "RFC"
	}

    #Set registry properties
	Set-ItemProperty -Path "HKCU:\Software\Pertamina\RFC" -Name "RFC00015-FirstLogin" -Value 1
}
