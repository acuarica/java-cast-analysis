import java

from CastExpr ce, LoopStmt ls
where ls.getAChild*() = ce.getEnclosingStmt()
select ce, ls