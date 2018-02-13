import java

from CastExpr ce, MethodAccess ma
where ce.getExpr() = ma and
  ma.getQualifier().getType().getTypeDescriptor() = "Ljava/net/URL;" and
  ma.getMethod().getName() = "openConnection"
select ce, ma