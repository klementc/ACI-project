#!/bin/bash

echo `mkdir /home/pi/soundMeter && cd /home/pi/soundMeter && touch dBValues.txt`

destdir=/home/pi/soundMeter/dBValues.txt

#loc=$2
loc="48.118169599999995:-1.6859136"

#create the redis timeseries
echo `redis-cli -p 6379 TS.CREATE sound:${loc} LABELS m 1`

while true
do

#        record=`arecord -D plughw:1,0 -d $1 record.wav`
	record=`arecord -D hw:1,0  -f S16_LE -r 48000 -d 5 record.wav`
        sndfileInfo=`sndfile-info record.wav | grep -oP "(-\d{1,2}\.\d{1,2})"`

	timestamp=`date +%s`

        if [ -f "$destdir" ]
        then
		echo "val:$sndfileInfo"
		echo "key: sound:$loc"
		echo "timestamp: $timestamp"
                echo "$sndfileInfo" >> "$destdir"
		echo `redis-cli -p 6379 TS.ADD sound:${loc} $timestamp $sndfileInfo`
        fi

        echo `rm record.wav`
        sleep $1
done
