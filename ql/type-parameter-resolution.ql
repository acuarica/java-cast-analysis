import java

from CastExpr ce
where ce.getType().getTypeDescriptor() = "Ljava/lang/Class;"
select ce, ce.getType().getTypeDescriptor()
