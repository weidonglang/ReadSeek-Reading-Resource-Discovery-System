@echo off
setlocal

set "JAVA_HOME=C:\Program Files\Java\jdk-17.0.18+8"
set "PATH=%JAVA_HOME%\bin;%PATH%"

call "%~dp0mvnw.cmd" %*
