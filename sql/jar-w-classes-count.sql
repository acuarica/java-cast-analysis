
select count(*)
from jar
where jarid in (select distinct jarid from class)
;
