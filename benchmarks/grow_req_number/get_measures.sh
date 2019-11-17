#!/bin/sh

declare -a arr=("100" "1000" "10000" "100000" "200000" "500000" "1000000")

echo "get metrics for get and set on random keys according to number of requests"

for i in "${arr[@]}"
do
   filename=${i}req_100_parallel_clients.log
   echo "values for $i: $filename"
   redis-benchmark -r 100000 -n $i -c 100 -t set > $filename
done


cat *.log | pcregrep -M "====== SET ======\n.*requests completed in" | grep "requests completed in" | awk -F"requests completed in|seconds" '{print $1 $2}' |sort -n > dataSET.dat 
