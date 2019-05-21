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
create or replace function shops_repair_item(itemName varchar)
    returns table
            (
                name varchar
            )
as
$$
DECLARE
    variable record;
BEGIN
    for variable in (
        select shops.name, items.type
        from shop_can_repair
                 inner join items on shop_can_repair.item = items.id
                 inner join shops on shop_can_repair.shop = shops.id
        where items.type = itemName
    )
        loop
            name := variable.name;
            return next;
        end loop;
end
$$ language plpgsql;

select * from shops_repair_item('Молоток');

-- Количество мастерских ремонтирующих товар N
-- select count(*)
-- from shops_repair_n;

-- Количество ремонтируемых товаров в мастерских одновременно ремонтирующих товары А и Б
create or replace view shops_repair_items as (
    select shops.name, count(items.type)
    from shop_can_repair
             inner join items on shop_can_repair.item = items.id
             inner join shops on shop_can_repair.shop = shops.id
    where item = 1
       or item = 2
    group by shops.name
);
select *
from shops_repair_items;

-- Количество мастерских ремонтирующих одновременно товары А и Б
select count(*)
from shops_repair_items;
