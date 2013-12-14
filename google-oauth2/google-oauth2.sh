#!/bin/bash

# A simple cURL OAuth2 authenticator
# depends on Python's built-in json module to prettify output
#
# Usage:
#	./google-oauth2.sh create - authenticates a user
#	./google-oauth2.sh refresh <token> - gets a new token
#
# Set CLIENT_ID and CLIENT_SECRET and SCOPE

CLIENT_ID=""
CLIENT_SECRET=""
SCOPE=${SCOPE:-"https://docs.google.com/feeds"}

set -e

if [ "$1" == "create" ]; then
	RESPONSE=`curl --silent "https://accounts.google.com/o/oauth2/device/code" --data "client_id=$CLIENT_ID&scope=$SCOPE"`
	DEVICE_CODE=`echo "$RESPONSE" | python -mjson.tool | grep -oP 'device_code"\s*:\s*"\K(.*)"' | sed 's/"//'`
	USER_CODE=`echo "$RESPONSE" | python -mjson.tool | grep -oP 'user_code"\s*:\s*"\K(.*)"' | sed 's/"//'`
	URL=`echo "$RESPONSE" | python -mjson.tool | grep -oP 'verification_url"\s*:\s*"\K(.*)"' | sed 's/"//'`

	echo -n "Go to $URL and enter $USER_CODE to grant access to this application. Hit enter when done..."
	read

	RESPONSE=`curl --silent "https://accounts.google.com/o/oauth2/token" --data "client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&code=$DEVICE_CODE&grant_type=http://oauth.net/grant_type/device/1.0"`

	ACCESS_TOKEN=`echo "$RESPONSE" | python -mjson.tool | grep -oP 'access_token"\s*:\s*"\K(.*)"' | sed 's/"//'`
	REFRESH_TOKEN=`echo "$RESPONSE" | python -mjson.tool | grep -oP 'refresh_token"\s*:\s*"\K(.*)"' | sed 's/"//'`

	echo "Access Token: $ACCESS_TOKEN"
	echo "Refresh Token: $REFRESH_TOKEN"
elif [ "$1" == "refresh" ]; then
	REFRESH_TOKEN=$2
	RESPONSE=`curl --silent "https://accounts.google.com/o/oauth2/token" --data "client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&refresh_token=$REFRESH_TOKEN&grant_type=refresh_token"`

	ACCESS_TOKEN=`echo $RESPONSE | python -mjson.tool | grep -oP 'access_token"\s*:\s*"\K(.*)"' | sed 's/"//'`
	
	echo "Access Token: $ACCESS_TOKEN"
fi
