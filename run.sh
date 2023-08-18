#!/bin/bash

counter=0
echo $counter > jobs.txt

for file in in/*; do
    ( ./main.sh -i "$file" -o "out/$(basename $file).webm" && echo "$file" ) &
    
    running_jobs=$(jobs | grep -c "Running")
    jobs > jobs.txt
    
    if [ $running_jobs -gt 5 ]; then
        wait -n
    	((counter--))
    fi
done

while [ $(jobs | grep -c "Running") -gt 1 ]; do
	jobs > jobs.txt
	wait -n
done

jobs > jobs.txt
echo end
