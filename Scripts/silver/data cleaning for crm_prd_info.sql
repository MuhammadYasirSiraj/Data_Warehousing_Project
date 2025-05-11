if object_id ('silver.crm_prd_info', 'U') is not null
	drop table silver.crm_prd_info;
create table silver.crm_prd_info (
	prd_id INT,
	cat_id VARCHAR(100),
	prd_key VARCHAR(100),
	prd_nm VARCHAR(100),
	prd_cost INT,
	prd_line VARCHAR(100),
	prd_start_dt DATE,
	prd_end_dt DATE,
	dwh_create_date datetime2 default getdate()
);

truncate table silver.crm_prd_info;
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
-- Data cleaning for crm_prd_info

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

--where substring(prd_key, 7, len(prd_key)) in (select sls_prd_key from bronze.crm_sales_details where sls_prd_key like 'F%');

--where replace(substring(prd_key, 1, 5), '-', '_') not in (select distinct id from bronze.erp_prd_cat);


	