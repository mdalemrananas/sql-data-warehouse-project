/*
===============================================================================
SQL Data Warehouse Project
Silver Layer - Data Transformation & Loading Procedure

Description:
This stored procedure transforms and loads data from the Bronze layer into
the Silver layer.

Transformation Tasks:
    - Remove duplicate records
    - Standardize text values
    - Clean invalid or missing data
    - Convert data types
    - Derive new business attributes
    - Apply business rules

Source Layer:
    Bronze

Target Layer:
    Silver

Author : Md Al Emran
===============================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN

    SET NOCOUNT ON;

    ----------------------------------------------------------------------------
    -- Clear Existing Data
    ----------------------------------------------------------------------------

    TRUNCATE TABLE silver.crm_cust_info;
    TRUNCATE TABLE silver.crm_prd_info;
    TRUNCATE TABLE silver.crm_sales_details;
    TRUNCATE TABLE silver.erp_cust_az12;
    TRUNCATE TABLE silver.erp_loc_a101;
    TRUNCATE TABLE silver.erp_px_cat_giv2;

    ----------------------------------------------------------------------------
    -- Load CRM Customer Information
    ----------------------------------------------------------------------------

    INSERT INTO silver.crm_cust_info (
        cst_id,
        cst_key,
        cst_firstname,
        cst_lastname,
        cst_material_status,
        cst_gndr,
        cst_create_date
    )
    SELECT
        cst_id,
        cst_key,
        TRIM(cst_firstname),
        TRIM(cst_lastname),
        CASE
            WHEN UPPER(TRIM(cst_material_status)) = 'S' THEN 'Single'
            WHEN UPPER(TRIM(cst_material_status)) = 'M' THEN 'Married'
            ELSE 'N/A'
        END,
        CASE
            WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
            WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
            ELSE 'N/A'
        END,
        cst_create_date
    FROM (
        SELECT *,
               ROW_NUMBER() OVER (
                   PARTITION BY cst_id
                   ORDER BY cst_create_date DESC
               ) AS flag_last
        FROM bronze.crm_cust_info
        WHERE cst_id IS NOT NULL
    ) t
    WHERE flag_last = 1;

    ----------------------------------------------------------------------------
    -- Load CRM Product Information
    ----------------------------------------------------------------------------

    INSERT INTO silver.crm_prd_info (
        prd_id,
        cat_id,
        prd_key,
        prd_nm,
        prd_cost,
        prd_line,
        prd_start_dt,
        prd_end_dt
    )
    SELECT
        prd_id,
        REPLACE(SUBSTRING(prd_key,1,5),'-','_'),
        SUBSTRING(prd_key,7,LEN(prd_key)),
        prd_nm,
        ISNULL(prd_cost,0),
        CASE
            WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
            WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
            WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
            WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
            ELSE 'N/A'
        END,
        CAST(prd_start_dt AS DATE),
        CAST(
            LEAD(prd_start_dt)
            OVER(PARTITION BY prd_key ORDER BY prd_start_dt) - 1
            AS DATE
        )
    FROM bronze.crm_prd_info;

    ----------------------------------------------------------------------------
    -- Load CRM Sales Details
    ----------------------------------------------------------------------------

    INSERT INTO silver.crm_sales_details (
        sls_old_num,
        sls_prd_key,
        sls_cust_id,
        sls_order_dt,
        sls_ship_dt,
        sls_due_dt,
        sls_sales,
        sls_quantity,
        sls_price
    )
    SELECT
        sls_old_num,
        sls_prd_key,
        sls_cust_id,

        CASE
            WHEN sls_order_dt = 0 OR LEN(sls_order_dt) <> 8
                THEN NULL
            ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
        END,

        CASE
            WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) <> 8
                THEN NULL
            ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
        END,

        CASE
            WHEN sls_due_dt = 0 OR LEN(sls_due_dt) <> 8
                THEN NULL
            ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
        END,

        CASE
            WHEN sls_sales IS NULL
                 OR sls_sales <= 0
                 OR sls_sales <> sls_quantity * ABS(sls_price)
            THEN sls_quantity * ABS(sls_price)
            ELSE sls_sales
        END,

        sls_quantity,

        CASE
            WHEN sls_price IS NULL
                 OR sls_price <= 0
            THEN sls_sales / NULLIF(sls_quantity,0)
            ELSE sls_price
        END

    FROM bronze.crm_sales_details;

    ----------------------------------------------------------------------------
    -- Load ERP Customer Information
    ----------------------------------------------------------------------------

    INSERT INTO silver.erp_cust_az12 (
        cid,
        bdate,
        gen
    )
    SELECT
        CASE
            WHEN cid LIKE 'NAS%'
                THEN SUBSTRING(cid,4,LEN(cid))
            ELSE cid
        END,

        CASE
            WHEN bdate > GETDATE()
                THEN NULL
            ELSE bdate
        END,

        CASE
            WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
            WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
            ELSE 'N/A'
        END

    FROM bronze.erp_cust_az12;

    ----------------------------------------------------------------------------
    -- Load ERP Customer Locations
    ----------------------------------------------------------------------------

    INSERT INTO silver.erp_loc_a101 (
        cid,
        cntry
    )
    SELECT
        REPLACE(cid,'-',''),

        CASE
            WHEN TRIM(cntry) = 'DE' THEN 'Germany'
            WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
            WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'N/A'
            ELSE TRIM(cntry)
        END

    FROM bronze.erp_loc_a101;

    ----------------------------------------------------------------------------
    -- Load ERP Product Categories
    ----------------------------------------------------------------------------

    INSERT INTO silver.erp_px_cat_giv2 (
        id,
        cat,
        subcat,
        maintenance
    )
    SELECT
        id,
        cat,
        subcat,
        maintenance
    FROM bronze.erp_px_cat_giv2;

END;
GO

------------------------------------------------------------------------------
-- Execute Silver Layer Load
------------------------------------------------------------------------------

EXEC silver.load_silver;
GO