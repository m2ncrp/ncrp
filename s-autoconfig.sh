name="Night City Role-Play v"
cfg=config.xml
envFile=globalSettings/env.xml

branchName=$(git rev-parse --abbrev-ref HEAD)

major=$(./XML.EXE sel -t -v "//branch[@name='"$branchName"']/commit/@major" $envFile)
middle=$(./XML.EXE sel -t -v "//branch[@name='"$branchName"']/commit/@middle" $envFile)
minor=$(./XML.EXE sel -t -v "//branch[@name='"$branchName"']/commit/@minor" $envFile)

echo "<settings>" > $cfg
echo -e "\t<hostname>$name $major.$middle.$minor</hostname>" >> $cfg
echo -e "\t<serverip />" >> $cfg
echo -e "\t<port>27015</port>" >> $cfg
echo -e "\t<maxplayers>4</maxplayers>" >> $cfg
echo -e "\t<weburl>www.mafia2-online.com</weburl>" >> $cfg
echo -e "\t<password />" >> $cfg
echo -e "\t<resources>" >> $cfg

cd ./resources/
for i in $(find */ -maxdepth 0 -type d)
do
	i=${i%*/}
    # echo "$i"
    echo -e "\t\t<resource>"${i##*/}"</resource>" >> ../$cfg
done
cd ..

echo -e "\t</resources>" >> $cfg
echo -e "\t<serverkey />" >> $cfg
echo -e "\t<modules />" >> $cfg
echo "</settings>" >> $cfg