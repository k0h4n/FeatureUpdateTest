@ECHO ON
Echo BEGIN precommit.cmd >> %SystemRoot%\Temp\MOTION-Update-CMD.log

c:
cd /d %~dp0
cmd /c whoami >> %SystemRoot%\Temp\MOTION-Update-CMD.log

START Powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "precommit.ps1"

Echo END precommit.cmd >> %SystemRoot%\Temp\MOTION-Update-CMD.log
