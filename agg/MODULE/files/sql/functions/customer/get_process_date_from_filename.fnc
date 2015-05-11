create or replace function get_process_date_from_filename
(p_filename in varchar2) 
return date is

v_result date;

begin

  select to_date(substr(substr(p_filename,
                               instr(p_filename,
                                       '/',
                                      -1) + 1),
                         1,
                          instr(substr(p_filename,
                                      instr(p_filename,
                                           '/',
                                             -1) + 1),
                               '.',
                               1) - 7),
                  'YYYYMMDDHH24MISS')
   into v_result
    from dual;
          
  return(v_result);
  
end get_process_date_from_filename;
/

exit
