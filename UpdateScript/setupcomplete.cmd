@ECHO ON
Echo BEGIN setupcomplete.cmd >> %SystemRoot%\Temp\MOTION-Update-CMD.log

c:
cd /d %~dp0
cmd /c whoami >> %SystemRoot%\Temp\MOTION-Update-CMD.log

START Powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "c:\ProgramData\MOTION\script\UpdateScript\setupcomplete.ps1"

Echo END setupcomplete.cmd >> %SystemRoot%\Temp\MOTION-Update-CMD.log
