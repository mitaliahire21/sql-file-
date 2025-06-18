create database company;
use company;
-- Customers Table
CREATE TABLE customers (
  customer_id INT PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100),
  country VARCHAR(50)
);

-- Orders Table
CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  order_date DATE,
  total_amount DECIMAL(10, 2),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Products Table
CREATE TABLE products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(100),
  category VARCHAR(50),
  price DECIMAL(10, 2)
);

-- Order Items Table
CREATE TABLE order_items (
  item_id INT PRIMARY KEY,
  order_id INT,
  product_id INT,
  quantity INT,
  price DECIMAL(10, 2),
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);
INSERT INTO customers (customer_id, name, email, country) VALUES
(1, 'Alice Johnson', 'alice@example.com', 'USA'),
(2, 'Bob Smith', 'bob@example.com', 'Canada'),
(3, 'Charlie Lee', 'charlie@example.com', 'UK'),
(4, 'Diana Patel', 'diana@example.com', 'India');

INSERT INTO orders (order_id, customer_id, order_date, total_amount) VALUES
(101, 1, '2024-06-01', 120.00),
(102, 2, '2024-06-03', 250.00),
(103, 1, '2024-06-10', 300.00),
(104, 3, '2024-06-15', 80.00),
(105, 4, '2024-06-20', 150.00);

INSERT INTO products (product_id, product_name, category, price) VALUES
(1001, 'Wireless Mouse', 'Electronics', 25.00),
(1002, 'Bluetooth Headphones', 'Electronics', 50.00),
(1003, 'Office Chair', 'Furniture', 100.00),
(1004, 'Standing Desk', 'Furniture', 150.00),
(1005, 'Water Bottle', 'Accessories', 15.00);

INSERT INTO order_items (item_id, order_id, product_id, quantity, price) VALUES
(1, 101, 1001, 2, 25.00),
(2, 101, 1005, 1, 15.00),
(3, 102, 1002, 3, 50.00),
(4, 103, 1004, 2, 150.00),
(5, 104, 1003, 1, 100.00),
(6, 105, 1005, 2, 15.00),
(7, 105, 1001, 1, 25.00);

-- 1. Select orders with amount > 500
SELECT *
FROM orders
WHERE total_amount > 500
ORDER BY total_amount DESC;

-- 2. INNER JOIN: List customer names and their orders
SELECT c.name AS customer_name, o.order_id, o.order_date, o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;

-- 3. LEFT JOIN: All customers, including those without orders
SELECT c.name AS customer_name, o.order_id, o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- 4. RIGHT JOIN: (only in MySQL/PostgreSQL) - all orders, even if no matching customer
SELECT o.order_id, o.total_amount, c.name AS customer_name
FROM orders o
RIGHT JOIN customers c ON o.customer_id = c.customer_id;

-- 5. Total revenue per country
SELECT c.country, SUM(o.total_amount) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.country
ORDER BY total_revenue DESC;

-- 6. Average order amount per customer
SELECT c.name AS customer_name, AVG(o.total_amount) AS avg_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY avg_order_value DESC;

-- 7. Products priced above average (subquery)
SELECT *
FROM products
WHERE price > (
  SELECT AVG(price) FROM products
);

-- 8. Create view for high-spending customers
CREATE VIEW high_value_customers AS
SELECT c.customer_id, c.name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING total_spent > 1000;

-- 9. Query the view
SELECT * FROM high_value_customers;

-- 10. Create index on order_date for optimization
CREATE INDEX idx_order_date ON orders(order_date);

-- 11. Monthly revenue (use correct function based on SQL type)

-- MySQL
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(total_amount) AS revenue
FROM orders
GROUP BY month
ORDER BY month;

-- SQLite
-- SELECT strftime('%Y-%m', order_date) AS month, SUM(total_amount) AS revenue
-- FROM orders
-- GROUP BY month
-- ORDER BY month;

-- PostgreSQL
-- SELECT TO_CHAR(order_date, 'YYYY-MM') AS month, SUM(total_amount) AS revenue
-- FROM orders
-- GROUP BY month
-- ORDER BY month;
