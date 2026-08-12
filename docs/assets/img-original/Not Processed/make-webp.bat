@echo off
REM ===========================================================
REM  make-webp.bat
REM  Converts every .jpg / .jpeg in a folder to web-sized .webp
REM
REM  USAGE:
REM    - Drop this file in the folder full of JPGs and double-click it
REM    - OR drag a folder onto this file
REM
REM  Output goes into a "webp" subfolder. Originals are untouched.
REM ===========================================================

REM --- Settings you might want to change ---------------------
set WIDTH=2000
set QUALITY=82
REM -----------------------------------------------------------

setlocal

REM If a folder was dragged onto the script, use that. Otherwise use
REM the folder the script is sitting in.
if "%~1"=="" (
    set "SRC=%~dp0"
) else (
    set "SRC=%~1"
)

cd /d "%SRC%" || (
    echo Could not open folder: %SRC%
    pause
    exit /b 1
)

REM Check ImageMagick is installed and on the PATH
where magick >nul 2>&1
if errorlevel 1 (
    echo.
    echo ImageMagick not found.
    echo Install it with:  winget install ImageMagick.ImageMagick
    echo Then close and reopen this window so the PATH updates.
    echo.
    pause
    exit /b 1
)

REM Bail out early if there's nothing to do
dir /b *.jpg *.jpeg >nul 2>&1
if errorlevel 1 (
    echo No .jpg or .jpeg files found in:
    echo   %CD%
    pause
    exit /b 1
)

if not exist "webp" mkdir "webp"

echo.
echo Converting JPGs in: %CD%
echo   max width : %WIDTH%px
echo   quality   : %QUALITY%
echo   output    : %CD%\webp
echo.

REM -resize "2000x>"  = shrink to 2000px wide, but never enlarge a
REM                     smaller image (the > is the "only shrink" flag)
REM -strip            = drop EXIF/GPS data, saves a bit of size and
REM                     stops camera location leaking onto the web
magick mogrify -path "webp" -format webp -resize "%WIDTH%x>" -quality %QUALITY% -strip *.jpg *.jpeg

echo.
echo Done. Files are in: %CD%\webp
echo.
pause
endlocal
