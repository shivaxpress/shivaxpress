@echo off
:: This script originally authored by BayVois LLC
rem ---------------------------------------------------------------------------
rem Genesys Windows Services Stop script
rem ---------------------------------------------------------------------------
rem Check the Command Line Arguments for list of Services to be stopped

echo %1
IF [%~1]==[] GOTO usage

:ResolveInitialState
SC query %1 | FIND "STATE" | FIND "RUNNING" >NUL
IF errorlevel 0 IF NOT errorlevel 1 GOTO StopService
SC query %1 | FIND "STATE" | FIND "STOPPED" >NUL
IF errorlevel 0 IF NOT errorlevel 1 GOTO StoppedService
echo Service State is changing, waiting for service to resolve its state before making changes
sc query %1 | Find "STATE"
timeout /t 2 /nobreak >NUL
GOTO ResolveInitialState

:StopService
echo Stopping %1 on \\%COMPUTERNAME%
sc stop %1 >NUL

GOTO StoppingService
:StopingServiceDelay
echo Waiting for %1 to stop
timeout /t 2 /nobreak >NUL
:StoppingService
SC query %1 | FIND "STATE" | FIND "STOPPED" >NUL
IF errorlevel 1 GOTO StopingServiceDelay

:StoppedService
echo %1 on \\%COMPUTERNAME% is stopped
GOTO:eof

:usage
echo This script will wait for the service to enter the stopped state if necessary.
echo.
echo %0 [service name]
echo Example: %0 ConfigServer64
echo.
echo For reason codes, run "sc stop"
GOTO:eof
