-- Найти всех мастеров в возрасте до 30 лет,
-- которые занимаются ремонтом заданной техники

create or replace view young_masters as (
  select * from masters
  where age(birthday) < interval '30 year' and item = 1
);

select * from young_masters;

