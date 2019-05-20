-- Рейтинг убыточности товаров
-- Основан на самых часто ремонтируемых товарах

-- Количество ремонтов товара
-- Рейтинг убыточности

create or replace function repair_count_items()
    returns table
            (
                mName    varchar,
                mRepairs int
            )
as
$$
DECLARE
    variable record;
BEGIN
    for variable in (select items.type, count(*) as repair_count
                     from repairs
                              inner join items on repairs.item = items.id
                     group by items.type
                     order by repair_count desc)
        loop
            mName := variable.type;
            mRepairs := variable.repair_count;
            return next;
        end loop;
end;
$$ language plpgsql;

create or replace function rating_of_bad_items()
    returns table
            (
                myName        varchar,
                myPercentRank float
            )
as
$$
DECLARE
    variable record;
    count    int;
BEGIN
    for variable in (select mName, (percent_rank() over win)::numeric as percent_rank
                     from repair_count_items() window win as (order by mRepairs))
        loop
            myName := variable.mName;
            myPercentRank := variable.percent_rank;
            return next;
        end loop;
end
$$ language plpgsql;

create or replace function rating_of_bad_item(item varchar)
    returns table
            (
                myName        varchar,
                myPercentRank float
            )
as
$$
DECLARE
    variable record;
BEGIN
    for variable in (
        select * from rating_of_bad_items() where rating_of_bad_items.myName = item)
        loop
            myName := variable.myName;
            myPercentRank := variable.myPercentRank;
            return next;
        end loop;
end
$$ language plpgsql;

select * from rating_of_bad_items();

select * from rating_of_bad_item('Молоток');


