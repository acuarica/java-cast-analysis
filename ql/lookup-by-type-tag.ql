import java

from CastExpr ce, SwitchStmt ss, RefType rt
where ce.getType() = rt and exists(int n | ce.getEnclosingStmt() = ss.getStmt(n))
select ss