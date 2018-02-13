import java

from CastExpr ce, NullLiteral nl
where ce.getExpr() = nl
select ce