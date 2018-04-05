/**
 */
import java

from InstanceOfExpr ioe, CastExpr ce, Method m, Method d, Parameter p
where ioe.getExpr() = p.getAnAccess() and ce.getExpr() = p.getAnAccess() and
  m = ce.getEnclosingCallable() and m.overrides(d)
select ce, m, d