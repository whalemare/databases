-- Найти всех мастеров в возрасте до 30 лет,
-- которые занимаются ремонтом заданной техники

create or replace view young_masters as (
  select masters.id, name, lastname, birthday, address, item, type, price from masters
    inner join items on masters.item = items.id
  where age(birthday) < interval '30 year'
    and items.type = 'Телефон'
);

select * from young_masters;

