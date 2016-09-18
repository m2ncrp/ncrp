@ECHO off
set exeName=m2online-svr-test.exe
set subversionTagBegin="/server/subversion/branch[@name="
set subversionTagEnd="]/commit"
set versionMinorTag="/server/version/minor"
set conf="globalSettings/env.xml"




rem * * * MAIN * * *
:main
if "%1" EQU "" (
	@echo This batch file'll useful
	@echo add -l flag and it'll launch your server
	@echo add -l --a will automaticly config your server
	@echo add -r will reload whole server
	@echo add -d will shutdown server
	@echo Enjoy! ^^_^^
	EXIT /B 0
)

if "%1" EQU "-l" (
	call :launch %~2
	EXIT /B 0
)

if "%1" EQU "-r" (
	call :shutdown
	call :launch
	EXIT /B 0
)

if "%1" EQU "-d" (
	call :shutdown
	EXIT /B 0
)

if "%1" EQU "-c" (
	call :checkCommit
	EXIT /B 0
)





rem * * * FUNCTIONS * * *
:launch
	cd resources && start makeMeta.bat
	cd ..

	if "%1" EQU "--a" (
		start s-autoconfig
	)
	call :checkCommit
	call :hacks
	start %exeName%
EXIT /B 0


:shutdown
	taskkill /im %exeName%
EXIT /B 0


:checkCommit
	set cur=''
	set las=''
	set branch='features'
	for /f %%i in ('git rev-parse --verify HEAD') do (
		set cur=%%i
	)
	for /f "delims=" %%j in ('XML.EXE sel -t -v %subversionTagBegin%%branch%%subversionTagEnd% %conf%') do (
		set las=%%j
	)
	@echo %cur% vs %las% 
	

	IF %cur% NEQ %las% (
		call :incrementMinorVersion
		xml.exe ed --inplace -u %subversionTagBegin%%branch%%subversionTagEnd% -v %cur% %conf%
	)
EXIT /B 0

:incrementMinorVersion
	for /f %%i in ('XML.EXE sel -t -v %versionMinorTag% %conf%') do (
		set /A var=%%i+1
	)
	xml.exe ed --inplace -u %versionMinorTag% -v %var% %conf%
EXIT /B 0


:hacks
	ping 127.0.0.1 -n 2 > nul
EXIT /B 0