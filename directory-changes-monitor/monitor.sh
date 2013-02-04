#!/bin/bash

# A simple file changes monitor
# usage: monitor.sh dir command

A=`find $1 -printf '%t' | md5sum`;
while true; do
	B=`find $1 -printf '%t' | md5sum`;
	if [ "$A" != "$B" ]; then
		echo "Detected change, doing: $2"
		eval $2
		A=$B
	fi
	sleep 1
done
