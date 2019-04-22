drop function if exists add_n(count integer);

create function add_n(count integer) returns varchar as
$$
DECLARE
  t int;
BEGIN
  select max(id) into t from cities;
  for i in (t + 1)..(count + t)
    loop
      insert into cities(name) values (md5(random()::text));
    end loop;
  return 'Done';
end;
$$ language plpgsql;

-- create function getRandomString(length integer) returns varchar as
-- $$
-- declare
--   chars  text[]  := '{A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}';
--   result text    := '';
--   i      integer := 0;
-- begin
--   if length < 0 then
--     raise exception 'Given length cannot be less than 0';
--   end if;
--   for i in 1..length
--     loop
--       result := result || chars [ 1 + random() * (array_length(chars, 1) - 1)];
--     end loop;
--   return result;
-- end;
-- $$ language plpgsql;


