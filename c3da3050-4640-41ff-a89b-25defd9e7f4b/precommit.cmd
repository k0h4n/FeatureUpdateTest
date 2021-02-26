@ECHO ON
Echo BEGIN precommit.cmd >> c:\local\precommit.log

c:
cd /d %~dp0
cmd /c whoami >> c:\local\precommit.log

START Powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "precommit.ps1"

Echo END precommit.cmd >> c:\local\precommit.log