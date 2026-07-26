---
paths:
  - "**/*.sql"
---

# SQL Style Guide

Standards for SQL formatting and naming conventions.

---

## Enforcement is the source of truth

Formatting is enforced by `sqlfluff`, not by this document. The canonical `.sqlfluff` config is what
`/add-gates` deploys: keyword capitalization upper, identifier capitalization lower, function
capitalization upper, plus sqlfluff's default layout rules (indentation, one column per line,
consistent commas, explicit whitespace, `WITH`/CTE structure). Set the `dialect` per repo
(`duckdb`, `bigquery`, `ansi`, etc.). If a formatting rule can be enforced, it lives in the config.

---

## Conventions sqlfluff can't (or shouldn't) enforce

- **CTEs over subqueries** — prefer `WITH` CTEs for readability.
- **CTE naming by transformation** — this shared vocabulary is convention, not lint:

  | Pattern | Meaning |
  |---|---|
  | `source` | raw table alias, no transformation |
  | `renamed` | column aliases and casts |
  | `filtered` | rows removed |
  | `joined` | two or more tables combined |
  | `aggregated` | GROUP BY applied |
  | `final` | last CTE before the SELECT |

- **Column naming** — snake_case; booleans `is_active` / `has_subscription` / `was_refunded`; dates
  `created_at` / `order_date`; IDs `user_id` not bare `id` in joined queries; avoid abbreviations
  (`quantity` not `qty`).
- **COALESCE for null handling** — make null handling explicit where it matters.
- **No `SELECT *` in production queries** — a judgment call, not a blanket ban. A final passthrough
  CTE (`SELECT * FROM final`) is fine; an upstream `SELECT *` that hides schema drift is not. This is
  left to judgment rather than linted, because the correct answer depends on position in the query.
- **Comments** — explain non-obvious business logic and complex JOINs with `-- reason`; don't
  comment the obvious.

---

## Example

```sql
WITH

source AS (
    SELECT * FROM orders
),

renamed AS (
    SELECT
        order_id,
        user_id,
        order_date,
        COALESCE(revenue, 0) AS revenue,
        status
    FROM source
),

filtered AS (
    SELECT *
    FROM renamed
    WHERE status != 'cancelled'
),

final AS (
    SELECT
        user_id,
        DATE_TRUNC('month', order_date) AS order_month,
        COUNT(order_id)                 AS order_count,
        SUM(revenue)                    AS total_revenue
    FROM filtered
    GROUP BY 1, 2
)

SELECT * FROM final
```
