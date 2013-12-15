#!/bin/bash

# Upload a file to Google Drive
#
# Usage: upload.sh <access_token> <file> [title] [path] [mime]

set -e

ACCESS_TOKEN=$1
BOUNDARY=`cat /dev/urandom | head -c 16 | xxd -ps`
MIME_TYPE=${5:-"application/octet-stream"}

( echo "--$BOUNDARY
Content-Type: application/json; charset=UTF-8

{ \"title\": \"$3\", \"parents\": [ { \"id\": \"$4\" } ] }

--$BOUNDARY
Content-Type: $MIME_TYPE
" \
&& cat $2 && echo "
--$BOUNDARY--" ) \
	| curl -v "https://www.googleapis.com/upload/drive/v2/files/?uploadType=multipart" \
	--header "Authorization: Bearer $ACCESS_TOKEN" \
	--header "Content-Type: multipart/related; boundary=\"$BOUNDARY\"" \
	--data-binary "@-"
