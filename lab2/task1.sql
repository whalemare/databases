-- Вывести информацию обо всех мастерах в возрасте старше 50 лет,
-- заработавших за последний день более 700 р

create or replace view day_master as (
  select masters.id, name, lastname, birthday, address
  from masters
         inner join work on masters.id = work.master
  where price > 500
    and (created >= (now() - interval '1 day'))
    and age(birthday) > interval '50 year'
);

select * from day_master;
