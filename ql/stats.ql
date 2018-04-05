/**
 * This query gets some basic stats per project.
 * It counts all the primitive casts and reference casts and the number of expressions.
 * The number of expressions is a way to estimate the size of the projects.
 */
import java

select count(Expr e), count(CastExpr ce), count(CastExpr ce | ce.getType() instanceof RefType)