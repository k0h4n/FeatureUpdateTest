@ECHO ON
Echo BEGIN setupcomplete.cmd >> c:\local\setupcomplete.log

c:
cd /d %~dp0
cmd /c whoami >> c:\local\setupcomplete.log

START Powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "c:\ProgramData\MOTION\script\UpdateScript\setupcomplete.ps1"

Echo END setupcomplete.cmd >> c:\local\setupcomplete.log