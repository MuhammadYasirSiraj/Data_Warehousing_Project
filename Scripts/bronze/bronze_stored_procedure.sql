execute bronze.load_bronze;

create or alter procedure bronze.load_bronze as
begin
	declare @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime;
	begin try
		set @batch_start_time = GETDATE();
		print 'Loading Bronze Layer.....';
		print char(13) + char(10);

		set @start_time = GETDATE();
		print '___________________________________________';
		print char(13) + char(10);
		print 'Truncating table: bronze.crm_cust_info';
		truncate table bronze.crm_cust_info;

		print 'Inserting in table: bronze.crm_cust_info';
		print '___________________________________________';
		bulk insert bronze.crm_cust_info
		from 'C:\Users\Yasir\Desktop\Data Warehousing Project\Datasets\source_crm\cust_info.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = GETDATE();
		print 'Load Duration: ' + cast (datediff(second, @start_time, @end_time) as varchar) + ' seconds';

		print char(13) + char(10);
		print '___________________________________________';
		print char(13) + char(10);
		print 'Truncating table: bronze.crm_prd_info';
		truncate table bronze.crm_prd_info;

		print 'Inserting in table: bronze.crm_prd_info';
		print '___________________________________________';
		bulk insert bronze.crm_prd_info
		from 'C:\Users\Yasir\Desktop\Data Warehousing Project\Datasets\source_crm\prd_info.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = GETDATE();
		print 'Load Duration: ' + cast (datediff(second, @start_time, @end_time) as varchar) + ' seconds';

		print char(13) + char(10);
		print '___________________________________________';
		print char(13) + char(10);
		print 'Truncating table: bronze.crm_sales_details';
		truncate table bronze.crm_sales_details;

		print 'Inserting in table: bronze.crm_sales_details';
		print '___________________________________________';
		bulk insert bronze.crm_sales_details
		from 'C:\Users\Yasir\Desktop\Data Warehousing Project\Datasets\source_crm\sales_details.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = GETDATE();
		print 'Load Duration: ' + cast (datediff(second, @start_time, @end_time) as varchar) + ' seconds';

		print char(13) + char(10);
		print '___________________________________________';
		print char(13) + char(10);
		print 'Truncating table: bronze.erp_cust_data';
		truncate table bronze.erp_cust_data;

		print 'Inserting in table: bronze.erp_cust_data';
		print '___________________________________________';
		bulk insert bronze.erp_cust_data
		from 'C:\Users\Yasir\Desktop\Data Warehousing Project\Datasets\source_erp\cust_data.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = GETDATE();
		print 'Load Duration: ' + cast (datediff(second, @start_time, @end_time) as varchar) + ' seconds';

		print char(13) + char(10);
		print '___________________________________________';
		print char(13) + char(10);
		print 'Truncating table: bronze.erp_loc_data';
		truncate table bronze.erp_loc_data;

		print 'Inserting in table: bronze.erp_loc_data';
		print '___________________________________________';
		bulk insert bronze.erp_loc_data
		from 'C:\Users\Yasir\Desktop\Data Warehousing Project\Datasets\source_erp\loc_data.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = GETDATE();
		print 'Load Duration: ' + cast (datediff(second, @start_time, @end_time) as varchar) + ' seconds';

		print char(13) + char(10);
		print '___________________________________________';
		print char(13) + char(10);
		print 'Truncating table: bronze.erp_prd_cat';
		truncate table bronze.erp_prd_cat;

		print 'Inserting in table: bronze.erp_prd_cat';
		print '___________________________________________';
		bulk insert bronze.erp_prd_cat
		from 'C:\Users\Yasir\Desktop\Data Warehousing Project\Datasets\source_erp\prd_cat.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = GETDATE();
		print 'Load Duration: ' + cast (datediff(second, @start_time, @end_time) as varchar) + ' seconds';

		print char(13) + char(10);
		print '===========================================';
		print char(13) + char(10);
		set @batch_end_time = GETDATE();
		print 'Total Load Duration of batch: ' + cast (datediff(second, @batch_start_time, @batch_end_time) as varchar) + ' seconds';
		print '===========================================';
	end try
	begin catch
	print '___________________________________________';
	print char(13) + char(10);
	print 'Error Message' + Error_message();
	print 'Error Message' + cast (Error_number() as varchar);
	print 'Error Message' + cast (Error_state() as varchar);
	print '___________________________________________';
	end catch
end