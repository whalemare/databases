create table if not exists exam
(
  id     serial primary key,
  master int references masters (id),
  rating int[] default (array [
    random() * (10 - 0) + 0,
    random() * (10 - 0) + 0,
    random() * (10 - 0) + 0,
    random() * (10 - 0) + 0,
    random() * (10 - 0) + 0,
    random() * (10 - 0) + 0,
    random() * (10 - 0) + 0,
    random() * (10 - 0) + 0
    ])
);

insert into exam (master, rating)
values (1, array [0, 1, null, 10, null]);

insert into exam (master)
values (2),
       (3),
       (4),
       (5),
       (6),
       (7),
       (8),
       (9),
       (10);


create table busy
(
  id       serial primary key,
  master   int references masters (id),
  schedule varchar[][]
);

-- busy in days of week
insert into busy (master, schedule)
values (1, array [['work', 'sleep'], ['work', 'work'], ['work', 'work'], ['work', 'work'], ['work', 'work']]),
       (2, array [['work', 'work'], ['sleep', 'sleep'], ['work', 'work'], ['work', 'work'], ['work', 'work']]),
       (3, array [['sleep', 'sleep'], ['work', 'work'], ['work', 'work'], ['work', 'work'], ['work', 'work']]),
       (4, array [['sleep', 'work'], ['work', 'sleep'], ['work', 'work'], ['work', 'work'], ['work', 'work']]),
       (5, array [['work', 'sleep'], ['work', 'work'], ['work', 'work'], ['work', 'work'], ['work', 'work']]),
       (6, array [['work', 'work'], ['sleep', 'work'], ['work', 'work'], ['work', 'work'], ['work', 'work']]),
       (7, array [['work', 'sleep'], ['work', 'sleep'], ['work', 'work'], ['work', 'work'], ['work', 'work']]),
       (8, array [['sleep', 'work'], ['work', 'work'], ['work', 'work'], ['work', 'work'], ['work', 'work']]),
       (9, array [['sleep', 'sleep'], ['work', 'sleep'], ['work', 'work'], ['work', 'work'], ['work', 'work']]),
       (10, array [['work', 'work'], ['sleep', 'work'], ['work', 'work'], ['work', 'work'], ['work', 'work']]);


