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
create or replace function shops_repair_item(itemName varchar, cityName varchar)
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
        select shops.name, items.type, cities.name
        from shop_can_repair
                 inner join items on shop_can_repair.item = items.id
                 inner join shops on shop_can_repair.shop = shops.id
                 inner join cities on shops.city = cities.id
        where items.type = itemName
          and cities.name = cityName
    )
        loop
            name := variable.name;
            return next;
        end loop;
end
$$ language plpgsql;

create or replace function shops_repair_items(firstItem varchar, lastItem varchar, cityName varchar)
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
        select *
        from shops_repair_item(firstItem, cityName)
    )
        loop
            name := variable.name;
            return next;
        end loop;

    for variable in (
        select *
        from shops_repair_item(lastItem, cityName)
    )
        loop
            name := variable.name;
            return next;
        end loop;
end
$$ language plpgsql;

-- Мастерские ремонтирующие товар в городе
select * from shops_repair_item('Молоток', 'Новосибирск');

-- Количество мастерских
select count(*) from shops_repair_item('Молоток', 'Новосибирск');

-- Мастерские ремонтирующие несколько товаров в городе
select distinct * from shops_repair_items('Принтер', 'Сканер', 'Сургут');
