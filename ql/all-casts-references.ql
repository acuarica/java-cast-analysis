/**
 * This query is the starting point of our manual inspection.
 * It gets all the casts (non-primitive) for further analysis.
 *
 * From this point we start to divise several cast usage patterns.
 * For each pattern we present a different QL query that refines this one.
 */
import java

from CastExpr ce
where ce.getType() instanceof RefType
select ce