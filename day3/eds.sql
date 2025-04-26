-- Create tables

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    country VARCHAR(50)
);

CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50)
);
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
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
-- Insert sample data

INSERT INTO customers VALUES
(1, 'John', 'Doe', 'john.doe@email.com', 'USA'),
(2, 'Jane', 'Smith', 'jane.smith@email.com', 'Canada'),
(3, 'Alice', 'Johnson', 'alice.j@email.com', 'USA'),
(4, 'Bob', 'Brown', 'bob.b@email.com', 'UK');

INSERT INTO categories VALUES
(1, 'Electronics'),
(2, 'Clothing'),
(3, 'Books');

INSERT INTO products VALUES
(1, 'Laptop', 1200.00, 1),
(2, 'Smartphone', 800.00, 1),
(3, 'T-Shirt', 20.00, 2),
(4, 'Novel', 15.00, 3),
(5, 'Headphones', 150.00, 1);

INSERT INTO orders VALUES
(1, 1, '2024-04-01'),
(2, 2, '2024-04-03'),
(3, 1, '2024-04-07'),
(4, 3, '2024-04-10');

INSERT INTO order_items VALUES
(1, 1, 1, 1),
(2, 1, 5, 2),
(3, 2, 3, 3),
(4, 3, 2, 1),
(5, 4, 4, 2);

--Retriving data

SELECT * FROM customers;
SELECT * FROM categories;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;

--SELECT, WHERE, ORDERBY 

SELECT first_name, last_name, email 
FROM customers
WHERE country = 'USA'
ORDER BY last_name ASC;

--JOINS

SELECT orders.order_id, customers.first_name, customers.last_name, orders.order_date
FROM orders
INNER JOIN customers ON orders.customer_id = customers.customer_id;

SELECT p.product_name, c.category_name
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id;

--SUBQUERY

SELECT product_name, price 
FROM products
WHERE price > (SELECT AVG(price) FROM products);

--AGGREGATE FUNCTIONS 

SELECT customer_id, COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
ORDER BY total_orders DESC;

--VIEW

CREATE VIEW customer_orders_summary AS
SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    COUNT(o.order_id) AS number_of_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;
SELECT * FROM customer_orders_summary;

--INDEX

CREATE INDEX idx_customer_id ON orders (customer_id);
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'orders';
