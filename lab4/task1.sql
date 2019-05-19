-- Рейтинг убыточности товаров
-- Основан на самых часто ремонтируемых товарах

-- Количество ремонтов товара
-- Рейтинг убыточности
select items.type, count(*) as repair_count
from repairs
         inner join items on repairs.item = items.id
group by items.type
order by repair_count desc;

