set file=meta.xml
del %file%

echo ^<meta^> >> %file%

cd server
echo 	^<!-- Server side scripts --^> >> ../%file%
for %%i in (*.nut) do echo 	^<script type^="server"^>%%~nxi^</script^> >> ../%file%
cd..
echo. >> %file%

cd client
echo 	^<!-- Client side scripts --^> >> ../%file%
for /r %%i in (*.nut) do echo 	^<script type^="client"^>%%~nxi^</script^> >> ../%file%
cd..
echo. >> %file%

cd files
echo 	^<!-- Images --^> >> ../%file%
for /r %%i in (*.png) do echo 	^<file^>%%~nxi^</file^> >> ../%file%
for /r %%i in (*.jpg) do echo 	^<file^>%%~nxi^</file^> >> ../%file%

<NUL set /p= ^</meta^> >> ../%file%