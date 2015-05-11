create or replace view customer.v_agg_partners as
select  partner_name, prefix, imsi_start_range, imsi_end_range, upper(replace(trim(partner_name),' ','_')) source_desc 
from	  customer.partners;

exit;
