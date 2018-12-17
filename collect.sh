#!/bin/bash

#Get the /proc file 
Sampling(){
	for ((i=1;i<=5000;i++))
	do
		#Can't ensure the intervals of each "cat"
		cat /proc/$1  | (grep '' >> ./$1-$i.txt)&
	done
}

#Get the container image name from file $1
#the images need to be downloaded in advance
cat $1 | while read image
do
	#Saving the sampling file in related folder named with image
	mkdir ./$image && cd $image

	#Although using &, it still can't ensure each process will execute synchronously
        (docker run -it $image)&
        (Sampling zoneinfo)& (Sampling meminfo)& (Sampling slabinfo)& (Sampling diskstats)&
	
	#Waiting for the sampling process completed and cleaning the running container
	sleep 5
	cd ..
	docker rm -f $(docker ps -aq) || echo y | docker system prune
done

