-- Corrected regional revenue query: completed orders only; aggregate filter belongs in HAVING.
SELECT c.region AS region, SUM(o.amount) AS revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.status = 'completed'
GROUP BY c.region
HAVING SUM(o.amount) > 80000
ORDER BY revenue DESC;
