import java

from CastExpr ce, MethodAccess ma
where ce.getExpr() = ma and
  ma.getQualifier().getType().getTypeDescriptor() = "Ljava/lang/Throwable;" and
  ma.getMethod().getName() = "getCause"
select ce, ma