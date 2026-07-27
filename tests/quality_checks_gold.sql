/*
===============================================================================
SQL Data Warehouse Project
Gold Layer - Data Quality Checks

Description:
This script performs data quality validation on the Gold layer to ensure
the warehouse is accurate, complete, and ready for reporting and analytics.

Validation Checks:
    1. Duplicate Primary Keys
    2. Null Primary Keys
    3. Referential Integrity
    4. Invalid Dates
    5. Negative Measures
    6. Missing Dimension References
    7. Business Rule Validation

Layer:
    Gold

Author : Md Al Emran
===============================================================================
*/

------------------------------------------------------------------------------
-- 1. Duplicate Customer Keys
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

------------------------------------------------------------------------------
-- 2. Duplicate Product Keys
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

------------------------------------------------------------------------------
-- 3. Null Customer Keys
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT *
FROM gold.dim_customers
WHERE customer_key IS NULL;

------------------------------------------------------------------------------
-- 4. Null Product Keys
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT *
FROM gold.dim_products
WHERE product_key IS NULL;

------------------------------------------------------------------------------
-- 5. Fact Table Without Customer Dimension
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT *
FROM gold.fact_sales
WHERE customer_key IS NULL;

------------------------------------------------------------------------------
-- 6. Fact Table Without Product Dimension
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT *
FROM gold.fact_sales
WHERE product_key IS NULL;

------------------------------------------------------------------------------
-- 7. Invalid Sales Amount
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT *
FROM gold.fact_sales
WHERE sales_amount < 0;

------------------------------------------------------------------------------
-- 8. Invalid Quantity
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT *
FROM gold.fact_sales
WHERE quantity <= 0;

------------------------------------------------------------------------------
-- 9. Invalid Price
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT *
FROM gold.fact_sales
WHERE price < 0;

------------------------------------------------------------------------------
-- 10. Order Date After Shipping Date
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT *
FROM gold.fact_sales
WHERE shipping_date < order_date;

------------------------------------------------------------------------------
-- 11. Due Date Before Order Date
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT *
FROM gold.fact_sales
WHERE due_date < order_date;

------------------------------------------------------------------------------
-- 12. Missing Customer Information
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT *
FROM gold.dim_customers
WHERE first_name IS NULL
   OR last_name IS NULL;

------------------------------------------------------------------------------
-- 13. Missing Product Information
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT *
FROM gold.dim_products
WHERE product_name IS NULL;

------------------------------------------------------------------------------
-- 14. Duplicate Customer IDs
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

------------------------------------------------------------------------------
-- 15. Duplicate Product IDs
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_id
HAVING COUNT(*) > 1;

------------------------------------------------------------------------------
-- 16. Sales Consistency Check
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT *
FROM gold.fact_sales
WHERE sales_amount <> quantity * price;

------------------------------------------------------------------------------
-- 17. Dimension Record Counts
------------------------------------------------------------------------------

SELECT
    'Customers' AS table_name,
    COUNT(*) AS total_records
FROM gold.dim_customers

UNION ALL

SELECT
    'Products',
    COUNT(*)
FROM gold.dim_products

UNION ALL

SELECT
    'Sales',
    COUNT(*)
FROM gold.fact_sales;

------------------------------------------------------------------------------
-- End of Script
------------------------------------------------------------------------------