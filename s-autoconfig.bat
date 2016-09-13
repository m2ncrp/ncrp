set file=config.xml
set major=''
set middle=''
set minor=''

del %file%

for /f "delims=" %%j in ('XML.EXE sel -t -v "/server/version/major" env/env.xml') do set major=%%j
for /f "delims=" %%j in ('XML.EXE sel -t -v "/server/version/middle" env/env.xml') do set middle=%%j
for /f "delims=" %%j in ('XML.EXE sel -t -v "/server/version/minor" env/env.xml') do set minor=%%j

echo ^<settings^> >> %file%
echo    ^<hostname^>Night City Role-Play v%major%.%middle%.%minor%^</hostname^> >> %file%
echo    ^<serverip /^> >> %file%
echo    ^<port^>23015^</port^> >> %file%
echo    ^<maxplayers^>4^</maxplayers^> >> %file%
echo    ^<weburl^>www.mafia2-online.com^</weburl^> >> %file%
echo    ^<password /^> >> %file%
echo    ^<resources^> >> %file%

for /d %%D in (resources/*) do ( 
echo 	^<resource^>%%~nxD^</resource^> >> %file%
)

echo    ^</resources^> >> %file%
echo    ^<serverkey /^> >> %file%
echo    ^<modules /^> >> %file%
echo ^</settings^> >> %file%

exit