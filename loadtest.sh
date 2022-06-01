#!/bin/bash

USERS=$1
ITERATIONS=$2
ROUTE=$3


for (( i=0; i<$USERS; i++ ))
do
    curl $ROUTE -s -c /tmp/cookies$i
done

for (( i=0; i<$ITERATIONS; i++ ))
do
    
    for (( j=0; j<$USERS; j++ ))
    do
	RAWOUT=$(curl $ROUTE -v -s -b /tmp/cookies$j 2>&1)
	RIP=${RAWOUT%') port'*}
	RIP=${RIP##*'com ('}

	PIP=${RAWOUT##*'message":"'}
	PIP=${PIP%'"}'*}
	echo "User $j to pod IP $PIP and Router IP $RIP"
    done
done

