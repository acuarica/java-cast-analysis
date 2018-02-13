import java

from CastExpr ce, MethodAccess ma
where ce.getExpr() = ma and ma.getMethod().getName() = "getLogger"
select ce, ma, ma.getQualifier()
