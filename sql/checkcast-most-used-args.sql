
select t.args, cp.classname, t.cc
from (
  select args, count(*) as cc
  from code
  where opcode=(select id from opcode where name='checkcast')
  group by args
) t
left join cp_classname cp on cp.classnameid=t.args
order by t.cc desc
limit 100
;
