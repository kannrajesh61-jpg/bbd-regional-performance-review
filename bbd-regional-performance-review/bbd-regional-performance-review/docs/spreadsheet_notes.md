# Spreadsheet Cleaning and Pivot Notes

## Setup
- Spreadsheet tool: Google Sheets (free).
- Tabs created: `orders` (imported from `data/orders_enriched.csv`) and `products` (product lookup table).
- `orders` contains 90 data rows plus its header (91 rows total). `order_month` was imported/formatted as **Plain text**; values remain `2026-09`, `2026-10`, and `2026-11`.
- The `products` tab contains the query `SELECT item, category, unit_price FROM products ORDER BY item` including headers in `A1:C10`.
- Added columns on `orders`: K `clean_first_name`, L `clean_last_name`, M `category`, N `unit_price`, O `revenue_calc`.
- First data-row formulas (copied down through row 91):
  - `clean_first_name` (K2): `=PROPER(TRIM(C2))`
  - `clean_last_name` (L2): `=PROPER(TRIM(D2))`
  - `category` (M2): `=VLOOKUP(G2,products!$A$2:$C$10,2,FALSE)`
  - `unit_price` (N2): `=XLOOKUP(G2,products!$A$2:$A$10,products!$C$2:$C$10,"UNKNOWN_ITEM")`
  - `revenue_calc` (O2): `=N2*H2`
- Missing-key fallback test in a spare cell: `=XLOOKUP("Mystery Item",products!$A$2:$A$10,products!$C$2:$C$10,"UNKNOWN_ITEM")` displayed `UNKNOWN_ITEM`.
- Filtered `status = completed`, sorted visible rows by `amount` largest to smallest, and pasted the 63 visible rows as values into `completed_orders`. Kept cleaned names and removed raw `first_name` / `last_name`. The exported data range is header plus 63 rows; summary/pivot outputs are outside that range.

## Completed-order aggregate block
| Metric | Formula | Result |
|---|---|---:|
| COUNT | `=COUNT(K2:K64)` (use the amount column range in the actual completed_orders layout) | 63 |
| SUM | `=SUM(K2:K64)` | ₹346,200 |
| AVERAGE | `=AVERAGE(K2:K64)` | ₹5,495.24 |
| MIN | `=MIN(K2:K64)` | ₹1,100 |
| MAX | `=MAX(K2:K64)` | ₹15,600 |

The amount column is K in the stated 13-column exported order. The formulas above are illustrative of the amount range in a completed-order tab; if using the exact 13-column order, `amount` is column K.

## Pivot table (i): Sum of amount by category and region
| Category | East | North | South | West | Grand Total |
|---|---:|---:|---:|---:|---:|
| Apparel | 10,600 | 19,400 | 10,000 | 37,500 | 77,500 |
| Electronics | 21,400 | 73,400 | 28,700 | 18,800 | 142,300 |
| Home | 37,500 | 26,500 | 43,800 | 18,600 | 126,400 |
| **Grand Total** | **69,500** | **119,300** | **82,500** | **74,900** | **346,200** |

## Pivot table (ii): Sum of amount and count of order_id by month
| Order month | Sum of amount | Count of order_id |
|---|---:|---:|
| 2026-09 | 98,300 | 19 |
| 2026-10 | 93,100 | 20 |
| 2026-11 | 154,800 | 24 |
| **Grand Total** | **346,200** | **63** |

## Reconciliation
| Metric | Spreadsheet | Part A q05 | Match/Mismatch |
|---|---:|---:|---|
| COUNT | 63 | 63 (`total_orders`) | Match |
| SUM | ₹346,200 | ₹346,200 (`total_revenue`) | Match |
| AVERAGE | ₹5,495.24 | ₹5,495.24 (`avg_order_value`, rounded to 2 decimals) | Match |

## Data validation
- Missing amounts: q02 identified order IDs **1001, 1010, 1064**. All three are pending, so they are not part of completed-order revenue. I left missing amounts blank rather than replacing them with zero, because zero would imply a known monetary value and could distort averages.
- Data types: `order_id`, `quantity`, `unit_price`, `amount`, and `revenue_calc` are numeric values; `order_month` remains text; names, region, rep, item, category, and status are text. I checked numeric columns with spreadsheet number formatting and aggregate functions rather than relying on visual appearance.
- Duplicate order IDs: none among the 63 completed orders; each `order_id` is unique.
- Largest completed amount: **₹15,600**, tied by order IDs **1061, 1065, 1069, 1077**. These match unit_price × quantity.
- Decision for the next analyst: preserve `order_month` as text and never convert blank amounts to zero; use `status = completed` consistently for revenue and retain the source `amount` alongside `revenue_calc` for reconciliation.
