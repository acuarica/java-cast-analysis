import java

from CastExpr ce, GenericType gt
where ce.getTypeExpr().getType() = gt
select ce