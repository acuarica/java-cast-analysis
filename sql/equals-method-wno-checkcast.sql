
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
  select m.methodid
  -- from method m
  -- left join code c on c.methodid = m.methodid
  from code c --on c.methodid = m.methodid
  where
    m.methodname='equals' and
    m.methoddescid=(
      select methoddescid
      from cp_methoddesc
      where methoddesc ='(Ljava/lang/Object;)Z'
    )
  group by m.methodid
  having sum(c.opcode=(select id from opcode where name='checkcast')) = 0
  limit 100
-- ) t
-- left join method s on s.methodid = t.methodid
-- left join class cv on cv.classid = s.classid
-- left join cp_classname cn on cn.classnameid = cv.classnameid
-- left join jar j on j.jarid = cv.jarid

;
