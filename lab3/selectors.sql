select *
from exam;

-- selector with nulls
select rating as with_nulls
from exam;

-- selector without nulls
select rating as not_nulls
from exam
where rating[3] is not null;

-- selector in matrix

select schedule from busy;

select schedule[1][1] as monday_half_day_busy from busy;

-- selector with [:]
select schedule[1:1] from busy;

-- selector with array_dims
select array_dims(schedule) from busy;