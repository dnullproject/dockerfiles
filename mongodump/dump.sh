#!/bin/bash
set -eu

NOW="$(date +"%F")-$(date +"%T")"
FILE="${DB_NAME}-${NOW}.gzip"
echo ******************************************************
echo Starting-BACKUP ${FILE}
echo ******************************************************

mongodump --uri=${MONGODB_URI} --gzip --archive=/mongodump/db/${FILE}

if [[ "${S3_UPLOAD}" == true ]]; then
  echo "S3 Upload - endpoint:${S3_ENDPOINT} s3://${S3_BUCKET}/${S3_PATH}/${FILE}"
  aws --endpoint-url=${S3_ENDPOINT} s3 cp /mongodump/db/${FILE} s3://${S3_BUCKET}/${S3_PATH}/${FILE}
fi

sleep 30 | echo End-BACKUP
curl ntfy.sh/${NOTIFY_CHANNEL}
