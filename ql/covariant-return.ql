import java

from CastExpr ce, RefType rt, Method m, Method d, VirtualMethodAccess vma
where ce.getType() = rt and ce.getEnclosingCallable() = m and m.overrides(d) and ce.getExpr() = vma  and vma.isOwnMethodAccess()
select ce, m, d, vma