call globalSettings/paths.bat

set major=''
set middle=''
set minor=''

del %conf%

for /f "delims=" %%j in ('XML.EXE sel -t -v "/server/version/major" %env%') do set major=%%j
for /f "delims=" %%j in ('XML.EXE sel -t -v "/server/version/middle" %env%') do set middle=%%j
for /f "delims=" %%j in ('XML.EXE sel -t -v "/server/version/minor" %env%') do set minor=%%j

echo ^<settings^> >> %conf%
echo    ^<hostname^>Night City Role-Play v%major%.%middle%.%minor%^</hostname^> >> %conf%
echo    ^<serverip /^> >> %conf%
echo    ^<port^>23015^</port^> >> %conf%
echo    ^<maxplayers^>4^</maxplayers^> >> %conf%
echo    ^<weburl^>www.mafia2-online.com^</weburl^> >> %conf%
echo    ^<password /^> >> %conf%
echo    ^<resources^> >> %conf%

::Remove all SRC with 'ret'urn file
for /d %%D in (resources/*) do (
	if not exist "resources/%%~nxD/ret" (
		echo 	^<resource^>%%~nxD^</resource^> >> %conf%
	)
)

echo    ^</resources^> >> %conf%
echo    ^<serverkey /^> >> %conf%
echo    ^<modules /^> >> %conf%
echo ^</settings^> >> %conf%

exit