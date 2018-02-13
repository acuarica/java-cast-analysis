import java

predicate isEquals(Method m) {
  m.getName() = "equals" and m.getNumberOfParameters() = 1 and not m.isAbstract() and not m.isNative() and
  m.getParameterType(0).getTypeDescriptor() = "Ljava/lang/Object;" and not m.getParameter(0).isVarargs() and
  m.getReturnType().getTypeDescriptor() = "Z"
}

from CastExpr ce, Method m
where ce.getEnclosingCallable() = m and isEquals(m)
select m