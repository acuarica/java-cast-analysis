import java

from CastExpr ce, MethodAccess ma, FieldAccess fa
where ma = ce.getExpr() and
    not ma.getMethod().isStatic() and not ma.getMethod().isVarargs() and
    ma.getMethod().isPublic() and
    ma.getMethod().getNumberOfParameters() = 1 and
    ma.getMethod().getParameterType(0).getTypeDescriptor() = "Ljava/lang/String;" and
    ma.getMethod().getReturnType().getTypeDescriptor() = "Ljava/lang/Object;" and
    ma.getArgument(0).getType().getTypeDescriptor() = "Ljava/lang/String;" and
    ma.getArgument(0) = fa and
    fa.getField().isFinal() and fa.getField().isStatic() and //fa.getField().isPublic() and
    fa.getField().getType().getTypeDescriptor() = "Ljava/lang/String;" // Double-check
select ce, "Expression is " + ce + " " + fa.getField().pp()
