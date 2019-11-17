#!/bin/sh

declare -a arr=("1" "10" "100" "200" "500" "750" "1000")

echo "get metrics for get and set on random keys according to number of requests"

for i in "${arr[@]}"
do
   filename=100000req_${i}_parallel_clients.log
   echo "values for $i: $filename"
   redis-benchmark -r 100000 -n 100000 -c $i -t set > $filename
done


cat *.log | pcregrep -M "====== SET ======\n.*requests completed in" | grep "requests completed in" | awk -F"requests completed in|seconds" '{print $1 $2}' |sort -n > dataSET.dat 
