@ECHO off

set file=meta.xml

for /d %%D in (*) do (
	cd %%~nxD
		rem IF exist ret (
		rem 	echo break
		rem 	goto :break
		rem )

		del %file%
		echo ^<meta^> >> %file%

		if exist server (
			cd server
			echo 	^<!-- Server side scripts --^> >> ../%file%
			for %%i in (*.nut) do echo 	^<script type^="server"^>%%~nxi^</script^> >> ../%file%
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
		rem :break
	cd..
)

ping 127.0.0.1 -n 2 > nul
exit;