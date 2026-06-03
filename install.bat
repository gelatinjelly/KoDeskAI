@echo off
chcp 65001 > nul
title KoDeskAI 설치

echo.
echo  ██╗  ██╗ ██████╗ ██████╗ ███████╗███████╗██╗  ██╗ █████╗ ██╗
echo  ██║ ██╔╝██╔═══██╗██╔══██╗██╔════╝██╔════╝██║ ██╔╝██╔══██╗██║
echo  █████╔╝ ██║   ██║██║  ██║█████╗  ███████╗█████╔╝ ███████║██║
echo  ██╔═██╗ ██║   ██║██║  ██║██╔══╝  ╚════██║██╔═██╗ ██╔══██║██║
echo  ██║  ██╗╚██████╔╝██████╔╝███████╗███████║██║  ██╗██║  ██║██║
echo  ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝
echo.
echo  한국어 특화 로컬 AI 비서 - 설치 프로그램
echo  ================================================
echo.

:: 관리자 권한 확인
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [오류] 관리자 권한으로 실행해주세요!
    echo 이 파일을 우클릭 후 "관리자 권한으로 실행" 선택
    pause
    exit /b 1
)

:: 설치 디렉토리 기준 경로 고정
set "INSTALL_DIR=%~dp0"
cd /d "%INSTALL_DIR%"

echo [1/6] Ollama 설치 확인 중...
where ollama >nul 2>&1
if %errorLevel% neq 0 (
    echo Ollama가 없습니다. 설치 중...
    winget install Ollama.Ollama -e --silent
    if %errorLevel% neq 0 (
        echo [오류] Ollama 설치 실패. 수동으로 설치해주세요: https://ollama.com/download
        pause
        exit /b 1
    )
    echo Ollama 설치 완료!
) else (
    echo Ollama 이미 설치됨 ✓
)

echo.
echo [2/6] Java 17 설치 확인 중...
java -version >nul 2>&1
if %errorLevel% neq 0 (
    echo Java가 없습니다. 설치 중...
    winget install Microsoft.OpenJDK.17 -e --silent
    if %errorLevel% neq 0 (
        echo [오류] Java 설치 실패. 수동으로 설치해주세요: https://adoptium.net
        pause
        exit /b 1
    )
    echo Java 17 설치 완료!
) else (
    echo Java 이미 설치됨 ✓
)

echo.
echo [3/6] Python 설치 확인 중...
python --version >nul 2>&1
if %errorLevel% neq 0 (
    echo Python이 없습니다. 설치 중...
    winget install Python.Python.3.10 -e --silent
    if %errorLevel% neq 0 (
        echo [오류] Python 설치 실패. 수동으로 설치해주세요: https://python.org
        pause
        exit /b 1
    )
    :: 설치 후 PATH 재로드
    set "PATH=%LOCALAPPDATA%\Programs\Python\Python310;%LOCALAPPDATA%\Programs\Python\Python310\Scripts;%PATH%"
    echo Python 설치 완료!
) else (
    echo Python 이미 설치됨 ✓
)

echo.
echo [4/6] Python 가상환경 설정 중...
if not exist "%INSTALL_DIR%venv" (
    echo 가상환경 생성 중...
    python -m venv "%INSTALL_DIR%venv"
    if %errorLevel% neq 0 (
        echo [오류] 가상환경 생성 실패
        pause
        exit /b 1
    )
    echo 가상환경 생성 완료! ✓
) else (
    echo 가상환경 이미 존재함 ✓
)

echo.
echo [5/6] Python 라이브러리 설치 중...
call "%INSTALL_DIR%venv\Scripts\activate.bat"
pip install fastapi uvicorn pymupdf python-docx openpyxl requests python-multipart -q
if %errorLevel% neq 0 (
    echo [오류] Python 라이브러리 설치 실패
    pause
    exit /b 1
)
echo Python 라이브러리 설치 완료! ✓

echo.
echo [6/6] AI 모델 다운로드 중... (약 4.5GB, 시간이 걸립니다)
if not exist "%INSTALL_DIR%models" mkdir "%INSTALL_DIR%models"
if not exist "%INSTALL_DIR%models\v7_q4.gguf" (
    echo HuggingFace에서 모델 다운로드 중...
    pip install huggingface_hub -q
    python -c "from huggingface_hub import hf_hub_download; hf_hub_download(repo_id='gelatinjelly/desktop-ai-v7', filename='v7_q4.gguf', local_dir='%INSTALL_DIR%models')"
    if %errorLevel% neq 0 (
        echo [오류] 모델 다운로드 실패
        pause
        exit /b 1
    )
    echo 모델 다운로드 완료! ✓
) else (
    echo 모델 이미 존재함 ✓
)

echo.
echo Ollama에 모델 등록 중...
:: 이미 실행 중인지 확인 후 실행
tasklist /FI "IMAGENAME eq ollama.exe" 2>nul | find /I "ollama.exe" >nul
if %errorLevel% neq 0 (
    start /B ollama serve
    timeout /t 3 /nobreak > nul
)

ollama list | find "desktop-v7" >nul
if %errorLevel% neq 0 (
    ollama create desktop-v7 -f "%INSTALL_DIR%Modelfile"
    if %errorLevel% neq 0 (
        echo [오류] 모델 등록 실패
        pause
        exit /b 1
    )
    echo 모델 등록 완료! ✓
) else (
    echo 모델 이미 등록됨 ✓
)

echo.
echo ================================================
echo  ✅ KoDeskAI 설치가 완료되었습니다!
echo ================================================
echo.
echo  실행 방법: start.bat 더블클릭
echo  접속 주소: http://localhost:8080
echo.
pause