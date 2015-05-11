CREATE OR REPLACE PACKAGE CUSTOMER.job_schedule IS

   /************************************************************************
    * Creates multijobs based on nodes and imports
    *
    * This will create records in MULTI_JOB_REF, MULTI_JOB_COMP_REF, JOB_COMP_DEP_REF
    * No commits or DDL statements are present in this procedure so you can
    * verify the changes before committing them.
    *
    * needs some privileges:
    grant all on gdl.format_mapping_version to customer;
    grant all on um.node_metric_jn  to customer;
    grant all on gdl.format_mapping to customer;
    grant all on um.file_match_operator_ref  to customer;
    grant all on jobs.job_code_ref to customer;
    grant all on jobs.multi_job_ref to customer;
    grant all on jobs.multi_job_comp_ref to customer;
    grant all on jobs.job_comp_dep_ref to customer;
    grant all on um.mrec_definition_ref to customer;
    grant all on um.mrec_metric_ref to customer;
    grant all on um.metric_definition_ref to customer;
    grant all on um.node_metric_jn to customer;
    grant all on dgf.node_ref to customer;

    * Created on 01/03/2011 JS (based on TM-CTMS CUSTOMER.JOB_SCHEDULE)
    ************************************************************************/

  /*
   *
   * Handy method to view the hierarchy: create the view as per the 1) below, then run 2) to view

  1)

   create or replace view customer.mj_view as
     select level lvl,
            t.comp_ref_id,
            t.parent_job_ref_id,
            t.multi_job_ref_id,
            c.dependent_comp_id as is_dep_on,
            nvl(m.description, j.description) description
       from jobs.multi_job_comp_ref t,
            jobs.job_code_ref       j,
            jobs.multi_job_ref      m,
            jobs.job_comp_dep_ref   c
      where t.job_code_id = j.job_code_id(+)
        and t.multi_job_ref_id = m.multi_job_ref_id(+)
        and t.comp_ref_id = c.parent_comp_id(+)
     connect by prior t.multi_job_ref_id = t.parent_job_ref_id
     order by level, comp_ref_id;


  2)

   select max(lvl) mlvl, comp_ref_id, parent_job_ref_id, multi_job_ref_id, is_dep_on, description
   from customer.mj_view
   group by comp_ref_id, parent_job_ref_id, multi_job_ref_id, is_dep_on, description
  order by max(lvl), nvl(multi_job_ref_id, comp_ref_id);
  */

  PROCEDURE recreate_vfi_job_schedule (is_partitioned varchar2 default 'N');

END job_schedule;
/
CREATE OR REPLACE PACKAGE BODY CUSTOMER.job_schedule IS

   /************************************************************************
    * Creates multijobs based on nodes and imports
    *
    * This will create records in MULTI_JOB_REF, MULTI_JOB_COMP_REF, JOB_COMP_DEP_REF
    * No commits or DDL statements are present in this procedure so you can
    * verify the changes before committing them.
    * Created on 01/03/2011 JS (based on TM-CTMS CUSTOMER.JOB_SCHEDULE)
    ************************************************************************/
  PROCEDURE recreate_vfi_job_schedule (is_partitioned varchar2 default 'N') IS

    -- all gdl mappings
    cursor c_mapping is
    select mapping_version_id from
    (select mapping_version_id, row_number() over(partition by v.mapping_id order by v.valid_from desc) rn
     from gdl.format_mapping_version v)
     where rn = 1;

    -- all node data
    cursor c_nodematch is
    select distinct n.node_id,
                    j.file_match_definition_id,
                    v.mapping_version_Id,
                    (case when count(fmj.forecast_definition_id) > 0 then 'Y' else 'N' end) generate_forecast_yn,
                    nvl(max(d.latency), 1) offset 
      from dgf.node_ref n
      join um.node_metric_jn j on j.node_id = n.node_id
      left outer join um.forecast_metric_jn fmj on fmj.metric_definition_id = j.metric_definition_id
      join gdl.format_mapping f
          on replace(substr(f.name,instr(f.name,'(') + 1),')','') = n.description
        join gdl.format_mapping_version v
          on v.mapping_id = f.mapping_id
      join customer.data_feed_frequency_ref d on d.node = n.description
     where exists (select 'x'
                     from  um.file_match_operator_ref o
                    where  o.operator_definition_id IN (35118,35117,36010,36020,35300,35301,36030,36040,35113,35114,36070,36080,100000) --($NODE_MATCH_OPERATORS)
                      and  o.file_match_version_id = j.file_match_definition_id
                   )
       and j.is_active = 'Y'
     group by n.node_id, j.file_match_definition_id, v.mapping_version_Id
     order by v.mapping_version_id, n.node_id;

    --need a forecast job entry in job_code_ref for each source
    cursor c_source_fcast_jobs is
    select j.job_code_id, sd.node_id, sd.source_id
      from jobs.job_code_ref j
      join um.source_desc_ref sd
        on sd.source_id = to_number(replace(j.blocking_status, 'source_'))
     where j.blocking_status like 'source_%';

    -- each mrec and the highest latency out of each of the nodes associated with it
    cursor c_mrecs is
      select rd.mrec_definition_id, rd.name, max(nvl(dff.latency, 1)) + 21 offset
        from um.mrec_definition_ref rd
        join um.mrec_metric_ref mmr on mmr.mrec_version_id = rd.mrec_definition_id
        join um.metric_definition_ref md on md.metric_definition_id = mmr.metric_definition_id
        join um.node_metric_jn nmj on nmj.metric_definition_id = md.metric_definition_id
        join dgf.node_ref nr on nr.node_id = nmj.node_id
        join customer.data_feed_frequency_ref dff on dff.node = nr.description
       group by rd.mrec_definition_id, rd.name;

    last_node_id integer    := 0;
    last_comp_id integer    := 102100;
    bar integer             := 1;
    prev_imp_job_id integer := 0;

    -- ID Ranges:
    -- 101000    main multi-job
    -- 102000+   import multi-jobs
    -- 103000    post-import multi-job
    -- 104000+   node matching
    -- 105000+   node metrics
    -- 106000+   forecasting
    -- 107000+   volumetric reconciliations

  begin

----------------------------------------------------------------------------
--- big daddy
----------------------------------------------------------------------------
    insert into jobs.multi_job_ref(multi_job_ref_id, description, parameters, job_category_id)
    values(101000, '(M) Run All', null, 1);

----------------------------------------------------------------------------
--- importers
----------------------------------------------------------------------------
    --overall import mj
    insert into jobs.multi_job_ref(multi_job_ref_id, description, parameters, job_category_id)
    values                        (102000,           '(M) Import Multi-job',null, 5000);

    --create mj for each import. currently only contains the import but may have other pre/post actions to add later
    for r_mapping in c_mapping loop

      -- parent multijob import
      insert into jobs.multi_job_ref(multi_job_ref_id, description, parameters, job_category_id)
      select 210 + r_mapping.mapping_version_id, '(M) Import ' || f.description,
             '-daemon no -load_type 1 -mapping ' || r_mapping.mapping_version_id, 5000 -- Dynamic Import
        from gdl.format_mapping_version f
       where f.mapping_id = r_mapping.mapping_version_id;

/*      --we can't run all the imports at once cause we get cpm errors. so, add dependencies every 2nd import to slow it down
      if (mod(bar,2) = 0) then
          insert into jobs.job_comp_dep_ref (parent_comp_id, dependent_comp_id)
                           values (last_comp_id, last_comp_id - 1);
      end if;*/

      --the ordinary job for the gdl import
      insert into jobs.multi_job_comp_ref(comp_ref_id, parent_job_ref_id, multi_job_ref_id, job_code_id)
      values(last_comp_id, 210 + r_mapping.mapping_version_id, NULL, 5000); -- GDL Import

      -- include import mj in all imports script
      insert into jobs.multi_job_comp_ref(comp_ref_id, parent_job_ref_id, multi_job_ref_id, job_code_id)
      values(210 + r_mapping.mapping_version_id, 102000, 210 + r_mapping.mapping_version_id, NULL);

      --create dependency between import mjs to prevent cpm problems
      if last_comp_id > 102100 then
        insert into jobs.job_comp_dep_ref (parent_comp_id, dependent_comp_id)
                           values (210 + r_mapping.mapping_version_id, prev_imp_job_id);
      end if;

      prev_imp_job_id := 210 + r_mapping.mapping_version_id;
      last_comp_id := last_comp_id + 1;

    end loop;

    -- include all imports mj in run all script
    insert into jobs.multi_job_comp_ref(comp_ref_id, parent_job_ref_id, multi_job_ref_id, job_code_id)
    values(102000, 101000, 102000, NULL);

----------------------------------------------------------------------------
--- post-import (gather stats and Load staging data)
----------------------------------------------------------------------------
    insert into jobs.multi_job_ref(multi_job_ref_id, description, parameters, job_category_id)
                           values (103000,           '(M) Post-Import Multi Job','-daemon no -gatherStatsOption 3' ,1);

    -- include post-processing mj in run all script
    insert into jobs.multi_job_comp_ref(comp_ref_id, parent_job_ref_id, multi_job_ref_id, job_code_id)
    values(103000, 101000, 103000, NULL);

    --dependency: post-import on all-imports
    insert into jobs.job_comp_dep_ref (parent_comp_id, dependent_comp_id)
                               values (103000, 102000);

    --gather stats
    insert into jobs.multi_job_comp_ref(comp_ref_id, parent_job_ref_id, multi_job_ref_id, job_code_id)
                                 values(100310, 103000,           null,             35307);

    --load staged data
    insert into jobs.multi_job_comp_ref(comp_ref_id, parent_job_ref_id, multi_job_ref_id, job_code_id)
                                 values(100320, 103000,           null,             35450);

    --dependency: load staged data depends on gather stats
    insert into jobs.job_comp_dep_ref (parent_comp_id, dependent_comp_id)
                               values (100320, 100310);

--    if is_partitioned = 'Y' then
--      --delete old staging partitions
--      insert into jobs.multi_job_comp_ref(comp_ref_id, parent_job_ref_id, multi_job_ref_id, job_code_id)
--                                   values(100330, 103000,           null,             38020);
--
--      --dependency: drop staging paritions depends on load staged data
--      insert into jobs.job_comp_dep_ref (parent_comp_id, dependent_comp_id)
--                                 values (100330, 100320);
--    end if;


----------------------------------------------------------------------------
--- node matching/metrics/forecasting
----------------------------------------------------------------------------
    --all node node-stuff job
    insert into jobs.multi_job_ref(multi_job_ref_id, description, parameters, job_category_id)
                           values (104000,           '(M) All Node Multi Job','-rerun no -weekday -1',1);

    -- include post-processing mj in run all script
    insert into jobs.multi_job_comp_ref(comp_ref_id, parent_job_ref_id, multi_job_ref_id, job_code_id)
    values(104000, 101000, 104000, NULL);

    --dependency: all-nodes on post-import
    insert into jobs.job_comp_dep_ref (parent_comp_id, dependent_comp_id)
                               values (104000, 103000);

    last_comp_id := 104100;

    for r_nodematch in c_nodematch loop

      if r_nodematch.node_id <> last_node_id then
        -- parent multijob for node
        insert into jobs.multi_job_ref(multi_job_ref_id, description, parameters, job_category_id)
        select 410 + n.node_id, '(M) Node ' || n.description, '-node ' || n.node_id || ' -match 100000 -daemon no -offset ' || r_nodematch.offset
              || ' --terminatetime 23:59:59', 1
          from dgf.node_ref n
         where n.node_id = r_nodematch.node_id;

        --node matching for yesterday (if weekday param is not specified then job uses sysdate - offset).
        insert into jobs.multi_job_comp_ref (comp_ref_id, parent_job_ref_id, multi_job_ref_id, job_code_id)
                                     values (last_comp_id,410 + r_nodematch.node_id,null,35110);

        last_comp_id := last_comp_id + 1;

        -- node metrics
        insert into jobs.multi_job_comp_ref (comp_ref_id, parent_job_ref_id, multi_job_ref_id, job_code_id)
                                     values (last_comp_id, 410 + r_nodematch.node_id, NULL, 35105);

        dbms_output.put_line('last_comp_id for node metrics is ' || last_comp_id);

        -- dependency (matching before metrics)
        insert into jobs.job_comp_dep_ref(parent_comp_id, dependent_comp_id)
        values(last_comp_id, last_comp_id - 1);

        last_comp_id := last_comp_id + 1;

        -- node forecasting
        if r_nodematch.generate_forecast_yn = 'Y' then

          --fcast multi job for node
          insert into jobs.multi_job_ref (multi_job_ref_id, description, parameters, job_category_id)
                                  values (610 + r_nodematch.node_id,'(M) Forecasts multi-job for node '||
                                          r_nodematch.node_id, '-node_id '||r_nodematch.node_id || ' -offset ' || r_nodematch.offset,35004);

          --add fcast mj to parent node mj
          insert into jobs.multi_job_comp_ref (comp_ref_id, parent_job_ref_id, multi_job_ref_id, job_code_id)
                                       values (610 + r_nodematch.node_id,410 + r_nodematch.node_id,610 + r_nodematch.node_id,null);

          -- dependency (metrics before forecasting)
          insert into jobs.job_comp_dep_ref(parent_comp_id, dependent_comp_id)
          values(610 + r_nodematch.node_id, last_comp_id - 1);

          --add forecast job to fcast multi-job for all sources for this node
          for r_source_fcast_jobs in c_source_fcast_jobs loop

            if r_source_fcast_jobs.node_id = r_nodematch.node_id then

              dbms_output.put_line('node is ' || r_nodematch.node_id || ' source is ' || r_source_fcast_jobs.source_id);
              dbms_output.put_line('last_comp_id is ' || last_comp_id);
              insert into jobs.multi_job_comp_ref(comp_ref_id, parent_job_ref_id, multi_job_ref_id, job_code_id)
              values (last_comp_id, 610 + r_nodematch.node_id, null, r_source_fcast_jobs.job_code_id);

              last_comp_id := last_comp_id + 1;

            end if;

          end loop;

        end if;

        -- include the node multijob in the report (node) multijob
        insert into jobs.multi_job_comp_ref(comp_ref_id, parent_job_ref_id, multi_job_ref_id, job_code_id)
        values(410 + r_nodematch.node_id, 104000, 410 + r_nodematch.node_id, NULL);

      end if;

      last_comp_id := last_comp_id + 1;
      last_node_id := r_nodematch.node_id;
    end loop;

----------------------------------------------------------------------------
--- Metric Reconciliations
----------------------------------------------------------------------------
    --all-mrecs mj
    insert into jobs.multi_job_ref(multi_job_ref_id, description, parameters, job_category_id)
                           values (105000,           '(M) All Metric Reconciliations Multi Job','-mrec_graph_id 100001',35005);

    --create individual mrec mjs so we can pass the correct offset parameter
    for r_mrec in c_mrecs loop

      insert into jobs.multi_job_ref(multi_job_ref_id, description, parameters, job_category_id)
                           values   (5100 + r_mrec.mrec_definition_id, '(M) ' || r_mrec.name,
                                     '-mrec_id '||r_mrec.mrec_definition_id||' -num_days 21 -offset ' || r_mrec.offset,35005);
                                     
      --add mrec job
      insert into jobs.multi_job_comp_ref(comp_ref_id, parent_job_ref_id, multi_job_ref_id, job_code_id)
      values (5100 + r_mrec.mrec_definition_id, 5100 + r_mrec.mrec_definition_id, null, 35501);

      --add to all-mrecs mj
      insert into jobs.multi_job_comp_ref(comp_ref_id, parent_job_ref_id, multi_job_ref_id, job_code_id)
      values (5200 + r_mrec.mrec_definition_id, 105000, 5100 + r_mrec.mrec_definition_id, null);

    end loop;

    --include mrec mj in run all script
    insert into jobs.multi_job_comp_ref(comp_ref_id, parent_job_ref_id, multi_job_ref_id, job_code_id)
    values(105000, 101000, 105000, NULL);

    --dependency: all-mrecs on all-nodes
    insert into jobs.job_comp_dep_ref (parent_comp_id, dependent_comp_id)
                               values (105000, 104000);
                               

----------------------------------------------------------------------------
--- Old file processing and regeneration jobs
----------------------------------------------------------------------------
    --Regen mj
    insert into jobs.multi_job_ref(multi_job_ref_id, description, parameters, job_category_id)
                           values (106000,           '(M) Regeneration Multi-job',null,1);

    --late file processing
    insert into jobs.multi_job_comp_ref(comp_ref_id, parent_job_ref_id, multi_job_ref_id, job_code_id)
    values(106001, 106000, null, 138040);

    --filter late filesets
    insert into jobs.multi_job_comp_ref(comp_ref_id, parent_job_ref_id, multi_job_ref_id, job_code_id)
    values(106002, 106000, null, 35455);

    --dependency: regen mj on mrec mj
    insert into jobs.job_comp_dep_ref (parent_comp_id, dependent_comp_id)
                               values (106002, 106001);

    --metric regen
    insert into jobs.multi_job_comp_ref(comp_ref_id, parent_job_ref_id, multi_job_ref_id, job_code_id)
    values(106003, 106000, null, 35308);

    --dependency: regen mj on mrec mj
    insert into jobs.job_comp_dep_ref (parent_comp_id, dependent_comp_id)
                               values (106003, 106002);

    --mrec regen
    insert into jobs.multi_job_comp_ref(comp_ref_id, parent_job_ref_id, multi_job_ref_id, job_code_id)
    values(106004, 106000, NULL, 35313);

    --dependency: regen mj on mrec mj
    insert into jobs.job_comp_dep_ref (parent_comp_id, dependent_comp_id)
                               values (106004, 106003);

    --include regen mj in run all script
    insert into jobs.multi_job_comp_ref(comp_ref_id, parent_job_ref_id, multi_job_ref_id, job_code_id)
    values(106000, 101000, 106000, NULL);

    --dependency: regen mj on mrec mj
    insert into jobs.job_comp_dep_ref (parent_comp_id, dependent_comp_id)
                               values (106000, 105000);


----------------------------------------------------------------------------
--- Housekeeping
----------------------------------------------------------------------------
    --housekeeping mj
    insert into jobs.multi_job_ref(multi_job_ref_id, description, parameters, job_category_id)
                           values (107000,           '(M) Housekeeping Multi Job',null,4);

    --delete sqlldr logs job
    insert into jobs.multi_job_comp_ref(comp_ref_id, parent_job_ref_id, multi_job_ref_id, job_code_id)
    values (107001, 107000, null, 100001);    

    --delete input files and other sqlldr files job
    insert into jobs.multi_job_comp_ref(comp_ref_id, parent_job_ref_id, multi_job_ref_id, job_code_id)
    values (107002, 107000, null, 100000);    

    --archive job logs
    insert into jobs.multi_job_comp_ref(comp_ref_id, parent_job_ref_id, multi_job_ref_id, job_code_id)
    values (107003, 107000, null, 100002);
    
    --archive UM data
    insert into jobs.multi_job_comp_ref(comp_ref_id, parent_job_ref_id, multi_job_ref_id, job_code_id)
    values (107004, 107000, null, 135600);

    --archive IMM data
    insert into jobs.multi_job_comp_ref(comp_ref_id, parent_job_ref_id, multi_job_ref_id, job_code_id)
    values (107005, 107000, null, 103010);
    
    --add housekeeping mj to run all
    insert into jobs.multi_job_comp_ref(comp_ref_id, parent_job_ref_id, multi_job_ref_id, job_code_id)
    values(107000, 101000, 107000, NULL);

    --dependency: housekeeping on mrecs
    insert into jobs.job_comp_dep_ref (parent_comp_id, dependent_comp_id)
                               values (107000, 106000);
                               
                               
  end recreate_vfi_job_schedule;

END job_schedule;
/

exit
