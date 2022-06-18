#! /bin/bash

if [ $1 == "--watch" ]
then
    
INPUT=$(realpath "$2")
OUTPUT=$(realpath "$3")
CURRENT=`cat $INPUT`
cd
while [ 1 -eq 1 ];
do

if [[ "$CURRENT" != `cat $INPUT` ]];
then
ruby ~/ass/main.rb $INPUT $OUTPUT
CURRENT=`cat $INPUT`
fi

done

else

INPUT=$(realpath "$1")
OUTPUT=$(realpath "$2")
cd
ruby ~/ass/main.rb $INPUT $OUTPUT

fi