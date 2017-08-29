select count(*)
from (
select
c.methodid,
count(*) as bytecodec,
0,0 -- sum(c.opcode=(select id from opcode where name='checkcast')) as checkcastc,
-- sum(c.opcode=(select id from opcode where name='instanceof')) as instanceofc
from code c
group by c.methodid
);

-- with m as (select * from method ),
-- c as (select * from code )

-- select
  -- t.methodid --,
  -- s.methodname,
 -- (select methoddesc from cp_methoddesc where methoddescid=s.methoddescid)methodesc,
  -- s.classid,
  -- cv.classnameid,
  -- cn.classname,
  -- j.coord
-- from (
--   select m.methodid, m.methodname,
-- (select methoddesc from cp_methoddesc where methoddescid=m.methoddescid)methodesc,
--   cn.classname, j.coord
--   from method m
--   left join code c on c.methodid = m.methodid
--   left join class cv on cv.classid = m.classid
--   left join cp_classname cn on cn.classnameid = cv.classnameid
--   left join jar j on j.jarid = cv.jarid
--   where
--     m.methodname='equals' and
--     m.methoddescid=(
--       select methoddescid
--       from cp_methoddesc
--       where methoddesc ='(Ljava/lang/Object;)Z'
--     )
--   group by m.methodid
--   having sum(c.opcode=(select id from opcode where name='checkcast')) = 0
--   limit 100
-- ) t
-- left join method s on s.methodid = t.methodid
-- left join class cv on cv.classid = s.classid
-- left join cp_classname cn on cn.classnameid = cv.classnameid
-- left join jar j on j.jarid = cv.jarid

;
