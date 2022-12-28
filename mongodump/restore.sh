#!/bin/bash
# TODO: gzip + archive
echo ******************************************************
echo Starting-RESTORE
echo ******************************************************

FILE="$1"

mongorestore $MONGODB_URI --out=/mongodump/db/$FILE

sleep 30 | echo End-RESTORE
