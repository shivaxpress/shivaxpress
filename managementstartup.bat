@echo Off
rem ---------------------------------------------------------------------------
rem Startup/Stop script for checking the Genesys Management services status
rem ---------------------------------------------------------------------------
Set ServiceName=GAX64


SC queryex "%ServiceName%"|Find "STATE"|Find /v "RUNNING">Nul&&(
    echo %ServiceName% not running 
    echo Start %ServiceName%

    Net start "%ServiceName%">nul||(
        Echo "%ServiceName%" wont start 
        exit /b 1
    )
    echo "%ServiceName%" started
    exit /b 0
)||(
    echo "%ServiceName%" working
    exit /b 0
)
