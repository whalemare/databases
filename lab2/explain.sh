#!/usr/bin/env bash

function postgres() {
    docker exec -it lab1 psql -U postgres -d postgres -c "$1"
}

function explain() {
    docker exec -it lab1 psql -U postgres -d postgres -c "explain analyse select * from items where price = $start;" >> $1
    docker exec -it lab1 psql -U postgres -d postgres -c "explain analyse select * from items where price < $start;" >> $1
    docker exec -it lab1 psql -U postgres -d postgres -c "explain analyse select * from items where price > $start;" >> $1
    docker exec -it lab1 psql -U postgres -d postgres -c "explain analyse select * from items where price between $start and $end;" >> $1
}

function explainFunctional() {
    docker exec -it lab1 psql -U postgres -d postgres -c "explain analyse select * from items where upper(type)='ПЫЛЕСОС';" >> $1
}

start=2500
end=5000

rm -rf reports
mkdir reports
cd reports
    echo "Drop all indexes"
    postgres "drop index if exists index_price"
    postgres "drop index if exists index_btree_price"
    postgres "drop index if exists index_hash_price"
    postgres "drop index if exists functional_type"

    echo "Explain without index"
    explain "simple.txt"

    echo "Explain with btree index"
    postgres "create index index_btree_price on items using btree(price)"
    explain "indexed_btree_price.txt"
    postgres "drop index if exists index_btree_price"

    echo "Explain with hash index"
    postgres "create index index_hash_price on items using hash(price)"
    explain "indexed_hash_price.txt"
    postgres "drop index if exists index_hash_price;"

    echo "Explain without functional index"
    explainFunctional "functional_simple.txt"

    echo "Explain with functional index"
    postgres "create index functional_type on items (upper(type))"
    explainFunctional "functional_upper_type.txt"
cd ..
