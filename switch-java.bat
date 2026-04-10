@echo off
setlocal
cd /d "%~dp0"
powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0switch-java.ps1" -NonInteractive -Scope Machine -PreferredVersionPrefix 17 %*
endlocal
