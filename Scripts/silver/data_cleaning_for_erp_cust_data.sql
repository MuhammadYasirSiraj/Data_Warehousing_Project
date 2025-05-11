truncate table silver.erp_cust_data;

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