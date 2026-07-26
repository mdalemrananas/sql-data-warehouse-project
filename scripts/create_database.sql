/*
===============================================================================
SQL Data Warehouse Project
Database Initialization Script

Description:
This script creates the Data Warehouse database and the schemas used to
organize data across different processing layers.

Schemas:
- Bronze : Raw data ingestion layer
- Silver : Cleaned and transformed data layer
- Gold   : Business-ready analytical data layer

Author : Md Al Emran
===============================================================================
*/

-- Switch to the master database
USE master;
GO

-- Create the Data Warehouse database
CREATE DATABASE DataWarehouse;
GO

-- Switch to the Data Warehouse database
USE DataWarehouse;
GO

-- Create Bronze schema (Raw Layer)
CREATE SCHEMA bronze;
GO

-- Create Silver schema (Cleaned & Transformed Layer)
CREATE SCHEMA silver;
GO

-- Create Gold schema (Business Layer)
CREATE SCHEMA gold;
GO