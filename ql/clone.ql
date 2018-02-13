import java

from CastExpr ce, CloneMethod cm
where ce.getEnclosingCallable() = cm
select cm, ce