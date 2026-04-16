@echo off
setlocal
cd /d "%~dp0"
powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\start-ai-service.ps1" %*
endlocal
