-- Анализ объемов работ

-- Количество отремонтированных товаров в магазине
select name, count(shop) as repair_count
from repairs
         inner join shops on repairs.shop = shops.id
group by shops.name
order by repair_count;
