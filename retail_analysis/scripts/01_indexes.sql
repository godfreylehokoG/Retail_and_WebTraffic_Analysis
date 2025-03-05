-- Indexes FoR optimizING join operations and filtering
CREATE INDEX idx_orders_store_id ON retail_analysis.orders(store_id);
CREATE INDEX idx_orders_customer_id ON retail_analysis.orders(customer_id);
CREATE INDEX idx_orders_order_date ON retail_analysis.orders(order_date);
CREATE INDEX idx_customers_registration_date ON retail_analysis.customers(registration_date);
CREATE INDEX idx_stores_open_status ON retail_analysis.stores(open_status);
CREATE INDEX idx_stores_store_type ON retail_analysis.stores(store_type);

-- Composite index for common query patterns
CREATE INDEX idx_orders_customer_date ON retail_analysis.orders(customer_id, order_date);
CREATE INDEX idx_orders_store_date ON retail_analysis.orders(store_id, order_date);