@echo off
REM ============================================
REM PC Information Extractor to Text File
REM Extracts: PC Name, Serial Number, Model
REM Saves to formatted text log with date in filename
REM ============================================

setlocal EnableExtensions

REM Get current date and time using PowerShell for reliability across regional settings
for /f %%I in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMddHHmmss"') do set "dt=%%I"

set "year=%dt:~0,4%"
set "month=%dt:~4,2%"
set "day=%dt:~6,2%"
set "hour=%dt:~8,2%"
set "minute=%dt:~10,2%"
set "second=%dt:~12,2%"

set "mydate=%day%-%month%-%year%"
set "mytime=%hour%:%minute%:%second%"

REM Get PC information
set "PCName=%COMPUTERNAME%"

REM Get Serial Number using PowerShell/CIM (WMIC is deprecated)
for /f "usebackq delims=" %%A in (`powershell -NoProfile -Command "(Get-CimInstance Win32_BIOS -ErrorAction SilentlyContinue).SerialNumber"`) do set "SerialNumber=%%A"

REM Get Model using PowerShell/CIM
for /f "usebackq delims=" %%A in (`powershell -NoProfile -Command "(Get-CimInstance Win32_ComputerSystem -ErrorAction SilentlyContinue).Model"`) do set "Model=%%A"

REM Trim whitespace from variables
for /f "tokens=* delims= " %%A in ("%SerialNumber%") do set "SerialNumber=%%A"
for /f "tokens=* delims= " %%A in ("%Model%") do set "Model=%%A"

REM Set default values if empty
if "%SerialNumber%"=="" set "SerialNumber=N/A"
if "%Model%"=="" set "Model=N/A"

REM Create text filename with current date
set "TextFile=pc_info_log_%mydate%.txt"

REM Display information in CMD window
cls
echo.
echo ============================================
echo        PC Information Report
echo ============================================
echo.
echo PC Name       : %PCName%
echo Serial Number : %SerialNumber%
echo Model         : %Model%
echo.
echo Date          : %mydate%
echo Time          : %mytime%
echo.
echo ============================================
echo Log File      : %TextFile%
echo Location      : %CD%
echo ============================================
echo.

REM Check if text file exists, if not create with professional header
if not exist "%TextFile%" (
    (
        echo PC INFORMATION LOG REPORT
        echo Generated: %mydate% %mytime%
        echo Total PCs: 0
        echo.
        echo ============================================================================
        echo Date       ^| Time     ^| PC Name                    ^| Serial Number        ^| Model
        echo ============================================================================
    ) > "%TextFile%"
    echo [NEW FILE] Created text log file with header
) else (
    echo [APPENDING] Adding data to existing log file
)

REM Format data for aligned table output (fixed-width columns)
REM Column widths: Date(10) | Time(8) | PC Name(26) | Serial Number(20) | Model
set "PCNamePadded=%PCName%                       "
set "PCNamePadded=%PCNamePadded:~0,26%"
set "SerialPadded=%SerialNumber%                    "
set "SerialPadded=%SerialPadded:~0,20%"

REM Append data to text file
echo %mydate% ^| %mytime% ^| %PCNamePadded% ^| %SerialPadded% ^| %Model%>> "%TextFile%"

REM Update Total PCs count in the header
powershell -NoProfile -Command "$path = '%TextFile%'; $lines = Get-Content $path; $count = ($lines | Where-Object { $_ -match '^\d{2}-\d{2}-\d{4}\s\|' }).Count; $lines = $lines | ForEach-Object { if ($_ -match '^Total PCs:') { 'Total PCs: ' + $count } else { $_ } }; Set-Content -Path $path -Value $lines"

echo.
echo [SUCCESS] Data successfully saved!
echo.
pause
endlocal
