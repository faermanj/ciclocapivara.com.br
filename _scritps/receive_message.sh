#!/bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
QUEUE_URL="https://sqs.sa-east-1.amazonaws.com/978758291456/ccp-q"
REGION=sa-east-1


for (( ; ; ))
do
	echo "Receiving message"
	MSG_HANDLE=$(aws sqs receive-message \
		--region $REGION \
		--queue-url $QUEUE_URL \
		--max-number-of-messages 1 \
		--wait-time-seconds 5 \
		--query "Messages[0].ReceiptHandle" \
		--output text)
	if [ "$MSG_HANDLE" != "None" ]
		then
		echo "Receipt handle [$MSG_HANDLE]"
		cd $DIR
		git fetch --all 
    	git reset --hard origin/master
		$DIR/build_and_publish.sh
		aws sqs delete-message \
			--region $REGION \
			--queue-url $QUEUE_URL \
			--receipt-handle $MSG_HANDLE
	fi
done
