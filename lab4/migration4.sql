-- информация о производителях
create table fabrics
(
    id   serial primary key,
    name varchar
);

insert into fabrics (name)
values ('Samsung'),
       ('Apple'),
       ('Moroko'),
       ('IKEA'),
       ('TrotoPoto');

-- информация о предметах, которая может делать производитель
create table fabric_can_make
(
    id     serial primary key,
    fabric int references fabrics (id),
    item   int references items (id)
);

insert into fabric_can_make(fabric, item)
values (1, 5),
       (1, 1),
       (1, 2),
       (1, 3),
       (1, 4),
       (2, 5),
       (3, 1),
       (3, 1),
       (4, 2),
       (4, 8),
       (5, 7),
       (5, 9),
       (5, 10);

-- информация о гарантийных мастерских в разных городах и товарах
create table shops
(
    id   serial primary key,
    name varchar,
    city int references cities (id)
);

insert into shops(name, city)
values ('МихалычиКо', 1),
       ('ABC', 1),
       ('La Coco', 2),
       ('Betruda', 3),
       ('Lokomotiv', 4),
       ('Mon Paris', 5),
       ('Alpha', 6),
       ('Beta', 7),
       ('Gamma', 8),
       ('Cyber Tripple', 9),
       ('Trio de Marta', 10),
       ('Lamoda', 2),
       ('Bonda', 4),
       ('Norka', 6),
       ('Zorka', 8),
       ('Hooka', 10);

-- информация какая мастерская может ремонтировать предметы
create table shop_can_repair
(
    id   serial primary key,
    shop int references shops (id),
    item int references items (id)
);

insert into shop_can_repair(shop, item)
values (1, 1),
       (1, 2),
       (2, 1),
       (2, 2),
       (2, 3),
       (3, 3),
       (3, 4),
       (4, 4),
       (4, 5),
       (5, 5),
       (5, 6),
       (6, 6),
       (6, 7),
       (7, 7),
       (7, 8),
       (8, 8),
       (8, 9),
       (9, 9),
       (9, 10);

-- данные о выполненных работах
create table repairs
(
    id   serial primary key,
    shop int references shops (id),
    item int references items (id)
);

insert into repairs(shop, item)
values (1, 1),
       (1, 2),
       (2, 1),
       (2, 1),
       (2, 1),
       (2, 2),
       (2, 3),
       (3, 3),
       (3, 3),
       (3, 3),
       (3, 3),
       (3, 4),
       (4, 4),
       (4, 5),
       (5, 5),
       (5, 5),
       (5, 5),
       (5, 6),
       (6, 6),
       (6, 7),
       (7, 7),
       (7, 8),
       (7, 8),
       (7, 8),
       (8, 8),
       (8, 8),
       (8, 9),
       (9, 9),
       (9, 10);

