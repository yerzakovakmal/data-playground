CREATE TABLE customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    name TEXT NOT NULL,
    segment VARCHAR(50)
);

CREATE TABLE products (
    product_id VARCHAR(20) PRIMARY KEY,
    product_name TEXT NOT NULL,
    category VARCHAR(50),
    sub_category VARCHAR(50)
);

CREATE TABLE locations (
    location_id SERIAL PRIMARY KEY,
    city VARCHAR(100),
    state VARCHAR(100),
    region VARCHAR(50),
    postal_code VARCHAR(20)
);

CREATE TABLE orders (
    row_id INTEGER PRIMARY KEY,

    order_id VARCHAR(30),
    product_id VARCHAR(20),
    customer_id VARCHAR(20),
    location_id INTEGER,
    order_date DATE,
    ship_date DATE,
    sales NUMERIC(10,2),
    quantity INTEGER,
    discount NUMERIC(4,2),
    profit NUMERIC(10,2),
    profit_margin NUMERIC(10,4),
    days_to_ship INTEGER,
    is_unprofitable BOOLEAN,

    -- Keys

    FOREIGN KEY(product_id) REFERENCES products(product_id),
    FOREIGN KEY(customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY(location_id) REFERENCES locations(location_id)
);