-- ====================================================================
-- PROJECT: SQL Practice - Employee Database Management & Analytics
-- AUTHOR: Professional Portfolio Script
-- DATABASE: practice
-- ====================================================================

-- --------------------------------------------------------------------
-- STEP 1: Database & Schema Initialization
-- Description: Create the database environment and defining the schema
--              for the 'employees' table with structural constraints.
-- --------------------------------------------------------------------

CREATE DATABASE IF NOT EXISTS practice;
USE practice;

DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    department VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    hire_date DATE NOT NULL
);

-- --------------------------------------------------------------------
-- STEP 2: Data Ingestion
-- Description: Inserting standard mock records into the table.
-- --------------------------------------------------------------------

INSERT INTO employees (first_name, last_name, department, salary, hire_date) VALUES
('Amit', 'Sharma', 'IT', 60000.00, '2023-01-15'),
('Priya', 'Patel', 'HR', 45000.00, '2022-05-12'),
('Rahul', 'Verma', 'IT', 48000.00, '2024-02-10'),
('Sneha', 'Reddy', 'IT', 75000.00, '2021-11-01'),
('Vikram', 'Singh', 'Sales', 52000.00, '2023-08-20');

-- --------------------------------------------------------------------
-- QUESTION 1: Basic Filtering and Sorting
-- Description: Extract the first name, last name, and salary of all 
--              employees in the 'IT' department earning more than 
--              50,000, ranked by highest earnings.
-- --------------------------------------------------------------------

SELECT first_name, last_name, salary 
FROM employees 
WHERE salary > 50000 
  AND department = 'IT'
ORDER BY salary DESC;

-- --------------------------------------------------------------------
-- QUESTION 2: Aggregations and Grouping
-- Description: Calculate the total workforce footprint and the 
--              average compensation model across each department.
-- Expected Columns: department, total_employees, average_salary
-- --------------------------------------------------------------------

SELECT 
    department,
    AVG(salary) AS average_salary,
    COUNT(*) AS total_employees
FROM employees
GROUP BY department;

-- --------------------------------------------------------------------
-- QUESTION 3: Filtering Grouped Data using HAVING
-- Description: Find all departments where the average salary is 
--              greater than 50,000. Display the department name 
--              and its average salary.
-- Expected Columns: department, average_salary
-- --------------------------------------------------------------------

SELECT
    department,
    AVG(salary) AS average_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 50000;

-- --------------------------------------------------------------------
-- QUESTION 4: Conditional Logic with CASE WHEN
-- Description: Create a report that lists each employee's first name, 
--              salary, and a new column called 'salary_tier'. 
--              If salary > 60,000 label it 'High'. 
--              If salary between 50,000 and 60,000 label it 'Medium'.
--              Otherwise, label it 'Low'.
-- Expected Columns: first_name, salary, salary_tier
-- --------------------------------------------------------------------

SELECT
    emp_id,
    first_name,
    last_name,
    CASE
        WHEN salary > 60000 THEN 'High'
        WHEN salary >= 50000 THEN 'Medium'
        ELSE 'Low'
    END AS salary_tier
FROM employees;

-- --------------------------------------------------------------------
-- QUESTION 5: Date Filtering and Functions
-- Description: Write a query to find all employees who were hired 
--              in the year 2023. Display their first name, last name, 
--              and their full hire date.
-- Expected Columns: first_name, last_name, hire_date
-- --------------------------------------------------------------------

SELECT 
    emp_id,
    first_name,
    last_name,
    hire_date 
FROM employees
WHERE YEAR(hire_date) = 2023;

-- --------------------------------------------------------------------
-- QUESTION 6: Subqueries
-- Description: Find the first name, last name, and salary of all 
--              employees who earn MORE than the overall company average salary.
-- Expected Columns: first_name, last_name, salary
-- --------------------------------------------------------------------

SELECT 
    emp_id, first_name, last_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- --------------------------------------------------------------------
-- STEP 3: Creating a Second Table for Relational Joins
-- Description: Define a lookup table for department details and locations.
-- --------------------------------------------------------------------

CREATE TABLE departments (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(50) NOT NULL,
    location VARCHAR(50) NOT NULL
);

INSERT INTO departments (dept_name, location) VALUES
('IT', 'New Delhi'),
('HR', 'Mumbai'),
('Sales', 'Bengaluru'),
('Marketing', 'Hyderabad');

-- --------------------------------------------------------------------
-- QUESTION 7: Relational Inner Joins
-- Description: Write a query to combine the 'employees' and 'departments' 
--              tables. Display each employee's first name, last name, 
--              department name, and their office location.
-- Expected Columns: first_name, last_name, department, location
-- --------------------------------------------------------------------

SELECT 
    e.emp_id, e.first_name, e.last_name, e.department, d.location
FROM employees AS e
INNER JOIN departments AS d
    ON e.department = d.dept_name;

-- --------------------------------------------------------------------
-- STEP 4: Data Mutation & Edge-Case Handling
-- Description: Inserting a transitional employee record to test 
--              unmatched lookups for complex relational joins.
-- --------------------------------------------------------------------

INSERT INTO employees (first_name, last_name, department, salary, hire_date) 
VALUES ('Karan', 'Malhotra', 'Finance', 55000.00, '2025-05-20');

-- --------------------------------------------------------------------
-- QUESTION 8: Relational Left Joins
-- Description: Write a query using a LEFT JOIN to display all employees 
--              (including the newly added employee in Finance). Show their 
--              first name, department, and location.
-- Expected Columns: first_name, department, location
-- --------------------------------------------------------------------

SELECT 
    e.emp_id, e.first_name, e.last_name, e.department, d.location
FROM employees AS e
LEFT JOIN departments AS d
    ON e.department = d.dept_name;

-- --------------------------------------------------------------------
-- QUESTION 9: Relational Right Joins
-- Description: Write a query using a RIGHT JOIN to display all departments,
--              showing the department name, location, and the first name 
--              of any employee working there. 
-- Expected Columns: dept_name, location, first_name
-- --------------------------------------------------------------------

SELECT 
    d.dept_id, 
    d.dept_name, 
    d.location, 
    e.first_name, 
    e.last_name
FROM employees AS e
RIGHT JOIN departments AS d
    ON e.department = d.dept_name;

-- --------------------------------------------------------------------
-- QUESTION 10: Joins with Aggregation
-- Description: Write a query to find the total number of employees working 
--              in each physical location. 
-- Expected Columns: location, total_employees
-- --------------------------------------------------------------------

SELECT
    d.location,
    COUNT(*) AS total_employees 
FROM employees AS e
INNER JOIN departments AS d
    ON e.department = d.dept_name
GROUP BY d.location;