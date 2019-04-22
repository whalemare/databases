-- Найти всех мастеров, чья работа стоит более 500 р.

create or replace view expensive_masters as (
  select masters.id,
         name,
         lastname,
         birthday,
         address,
         price
  from masters
         inner join items on masters.item = items.id
  where items.price > 500
);

select * from expensive_masters;
