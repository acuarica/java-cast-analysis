import java

from CastExpr ce, TestMethod tm, RefType rt
where ce.getEnclosingCallable() = tm and ce.getType() = rt
select ce, tm