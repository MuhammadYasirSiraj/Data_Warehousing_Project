truncate table silver.erp_prd_cat;
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
from bronze.erp_prd_cat
