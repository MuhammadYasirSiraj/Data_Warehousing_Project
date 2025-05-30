execute silver.load_silver;

create or alter procedure silver.load_silver as
begin
	declare @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime;
	begin try
		set @batch_start_time = GETDATE();
		print 'Loading Silver Layer.....';
		print char(13) + char(10);

		set @start_time = GETDATE();
		print '___________________________________________';
		print char(13) + char(10);
		print 'Truncating table: silver.crm_cust_info';
		truncate table silver.crm_cust_info;

		print 'Inserting in table: silver.crm_cust_info';
		print '___________________________________________';
		insert into silver.crm_cust_info (
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date)
		select
		cst_id,
		cst_key,
		trim(cst_firstname) as cst_firstname,
		trim(cst_lastname) as cst_lastname,
		case when upper(trim(cst_marital_status)) = 'S' then 'Single'
			 when upper(trim(cst_marital_status)) = 'M' then 'Married'
			 else 'N/A'
		end cst_marital_status,
		case when upper(trim(cst_gndr)) = 'F' then 'Female'
			 when upper(trim(cst_gndr)) = 'M' then 'Male'
			 else 'N/A'
		end cst_gndr,
		cst_create_date
		from (
		select *, row_number() over (partition by cst_id order by cst_create_date desc) as flag_last
		from bronze.crm_cust_info
		where cst_id is not null
		) t where flag_last = 1;

		set @end_time = GETDATE();
		print 'Load Duration: ' + cast (datediff(second, @start_time, @end_time) as varchar) + ' seconds';

		print char(13) + char(10);
		print '___________________________________________';
		print char(13) + char(10);

		print 'Truncating table: silver.crm_prd_info';
		truncate table silver.crm_prd_info;

		print 'Inserting in table: silver.crm_prd_info';
		print '___________________________________________';
		insert into silver.crm_prd_info (
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
			)
		select
			prd_id,
			replace(substring(prd_key, 1, 5), '-', '_') as cat_id,
			substring(prd_key, 7, len(prd_key)) as prd_key,
			prd_nm,
			isnull(prd_cost, 0) as prd_cost,
		case upper(trim(prd_line))
			 when 'R' then 'Road'
			 when 'M' then 'Mountain'
			 when 'S' then 'Street'
			 when 'T' then 'Tree'
			 else 'N/A'
		end as prd_line,
			prd_start_dt,
			cast(dateadd(day, -1, lead(prd_start_dt) over (partition by prd_key order by prd_start_dt)) as date) as prd_end_dt
		from bronze.crm_prd_info;

		set @end_time = GETDATE();
		print 'Load Duration: ' + cast (datediff(second, @start_time, @end_time) as varchar) + ' seconds';

		print char(13) + char(10);
		print '___________________________________________';
		print char(13) + char(10);

		print 'Truncating table: silver.crm_sales_details';
		truncate table silver.crm_sales_details;
		
		print 'Inserting in table: silver.crm_sales_details';
		print '___________________________________________';
		insert into silver.crm_sales_details (
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price
		)
		select 
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		case when sls_order_dt = 0 or len(sls_order_dt) != 8 then null
			 else cast(cast(sls_order_dt as varchar) as date)
		end as sls_order_dt,
		case when sls_ship_dt = 0 or len(sls_ship_dt) != 8 then null
			 else cast(cast(sls_ship_dt as varchar) as date)
		end as sls_ship_dt,
		case when sls_due_dt = 0 or len(sls_due_dt) != 8 then null
			 else cast(cast(sls_due_dt as varchar) as date)
		end as sls_due_dt,
		case when sls_sales is null or sls_sales <= 0 or sls_sales != sls_quantity*abs(sls_price)
				then sls_quantity*abs(sls_price)
			else sls_sales
		end as sls_sales,
		sls_quantity,
		case when sls_price is null or sls_price <= 0
				then sls_sales/nullif(sls_quantity, 0)
			else sls_price
		end as sls_price
		from bronze.crm_sales_details;

		set @end_time = GETDATE();
		print 'Load Duration: ' + cast (datediff(second, @start_time, @end_time) as varchar) + ' seconds';

		print char(13) + char(10);
		print '___________________________________________';
		print char(13) + char(10);

		print 'Truncating table: silver.erp_cust_data';
		truncate table silver.erp_cust_data;

		print 'Inserting in table: silver.erp_cust_data';
		print '___________________________________________';
		insert into silver.erp_cust_data (
			cid,
			bdate,
			gen
		)
		select 
		case when cid like 'NAS%' then substring(cid, 4, len(cid))
			else cid
		end as cid,
		case when bdate > getdate() then null
			else bdate
		end as bdate,
		case when upper(trim(gen)) in ('F', 'FEMALE') then 'Female'
			when upper(trim(gen)) in ('M', 'MALE') then 'Male'
			else 'N/A'
		end as gen
		from bronze.erp_cust_data;

		set @end_time = GETDATE();
		print 'Load Duration: ' + cast (datediff(second, @start_time, @end_time) as varchar) + ' seconds';

		print char(13) + char(10);
		print '___________________________________________';
		print char(13) + char(10);

		print 'Truncating table: silver.erp_loc_data';
		truncate table silver.erp_loc_data;

		print 'Inserting in table: silver.erp_loc_data';
		print '___________________________________________';
		insert into silver.erp_loc_data (
		cid,
		cntry
		)
		select 
		replace(cid, '-', '') cid,
		case when trim(cntry) = 'DE' then 'Germany'
			when trim(cntry) in ('US', 'USA') then 'United States'
			when trim(cntry) = '' or cntry is null then 'N/A'
			else trim(cntry)
		end as cntry
		from bronze.erp_loc_data;

		set @end_time = GETDATE();
		print 'Load Duration: ' + cast (datediff(second, @start_time, @end_time) as varchar) + ' seconds';

		print char(13) + char(10);
		print '___________________________________________';
		print char(13) + char(10);

		print 'Truncating table: silver.erp_prd_cat';
		truncate table silver.erp_prd_cat;

		print 'Inserting in table: silver.erp_prd_cat';
		print '___________________________________________';
		insert into silver.erp_prd_cat (
			id,
			cat,
			subcat,
			maintenance
		)
		select 
		id,
		cat,
		subcat,
		maintenance
		from bronze.erp_prd_cat;

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