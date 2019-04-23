-- update []
update exam
set rating='{0, 1, null, 10, null}'
where id = 1;

-- update [[]]
update busy
set schedule='{{work,sleep},{work,work},{work,work},{work,work},{work,work}}'
where id = 1;

-- update dims
update exam
set rating [ 1 : 2]='{999, 999}'
where id = 2;

-- update dims [[]]

update busy
set schedule [ 1][ 1 : 2]='{hard, hard}'
where id = 2;

select id, schedule [1][1 : 2]
from busy;

-- update single element

update exam set rating[1]='999' where id=3;

select id, rating[1] from exam where id=3;

-- update single element in [][]

update busy set schedule[2][2]='eat' where id=3;

select schedule[2][2] from busy where id=3;


