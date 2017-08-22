
select count(*) equals_method_w_instanceof_count
from (
  select methodid
  from method
  where
    methodname='equals' and
    methoddescid=(
      select methoddescid
      from cp_methoddesc
      where methoddesc ='(Ljava/lang/Object;)Z'
    )
) t
inner join (
  select distinct methodid
  from code
  where opcode = (select id from opcode where name='instanceof')
) s on s.methodid = t.methodid
;
