#!/bin/sh

# Auther: LoOnyRider
# Data: november 2016
# GitHub: https://github.com/LoOnyBiker

DEBUG="false"
exeName=m2online-svr.exe
xmlFile=globalSettings/env.xml

# {url}: http://stackoverflow.com/questions/1417957/show-just-the-current-branch-in-git/1418022#1418022
branchName=$(git rev-parse --abbrev-ref HEAD)
branchMinor=""

DEBUG_HEADER() {
	echo ""
	# Show xml content
	./XML.exe el -a $xmlFile
	echo ""
	# Show xml content with values
	./XML.exe el -v $xmlFile	
}

DEBUG_FOOTER() {
	echo ""
	echo "= = After changes = ="
	./XML.exe el -v $xmlFile
}

# {url}: http://stackoverflow.com/questions/9726143/searching-for-xml-tag-by-value-between-them-and-inserting-a-new-tag-in-shell-scr
	# xmlstarlet ed -a '//p[n="hello"]/r/s' -t elem -n s -v 2.0 input.xml
	# 
# So now command will look like:
# ./XML.exe ed -u "//server/@major" -v 2 globalSettings/env.xml
# xmlstarlet.exe edit update "tag_path" value content <xml_path>

# Update all branches value
updateAllBranches() {
	xmlPath="//server/subversion/branch/commit/@major"

	if [ $DEBUG == "true" ]; then
		echo "//branch[@name='"$branchName"']/commit/@major"
		DEBUG_HEADER
	fi


	if [ "$1" == "--m1" ]; then
		# Update all major values
		# ./XML.exe ed --inplace -u "//server/subversion/branch/commit/@major" -v "$1" $xmlFile
		./XML.exe ed --inplace -u $xmlPath -v "$2" $xmlFile
	fi

	if [ "$1" == "--m2" ]; then
		xmlPath="//server/subversion/branch/commit/@middle"
		./XML.exe ed --inplace -u $xmlPath -v "$2" $xmlFile
	fi

	if [ "$1" == "--m3" ]; then
		xmlPath="//server/subversion/branch/commit/@minor"
		./XML.exe ed --inplace -u $xmlPath -v "$2" $xmlFile
	fi


	if [ $DEBUG == "true" ]; then
		DEBUG_FOOTER
	fi
}

updateBranchVersion() {
	xmlPath="//branch[@name='"$branchName"']/commit/@major"

	if [ $DEBUG == "true" ]; then
		echo $xmlPath
		DEBUG_HEADER
	fi


	if [ "$1" == "--m1" ]; then
		# Update specific attribute
			# {url}: http://stackoverflow.com/questions/7837879/xmlstarlet-update-an-attribute
			# ./XML.exe ed --inplace -u //property[@name='XF86Display']/@value -v "$1" $xmlFile
		./XML.exe ed --inplace -u $xmlPath -v "$2" $xmlFile
	fi

	if [ "$1" == "--m2" ]; then
		xmlPath="//branch[@name='"$branchName"']/commit/@middle"
		./XML.exe ed --inplace -u $xmlPath -v "$2" $xmlFile
	fi

	if [ "$1" == "--m3" ]; then
		xmlPath="//branch[@name='"$branchName"']/commit/@minor"
		./XML.exe ed --inplace -u $xmlPath -v "$2" $xmlFile
	fi


	if [ $DEBUG == "true" ]; then
		DEBUG_FOOTER
	fi
}

getMinor() {
	xmlPath="//branch[@name='"$branchName"']/commit/@minor"
	# {url}: http://stackoverflow.com/questions/12640152/xmlstarlet-select-value
	branchMinor=$(./XML.exe sel -t -v $xmlPath $xmlFile)
}

checkCommit() {
	if [ $DEBUG == "true" ]; then
		DEBUG_HEADER
	fi


	echo -e "Branch: \t$branchName"
	echo -e "Commit hash: \t$(git rev-parse --verify HEAD)"
	getMinor

	xmlPath="//branch[@name='"$branchName"']/commit"
	commitHash=$(./XML.exe sel -t -v $xmlPath $xmlFile)
	echo "env.xml commit hash: "$commitHash

	# Get number of commits since certain commit hash
		# {url}: http://stackoverflow.com/questions/7693249/commits-since-a-certain-commit-number
	# git rev-list <since_hash>..HEAD
	commitCount=$(git rev-list $commitHash..HEAD --count)
	echo "Since "$commitHash" "$commitCount" commits more!"

	echo "Minor value was = "$branchMinor
	# {url}: http://askubuntu.com/questions/385528/how-to-increment-a-variable-in-bash
	branchMinor=$((branchMinor+commitCount))
	echo "Now value become = "$branchMinor

	# update minor value for branch
	xmlPath="//branch[@name='"$branchName"']/commit/@minor"
	./XML.exe ed --inplace -u $xmlPath -v "$branchMinor" $xmlFile
	
	# update commit hash
	xmlPath="//branch[@name='"$branchName"']/commit"
	commitHash=$(git rev-parse HEAD)
	./XML.exe ed --inplace -u $xmlPath -v "$commitHash" $xmlFile


	if [ $DEBUG == "true" ]; then
		DEBUG_FOOTER
	fi

	echo ""
}

# Check env.xml, update it and launch server
launch() {
	checkCommit
	./s-autoconfig.sh
	./$exeName
}











# Main flow
if [ -z "$1" ]; then
	echo -e "\ts-do.sh [flag] [value] [options]\n
	s-do.sh script allow launch and manage server preferences\n\t   in git bash on windows or in terminal on *NIX.\n
	FLAGS:
	  -l    check for commits, update env and config files, launch server
	  -c    check commit hash, update env xml file
	  -ub   update version for current branch in env.xml
	  --m1  point to major version
	  --m2  point to middle version
	  --m3  point to minor version
	OPTIONS:
	  --all update all branches

	USAGE:
	  ./s-do.sh -l
	  ./s-do.sh -c
	  ./s-do.sh -ub --m2 [value]
	  ./s-do.sh -ub --m1 [value] --all

	Enjoy! ^_^"
fi

# Launch server
if [ "$1" = "-l" ]; then
	launch
fi

# Output last commit hash
# 
# Usage: ./s-do.sh -c
if [ "$1" == "-c" ]; then
	checkCommit
fi

# Update current branch version
# 
# Usage: ./s-do.sh -ub <flag> <value> [OPTION]
# Flags are:
	# "--m1" update major version value
	# "--m2" update middle version value
	# "--m3" update minor version value
# Option is:
	# "--all" update all branches 
if [ "$1" == "-ub" ]; then
	if [ -z "$4" ];	then
		updateBranchVersion $2 $3
	fi
	if [ "$4" == "--all" ]; then
		updateAllBranches $2 $3
	fi
fi