if object_id ('bronze.crm_cust_info', 'U') is not null
	drop table bronze.crm_cust_info;
create table bronze.crm_cust_info (
	cst_id INT,
	cst_key	VARCHAR(100),
	cst_firstname VARCHAR(100),
	cst_lastname VARCHAR(100),
	cst_marital_status VARCHAR(100),
	cst_gndr VARCHAR(100),
	cst_create_date DATE
);

if object_id ('bronze.crm_prd_info', 'U') is not null
	drop table bronze.crm_prd_info;
create table bronze.crm_prd_info (
	prd_id INT,
	prd_key VARCHAR(100),
	prd_nm VARCHAR(100),
	prd_cost INT,
	prd_line VARCHAR(100),
	prd_start_dt DATE,
	prd_end_dt DATE
);

if object_id ('bronze.crm_sales_details', 'U') is not null
	drop table bronze.crm_sales_details;
create table bronze.crm_sales_details (
	sls_ord_num VARCHAR(100),	
	sls_prd_key	VARCHAR(100),
	sls_cust_id	INT,
	sls_order_dt VARCHAR(100),
	sls_ship_dt	VARCHAR(100),
	sls_due_dt VARCHAR(100),
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
);

if object_id ('bronze.erp_cust_data', 'U') is not null
	drop table bronze.erp_cust_data;
create table bronze.erp_cust_data (
	CID	VARCHAR(100),
	BDATE DATE,
	GEN VARCHAR(100)
);

if object_id ('bronze.erp_loc_data', 'U') is not null
	drop table bronze.erp_loc_data;
create table bronze.erp_loc_data (
	CID	VARCHAR(100),
	CNTRY VARCHAR(100)
);

if object_id ('bronze.erp_prd_cat', 'U') is not null
	drop table bronze.erp_prd_cat;
create table bronze.erp_prd_cat (
	ID VARCHAR(100),	
	CAT	VARCHAR(100),
	SUBCAT VARCHAR(100),
	MAINTENANCE VARCHAR(100)
);