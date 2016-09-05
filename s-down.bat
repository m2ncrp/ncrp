@ECHO off
taskkill /im m2online-svr-test.exe

if "%1" EQU "-e" (
	exit
)