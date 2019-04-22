#!/usr/bin/env bash
rm -f init.sql

# lab1
cat lab1/database.sql >> init.sql

# lab2
cat lab2/function.sql >> init.sql

docker kill $(docker ps -q)
docker rm $(docker ps -a -q)
docker-compose up -d postgresql
docker logs --follow lab1
