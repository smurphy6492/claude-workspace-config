---
paths:
  - "**/*.sql"
---

# SQL Style Guide

Standards for SQL formatting and naming conventions.

---

## Formatting

- **CTEs over subqueries** — always prefer `WITH` CTEs for readability
- **One column per line** in SELECT statements
- **Explicit JOIN syntax** — always write `INNER JOIN`, `LEFT JOIN`, etc. (never comma joins)
- **Uppercase keywords** — `SELECT`, `FROM`, `WHERE`, `JOIN`, `GROUP BY`, `ORDER BY`
- **Lowercase identifiers** — table names, column names, CTE names
- **Trailing commas** on all but the last column (or leading — pick one and be consistent)
- **COALESCE for null handling** — make null handling explicit, don't rely on implicit behavior

---

## CTE Naming Conventions

Name CTEs by what transformation they perform:

| Pattern | Example |
|---|---|
| `source` | raw table alias with no transformation |
| `renamed` | column aliases and casts |
| `filtered` | rows removed |
| `joined` | two or more tables combined |
| `aggregated` | GROUP BY applied |
| `final` | last CTE before the SELECT |

---

## Column Naming
- `snake_case` for all column names
- Boolean columns: `is_active`, `has_subscription`, `was_refunded`
- Date columns: `created_at`, `updated_at`, `order_date`
- ID columns: `user_id`, `order_id` (not just `id` in joined queries)
- Avoid abbreviations unless universally understood (`qty` → `quantity`)

---

## Comments
- Comment non-obvious business logic with `-- reason`
- Comment complex JOIN conditions
- No need to comment obvious things (`-- select all users`)

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

---

## Anti-Patterns
- ❌ `SELECT *` in production queries
- ❌ Subqueries where a CTE would be clearer
- ❌ Implicit NULL handling (always use COALESCE)
- ❌ Undescriptive column aliases (`a`, `x`, `col1`)
- ❌ Mixing case in keywords (`Select`, `select`, `SELECT`)
