@echo off
setlocal

set "JAVA_HOME=C:\Program Files\Java\jdk-11.0.30+7"
set "PATH=%JAVA_HOME%\bin;%PATH%"

call "%~dp0mvnw.cmd" %*
