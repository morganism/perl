--Update the default billing chain graph (which controls DGF/UM node dropdowns) to be the VFI default

merge into utils.parameter_values v
using (select 35200 parameter_instance_id,
              35200 parameter_set_id,
              35200 parameter_type_id,
              1 parameter_order,
              'BILLING_CHAIN_GRAPH_INSTANCE' name,
              100001 value
         from dual) vfi
on (v.parameter_instance_id = vfi.parameter_instance_id)
when matched then
  update set v.value = vfi.value
when not matched then
  insert
    (parameter_instance_id,
     parameter_set_id,
     parameter_type_id,
     parameter_order,
     name,
     value)
  values
    (vfi.parameter_instance_id,
     vfi.parameter_set_id,
     vfi.parameter_type_id,
     vfi.parameter_order,
     vfi.name,
     vfi.value);
     
exit;
