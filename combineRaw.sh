## combine multiple raw data into one

#!/bin/bash
FILES=./raw/*
STR=" "

for f in $FILES
do
	STR="$STR $f"	
done

cat $STR > rawData
