import java

from CastExpr ce, MethodAccess ma, Method m
where ma = ce.getExpr() and m = ma.getMethod() and
	m.getName() = "newInstance"
select ce, "Expression is " + ce