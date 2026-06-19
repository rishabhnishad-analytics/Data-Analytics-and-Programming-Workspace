-- =========================================================================
-- MASTER SQL PRACTICE2: WINDOW FUNCTIONS FOR BUSINESS ANALYTICS
-- Target Dataset: Corporate Sales Performance (25 Balanced Entries)
-- =========================================================================

-- -------------------------------------------------------------------------
-- STEP 1: DATABASE & TABLE SETUP
-- -------------------------------------------------------------------------

-- Create the table structure
CREATE TABLE IF NOT EXISTS corporate_sales (
    deal_id INT PRIMARY KEY,
    fiscal_year INT,
    quarter VARCHAR(2),
    sales_manager VARCHAR(50),
    region VARCHAR(10),
    product_line VARCHAR(30),
    revenue DECIMAL(10, 2)
);

-- Clear any old data to ensure a fresh build
TRUNCATE TABLE corporate_sales;

-- Insert 25 balanced mock transaction rows (5 deals per manager across regions)
INSERT INTO corporate_sales (deal_id, fiscal_year, quarter, sales_manager, region, product_line, revenue) VALUES
(1,  2025, 'Q1', 'Rahul Verma', 'North', 'Enterprise Software', 145000.00),
(2,  2025, 'Q1', 'Amit Sharma', 'North', 'Cloud Storage',       130000.00),
(3,  2025, 'Q2', 'Rahul Verma', 'North', 'Cybersecurity',       115000.00),
(4,  2025, 'Q2', 'Amit Sharma', 'North', 'Enterprise Software', 125000.00),
(5,  2025, 'Q3', 'Rahul Verma', 'North', 'Cloud Storage',       150000.00),
(6,  2025, 'Q1', 'Priya Patel', 'West',  'Cybersecurity',       190000.00),
(7,  2025, 'Q1', 'Rohan Shah',  'West',  'Enterprise Software',  90000.00),
(8,  2025, 'Q2', 'Priya Patel', 'West',  'Cloud Storage',       175000.00),
(9,  2025, 'Q2', 'Rohan Shah',  'West',  'Cybersecurity',       110000.00),
(10, 2025, 'Q3', 'Priya Patel', 'West',  'Enterprise Software', 160000.00),
(11, 2025, 'Q1', 'Vikram Singh', 'South', 'Cloud Storage',       135000.00),
(12, 2025, 'Q2', 'Vikram Singh', 'South', 'Cybersecurity',       140000.00),
(13, 2025, 'Q3', 'Vikram Singh', 'South', 'Enterprise Software', 120000.00),
(14, 2025, 'Q4', 'Vikram Singh', 'South', 'Cloud Storage',       155000.00),
(15, 2025, 'Q4', 'Vikram Singh', 'South', 'Cybersecurity',       130000.00),
(16, 2025, 'Q3', 'Amit Sharma',  'North', 'Cloud Storage',       110000.00),
(17, 2025, 'Q4', 'Rahul Verma', 'North', 'Cybersecurity',       135000.00),
(18, 2025, 'Q4', 'Amit Sharma',  'North', 'Enterprise Software', 140000.00),
(19, 2025, 'Q4', 'Rohan Shah',  'West',  'Cloud Storage',       125000.00),
(20, 2025, 'Q3', 'Rohan Shah',  'West',  'Cybersecurity',       130000.00),
(21, 2025, 'Q4', 'Priya Patel', 'West',  'Enterprise Software', 145000.00),
(22, 2025, 'Q1', 'Rohan Shah',  'West',  'Cloud Storage',       105000.00),
(23, 2025, 'Q2', 'Rahul Verma', 'North', 'Cybersecurity',       120000.00),
(24, 2025, 'Q3', 'Amit Sharma',  'North', 'Enterprise Software', 115000.00),
(25, 2025, 'Q5', 'Priya Patel', 'West',  'Cloud Storage',       150000.00);


-- -------------------------------------------------------------------------
-- STEP 2: BLOCK 1 - THE AGGREGATE FAMILY
-- -------------------------------------------------------------------------

-- Q1: SUM() - Corporate Running Total
-- Business Need: Audit cumulative growth row-by-row sequentially across the company.
SELECT 
    deal_id, 
    sales_manager, 
    region,
    revenue,
    SUM(revenue) OVER(ORDER BY deal_id ASC) AS 'running_total'
FROM corporate_sales;

-- Q2: AVG() - Regional Market Benchmark
-- Business Need: Compare individual deal values directly against flat regional market averages.
SELECT 
    deal_id, 
    sales_manager, 
    region, 
    revenue,
    AVG(revenue) OVER(PARTITION BY region) AS 'average_revenue'
FROM corporate_sales;

-- Q3: COUNT() - Manager Workload Volume Tracker
-- Business Need: Determine the total transaction count closed per individual sales representative.
SELECT 
    deal_id, 
    sales_manager, 
    region, 
    revenue,
    COUNT(revenue) OVER(PARTITION BY sales_manager) AS 'no_of_deals'
FROM corporate_sales;

-- Q4: MIN() - Regional Revenue Floor
-- Business Need: Establish the absolute lowest transaction value threshold per territory.
SELECT 
    deal_id, 
    sales_manager, 
    region, 
    revenue,
    MIN(revenue) OVER(PARTITION BY region) AS 'min_revenue'
FROM corporate_sales;

-- Q5: MAX() - Regional Revenue Ceiling
-- Business Need: Identify record-breaking performance milestones achieved per territory.
SELECT 
    deal_id, 
    sales_manager, 
    region, 
    revenue,
    MAX(revenue) OVER(PARTITION BY region) AS 'max_revenue'
FROM corporate_sales;


-- -------------------------------------------------------------------------
-- STEP 3: BLOCK 2 - THE RANKING FAMILY
-- -------------------------------------------------------------------------

-- Q6: ROW_NUMBER() - Unique Line Serializer
-- Business Need: Assign strict unique sequential positions to deals sorted by revenue within each region.
SELECT 
    deal_id,
    fiscal_year,
    quarter,	
    sales_manager, 
    region, 
    revenue,
    ROW_NUMBER() OVER(PARTITION BY region ORDER BY revenue DESC) AS 'serial_number'
FROM corporate_sales;

-- Q7: RANK() - Competitive Leaderboard (Skips Numbers on Ties)
-- Business Need: Generate a standard sports-style ranking list where matching values share positions and skip numbers.
SELECT 
    deal_id,
    fiscal_year,
    quarter,	
    sales_manager, 
    region, 
    revenue,
    RANK() OVER(PARTITION BY region ORDER BY revenue DESC) AS 'competition_rank'
FROM corporate_sales;

-- Q8: DENSE_RANK() - Dense Executive Leaderboard (Continuous Sequence)
-- Business Need: Create an unbroken continuous ranking sequence where matching values share ranks without numeric gaps.
SELECT 
    deal_id,
    fiscal_year,
    quarter,	
    sales_manager, 
    region, 
    revenue,
    DENSE_RANK() OVER(PARTITION BY region ORDER BY revenue DESC) AS 'dense_rank'
FROM corporate_sales;

-- Q9: PERCENT_RANK() - Relative Percentile Distribution (CUET NTA Analogy Scale 0-1)
-- Business Need: Determine the exact normalized relative standing tier of a transaction inside its market pool.
SELECT 
    deal_id,
    sales_manager,
    region,
    revenue,
    PERCENT_RANK() OVER(PARTITION BY region ORDER BY revenue DESC) AS 'percentile_rank'
FROM corporate_sales;


-- -------------------------------------------------------------------------
-- STEP 4: BLOCK 3 - THE VALUE & NAVIGATION FAMILY
-- -------------------------------------------------------------------------

-- Q10: LAG() - Historical Period Growth Tracer
-- Business Need: Pull the previous chronological entry's value to calculate period-over-period growth metrics.
SELECT 
    deal_id,
    sales_manager,
    region,
    revenue,
    LAG(revenue, 1) OVER(ORDER BY deal_id ASC) AS 'previous_revenue'
FROM corporate_sales;

-- Q11: LEAD() - Future Pipe Delivery Lookahead
-- Business Need: Extract upcoming sequential records to monitor pipeline momentum shifts.
SELECT 
    deal_id,
    sales_manager,
    region,
    revenue,
    LEAD(revenue, 1) OVER(ORDER BY deal_id ASC) AS 'upcoming_revenue'
FROM corporate_sales;

-- Q12: FIRST_VALUE() - Descriptive Top Champion Performance Anchor
-- Business Need: Extract the name of the top-performing regional record holder onto all comparative rows.
SELECT 
    deal_id,
    sales_manager,
    region,
    revenue,
    FIRST_VALUE(sales_manager) OVER(PARTITION BY region ORDER BY revenue DESC) AS 'regional_champion_name'
FROM corporate_sales;

-- Q13: LAST_VALUE() - Absolute Baseline Group Floor Anchor (Full Window Frame Override)
-- Business Need: Isolate and copy the absolute lowest transactional floor value across the whole regional group.
SELECT 
    deal_id,
    sales_manager,
    region,
    revenue,
    LAST_VALUE(revenue) OVER(
        PARTITION BY region 
        ORDER BY revenue DESC 
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS 'regional_floor_revenue'
FROM corporate_sales;