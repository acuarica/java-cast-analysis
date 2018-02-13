import java

from CastExpr ce, FieldAccess fa
where ce.getExpr() = fa
select ce, "Expression is " + ce + " " + fa.getField().pp()