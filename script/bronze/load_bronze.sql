/*---------------------------------------------------------------
Stored procedure: load bronze layer(source -> bronze)
-----------------------------------------------------------------
Script purpose:
  1. This script bulk-inserts the data into all the tables from the sources
  2. Truncate the table if it already has the data on running
  3. Calculate the time it takes for each query to run
Parameter:
  None
  This stored procedure does not accept any parameters or return any tables
Usage Example:
  EXEC bronze.load_bronze
------------------------------------------------------------------
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
	DECLARE @Start_time DATETIME , @End_time DATETIME
	DECLARE @start DATETIME, @end DATETIME
	BEGIN TRY
		SET @start = GETDATE();
		PRINT 'loading bronze layer....';
		PRINT '----------------------------------------------';
		PRINT 'Loading CRM Tables...';
		SET @Start_time = GETDATE();
		PRINT '>> Truncating table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;
		PRINT '>> Inserting data: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\devya\source\repos\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		PRINT '>> Truncating table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;
		PRINT '>> Inserting data: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\devya\source\repos\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		PRINT '>> Truncating table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;
		PRINT '>> Inserting data: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\devya\source\repos\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @End_time = GETDATE();
		PRINT '>> load duration for CRM Tables: ' + CAST(DATEDIFF(SECOND, @Start_time, @End_time) AS VARCHAR) + 'Seconds';
		PRINT 'CRM Tables loaded successfully.';
		PRINT '-----------------------------------------';
		PRINT 'loading ERP Tables.....';
		
		SET @Start_time = GETDATE();
		PRINT '>> Truncating table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;
		PRINT '>> Inserting data: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\devya\source\repos\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		PRINT 'Truncating table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;
		PRINT '>> Inserting data: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\devya\source\repos\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		PRINT '>> Truncating table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		PRINT '>> Inserting data: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\devya\source\repos\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @End_time = GETDATE();
		PRINT 'ERP Tables loaded successfully';
		PRINT 'load duration for ERP Tables: ' + CAST(DATEDIFF(SECOND, @Start_time, @End_time) AS VARCHAR) + 'Seconds'
		SET @end = GETDATE();
		PRINT 'load duration for whole bronze layer: ' + CAST(DATEDIFF(SECOND, @start, @end) AS VARCHAR) + 'Seconds'
	END TRY
	BEGIN CATCH
		PRINT '-------------------------------------------';
		PRINT 'ERROR OCCURRED DURING THE TIME OF EXECUTION';
		PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE();
		PRINT 'ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS VARCHAR);
		PRINT '-------------------------------------------';
	END CATCH
END
