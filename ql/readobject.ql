import java

from CastExpr ce, MethodAccess ma, ReadObjectMethod rom
where ce.getAChildExpr() = ma and ma.getMethod() = rom
select ma, rom