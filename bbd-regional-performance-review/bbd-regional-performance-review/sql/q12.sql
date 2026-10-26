-- Business question: product contribution tiers.
SELECT o.item AS item, SUM(o.amount) AS total_revenue, CASE WHEN SUM(o.amount) >= 60000 THEN 'High' WHEN SUM(o.amount) >= 15000 AND SUM(o.amount) < 60000 THEN 'Medium' ELSE 'Low' END AS contribution_tier FROM orders o WHERE o.status = 'completed' GROUP BY o.item ORDER BY total_revenue DESC;
