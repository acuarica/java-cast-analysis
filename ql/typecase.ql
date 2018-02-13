import java

int instanceofCountForIfChain(IfStmt is) {
  exists(int rest |
    (
      if is.getElse() instanceof IfStmt then
        rest = instanceofCountForIfChain(is.getElse())
      else
        rest = 0
    )
    and
    (
      if is.getCondition() instanceof InstanceOfExpr then
        result = 1 + rest
      else
        result = rest
    )
  )
}

from IfStmt is, int n
where
  n = instanceofCountForIfChain(is)
  and n > 0
  and not exists(IfStmt other | is = other.getElse())
select is,
  "This if block performs a chain of " + n +
  " type tests - consider alternatives, e.g. polymorphism or the visitor pattern."
