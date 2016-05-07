#!/bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

SRC_DIR="$DIR/../"
DST_DIR="/tmp/_site/"
S3_BUCKET="s3://ciclocapivara.com.br/"
S3_REGION="--region=sa-east-1"

echo "Building from [$SRC_DIR] to [$DST_DIR]"
jekyll build -s $SRC_DIR -d $DST_DIR
echo "Publishing to [$S3_BUCKET]"
aws s3 sync $DST_DIR $S3_BUCKET $S3_REGION
