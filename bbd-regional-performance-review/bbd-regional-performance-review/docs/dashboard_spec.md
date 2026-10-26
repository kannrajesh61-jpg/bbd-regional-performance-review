# Dashboard Specification — Big Billion Days Regional Performance Review

## Data source
Connect Tableau Public to `data/orders_clean.csv`. `order_month` must be treated as a text dimension, not automatically parsed into a date. The 13 fields are:

| Field | Classification |
|---|---|
| order_id | Dimension |
| order_month | Dimension |
| clean_first_name | Dimension |
| clean_last_name | Dimension |
| region | Dimension |
| rep_name | Dimension |
| item | Dimension |
| category | Dimension |
| unit_price | Measure |
| quantity | Measure |
| amount | Measure |
| revenue_calc | Measure |
| status | Dimension |

## KPI cards
- **Total Revenue:** `SUM(amount)` = **₹346,200**. This equals Part A q05 `total_revenue`.
- **Total Units Sold:** `SUM(quantity)` = **106 units**.

## Chart sheets

### 1. Revenue by Region
- Chart type: horizontal bar chart.
- Rows: `region`; Columns: `SUM(amount)`; Colour: `region`.
- Why: bars make regional revenue levels easy to compare and rank.
- Exact chart data:

| Region | Revenue (INR) |
|---|---:|
| North | 119,300 |
| South | 82,500 |
| East | 69,500 |
| West | 74,900 |
| **Total** | **346,200** |

### 2. Revenue by Category
- Chart type: horizontal bar chart.
- Rows: `category`; Columns: `SUM(amount)`; Colour: `category`.
- Why: bars clearly compare category contribution using a common scale.
- Exact chart data:

| Category | Revenue (INR) |
|---|---:|
| Electronics | 142,300 |
| Home | 126,400 |
| Apparel | 77,500 |
| **Total** | **346,200** |

### 3. Revenue Trend by Month and Category
- Chart type: line chart.
- Columns: `order_month` (text, sorted ascending); Rows: `SUM(amount)`; Colour: `category`; Detail: `category`.
- Why: separate lines reveal each category's monthly direction and make the late-period increase visible.
- Exact chart data:

| Order month | Apparel | Electronics | Home | Total |
| 2026-09 | 24,700 | 43,000 | 30,600 | 98,300 |
| 2026-10 | 30,600 | 49,900 | 12,600 | 93,100 |
| 2026-11 | 22,200 | 49,400 | 83,200 | 154,800 |
| **Total** | **77,500** | **142,300** | **126,400** | **346,200** |

### 4. Region x Category Detail
- Chart type: text table / crosstab.
- Rows: `region`; Columns: `category`; Text/Measure: `SUM(amount)`; Colour: `SUM(amount)` using a single intensity scale.
- Why: the crosstab preserves exact values for operational follow-up while allowing quick region-category comparisons.
- Exact chart data:

| Region | Apparel | Electronics | Home | Total |
| East | 10,600 | 21,400 | 37,500 | 69,500 |
| North | 19,400 | 73,400 | 26,500 | 119,300 |
| South | 10,000 | 28,700 | 43,800 | 82,500 |
| West | 37,500 | 18,800 | 18,600 | 74,900 |
| **Total** | **77,500** | **142,300** | **126,400** | **346,200** |

## Dashboard layout
1. **Top band:** horizontal container holding the Total Revenue KPI card and Total Units Sold KPI card.
2. **Directly below KPI cards:** a horizontal filter band with the `category` filter, set to apply to all four worksheets using this data source.
3. **Trend row:** full-width horizontal container holding Revenue Trend by Month and Category.
4. **Comparison row:** horizontal container with Revenue by Region and Revenue by Category side by side.
5. **Bottom row:** full-width Region x Category Detail text table.

Use vertical containers to stack these rows in the stated top-to-bottom order and horizontal containers within the KPI and comparison rows. With **Use as Filter** switched on for Revenue by Region, clicking a region bar filters the other three worksheets to that region; the KPI cards and charts update to show only the selected region's data (subject to the category filter).

## Visualization summary
The dashboard compares completed-order revenue across regions and categories, tracks monthly category trends, and exposes the exact region-category combinations behind the totals. It reconciles to ₹346,200 across all views and represents 106 units sold.

## Summary analysis
1. **North leads regional revenue** at ₹119,300, ahead of South at ₹82,500 by ₹36,800. North is the largest regional contributor in the full completed-order dataset.
2. **Electronics is the top category** at ₹142,300, followed by Home at ₹126,400 and Apparel at ₹77,500; Electronics exceeds Apparel by ₹64,800.
3. **November is the strongest month**, with ₹154,800 versus ₹98,300 in September and ₹93,100 in October. Total revenue rose by ₹61,700 from October to November, a 66.3% increase.
4. **Regional movement is not uniform:** North declined from ₹53,500 in September to ₹41,300 in October (−22.8%), while East rose from ₹12,200 in October to ₹50,900 in November.

## Recommendations
1. **North × Electronics — protect and selectively scale the proven high-revenue pairing.** North Electronics generated ₹73,400. Run a controlled promotional push on leading electronics items in North, keeping a holdout group to measure incremental impact. Watch incremental completed-order revenue and contribution per promotional rupee.
2. **West × Apparel — test a targeted regional category promotion.** West Apparel generated ₹37,500, the largest single region-category cell. Test a limited apparel offer and compare completed revenue, units sold, and average order value against a holdout or pre-campaign baseline before expanding.
3. **Home category — prepare inventory and campaign capacity for the November peak.** Home generated ₹126,400 overall, including ₹43,800 in South and ₹37,500 in East across the full period; overall November revenue reached ₹154,800. Check item-level stock cover before a time-boxed Home promotion and monitor stockouts, completed revenue, and units sold.

## Reconciliation
| Measure | Value (INR) |
|---|---:|
| Total Revenue KPI (`SUM(amount)`) | 346,200 |
| Sum of Revenue by Region | 346,200 |
| Sum of Revenue by Category | 346,200 |
| Part B pivot grand total | 346,200 |
