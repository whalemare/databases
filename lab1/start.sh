#!/usr/bin/env bash

docker kill $(docker ps -q)
docker rm $(docker ps -a -q)
docker-compose up -d postgresql
docker logs --follow lab1