
drop table if exists mat_method_cast;

create table mat_method_cast (
       methodid integer primary key,
       bytecodec int not null,
       checkcastc int not null,
       instanceofc int not null
);

insert into mat_method_cast (methodid, bytecodec, checkcastc, instanceofc)
select
  c.methodid,
  count(*) as bytecodec,
  0,0 -- sum(c.opcode=(select id from opcode where name='checkcast')) as checkcastc,
  -- sum(c.opcode=(select id from opcode where name='instanceof')) as instanceofc
from code c
group by c.methodid;
