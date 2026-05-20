@echo off
chcp 65001 > nul
title KoDeskAI 종료

echo KoDeskAI 종료 중...

taskkill /f /im ollama.exe >nul 2>&1
taskkill /f /im java.exe >nul 2>&1
taskkill /f /im python.exe >nul 2>&1

echo ✅ KoDeskAI가 종료되었습니다.
pause
