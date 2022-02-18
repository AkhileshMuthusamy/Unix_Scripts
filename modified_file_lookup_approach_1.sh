#!/bin/sh

# Script for listing modified files 
# Operating System: IBM Z/OS

print -n "Enter the workspace: "
read WORKSPACE
print -n "Enter the component name: "
read COMPONENT
print -n "Enter the file format: "
read FILETYPE

# The old unix system does not have option to find files based on modified time,
# we can acheive this behaviour by comparing files.
readonly REF_FILE_PATH="REF_FILE.txt"

rm $REF_FILE_PATH -f 2> /dev/null

PREVIOUS_DATE=`TZ=EST6 date "+%Y%m%d%H%M.%S"`
echo $PREVIOUS_DATE

touch -t $PREVIOUS_DATE $REF_FILE_PATH

if [ $FILETYPE == "dat" ]
then
	path="/u/akhilesh/tst/$WORKSPACE/$COMPONENT/data/"
elif [ $FILETYPE == "log" ]
then
	path="/u/akhilesh/tst/$WORKSPACE/$COMPONENT/log/"
elif [ $FILETYPE == "bak" ]
then
	path="/u/akhilesh/tst/$WORKSPACE/$COMPONENT/backup/"
else
	path="/u/akhilesh/tst/$WORKSPACE/$COMPONENT"
fi

echo $path

# find files newer than the reference file
FILES=$( find "$path" ! -type d -newer $REF_FILE_PATH -name "*.$FILETYPE" )
for FILE in $FILES ; do echo $FILE ; done