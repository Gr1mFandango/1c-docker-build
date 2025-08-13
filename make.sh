#!/bin/bash
set -e

export $(grep -v '^#' .env | xargs)

if [ ! -f .env ]; then
    echo "Please, create .env file"
    exit 1
fi

if [ -z "$HASP_SERVER" ]; then
  HASP_SERVER=localhost
fi

cp client/configs/nethasp.ini client/nethasp.ini
sed -i "s/"%HASP_SERVER%"/$HASP_SERVER/" client/nethasp.ini

docker compose up -d

rm -f client/nethasp.ini
