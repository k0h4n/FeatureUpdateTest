@ECHO ON
Echo BEGIN success.cmd >> %SystemRoot%\Temp\MOTION-Update-CMD.log

c:
cd /d %~dp0
cmd /c whoami >> %SystemRoot%\Temp\MOTION-Update-CMD.log

START Powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "c:\ProgramData\MOTION\script\RFC00015-InPlaceUpgradeScript\success.ps1"

Echo END success.cmd >> %SystemRoot%\Temp\MOTION-Update-CMD.log
