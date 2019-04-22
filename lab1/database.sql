grant all privileges on database postgres to postgres;

create table if not exists cities
(
  id   serial primary key,
  name varchar
);

create table if not exists masters
(
  id       serial primary key,
  name     varchar,
  lastname varchar,
  birthday date CHECK (birthday <= now() and (extract(year from now()) - extract(year from birthday) >= 18)),
  address  varchar
);

create table if not exists orders
(
  id      serial primary key,
  created timestamp default now() CHECK (created <= now()),
  count   integer check (count > 0)
);

create table if not exists items
(
  id   serial primary key,
  type varchar,
  price integer
);

-- region ADD PERMISSIONS
alter table cities
  owner to postgres;

alter table masters
  owner to postgres;

alter table orders
  owner to postgres;

alter table items
  owner to postgres;
-- endregion

--region FILL DATA TO TABLES

insert into cities (name)
values ('Новосибирск'),
       ('Краснодар'),
       ('Екатеринбург'),
       ('Красноярск'),
       ('Урюпинск'),
       ('Сургут'),
       ('Кемерово'),
       ('Москва'),
       ('Сызрань'),
       ('Новгород');

-- year/month/day
insert into masters (name, lastname, birthday, address)
values ('Александр', 'Кузьмин', '1992/08/12',
        '121352, г. Красноармейская, ул. Магистральный Переулок, дом 65, квартира 278'),
       ('Роза', 'Лебедева', '1990/01/12', '164549, г. Рыбная Слобода, ул. Одоевского Проезд, дом 80, квартира 128'),
       ('Василиса', 'Баландина', '1980/01/12',
        '453238, г. Вадинск, ул. Воздвиженский 2-й Переулок, дом 47, квартира 71'),
       ('Викторина', 'Трифонова', '1984/01/12',
        '453238, г. Вадинск, ул. Воздвиженский 2-й Переулок, дом 47, квартира 71'),
       ('Мая', 'Кудрявцева', '1983/08/11', '453238, г. Вадинск, ул. Воздвиженский 2-й Переулок, дом 47, квартира 71'),
       ('Адам', 'Попов', '1993/08/10', '433252, г. Нилово, ул. Котельнический 5-й Переулок, дом 37, квартира 269'),
       ('Илья', 'Кириллов', '1983/08/09', '453238, г. Вадинск, ул. Воздвиженский 2-й Переулок, дом 47, квартира 71'),
       ('Сергей', 'Бордунов', '1986/08/08', '453238, г. Вадинск, ул. Воздвиженский 2-й Переулок, дом 47, квартира 71'),
       ('Валентин', 'Емельянов', '1996/08/07', '601624, г. Скалистый, ул. Подсосенский Переулок, дом 66, квартира 280'),
       ('Жора', 'Власов', '1988/08/06', '428014, г. Яровое, ул. МКАД 46 км Дорога, дом 43, квартира 35');

insert into items (type, price)
values ('Телефон', round(random() * (5000 - 0) + 0)),
       ('Молоток', round(random() * (5000 - 0) + 0)),
       ('Компьютер', round(random() * (5000 - 0) + 0)),
       ('Мышка', round(random() * (5000 - 0) + 0)),
       ('Клавиатура', round(random() * (5000 - 0) + 0)),
       ('Монитор', round(random() * (5000 - 0) + 0)),
       ('Принтер', round(random() * (5000 - 0) + 0)),
       ('Сканер', round(random() * (5000 - 0) + 0)),
       ('Вентилятор', round(random() * (5000 - 0) + 0)),
       ('Пылесос', round(random() * (5000 - 0) + 0));

insert into orders (count)
values (1),
       (2),
       (3),
       (4),
       (5),
       (6),
       (7),
       (8),
       (9),
       (10);

--endregion

-- region CREATE LINKED TABLE

create table if not exists work
(
  id serial primary key,
  master int references masters(id),
  item int references items(id),
  created date default now() check ( created >= now()),
  price int check ( price > 0 )
);

-- endregion
