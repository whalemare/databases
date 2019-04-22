drop function if exists add_n(count integer);

create function add_n(count integer) returns varchar as
$$
DECLARE
  t int;
BEGIN
  select max(id) into t from cities;
  for i in (t + 1)..(count + t)
    loop
      insert into items(type, price) values (md5(random()::text), round(random() * (5000 - 1000) + 1000));
    end loop;
  return 'Done';
end;
$$ language plpgsql;


-- Add 1000 random elements into cities table
select add_n(1000);

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
