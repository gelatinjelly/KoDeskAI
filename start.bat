@echo off
title KoDeskAI

set INSTALL_DIR=%~dp0
cd /d %INSTALL_DIR%

echo [1/3] Starting Ollama...
tasklist /FI "IMAGENAME eq ollama.exe" 2>nul | find /I "ollama.exe" >nul
if %errorLevel% neq 0 (
    set OLLAMA_KEEP_ALIVE=-1
    start /B ollama serve
    timeout /t 3 /nobreak > nul
    echo Ollama started!
) else (
    echo Ollama already running.
)

echo [2/3] Starting file server...
if exist %INSTALL_DIR%venv\Scripts\python.exe (
    start /B %INSTALL_DIR%venv\Scripts\python.exe %INSTALL_DIR%file_server.py
) else (
    start /B python %INSTALL_DIR%file_server.py
)
timeout /t 2 /nobreak > nul
echo File server started!

echo [3/3] Starting AI server...
start /B java -jar %INSTALL_DIR%llama-server.jar
timeout /t 5 /nobreak > nul
echo AI server started!

echo.
echo KoDeskAI is ready!
echo Open browser: http://localhost:8080
echo.
start http://localhost:8080
pause