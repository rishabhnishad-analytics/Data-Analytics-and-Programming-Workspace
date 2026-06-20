-- =========================================================================
-- SQL PRACTICE LOG 3: THE COMPREHENSIVE CHALLENGE (QUESTIONS 1 - 15)
-- AUTHOR: Data & Business Analytics Portfolio
-- DATE: June 2026
-- =========================================================================

-- -------------------------------------------------------------------------
-- PART 1: DATABASE SCHEMA & REFRESH DATA SETUPS
-- -------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS tech_products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(30),
    tier VARCHAR(15),
    base_cost DECIMAL(10,2),
    licensing_model VARCHAR(20),
    release_year INT
);

CREATE TABLE IF NOT EXISTS deal_transactions (
    deal_id INT PRIMARY KEY,
    product_id INT,
    sales_manager VARCHAR(50),
    region VARCHAR(10),
    quarter VARCHAR(2),
    units_sold INT,
    deal_revenue DECIMAL(10,2)
);

TRUNCATE TABLE tech_products;
TRUNCATE TABLE deal_transactions;

INSERT INTO tech_products VALUES 
(101, 'Cloud Enterprise Storage', 'Cloud',        'Premium',  45000.00, 'Subscription', 2024),
(102, 'NextGen Firewall Core',   'Security',     'Premium',  60000.00, 'Per-User',     2023),
(103, 'SaaS HR Platform',        'Applications', 'Standard', 25000.00, 'Subscription', 2024),
(104, 'Data Analytics Engine',   'Analytics',    'Premium',  75000.00, 'Perpetual',    2025),
(105, 'AI Chatbot Integration',  'Applications', 'Standard', 15000.00, 'Subscription', 2025);

INSERT INTO deal_transactions VALUES
(1,  101, 'Rahul Verma', 'North', 'Q1', 3,  150000.00),
(2,  102, 'Amit Sharma', 'North', 'Q1', 2,  130000.00),
(3,  104, 'Rahul Verma', 'North', 'Q1', 2,  160000.00),
(4,  103, 'Amit Sharma', 'North', 'Q2', 5,  125000.00),
(5,  101, 'Rahul Verma', 'North', 'Q2', 4,  200000.00),
(6,  102, 'Priya Patel', 'West',  'Q1', 3,  195000.00),
(7,  103, 'Rohan Shah',  'West',  'Q1', 4,  100000.00),
(8,  104, 'Priya Patel', 'West',  'Q2', 3,  240000.00),
(9,  101, 'Rohan Shah',  'West',  'Q2', 2,  110000.00),
(10, 102, 'Priya Patel', 'West',  'Q3', 4,  260000.00),
(11, 104, 'Vikram Singh', 'South', 'Q1', 2,  170000.00),
(12, 101, 'Vikram Singh', 'South', 'Q1', 3,  135000.00),
(13, 103, 'Vikram Singh', 'South', 'Q2', 6,  150000.00),
(14, 102, 'Vikram Singh', 'South', 'Q2', 2,  120000.00),
(15, 104, 'Vikram Singh', 'South', 'Q3', 3,  255000.00),
(16, 103, 'Amit Sharma',  'North', 'Q3', 4,  100000.00),
(17, 102, 'Rahul Verma', 'North', 'Q3', 3,  180000.00),
(18, 104, 'Amit Sharma',  'North', 'Q4', 1,  85000.00),
(19, 101, 'Rohan Shah',  'West',  'Q3', 3,  140000.00),
(20, 104, 'Rohan Shah',  'West',  'Q4', 2,  165000.00),
(21, 102, 'Priya Patel', 'West',  'Q4', 2,  130000.00),
(22, 103, 'Rohan Shah',  'West',  'Q4', 5,  125000.00),
(23, 101, 'Rahul Verma', 'North', 'Q4', 3,  145000.00),
(24, 102, 'Amit Sharma',  'North', 'Q4', 2,  125000.00),
(25, 105, 'Priya Patel', 'West',  'Q4', 8,  120000.00);

-- -------------------------------------------------------------------------
-- PART 2: THE COMPREHENSIVE CHALLENGE SOLUTIONS (Q1 - Q15)
-- -------------------------------------------------------------------------

-- Q1: Display all transactions for the 'Premium' tier products.
SELECT dt.deal_id, dt.sales_manager, tp.product_name, dt.deal_revenue
FROM tech_products AS tp
INNER JOIN deal_transactions AS dt
    ON tp.product_id = dt.product_id
WHERE tp.tier = 'Premium';

-- Q2: Find all deals executed in the 'North' region for products released in 2024.
SELECT dt.deal_id, dt.region, tp.product_name, tp.release_year
FROM tech_products AS tp
INNER JOIN deal_transactions AS dt
    ON dt.product_id = tp.product_id
WHERE tp.release_year = 2024 AND dt.region = 'North';

-- Q3: Fetch all transactions where units sold > 3, sorted highest revenue to lowest.
SELECT deal_id, units_sold, deal_revenue
FROM deal_transactions
WHERE units_sold > 3 
ORDER BY deal_revenue DESC;

-- Q4: List all transactions managed by 'Rahul Verma' or 'Priya Patel' involving 'Subscription' products.
SELECT dt.deal_id, dt.sales_manager, tp.product_name, tp.licensing_model
FROM tech_products AS tp
INNER JOIN deal_transactions AS dt
    ON tp.product_id = dt.product_id
WHERE tp.licensing_model = 'Subscription'  
  AND dt.sales_manager IN ('Rahul Verma', 'Priya Patel');

-- Q5: Show every UNIQUE product name that generated revenue in the 'West' region during Q4.
SELECT DISTINCT tp.product_name
FROM tech_products AS tp
INNER JOIN deal_transactions AS dt
    ON dt.product_id = tp.product_id
WHERE dt.region = 'West' AND dt.quarter = 'Q4';

-- Q6: Calculate the total revenue and total units sold for each distinct product category.
SELECT tp.category,
       SUM(dt.deal_revenue) AS total_revenue,
       SUM(dt.units_sold) AS total_units_sold
FROM tech_products AS tp
INNER JOIN deal_transactions AS dt
    ON tp.product_id = dt.product_id
GROUP BY tp.category;

-- Q7: Find average revenue per deal for each manager, displaying only those > $140,000.
SELECT sales_manager, AVG(deal_revenue) AS avg_revenue
FROM deal_transactions 
GROUP BY sales_manager
HAVING AVG(deal_revenue) > 140000;

-- Q8: Group deals by region and quarter to find the total revenue (sorted highest to lowest).
SELECT region, quarter, SUM(deal_revenue) AS total_quarter_revenue
FROM deal_transactions
GROUP BY region, quarter 
ORDER BY total_quarter_revenue DESC;

-- Q9: Find which product names have been sold across more than 4 individual transactions.
SELECT tp.product_name, COUNT(dt.deal_id) AS number_of_transactions
FROM tech_products AS tp
INNER JOIN deal_transactions AS dt
    ON dt.product_id = tp.product_id
GROUP BY tp.product_id, tp.product_name
HAVING COUNT(dt.deal_id) > 4;

-- Q10: Calculate total units sold per region, filtering out regions with fewer than 15 units.
SELECT region, SUM(units_sold) AS total_units_sold
FROM deal_transactions
GROUP BY region
HAVING SUM(units_sold) > 15;

-- Q11 (Option A): Subquery checking revenue above company average (with Join context).
SELECT tp.product_name, tp.category, dt.deal_revenue
FROM tech_products AS tp
INNER JOIN deal_transactions AS dt
    ON dt.product_id = tp.product_id
WHERE dt.deal_revenue > (SELECT AVG(deal_revenue) FROM deal_transactions);

-- Q11 (Option B): Subquery checking revenue above company average (single table variables).
SELECT product_id, sales_manager, region, deal_revenue
FROM deal_transactions 
WHERE deal_revenue > (SELECT AVG(deal_revenue) FROM deal_transactions);

-- Q12: List details of products that have NEVER been sold to a client in the 'South' region.
SELECT product_id, product_name
FROM tech_products
WHERE product_id NOT IN (
    SELECT DISTINCT product_id
    FROM deal_transactions
    WHERE region = 'South'
);

-- Q13: Extract all individual deals managed by the specific manager with the highest single deal record.
SELECT * 
FROM deal_transactions
WHERE sales_manager = (
    SELECT sales_manager 
    FROM deal_transactions 
    ORDER BY deal_revenue DESC 
    LIMIT 1
);

-- Q14: Correlated Subquery - Find deals where units sold > regional average units sold.
SELECT t1.deal_id, t1.region, t1.units_sold, t1.deal_revenue
FROM deal_transactions AS t1
WHERE t1.units_sold > (
    SELECT AVG(t2.units_sold) 
    FROM deal_transactions AS t2 
    WHERE t2.region = t1.region
);

-- Q15: Find the product category that brought in the maximum aggregate revenue.
SELECT tp.category, SUM(dt.deal_revenue) AS total_revenue
FROM tech_products AS tp
INNER JOIN deal_transactions AS dt 
    ON tp.product_id = dt.product_id
GROUP BY tp.category
ORDER BY total_revenue DESC
LIMIT 1;