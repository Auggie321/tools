#!/bin/bash

docker-compose stop
echo "y"|docker-compose rm -v
rm -rf esdata
docker-compose -f docker-compose.yml up -d