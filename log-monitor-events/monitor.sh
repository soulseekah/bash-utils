#!/bin/bash

# Monitor streams for specific byte sequences and react
# usage: monitor.sh keyword command

while read line; do
	echo $line
	line=`echo -n "$line" | grep -i "$1"`
	if [ -n "$line" ]; then
		eval $2	
	fi
done
