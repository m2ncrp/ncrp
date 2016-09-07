set file=config.xml

del %file%

echo ^<settings^> >> %file%
echo    ^<hostname^>Night City Role-Play v0.0.7^</hostname^> >> %file%
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