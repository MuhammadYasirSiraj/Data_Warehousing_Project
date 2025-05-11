-- Checking for Nulls and Duplicates, no results are expected.

select sls_ord_num, count(*)
from bronze.crm_sales_details
group by sls_ord_num
having count(*) > 1 or sls_ord_num is null;

-- Checking for unwanted spaces

select *
from bronze.crm_sales_details
where sls_ord_num != trim(sls_ord_num);

-- Checking data consistancy & standardization

select distinct prd_line
from silver.crm_prd_info;

-- Checking for negative and null values

select prd_cost
from silver.crm_prd_info
where prd_cost < 0 or prd_cost is null;

-- Checking start dates and end dates

select *
from silver.crm_prd_info
where prd_start_dt > prd_end_dt;

-- Checkin data type

SELECT 
    COLUMN_NAME, 
    DATA_TYPE 
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'crm_prd_info'
    AND COLUMN_NAME = 'prd_end_dt';

-- Checking for primary keys

select *
from bronze.crm_sales_details
where sls_cust_id not in (select cst_id from silver.crm_cust_info) and sls_prd_key not in (select prd_key from silver.crm_prd_info);

-- Checking invalid dates

select nullif(sls_ship_dt, 0) sls_ship_dt
from bronze.crm_sales_details
where sls_ship_dt <= 0 or len(sls_ship_dt) != 8;

select nullif(sls_ship_dt, 0) sls_ship_dt
from bronze.crm_sales_details
group by sls_ship_dt
having sls_ship_dt > max(sls_ship_dt) or sls_ship_dt < max(sls_ship_dt);

select *
from bronze.crm_sales_details
where sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt;

-- Business rule: Sales = Quantity * Price and would not be null, zero and negative
-- Checking data consistensy

select distinct sls_sales as old_sales, 
sls_quantity, 
sls_price as old_price
from silver.crm_sales_details
where sls_sales != sls_quantity*sls_price
or sls_sales is null or sls_quantity is null or sls_price is null
or sls_sales <= 0 or sls_quantity <= 0 or sls_price <= 0
order by sls_sales, sls_quantity, sls_price;

-- Identifying out of range dates

select distinct
bdate 
from silver.erp_cust_data
where bdate < '1925-01-01' or bdate > getdate();


select distinct cntry as old,
case when trim(cntry) = 'DE' then 'Germany'
	when trim(cntry) in ('US', 'USA') then 'United States'
	when trim(cntry) = '' or cntry is null then 'N/A'
	else trim(cntry)
end as cntry
from bronze.erp_loc_data