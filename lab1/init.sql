grant all privileges on database postgres to postgres;

create table if not exists orders
(
  id      serial primary key,
  created timestamp default now() CHECK (created <= now()),
  count   integer check (count >= 0)
);

create table if not exists items
(
  id   serial primary key,
  type varchar,
  cost integer
);

create table if not exists masters
(
  id       serial primary key,
  name     varchar,
  lastname varchar,
  birthday date CHECK (birthday <= now() and (extract(year from now()) - extract(year from birthday) >= 18)),
  address  varchar
);


create table if not exists cities
(
  id   serial primary key,
  name varchar
);

alter table orders
  owner to postgres;

alter table items
  owner to postgres;

alter table masters
  owner to postgres;

-- FILL DATA TO TABLES


