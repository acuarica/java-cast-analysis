import java

from InstanceOfExpr ie, ReturnStmt rs
where rs.getResult() = ie
select rs, ie