@ECHO off
	setlocal ENABLEDELAYEDEXPANSION
	for /f "tokens=2" %%i in ('git ls-remote --heads origin') do (
		set x=%%i
		set x=!x:~11,16!
		@echo !x!

		xml ed --inplace -s server/subversion -t elem -n branch -v !x! env/env.xml
	)
	pause