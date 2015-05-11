grant select on parameter_values to customer;
grant select on parameter_set_ref to customer;

--need this for populate um staging
grant execute on utils.putmessage to customer;

exit
