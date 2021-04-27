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

    New-Item -Path $path -Name "ShowCortanaButton" -Value 0

    $path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search"

    If(-Not $(Test-Path $path)){
		New-Item -Path $path -Force
	}

    New-Item -Path $path -Name "SearchboxTaskbarMode" -Value 0


    #If registry key doesnt exist, create one
	If(-Not $(Test-Path "HKLM:\Software\Pertamina")){
		New-Item -Path "HKLM:\Software" -Name "Pertamina"
	}
    
    If(-Not $(Test-Path "HKLM:\Software\Pertamina\RFC")){
		New-Item -Path "HKLM:\Software\Pertamina" -Name "RFC"
	}

    #Set registry properties
	Set-ItemProperty -Path "HKLM:\Software\Pertamina\RFC" -Name "RFC00015-FirstLogin" -Value 1
}