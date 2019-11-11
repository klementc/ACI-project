#!/bin/sh

#For this script to work there are 2 dependencies -
# sudo apt install curl jq

# Grab this server's public IP address
PUBLIC_IP=`curl -s https://ipinfo.io/ip`

# Call the geolocation API and capture the output
curl -s https://ipvigilante.com/${PUBLIC_IP} | \
	        
	jq '.data.latitude, .data.longitude' | \
		        
	while 
		read -r LATITUDE; do
		read -r LONGITUDE
		echo "${LATITUDE}:${LONGITUDE}" | \tr --delete \" 
	done


