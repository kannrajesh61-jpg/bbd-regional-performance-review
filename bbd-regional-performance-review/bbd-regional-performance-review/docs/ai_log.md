# AI-Assisted Analysis and Human-in-the-Loop Verification Log

## D1 — Five-part prompt for q13

**Role:** You are a careful SQL business analyst writing auditable regional sales reporting queries.

**Task:** Write the SQL query for rep performance against monthly target, returning `rep_name`, `order_month`, `monthly_target`, `revenue`, and `performance_tier`.

**Context:** The schema uses `reps(rep_id, rep_name, region, monthly_target)`, `customers(customer_id, first_name, last_name, city, region, age, rep_id)`, and `orders(order_id, customer_id, item, quantity, amount, status, order_month)`. SQL dialect used for this repository: SQLite.

**Constraints:** Include completed orders only. Revenue is `SUM(amount)`. Group by rep, order month, and monthly target. Set `performance_tier` to `Below Target` when revenue is below target, `On Target` when revenue is at least target but below 1.1 times target, and `Above Target` otherwise. Do not use `WITH` clauses or stored procedures. Do not filter aggregates in `WHERE`; write the aggregate expression directly inside the `CASE` expression.

**Format:** Return raw SQL only, with inline comments.

## D1 — Inspect the assistant's original answer

Original answer:
```sql
SELECT region_name, SUM(total_sales) AS sales
FROM sales
WHERE SUM(total_sales) > 80000
GROUP BY region_name
ORDER BY sales DESC;
```
Claim: “North is the strongest region, and its revenue grew 38% month over month.”

| Defect | Classification | Why it is wrong | Correct fix |
|---|---|---|---|
| `sales` table does not exist | fake method/function | The actual schema has `orders`, not `sales`. | Query `orders` joined to `customers` to obtain region. |
| `region_name` and `total_sales` columns do not exist | fake method/function | Region is `customers.region`; revenue values are `orders.amount`. | Use `c.region` and `SUM(o.amount)`. |
| `SUM(total_sales) > 80000` is in `WHERE` | logic error | SQL filters grouped aggregate results in `HAVING`, not `WHERE`. | Put `HAVING SUM(o.amount) > 80000` after `GROUP BY`. |
| North's “38% month-over-month growth” | phantom statistic | No calculation or evidence was supplied, and the actual North values contradict growth. | Calculate using the q11 September and October North revenues. |

## D1 — Corrected query and execution evidence

Saved as `sql/d1_corrected.sql` and executed against the seed:

```sql
SELECT c.region AS region, SUM(o.amount) AS revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.status = 'completed'
GROUP BY c.region
HAVING SUM(o.amount) > 80000
ORDER BY revenue DESC;
```

| region | revenue |
|---|---:|
| North | 119300 |
| South | 82500 |

Only completed orders contribute to revenue. North's q11 revenue was ₹53,500 in 2026-09 and ₹41,300 in 2026-10. Month-over-month change = `(41,300 - 53,500) / 53,500 × 100` = **−22.8%** (rounded to one decimal). The assistant's **38% growth claim is contradicted by the data**: North revenue decreased.

## D1 — Human-in-the-loop protocol

**Specification:** I translated the vague request into a testable definition: regional revenue means the sum of `orders.amount` for `status = 'completed'`, grouped by the customer's region, retaining only regions above ₹80,000.

**Execution:** I ran the corrected query against the supplied 4-table seed after checking the row counts. It returned exactly North ₹119,300 and South ₹82,500.

**Inspection:** I inspected the SQL structure and result columns. The table and column names exist in the schema, the completed-order condition is applied before aggregation, and the aggregate threshold is in `HAVING`.

**Verification:** I cross-checked the regional result against q11 and the overall completed-order total in q05. North and South exceed the threshold, and the result values reconcile with the regional data. I independently calculated North's September-to-October change as −22.8%.

**Decision:** **Reject the original answer** because it uses a nonexistent table/columns, incorrectly filters an aggregate in `WHERE`, and makes an unsupported 38% claim contradicted by q11. **Accept the corrected version** because it runs on the real schema, returns the expected two rows, uses completed orders only, and matches the verified totals.

## D2 — Five-part root-cause prompt

**Role:** Act as a spreadsheet formula debugger who checks both lookup keys and cross-sheet references.

**Task:** Diagnose why a VLOOKUP fails even though the requested product exists, and provide a repaired formula.

**Context:** On the `orders` tab, cell `G2` contains the text ` Smart Watch` with one leading space. The `products` tab occupies `A1:C10`, with headers in row 1, item names in column A, and unit prices in column C. The formula currently entered on `orders` is `=VLOOKUP(G2, $A$2:$C$10, 3, FALSE)`.

**Constraints:** Explain the exact-match issue; preserve exact matching; trim unwanted spaces from the lookup key; use an absolute range; explicitly reference the `products` sheet so the range is not accidentally taken from the `orders` tab.

**Format:** Give the root cause in plain English, then provide one repaired formula and explain why it works.

**Root cause:** `G2` has a leading space, so the exact-match lookup key is not equal to `Smart Watch` in the product list. Also, because the formula is entered on the `orders` tab, the range should explicitly reference `products`; otherwise `$A$2:$C$10` points to the current sheet.

**Repaired formula:**
```excel
=VLOOKUP(TRIM(G2), products!$A$2:$C$10, 3, FALSE)
```
`TRIM(G2)` removes the leading space, `products!` points to the correct lookup table, `$A$2:$C$10` stays fixed when copied, `3` returns the unit price, and `FALSE` preserves exact matching.

## Skeptical-analyst prompt for the first Part C recommendation

**Role:** Act as a skeptical senior commercial analyst reviewing a proposed promotion recommendation.

**Task:** Challenge the recommendation “North × Electronics — protect and selectively scale the proven high-revenue pairing” and identify what evidence would be needed before claiming that a promotion will cause incremental growth.

**Context:** The completed-order data shows North Electronics revenue of ₹73,400, North total revenue of ₹119,300, and total Electronics revenue of ₹142,300. The dataset contains order-level amounts, units, regions, categories, and months, but no campaign exposure, discount, margin, inventory, or holdout-group fields.

**Constraints:** Ask for unstated assumptions and evidence of cause, not just correlation. Distinguish descriptive facts from causal claims. Suggest specific checks available in this dataset and name missing data needed for a stronger decision.

**Format:** Return a concise critique with assumptions, checks, and a recommendation for a controlled test.

### Unstated assumptions and checks

| Assumption behind the recommendation | Figure/check that would confirm or weaken it |
|---|---|
| North's Electronics sales are consistently strong rather than driven by one unusual month. | Break North Electronics revenue down by month and item. The current overall North Electronics total is ₹73,400; use a month-by-month pivot to check whether the total is broadly distributed or concentrated. |
| High revenue means high profitability and leaves room for a promotion. | The dataset has no margin, discount, or fulfilment-cost fields. Obtain contribution margin by item and discount cost before scaling; revenue alone cannot confirm profitability. |
| A promotion would cause incremental sales rather than subsidise orders that would have happened anyway. | The current data has no promotion flag or control group. Run a randomized/holdout test and compare incremental completed-order revenue, units, and contribution per promotional rupee. |
| Sufficient stock is available for the promoted items. | The dataset has no inventory or stockout fields. Check current stock cover and historical stockout rates for North Electronics before committing spend. |
