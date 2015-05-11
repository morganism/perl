create or replace procedure um.dropStagingPartitions
is
  /*
  * Drop old staging partitions. By default, Oracle won't let you drop the
  * only partition of a table, so we catch that error and swallow it. We
  * delete partitions older than 2 days anyway just for ultra-caution.
  */
  i integer;

  LAST_PARTITION EXCEPTION;
  PRAGMA EXCEPTION_INIT(last_partition, -14083);

  cursor ffs_d_clauses is
    select 'alter table um.f_file_staging drop partition ' ||
           partition_name d_clause
      from all_tab_partitions
     where table_name = 'F_FILE_STAGING'
    minus
    select distinct 'F_FILE_STAGING_P' || lpad(t.job_id, 9, '0')
      from um.f_file_staging t, jobs.job j
     where t.job_id = j.job_id
       and j.termination_time < trunc(sysdate) - 2;

  cursor lrs_d_clauses is
    select 'alter table um.log_record_staging drop partition ' ||
           partition_name d_clause
      from all_tab_partitions
     where table_name = 'LOG_RECORD_STAGING'
    minus
    select distinct 'LOG_RECORD_STAGING_P' || lpad(t.job_id, 9, '0')
      from um.log_record_staging t, jobs.job j
     where t.job_id = j.job_id
       and j.termination_time < trunc(sysdate) - 2;

begin
  
  begin
    -- delete all the old partitions
    for line in ffs_d_clauses loop
      --    dbms_output.put_line('sql string: ' || line.d_clause);
      execute immediate line.d_clause;
    end loop;

    exception
    when last_partition then null;
--      dbms_output.put_line(SQLERRM);
    when others then
      raise;
   end;
    
  begin
      for line in lrs_d_clauses loop
        --    dbms_output.put_line('sql string: ' || line.d_clause);
        execute immediate line.d_clause;
      end loop;
      
    exception
    when last_partition then null;
--      dbms_output.put_line(SQLERRM);
    when others then
      raise;
  end;

end dropStagingPartitions;
/

exit
