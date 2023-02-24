#!/bin/bash

ARCH=$1

if [ -z $ARCH ]; then
	echo "ERROR: Architecture not specified !!!"
	echo "Try again with './push.sh amd64|arm64' options."
	exit 1
fi

set -x
docker tag kribakarans/webtop:latest kribakarans/webtop:$ARCH
sudo docker push kribakarans/webtop:$ARCH
sudo docker manifest create kribakarans/webtop:latest kribakarans/webtop:amd64 kribakarans/webtop:arm64
sudo docker manifest push kribakarans/webtop:latest
