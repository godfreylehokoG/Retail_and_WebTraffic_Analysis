-- Load stores data
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/stores.csv'
INTO TABLE retail_analysis.stores
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(store_id, store_name, location, open_status, store_type);

-- Load customers data
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customers.csv'
INTO TABLE retail_analysis.customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(customer_id, first_name, last_name, registration_date);

-- Load orders data
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/orders.csv'
INTO TABLE retail_analysis.orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, store_id, customer_id, order_date, order_amount);

-- Verify data loading and foreign key integrity
SELECT CONCAT('Stores count: ', COUNT(*)) AS stores_count FROM retail_analysis.stores;
SELECT CONCAT('Customers count: ', COUNT(*)) AS customers_count FROM retail_analysis.customers;
SELECT CONCAT('Orders count: ', COUNT(*)) AS orders_count FROM retail_analysis.orders;

-- Check for orphaned records (should return 0 rows if foreign keys are valid)
SELECT COUNT(*) AS orphaned_store_records FROM retail_analysis.orders o
WHERE NOT EXISTS (SELECT 1 FROM retail_analysis.stores s WHERE s.store_id = o.store_id);

SELECT COUNT(*) AS orphaned_customer_records FROM retail_analysis.orders o
WHERE NOT EXISTS (SELECT 1 FROM retail_analysis.customers c WHERE c.customer_id = o.customer_id);