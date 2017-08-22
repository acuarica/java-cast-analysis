
select count(*) method_w_checkcast_count
from (
  select distinct methodid
  from code
  where opcode=(select id from opcode where name='checkcast')
)
;
