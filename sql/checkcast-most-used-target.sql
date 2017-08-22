
select *
from (
  select
    t.opcode,
    (select name from opcode where id=t.opcode),
    t.args,
    (select fullmethodname from cp_methodref_view where methodrefid=t.args),
    count(*) as cc
  from (
    select c.opcode, c.args
    from (
      select opcodeindex-1 as opcodeindex from code
      where opcode=(select id from opcode where name='checkcast')
    ) t
    left join code c on c.opcodeindex=t.opcodeindex
  ) t
  group by opcode, args
)
order by cc desc
limit 100
;
