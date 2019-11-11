#!/bin/bash

echo `mkdir /home/pi/soundMeter && cd /home/pi/soundMeter && touch dBValues.txt`

destdir=/home/pi/soundMeter/dBValues.txt

while true
do

#        record=`arecord -D plughw:1,0 -d $1 record.wav`
	record=`arecord -D hw:1,0  -f S16_LE -r 48000 -d 5 record.wav`
        sndfileInfo=`sndfile-info record.wav | grep -oP "(-\d{1,2}\.\d{1,2})"`

        if [ -f "$destdir" ]
        then
		echo "val:$sndfileInfo"
                echo "$sndfileInfo" >> "$destdir"
                echo "done"
        fi

        echo `rm record.wav`
        sleep $2
done
