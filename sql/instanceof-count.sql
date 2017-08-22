

select count(*) instanceof_count
from code
where opcode=(select id from opcode where name='instanceof')
;
