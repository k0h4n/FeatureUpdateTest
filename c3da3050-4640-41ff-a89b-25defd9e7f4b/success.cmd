@ECHO ON
Echo BEGIN success.cmd >> c:\local\success.log

c:
cd /d %~dp0
cmd /c whoami >> c:\local\success.log

START Powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "success.ps1"

Echo END success.cmd >> c:\local\success.log