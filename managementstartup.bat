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
    echo "%ServiceName%" working and stopping now
    echo Stop "%ServiceName%"
    
    Net stop "%ServiceName%">nul||(
        Echo "%ServiceName%" wont stop 
        exit /b 1
    )
    echo "%ServiceName%" stopped
    exit /b 0
)
