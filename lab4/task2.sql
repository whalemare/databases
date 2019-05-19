--
-- Обеспеченность каждого города мастерскими
--

-- Форматированный вывод списка городов
select shops.id, shops.name, cities.name
from shops
         inner join cities on shops.city = cities.id;

-- Количество мастерских в городах
select cities.name, count(shops.city) as count
from shops
         inner join cities on shops.city = cities.id
group by cities.name
order by count;

-- Мастерские ремонтирующие товар N
create or replace view shops_repair_n as (
    select shops.name, items.type
    from shop_can_repair
             inner join items on shop_can_repair.item = items.id
             inner join shops on shop_can_repair.shop = shops.id
    where item = 1
);

-- Количество мастерских ремонтирующих товар N
select count(*) from shops_repair_n;

-- Количество мастерских ремонтирующих товары А и Б


