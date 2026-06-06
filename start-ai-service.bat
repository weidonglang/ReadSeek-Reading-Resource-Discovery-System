@echo off
setlocal
cd /d "%~dp0"
powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\start-ai-service.ps1" %*
if errorlevel 1 (
  echo.
  echo [ReadSeek] AI service startup failed. Check the error message above.
  pause
)
endlocal
