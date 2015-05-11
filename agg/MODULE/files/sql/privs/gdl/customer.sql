grant insert, update, references, select on customer.stg_agg_data_ds4 to gdl;
grant insert, update, references, select on customer.stg_agg_data_ds5 to gdl;
grant insert, update, references, select on customer.stg_agg_data_ds6 to gdl;
grant insert, update, references, select on customer.stg_agg_data_ds8 to gdl;
grant insert, update, references, select on customer.stg_agg_data_ds11 to gdl;
grant insert, update, references, select on customer.stg_agg_data_ds12 to gdl;
grant insert, update, references, select on customer.stg_agg_data_ds20 to gdl;
grant insert, update, references, select on customer.stg_agg_data_ds23 to gdl;
grant insert, update, references, select on customer.stg_agg_data_ds28 to gdl;
grant insert, update, references, select on customer.stg_agg_data_ds33 to gdl;
grant insert, update, references, select on customer.stg_agg_data_ds39 to gdl;
grant insert, update, references, select on customer.stg_agg_data_ds40 to gdl;
grant insert, update, references, select on customer.stg_agg_data_ds44 to gdl;
grant insert, update, references, select on customer.stg_agg_data_ds45 to gdl;
grant insert, update, references, select on customer.stg_agg_data_ds48 to gdl;
grant insert, update, references, select on customer.stg_agg_data_ds49 to gdl;
grant insert, update, references, select on customer.stg_agg_data_ds53 to gdl;
grant insert, update, references, select on customer.stg_agg_data_ds54 to gdl;
grant insert, update, references, select on customer.stg_agg_data_ds55 to gdl;
grant insert, update, references, select on customer.stg_agg_data_ds56 to gdl;
grant insert, update, references, select on customer.stg_agg_data_ds64 to gdl;
grant insert, update, references, select on customer.stg_agg_data_ds65 to gdl;
grant insert, update, references, select on customer.stg_agg_data_ds80 to gdl;
grant insert, update, references, select on customer.stg_agg_data_ds81 to gdl;
grant insert, update, references, select on customer.stg_agg_data_ds70 to gdl;
grant insert, update, references, select on customer.stg_agg_data_ds71 to gdl;
grant insert, update, references, select on customer.stg_agg_data_ds72 to gdl;


grant execute on customer.populate_um_staging to gdl;
grant execute on customer.get_process_date_from_filename to gdl;

grant customer_ro to gdl;

exit;
