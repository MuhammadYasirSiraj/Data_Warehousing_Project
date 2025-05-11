truncate table silver.crm_cust_info;

--Inserting data into silver layer
insert into silver.crm_cust_info (
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date)

-- Data Cleaning
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


-- Window function for removing duplicates and null cells
select * from (
select *, row_number() over (partition by cst_id order by cst_create_date desc) as flag_last
from bronze.crm_cust_info
)t where cst_id is not null and flag_last = 1;

select * from silver.crm_cust_info;