#!/bin/bash
while true; do
	modified=$(inotifywait --format '%w%f' --exclude '.swp' -e modify src/**/)
	cp -v $modified $(echo "$modified" | sed 's/^src/build/')
	phpunit --no-coverage $@
done  
