-- Create schema to isolate our analysis
CREATE SCHEMA IF NOT EXISTS retail_analysis;

-- Create stores table with appropriate constraints and indexes
DROP TABLE IF EXISTS retail_analysis.stores;
CREATE TABLE retail_analysis.stores (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    open_status VARCHAR(10) CHECK (open_status IN ('Open', 'Closed')),
    store_type VARCHAR(10) CHECK (store_type IN ('Large', 'Medium', 'Small'))
);

-- Create customers table with appropriate constraints and indexes
DROP TABLE IF EXISTS retail_analysis.customers;
CREATE TABLE retail_analysis.customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    registration_date DATE NOT NULL
);

-- Create orders table with appropriate constraints and indexes
DROP TABLE IF EXISTS retail_analysis.orders;
CREATE TABLE retail_analysis.orders (
    order_id INT PRIMARY KEY,
    store_id INT NOT NULL,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL CHECK (order_date BETWEEN '2023-01-01' AND '2023-12-31'),
    order_amount DECIMAL(10, 2) NOT NULL CHECK (order_amount > 0),
    FOREIGN KEY (store_id) REFERENCES retail_analysis.stores(store_id),
    FOREIGN KEY (customer_id) REFERENCES retail_analysis.customers(customer_id)
);