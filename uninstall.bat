@echo off
title KoDeskAI Uninstall

set INSTALL_DIR=%~dp0
cd /d %INSTALL_DIR%

echo.
echo KoDeskAI Uninstaller
echo ================================================
echo WARNING: This will remove KoDeskAI completely.
echo ================================================
echo.

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Please run as administrator!
    pause
    exit /b 1
)

set /p CONFIRM=Are you sure? (Y/N): 
if /i "%CONFIRM%" neq "Y" (
    echo Cancelled.
    pause
    exit /b 0
)

echo.
echo [1/5] Stopping services...
taskkill /F /IM java.exe >nul 2>&1
taskkill /F /IM python.exe >nul 2>&1
taskkill /F /IM uvicorn.exe >nul 2>&1
taskkill /F /IM ollama.exe >nul 2>&1
echo Done.

echo.
echo [2/5] Removing Ollama model (desktop-v7)...
ollama rm desktop-v7 >nul 2>&1
echo Done.

echo.
echo [3/5] Removing venv and models folder...
if exist "%INSTALL_DIR%venv" (
    rmdir /S /Q "%INSTALL_DIR%venv"
    echo venv removed.
) else (
    echo venv not found.
)
if exist "%INSTALL_DIR%models" (
    rmdir /S /Q "%INSTALL_DIR%models"
    echo models removed.
) else (
    echo models not found.
)

echo.
echo [4/5] Optional removals...
set /p DEL_OLLAMA=Remove Ollama? (Y/N): 
if /i "%DEL_OLLAMA%" equ "Y" (
    winget uninstall Ollama.Ollama --silent >nul 2>&1
    echo Ollama removed.
) else (
    echo Ollama kept.
)

set /p DEL_JAVA=Remove Java 17? (Y/N): 
if /i "%DEL_JAVA%" equ "Y" (
    winget uninstall Microsoft.OpenJDK.17 --silent >nul 2>&1
    echo Java removed.
) else (
    echo Java kept.
)

set /p DEL_PYTHON=Remove Python 3.10? (Y/N): 
if /i "%DEL_PYTHON%" equ "Y" (
    winget uninstall Python.Python.3.10 --silent >nul 2>&1
    echo Python removed.
) else (
    echo Python kept.
)

echo.
echo [5/5] Clearing browser localStorage...
echo (Please clear site data for localhost:8080 in your browser manually)

echo.
echo ================================================
echo KoDeskAI uninstall complete!
echo You can now delete this folder manually.
echo ================================================
echo.
pause