@ECHO off
set exeName=m2online-svr-test.exe
set lastCommitPath=env\commitInfo.txt




rem * * * MAIN * * *
:main
if "%1" EQU "" (
	@echo This batch file'll useful
	@echo add -l flag and it'll launch your server
	@echo add -l --ac will automaticly config your server
	@echo add -r will reload whole server
	@echo add -d will shutdown server
	@echo Enjoy! ^^_^^
	EXIT /B 0
)

if "%1" EQU "make" (
	if "%2" EQU "me" (
		if "%3" EQU "a" (
			if "%4" EQU "sandwitch" (
				@echo Make it yourself.
			)
		)
	)
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
	call :checkCommit %lastCommit%
	EXIT /B 0
)





rem * * * FUNCTIONS * * *
:launch
	cd resources && start makeMeta.bat
	cd ..

	if "%1" EQU "--a" (
		start s-autoconfig
	)

	if "%1" EQU "--g" (
		git status
	)

	call :hacks
	start %exeName%
EXIT /B 0


:shutdown
	taskkill /im %exeName%
EXIT /B 0


:checkCommit
	for /f %%i in ('XML.EXE sel -t -v "/server/version/minor" env/env.xml') do (
		set /A var=%%i+1
	)
	xml.exe ed --inplace -u "/server/version/minor" -v %var% env/env.xml
EXIT /B 0


:hacks
	ping 127.0.0.1 -n 2 > nul
EXIT /B 0