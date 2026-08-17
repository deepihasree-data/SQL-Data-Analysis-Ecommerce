-- TASK 4: SQL FOR DATA ANALYSIS
-- Ecommerce Database Analysis
-- Database: PostgreSQL

-- 1. CREATE TABLES
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 2. INSERT DATA
INSERT INTO customers VALUES
(1, 'Arun Kumar', 'arun@gmail.com', 'Chennai'),
(2, 'Priya Sharma', 'priya@gmail.com', 'Coimbatore'),
(3, 'Rahul Singh', 'rahul@gmail.com', 'Bangalore'),
(4, 'Divya Raj', 'divya@gmail.com', 'Chennai'),
(5, 'Karthik Kumar', 'karthik@gmail.com', 'Madurai'),
(6, 'Sneha Patel', 'sneha@gmail.com', 'Bangalore'),
(7, 'Vijay Anand', 'vijay@gmail.com', 'Hyderabad'),
(8, 'Meena Devi', 'meena@gmail.com', 'Coimbatore');

INSERT INTO products VALUES
(101, 'Laptop', 'Electronics', 55000.00),
(102, 'Smartphone', 'Electronics', 25000.00),
(103, 'Headphones', 'Electronics', 3000.00),
(104, 'Office Chair', 'Furniture', 8500.00),
(105, 'Keyboard', 'Electronics', 1800.00),
(106, 'Mouse', 'Electronics', 900.00),
(107, 'Table', 'Furniture', 12000.00),
(108, 'Backpack', 'Accessories', 2500.00);

INSERT INTO orders VALUES
(1001, 1, '2026-01-10', 58000.00),
(1002, 2, '2026-01-15', 25000.00),
(1003, 3, '2026-02-05', 3000.00),
(1004, 1, '2026-02-20', 8500.00),
(1005, 4, '2026-03-01', 26800.00),
(1006, 5, '2026-03-12', 12900.00),
(1007, 6, '2026-03-20', 55000.00),
(1008, 2, '2026-04-02', 4300.00),
(1009, 7, '2026-04-15', 12000.00),
(1010, 3, '2026-05-10', 3400.00);

INSERT INTO order_items VALUES
(1, 1001, 101, 1),(2, 1001, 106, 1),(3, 1002, 102, 1),
(4, 1003, 103, 1),(5, 1004, 104, 1),(6, 1005, 102, 1),
(7, 1005, 105, 1),(8, 1006, 107, 1),(9, 1006, 106, 1),
(10, 1007, 101, 1),(11, 1008, 103, 1),(12, 1008, 106, 1),
(13, 1009, 107, 1),(14, 1010, 103, 1),(15, 1010, 106, 1);

-- 3. SELECT
SELECT * FROM customers;

-- 4. WHERE
SELECT * FROM customers WHERE city = 'Chennai';

-- 5. ORDER BY
SELECT * FROM orders ORDER BY total_amount DESC;

-- 6. GROUP BY + SUM
SELECT customer_id, SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id
ORDER BY total_spent DESC;

-- 7. AVG
SELECT AVG(total_amount) AS average_order_value FROM orders;

-- 8. INNER JOIN
SELECT c.customer_id, c.customer_name, o.order_id, o.order_date, o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
ORDER BY o.total_amount DESC;

-- 9. LEFT JOIN
SELECT c.customer_id, c.customer_name, o.order_id, o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

-- 10. RIGHT JOIN
SELECT c.customer_id, c.customer_name, o.order_id, o.order_date, o.total_amount
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY o.order_id;

-- 11. MULTIPLE TABLE JOIN
SELECT c.customer_name, o.order_id, p.product_name, p.category, oi.quantity
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
ORDER BY o.order_id;

-- 12. SUBQUERY
SELECT order_id, customer_id, total_amount
FROM orders
WHERE total_amount > (SELECT AVG(total_amount) FROM orders)
ORDER BY total_amount DESC;

-- 13. CREATE VIEW
CREATE VIEW customer_sales_summary AS
SELECT c.customer_id, c.customer_name, c.city,
       COUNT(o.order_id) AS number_of_orders,
       SUM(o.total_amount) AS total_spent,
       AVG(o.total_amount) AS average_order_value
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.city;

SELECT * FROM customer_sales_summary ORDER BY total_spent DESC;

-- 14. CREATE INDEX
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_order_date ON orders(order_date);

-- 15. CHECK INDEXES
SELECT indexname, tablename
FROM pg_indexes
WHERE schemaname = 'public';

-- 16. QUERY OPTIMIZATION
EXPLAIN SELECT * FROM orders WHERE customer_id = 1;
EXPLAIN ANALYZE SELECT * FROM orders WHERE customer_id = 1;
