@ECHO ON
Echo BEGIN preinstall.cmd >> c:\local\preinstall.log

c:
cd /d %~dp0
cmd /c whoami >> c:\local\preinstall.log

START Powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "preinstall.ps1"

Echo END preinstall.cmd >> c:\local\preinstall.log