@echo off
setlocal

echo ReadSeek requires Java 17. Delegating to mvnw-jdk17.cmd.
call "%~dp0mvnw-jdk17.cmd" %*
