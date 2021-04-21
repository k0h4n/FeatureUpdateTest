@ECHO ON
Echo BEGIN preinstall.cmd >> %SystemRoot%\Temp\MOTION-Update-CMD.log

c:
cd /d %~dp0
cmd /c whoami >> %SystemRoot%\Temp\MOTION-Update-CMD.log

START Powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "preinstall.ps1"

Echo END preinstall.cmd >> %SystemRoot%\Temp\MOTION-Update-CMD.log
