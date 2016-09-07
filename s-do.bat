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
	FOR /F %%i IN (%lastCommitPath%) DO set lastCommit=%%i
	
	git rev-parse --verify HEAD >> env/tmp.txt
	FOR /F %%i IN (env/tmp.txt) DO set actual=%%i && del env\tmp.txt

	if %lastCommit% NEQ %actual% (
		@echo Different commit hash: %lastCommit% vs %actual%
		del %lastCommitPath% && @echo %actual% >> %lastCommitPath%
	)

	if %lastCommit% EQU %actual% (
		@echo Last commit hash: %lastCommit%
	) 
EXIT /B 0


:hacks
	ping 127.0.0.1 -n 2 > nul
EXIT /B 0