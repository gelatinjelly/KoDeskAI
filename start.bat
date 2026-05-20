@echo off
chcp 65001 > nul
title KoDeskAI

echo.
echo  KoDeskAI 시작 중...
echo.

:: Ollama 서버 시작
echo [1/3] Ollama 서버 시작 중...
set OLLAMA_KEEP_ALIVE=-1
start /B ollama serve
timeout /t 3 /nobreak > nul

:: Python 파일 분석 서버 시작
echo [2/3] 파일 분석 서버 시작 중...
start /B python file_server.py

:: Spring Boot 서버 시작
echo [3/3] AI 서버 시작 중...
timeout /t 2 /nobreak > nul
start /B java -jar llama-server.jar

timeout /t 5 /nobreak > nul

echo.
echo  ✅ KoDeskAI 실행 완료!
echo  브라우저에서 접속: http://localhost:8080
echo.
start http://localhost:8080
pause
