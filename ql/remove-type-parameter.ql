import java

from CastExpr ce, RawType rt
where ce.getTypeExpr().getType() = rt
select ce