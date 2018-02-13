import java

from CastExpr ce, MethodAccess ma, RawType rt
where ce.getExpr() = ma and ma.getQualifier().getType() = rt
select ce, ma