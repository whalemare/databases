-- Обеспеченность каждого города мастерскими

-- Форматированный вывод списка городов
select shops.id, shops.name, cities.name
from shops
         inner join cities on shops.city = cities.id

-- Количество мастерских в городах


-- Количество мастерских ремонтирующих товар N

-- Количество мастерских ремонтирующих товары А и Б


