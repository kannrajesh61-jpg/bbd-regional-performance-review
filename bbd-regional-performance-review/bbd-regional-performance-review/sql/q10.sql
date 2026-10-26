-- Business question: customers who never ordered.
SELECT c.customer_id AS customer_id, c.first_name AS first_name, c.last_name AS last_name, c.region AS region FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id WHERE o.order_id IS NULL ORDER BY c.customer_id;
