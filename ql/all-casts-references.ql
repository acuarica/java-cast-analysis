import java

from CastExpr ce, RefType rt
where ce.getType() = rt
select ce, ce.getLocation(), "as"