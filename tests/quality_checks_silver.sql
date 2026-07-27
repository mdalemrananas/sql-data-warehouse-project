/*
===============================================================================
SQL Data Warehouse Project
Silver Layer - Data Quality Checks

Description:
This script validates the quality of the Silver layer after data cleansing
and transformation.

Validation Checks:
    1. Null Primary Keys
    2. Duplicate Records
    3. Data Standardization
    4. Invalid Dates
    5. Invalid Numeric Values
    6. Business Rule Validation
    7. Referential Consistency

Source Layer:
    Silver

Author : Md Al Emran
===============================================================================
*/

------------------------------------------------------------------------------
-- CRM CUSTOMER INFORMATION
------------------------------------------------------------------------------

-- Check for NULL Customer IDs
-- Expected Result: 0 Rows

SELECT *
FROM silver.crm_cust_info
WHERE cst_id IS NULL;

------------------------------------------------------------------------------
-- Check for Duplicate Customer IDs
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT
    cst_id,
    COUNT(*) AS duplicate_count
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1;

------------------------------------------------------------------------------
-- Check Invalid Marital Status
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT *
FROM silver.crm_cust_info
WHERE cst_material_status NOT IN ('Single','Married','N/A');

------------------------------------------------------------------------------
-- Check Invalid Gender Values
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT *
FROM silver.crm_cust_info
WHERE cst_gndr NOT IN ('Male','Female','N/A');

------------------------------------------------------------------------------
-- CRM PRODUCT INFORMATION
------------------------------------------------------------------------------

-- Check NULL Product IDs
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT *
FROM silver.crm_prd_info
WHERE prd_id IS NULL;

------------------------------------------------------------------------------
-- Check Duplicate Product IDs
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT
    prd_id,
    COUNT(*) AS duplicate_count
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1;

------------------------------------------------------------------------------
-- Check Negative Product Cost
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT *
FROM silver.crm_prd_info
WHERE prd_cost < 0;

------------------------------------------------------------------------------
-- Check Invalid Product Line
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT *
FROM silver.crm_prd_info
WHERE prd_line NOT IN (
    'Mountain',
    'Road',
    'Touring',
    'Other Sales',
    'N/A'
);

------------------------------------------------------------------------------
-- Check Invalid Product Date Range
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt IS NOT NULL
  AND prd_end_dt < prd_start_dt;

------------------------------------------------------------------------------
-- CRM SALES DETAILS
------------------------------------------------------------------------------

-- Check NULL Customer IDs
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT *
FROM silver.crm_sales_details
WHERE sls_cust_id IS NULL;

------------------------------------------------------------------------------
-- Check NULL Product Keys
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT *
FROM silver.crm_sales_details
WHERE sls_prd_key IS NULL;

------------------------------------------------------------------------------
-- Check Negative Sales Amount
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT *
FROM silver.crm_sales_details
WHERE sls_sales < 0;

------------------------------------------------------------------------------
-- Check Invalid Quantity
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT *
FROM silver.crm_sales_details
WHERE sls_quantity <= 0;

------------------------------------------------------------------------------
-- Check Negative Price
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT *
FROM silver.crm_sales_details
WHERE sls_price < 0;

------------------------------------------------------------------------------
-- Check Sales Calculation
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT *
FROM silver.crm_sales_details
WHERE sls_sales <> sls_quantity * sls_price;

------------------------------------------------------------------------------
-- Check Invalid Date Sequence
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT *
FROM silver.crm_sales_details
WHERE sls_ship_dt < sls_order_dt
   OR sls_due_dt < sls_order_dt;

------------------------------------------------------------------------------
-- ERP CUSTOMER INFORMATION
------------------------------------------------------------------------------

-- Check Future Birth Dates
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT *
FROM silver.erp_cust_az12
WHERE bdate > GETDATE();

------------------------------------------------------------------------------
-- Check Invalid Gender Values
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT *
FROM silver.erp_cust_az12
WHERE gen NOT IN ('Male','Female','N/A');

------------------------------------------------------------------------------
-- ERP CUSTOMER LOCATION
------------------------------------------------------------------------------

-- Check Missing Customer IDs
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT *
FROM silver.erp_loc_a101
WHERE cid IS NULL;

------------------------------------------------------------------------------
-- Check Missing Country Values
------------------------------------------------------------------------------

SELECT *
FROM silver.erp_loc_a101
WHERE cntry IS NULL;

------------------------------------------------------------------------------
-- ERP PRODUCT CATEGORY
------------------------------------------------------------------------------

-- Check Missing Category IDs
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT *
FROM silver.erp_px_cat_giv2
WHERE id IS NULL;

------------------------------------------------------------------------------
-- Check Missing Categories
------------------------------------------------------------------------------

SELECT *
FROM silver.erp_px_cat_giv2
WHERE cat IS NULL;

------------------------------------------------------------------------------
-- Referential Integrity Checks
------------------------------------------------------------------------------

-- Sales Product Keys Missing in Product Table
-- Expected Result: 0 Rows

SELECT DISTINCT
    s.sls_prd_key
FROM silver.crm_sales_details s
LEFT JOIN silver.crm_prd_info p
    ON s.sls_prd_key = p.prd_key
WHERE p.prd_key IS NULL;

------------------------------------------------------------------------------
-- Sales Customer IDs Missing in Customer Table
-- Expected Result: 0 Rows
------------------------------------------------------------------------------

SELECT DISTINCT
    s.sls_cust_id
FROM silver.crm_sales_details s
LEFT JOIN silver.crm_cust_info c
    ON s.sls_cust_id = c.cst_id
WHERE c.cst_id IS NULL;

------------------------------------------------------------------------------
-- Summary Record Counts
------------------------------------------------------------------------------

SELECT
    'crm_cust_info' AS table_name,
    COUNT(*) AS total_records
FROM silver.crm_cust_info

UNION ALL

SELECT
    'crm_prd_info',
    COUNT(*)
FROM silver.crm_prd_info

UNION ALL

SELECT
    'crm_sales_details',
    COUNT(*)
FROM silver.crm_sales_details

UNION ALL

SELECT
    'erp_cust_az12',
    COUNT(*)
FROM silver.erp_cust_az12

UNION ALL

SELECT
    'erp_loc_a101',
    COUNT(*)
FROM silver.erp_loc_a101

UNION ALL

SELECT
    'erp_px_cat_giv2',
    COUNT(*)
FROM silver.erp_px_cat_giv2;

------------------------------------------------------------------------------
-- End of Script
------------------------------------------------------------------------------