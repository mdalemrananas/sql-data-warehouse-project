/*
===============================================================================
SQL Data Warehouse Project
Bronze Layer - Data Loading Procedure

Description:
This stored procedure loads raw CRM and ERP data from CSV files into the
Bronze layer using SQL Server BULK INSERT.

Process:
    1. Truncate existing Bronze tables
    2. Load fresh data from source CSV files
    3. Preserve the raw source data for downstream transformations

Source Systems:
    - CRM
    - ERP

Layer:
    Bronze (Raw Data Layer)

Author : Md Al Emran
===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN

    SET NOCOUNT ON;

    ----------------------------------------------------------------------------
    -- Load CRM Customer Information
    ----------------------------------------------------------------------------

    TRUNCATE TABLE bronze.crm_cust_info;

    BULK INSERT bronze.crm_cust_info
    FROM 'D:\Downloads\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );

    ----------------------------------------------------------------------------
    -- Load CRM Product Information
    ----------------------------------------------------------------------------

    TRUNCATE TABLE bronze.crm_prd_info;

    BULK INSERT bronze.crm_prd_info
    FROM 'D:\Downloads\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );

    ----------------------------------------------------------------------------
    -- Load CRM Sales Details
    ----------------------------------------------------------------------------

    TRUNCATE TABLE bronze.crm_sales_details;

    BULK INSERT bronze.crm_sales_details
    FROM 'D:\Downloads\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );

    ----------------------------------------------------------------------------
    -- Load ERP Customer Location
    ----------------------------------------------------------------------------

    TRUNCATE TABLE bronze.erp_loc_a101;

    BULK INSERT bronze.erp_loc_a101
    FROM 'D:\Downloads\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );

    ----------------------------------------------------------------------------
    -- Load ERP Customer Demographics
    ----------------------------------------------------------------------------

    TRUNCATE TABLE bronze.erp_cust_az12;

    BULK INSERT bronze.erp_cust_az12
    FROM 'D:\Downloads\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );

    ----------------------------------------------------------------------------
    -- Load ERP Product Categories
    ----------------------------------------------------------------------------

    TRUNCATE TABLE bronze.erp_px_cat_giv2;

    BULK INSERT bronze.erp_px_cat_giv2
    FROM 'D:\Downloads\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );

END;
GO

------------------------------------------------------------------------------
-- Execute Data Load
------------------------------------------------------------------------------

EXEC bronze.load_bronze;
GO