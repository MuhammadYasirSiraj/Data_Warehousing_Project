truncate table silver.erp_loc_data;

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