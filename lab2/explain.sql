-- Execute explain without index
explain analyse select *
                from items
                where price < 2500;

explain analyse select *
                from items
                where price > 2500;

explain analyse select *
                from items
                where price = 2500;

explain analyse select *
                from items
                where price between 1000 and 2500;

-- Add index and execute with index

create index index_price on items using btree(price);
explain analyse select *
                from items
                where price < 2500;

explain analyse select *
                from items
                where price > 2500;

explain analyse select *
                from items
                where price = 2500;

explain analyse select *
                from items
                where price between 1000 and 2500;
