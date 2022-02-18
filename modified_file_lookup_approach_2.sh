#!/bin/sh

# Script for listing modified files 
# Operating System: IBM Z/OS

print -n "Enter the workspace: "
read WORKSPACE
print -n "Enter the component name: "
read COMPONENT
print -n "Enter the file format: "
read FILETYPE


PREVIOUS_DATE=`TZ=EST6 date "+%m%d%H%M"`
echo $PREVIOUS_DATE

if [ $FILETYPE == "dat" ]
then
	FILE_PATH="/u/akhilesh/tst/$WORKSPACE/$COMPONENT/data/"
elif [ $FILETYPE == "log" ]
then
	FILE_PATH="/u/akhilesh/tst/$WORKSPACE/$COMPONENT/log/"
elif [ $FILETYPE == "bak" ]
then
	FILE_PATH="/u/akhilesh/tst/$WORKSPACE/$COMPONENT/backup/"
else
	FILE_PATH="/u/akhilesh/tst/$WORKSPACE/$COMPONENT"
fi

# echo $FILE_PATH

FILE_LIST=$( ls -lt $FILE_PATH | grep "\.$FILETYPE" | awk '{print $6","$7$8","$9","$8}' | sed 's/Jan,/01/1' | sed 's/Feb,/02/1' | sed 's/Mar,/03/1' | sed 's/Apr,/04/1' | sed 's/May,/05/1' | sed 's/Jun,/06/1' | sed 's/Jul,/07/1' | sed 's/Aug,/08/1' | sed 's/Sep,/09/1' | sed 's/Oct,/10/1' | sed 's/Nov,/11/1' | sed 's/Dec,/12/1' | sed 's/\://1' )

# echo $FILE_LIST

for FILE in $FILE_LIST
do
    FILE_DATE=$( echo $FILE | sed 's/,/ /g' | awk '{print $1}' )
    if [ $( echo $FILE_DATE | wc -c ) -eq 8 ]
    then
            FILE_DATE=$( echo $FILE_DATE | sed 's/.\{2\}/&0/' )
    fi
    FILE_NAME=$( echo $FILE | sed 's/,/ /g' | awk '{print $2}' )
    TIME=$( echo $FILE | sed 's/,/ /g' | awk '{print $3}' )
    # echo $FILE_DATE $FILE_NAME $TIME
    if [ $( echo $TIME | wc -c ) -eq 6 ]
    then
            if [ $PREVIOUS_DATE -lt $FILE_DATE ]
            then
                    echo $FILE_NAME
            fi
    fi
done