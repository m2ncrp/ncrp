@ECHO off

rem TODO
rem 1. Ignore file contains name of files that shouldn't be included into meta.xml from server side
set ignoreFile=.batignore
set file=meta.xml

for /d %%D in (*) do (
	cd %%~nxD

		del %file%
		echo ^<meta^> >> %file%

		if exist server (
			cd server
			echo 	^<!-- Server side scripts --^> >> ../%file%

			for /f "tokens=* delims= " %%a in ('dir/b %CD%\%%~nxD\server\*.nut') do (
				if exist %CD%\%%~nxD\%ignoreFile% (
					find /i "%%a" < %CD%\%%~nxD\%ignoreFile% > nul || echo 	^<script type^="server"^>%%a^</script^> >> %CD%\%%~nxD\%file%
				) else (
					echo 	^<script type^="server"^>%%a^</script^> >> ../%file%
				)
			)
			cd..
			echo. >> %file%
		)
		
		if exist client (
			cd client
			echo 	^<!-- Client side scripts --^> >> ../%file%
			for /r %%i in (*.nut) do echo 	^<script type^="client"^>%%~nxi^</script^> >> ../%file%
			cd..
			echo. >> %file%
		)

		if exist files (
			cd files
			echo 	^<!-- Images --^> >> ../%file%
			for /r %%i in (*.png) do echo 	^<file^>%%~nxi^</file^> >> ../%file%
			for /r %%i in (*.jpg) do echo 	^<file^>%%~nxi^</file^> >> ../%file%
			cd..
		)

		<NUL set /p= ^</meta^> >> %file%
	cd..
)

ping 127.0.0.1 -n 2 > nul
exit;