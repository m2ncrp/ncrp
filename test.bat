@echo off
for /f %%i in ('XML.EXE sel -t -v "//caption" env/env.xml') do (
	@echo %%i
)

pause