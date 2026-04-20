@echo off
setlocal

if defined JAVA_HOME (
    if exist "%JAVA_HOME%\bin\java.exe" goto run
)

set "JAVA_HOME=%USERPROFILE%\.jdks\ms-17.0.18"
if exist "%JAVA_HOME%\bin\java.exe" goto run

set "JAVA_HOME=C:\Program Files\Java\jdk-17.0.18+8"
if exist "%JAVA_HOME%\bin\java.exe" goto run

echo Could not find JDK 17. Set JAVA_HOME to a JDK 17 directory and retry.
exit /b 1

:run
set "PATH=%JAVA_HOME%\bin;%PATH%"

call "%~dp0mvnw.cmd" %*
