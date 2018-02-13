import java

from InstanceOfExpr ioe, RefType t, RefType ct
where t = ioe.getExpr().getType()
  and ct = ioe.getTypeName().getType()
  and ct = t.getASupertype+()
select ioe, "There is no need to test whether an instance of $@ is also an instance of $@ - it always is.",
  t, t.getName(),
  ct, ct.getName()