import java

from CastExpr ce, CatchClause cc
where cc.getAChild*() = ce.getEnclosingStmt()
select ce, cc