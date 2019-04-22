#!/usr/bin/env bash

function postgres() {
    docker exec -it lab1 psql -U postgres -d postgres -c "$1"
}

echo "Cities"
postgres "select * from cities limit 20"

echo "Items"
postgres "select * from items limit 20"

echo "Masters"
postgres "select * from masters limit 20"

echo "Orders"
postgres "select * from orders limit 20"
