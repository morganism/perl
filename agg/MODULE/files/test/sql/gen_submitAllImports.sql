select 'jssubmitJob "Import" "-mapping '||fmv.mapping_id||' -daemon no -load_type 1 -rb true -mapping_version '||fmv.mapping_version_id||'"'
      ,'# '||replace(upper(lt.target_table),'STG_AGG_DATA_','') table_name
from gdl.loadable_tables_ref lt
inner join gdl.format_mapping_version fmv
on fmv.loadable_table_id = lt.loadable_table_id
where upper(lt.target_table) like 'STG_AGG_DATA_DS%'
and fmv.status = 'A'
/
