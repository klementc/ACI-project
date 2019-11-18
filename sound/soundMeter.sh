#!/bin/bash

echo `mkdir /home/pi/soundMeter && cd /home/pi/soundMeter && touch dBValues.txt`

destdir=/home/pi/soundMeter/dBValues.txt

#loc=$2
#loc="48.118169599999995:-1.6859136"

helper_function() {
	echo "./soundMeter <ipdb> <portdb> <loc> <recordduration> <pause>"
	echo "ipdb: 0.0.0.0 for local db node"
	echo "portdb: 6379 most of the time"
	echo "loc: format like -29.5943:28.44332 (long:lat)"
	echo "recordduration: for how long do we record sound"
	echo "pause: time between samples"
}

if [ $# -eq 0 ]; then
	helper_function
	exit 0
fi

ipdb="$1"
portdb="$2"
loc="$3"
p="$4"
#create the redis timeseries
echo `redis-cli -p $portdb -h $ipdb TS.CREATE sound:${loc} LABELS m 1`

while true
do

#        record=`arecord -D plughw:1,0 -d $1 record.wav`
	record=`arecord -D hw:1,0  -f S16_LE -r 48000 -d $p record.wav`
        sndfileInfo=`sndfile-info record.wav | grep -oP "(-\d{1,2}\.\d{1,2})"`

	timestamp=`date +%s`

        if [ -f "$destdir" ]
        then
		echo "val:$sndfileInfo"
		echo "key: sound:$loc"
		echo "timestamp: $timestamp"
                echo "$sndfileInfo" >> "$destdir"
		# redis-cli -p 6379 -h 176.139.14.235 TS.ADD sound:${loc} $timestamp $sndfileInfo
		echo `redis-cli -p $portdb -h $ipdb TS.ADD sound:${loc} $timestamp $sndfileInfo`
        fi

        echo `rm record.wav`
        sleep $5
done
