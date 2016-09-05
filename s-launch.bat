@ECHO off

if "%1" EQU "-ac" (
	start s-autoconfig
)

cd resources
start makeMeta.bat
cd..

ping 127.0.0.1 -n 2 > nul
start m2online-svr-test.exe

if "%1" EQU "-e" (
	exit
)