/*
===============================================================================
SQL Data Warehouse Project
Silver Layer - Table Creation Script

Description:
This script creates the Silver layer tables used to store cleansed,
standardized, and transformed data from the Bronze layer.

The Silver layer serves as the intermediate data layer, where raw data is
validated, cleaned, and prepared for downstream business analytics.

Source Systems:
    - CRM (Customer Relationship Management)
    - ERP (Enterprise Resource Planning)

Layer:
    Silver (Cleaned & Transformed Data Layer)

Author : Md Al Emran
===============================================================================
*/

------------------------------------------------------------------------------
-- CRM TABLES
------------------------------------------------------------------------------

-- Customer Information
CREATE TABLE silver.crm_cust_info (
    cst_id               INT,
    cst_key              NVARCHAR(50),
    cst_firstname        NVARCHAR(50),
    cst_lastname         NVARCHAR(50),
    cst_material_status  NVARCHAR(50),
    cst_gndr             NVARCHAR(50),
    cst_create_date      DATE,
    dwh_create_date      DATETIME2 DEFAULT GETDATE()
);
GO

-- Product Information
CREATE TABLE silver.crm_prd_info (
    prd_id               INT,
    prd_key              NVARCHAR(50),
    prd_nm               NVARCHAR(50),
    prd_cost             INT,
    prd_line             NVARCHAR(50),
    prd_start_dt         DATETIME,
    prd_end_date         DATETIME,
    dwh_create_date      DATETIME2 DEFAULT GETDATE()
);
GO

-- Sales Transactions
CREATE TABLE silver.crm_sales_details (
    sls_old_num          NVARCHAR(50),
    sls_prd_key          NVARCHAR(50),
    sls_cust_id          INT,
    sls_order_dt         INT,
    sls_ship_dt          INT,
    sls_due_dt           INT,
    sls_sales            INT,
    sls_quantity         INT,
    sls_price            INT,
    dwh_create_date      DATETIME2 DEFAULT GETDATE()
);
GO

------------------------------------------------------------------------------
-- ERP TABLES
------------------------------------------------------------------------------

-- Customer Location
CREATE TABLE silver.erp_loc_a101 (
    cid                  NVARCHAR(50),
    cntry                NVARCHAR(50),
    dwh_create_date      DATETIME2 DEFAULT GETDATE()
);
GO

-- Customer Demographics
CREATE TABLE silver.erp_cust_az12 (
    cid                  NVARCHAR(50),
    bdate                DATE,
    gen                  NVARCHAR(50),
    dwh_create_date      DATETIME2 DEFAULT GETDATE()
);
GO

-- Product Categories
CREATE TABLE silver.erp_px_cat_giv2 (
    id                   NVARCHAR(50),
    cat                  NVARCHAR(50),
    subcat               NVARCHAR(50),
    maintenance          NVARCHAR(50),
    dwh_create_date      DATETIME2 DEFAULT GETDATE()
);
GO

------------------------------------------------------------------------------
-- End of Script
------------------------------------------------------------------------------