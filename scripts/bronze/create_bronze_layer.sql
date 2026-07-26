/*
===============================================================================
SQL Data Warehouse Project
Bronze Layer - Table Creation Script

Description:
This script creates the Bronze layer tables used to store raw data
ingested from CRM and ERP source systems.

Source Systems:
- CRM (Customer Relationship Management)
- ERP (Enterprise Resource Planning)

Layer:
- Bronze (Raw Data Layer)

Author : Md Al Emran
===============================================================================
*/

------------------------------------------------------------------------------
-- CRM TABLES
------------------------------------------------------------------------------

-- Customer Information
CREATE TABLE bronze.crm_cust_info (
    cst_id              INT,
    cst_key             NVARCHAR(50),
    cst_firstname       NVARCHAR(50),
    cst_lastname        NVARCHAR(50),
    cst_material_status NVARCHAR(50),
    cst_gndr            NVARCHAR(50),
    cst_create_date     DATE
);

-- Product Information
CREATE TABLE bronze.crm_prd_info (
    prd_id          INT,
    prd_key         NVARCHAR(50),
    prd_nm          NVARCHAR(50),
    prd_cost        INT,
    prd_line        NVARCHAR(50),
    prd_start_dt    DATETIME,
    prd_end_date    DATETIME
);

-- Sales Transactions
CREATE TABLE bronze.crm_sales_details (
    sls_old_num     NVARCHAR(50),
    sls_prd_key     NVARCHAR(50),
    sls_cust_id     INT,
    sls_order_dt    INT,
    sls_ship_dt     INT,
    sls_due_dt      INT,
    sls_sales       INT,
    sls_quantity    INT,
    sls_price       INT
);

------------------------------------------------------------------------------
-- ERP TABLES
------------------------------------------------------------------------------

-- Customer Location
CREATE TABLE bronze.erp_loc_a101 (
    cid     NVARCHAR(50),
    cntry   NVARCHAR(50)
);

-- Customer Demographics
CREATE TABLE bronze.erp_cust_az12 (
    cid     NVARCHAR(50),
    bdate   DATE,
    gen     NVARCHAR(50)
);

-- Product Categories
CREATE TABLE bronze.erp_px_cat_giv2 (
    id          NVARCHAR(50),
    cat         NVARCHAR(50),
    subcat      NVARCHAR(50),
    maintenance NVARCHAR(50)
);

------------------------------------------------------------------------------
-- End of Script
------------------------------------------------------------------------------