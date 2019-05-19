#!/usr/bin/env bash
rm -f init.sql

# lab1
cat lab1/database.sql >> init.sql

# lab2
cat lab2/function.sql >> init.sql
cat lab2/task1.sql >> init.sql
cat lab2/task2.sql >> init.sql
cat lab2/task3.sql >> init.sql

# lab3
cat lab3/arrays.sql >> init.sql
cat lab3/selectors.sql >> init.sql
cat lab3/update.sql >> init.sql

# lab4
cat lab4/migration4.sql >> init.sql

docker kill $(docker ps -q)
docker rm $(docker ps -a -q)
docker-compose up -d postgresql
docker logs --follow lab1
