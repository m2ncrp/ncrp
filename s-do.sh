#!/bin/sh
exeName=m2online-svr-test.exe
lastCommitPath=env/commitInfo.txt

# Functions
launch() 
{
	#cd resources && ./makeMeta.sh
	#cd ..

	if [ "$1" == "--a" ]
	then
		./s-autoconfig.sh
	fi

	if [ "$1" == "--g" ]
	then
		git status
	fi

	hacks
	./$exeName
}


shutdown() {
	echo $!
	#kill $task
}


checkCommit() {
	#FOR /F %%i IN (%lastCommitPath%) DO set lastCommit=%%i
	
	#git rev-parse --verify HEAD >> env/tmp.txt
	#FOR /F %%i IN (env/tmp.txt) DO set actual=%%i && del env\tmp.txt

	#if [$lastCommit !==! $actual]; then
	#	echo Different commit hash: $lastCommit vs $actual
	#	del $lastCommitPath && echo $actual >> $lastCommitPath
	#fi

	#if [$lastCommit == $actual]; then
	#	echo "Last commit hash: " $lastCommit
	#fi
	exit 0
}


hacks() {
	ping 127.0.0.1 -n 2 > nul
}




# Main flow
if [ "$1" = "" ]; then
	echo "This batch file'll useful"
	echo "add -l flag and it'll launch your server"
	echo "add -l --ac will automaticly config your server"
	echo "add -r will reload whole server"
	echo "add -d will shutdown server"
	echo "Enjoy! ^_^"
fi

#if ["$1" == "make"] then
#	if ["$2" == "me"] then
#		if ["$3" == "a"] then
#			if ["$4" == "sandwitch"] then
#				echo "Make it yourself."
#			fi
#		fi
#	fi
#	exit 0
#fi

if [ "$1" = "-l" ] 
then
	launch $2
fi

#if ["$1" == "-r"]; then
#	shutdown
#	launch
#	exit 0
#fi

if [ "$1" == "-d" ]
then
	shutdown
fi

#if ["$1" == "-c"]; then
#	checkCommit $lastCommit
#	exit 0
#fi





