-- drop user postgres;
-- create user postgres with password 'postgres'
--   superuser
--   createdb
--   createrole
--   replication
--   bypassrls;
--
-- create database postgres
--   encoding = 'UTF8'
--   connection limit = -1;

grant all privileges on database postgres to postgres;

create table if not exists orders
(
  id      serial primary key,
  created timestamp default now() CHECK (created <= now()),
  count   integer
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
  birthday date /*CHECK (birthday <= now() && (extract(year from now()) - extract(year from birthday) >= 18))*/,
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
