import java

from CastExpr ce, MethodAccess ma
where ce.getExpr() = ma and ma.getQualifier().getType().getTypeDescriptor() = "Ljava/lang/reflect/Field;"
select ce, ma