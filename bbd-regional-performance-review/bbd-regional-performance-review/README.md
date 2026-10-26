# Big Billion Days Regional Performance Review

A traceable analytics pipeline for the synthetic Flipkart Big Billion Days dataset: SQL reporting, spreadsheet cleaning and reconciliation, dashboard specification, and human-verified AI assistance.

- **SQL compiler:** SQLite-compatible local execution via Python's built-in `sqlite3` engine for this prepared repository. SQL dialect: SQLite.
- **Spreadsheet tool:** Google Sheets (free); formulas, filters, and pivots are documented in `docs/spreadsheet_notes.md`.
- **Dashboard in Tableau Public:** No. The dashboard is specified in `docs/dashboard_spec.md`, and its figures are calculated from the cleaned CSV as allowed by the brief.

## Three most important findings

Completed-order revenue is ₹346,200 across 63 orders and 106 units. North is the largest region at ₹119,300, followed by South at ₹82,500, West at ₹74,900, and East at ₹69,500. Electronics leads category revenue at ₹142,300, with Home at ₹126,400 and Apparel at ₹77,500. November is the strongest month at ₹154,800, compared with ₹98,300 in September and ₹93,100 in October. North's revenue declined 22.8% from September to October, so the assistant's unsupported claim of 38% growth is false.

## File index

| File | Part | Purpose |
|---|---|---|
| `sql/00_schema_and_seed.sql` | A | Creates and loads the four source tables |
| `sql/q01.sql`–`sql/q13.sql` | A | Thirteen required reporting queries |
| `sql/d1_corrected.sql` | D | Corrected and executed regional revenue query |
| `results/query_results.md` | A, D | Seed counts, query results, and corrected D1 result |
| `data/orders_enriched.csv` | A | Full q09 order-level export, 90 rows |
| `data/orders_clean.csv` | B | Completed-order export with 13 cleaned/enriched columns |
| `docs/spreadsheet_notes.md` | B | Formulas, aggregate checks, pivots, validation and setup notes |
| `docs/dashboard_spec.md` | C | Tableau-ready field, KPI, worksheet, layout and narrative specification |
| `docs/ai_log.md` | D | Structured prompts, defect review, verification protocol and skeptical review |

## Assumptions

- Revenue always means `SUM(amount)` for `status = 'completed'`, except where a task explicitly asks for all statuses.
- SQLite was selected as the SQL dialect. `order_month` is preserved as text, and missing amounts remain blank in CSV exports.
- The dashboard specification is completed in text without building a Tableau Public workbook, an option allowed by the brief.
- No actual promotion, profit-margin, inventory, or campaign-exposure data is present, so recommendations are framed as controlled tests rather than proven causal outcomes.
