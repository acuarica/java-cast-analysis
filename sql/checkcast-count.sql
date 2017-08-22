
select count(*) checkcast_count
from code
where opcode=(select id from opcode where name='checkcast')
;
