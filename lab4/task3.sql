-- Анализ объемов работ

-- Количество отремонтированных товаров в магазине
create or replace function list_of_count_repairs()
    returns table
            (
                shopName varchar,
                repairedCount int
            )
as
$$
DECLARE
    variable record;
BEGIN
    for variable in (
        select name, count(shop) as repair_count
        from repairs
                 inner join shops on repairs.shop = shops.id
        group by shops.name
        order by repair_count
    )
        loop
            shopName := variable.name;
            repairedCount := variable.repair_count;
            return next;
        end loop;

end
$$ language plpgsql;

-- Количество отремонтрованных товаров в магазине
create or replace function count_of_repairs(searchShopName varchar)
    returns table
            (
                shopName varchar,
                repairedCount int
            )
as
$$
DECLARE
    variable record;
BEGIN
    for variable in (
        select name, count(shop) as repair_count
        from repairs
                 inner join shops on repairs.shop = shops.id
        where shops.name = searchShopName
        group by shops.name
        order by repair_count

    )
        loop
            shopName := variable.name;
            repairedCount := variable.repair_count;
            return next;
        end loop;

end
$$ language plpgsql;

select * from list_of_count_repairs();

select * from count_of_repairs('Beta');
select * from count_of_repairs('La Coco');
select * from count_of_repairs('Undefined');
