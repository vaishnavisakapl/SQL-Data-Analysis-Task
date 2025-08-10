-- Customers Table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(100),
    country VARCHAR(50)
);
INSERT INTO customers (name, email, country) VALUES
('John Doe', 'john@example.com', 'USA'),
('Jane Smith', 'jane@example.com', 'Canada'),
('Mike Brown', 'mike@example.com', 'USA'),
('Sara Khan', 'sara@example.com', 'India');
select * from customers;

-- Products Table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price NUMERIC(10, 2)
);
INSERT INTO products (product_name, category, price) VALUES
('Laptop', 'Electronics', 800.00),
('Phone', 'Electronics', 500.00),
('Chair', 'Furniture', 120.00),
('Table', 'Furniture', 300.00);
select * from products;

-- Orders Table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    product_id INT REFERENCES products(product_id),
    order_date DATE,
    quantity INT
);
INSERT INTO orders (customer_id, product_id, order_date, quantity) VALUES
(1, 1, '2025-07-01', 1),
(1, 2, '2025-07-05', 2),
(2, 3, '2025-07-03', 4),
(3, 4, '2025-07-06', 1),
(4, 1, '2025-07-08', 2);
select * from orders;

--QERY select, where, group by, oder by
-- 1. Select all customers from USA
SELECT * FROM customers
WHERE country = 'USA';

-- 2. List all orders sorted by order_date
SELECT * FROM orders
ORDER BY order_date DESC;

-- 3. Total quantity ordered per product
SELECT product_id, SUM(quantity) AS total_sold
FROM orders
GROUP BY product_id;

b) JOINS (INNER, LEFT, RIGHT)
-- INNER JOIN: Orders with customer names
SELECT o.order_id, c.name, p.product_name, o.quantity
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN products p ON o.product_id = p.product_id;

-- LEFT JOIN: All customers and their orders (including those without orders)
SELECT c.name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- RIGHT JOIN: All products and their orders
SELECT p.product_name, o.order_id
FROM orders o
RIGHT JOIN products p ON o.product_id = p.product_id;

c) Subqueries
-- Customers who bought more than 2 products in total
SELECT name
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING SUM(quantity) > 2
);
d) Aggregate Functions
-- Total revenue per product
SELECT p.product_name, SUM(o.quantity * p.price) AS revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name;

-- Average order quantity
SELECT AVG(quantity) AS avg_quantity FROM orders;

e) Create Views
-- View for total sales per country
CREATE VIEW sales_by_country AS
SELECT c.country, SUM(o.quantity * p.price) AS total_sales
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
GROUP BY c.country;

-- View usage
SELECT * FROM sales_by_country;

