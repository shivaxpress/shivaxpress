@echo off
:: This script originally authored by BayVois LLC
rem ---------------------------------------------------------------------------
rem Genesys Windows Services Stop script
rem ---------------------------------------------------------------------------
rem Check the Command Line Arguments for list of Services to be started

echo %1
IF [%~1]==[] GOTO usage

:ResolveInitialState
SC query %1 | FIND "STATE" | FIND "STOPPED" >NUL
IF errorlevel 0 IF NOT errorlevel 1 GOTO StartService
SC query %1 | FIND "STATE" | FIND "RUNNING" >NUL
IF errorlevel 0 IF NOT errorlevel 1 GOTO StartedService
echo Service State is changing, waiting for service to resolve its state before making changes
sc query %1 | Find "STATE"
timeout /t 2 /nobreak >NUL
GOTO ResolveInitialState

:StartService
echo Starting %1 on \\%COMPUTERNAME%
sc start %1 >NUL

GOTO StartingService
:StartingServiceDelay
echo Waiting for %1 to start
timeout /t 2 /nobreak >NUL
:StartingService
SC query %1 | FIND "STATE" | FIND "RUNNING" >NUL
IF errorlevel 1 GOTO StartingServiceDelay

:StartedService
echo %1 on \\%COMPUTERNAME% is started
GOTO:eof

:usage
echo %0 [service name]
echo Example: %0 ConfigServer64
echo.
GOTO:eof
