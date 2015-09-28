#!/bin/bash

RC=0
SLEEP=1

C=$(docker run -d zombietest /runsvinit -reap=false)
sleep $SLEEP
NOREAP=$(docker exec $C ps -o pid,stat | grep Z | wc -l)
echo -n without reaping, we have $NOREAP zombies...
if [ "$NOREAP" -le "0" ]
then
	echo " FAIL"
	RC=1
else
	echo " good"
fi
docker stop $C >/dev/null
docker rm $C >/dev/null

C=$(docker run -d zombietest /runsvinit)
sleep $SLEEP
YESREAP=$(docker exec $C ps -o pid,stat | grep Z | wc -l)
echo -n with reaping, we have $YESREAP zombies...
if [ "$YESREAP" -gt "0" ]
then
	echo " FAIL"
	RC=1
else
	echo " good"
fi
docker stop $C >/dev/null
docker rm $C >/dev/null

exit $RC
