
select m.methodid
from method m
inner join code c on c.methodid = m.methodid
where
  m.methodname='equals' and
  m.methoddescid=(
    select methoddescid
    from cp_methoddesc
    where methoddesc ='(Ljava/lang/Object;)Z'
  )
group by m.methodid
having count(c.opcode=(select id from opcode where name='checkcast')) = 0
limit 10
;
