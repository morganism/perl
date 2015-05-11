create or replace package volumetricrec_daily is

  /***
  * Types
  **/
  type mrec_line is record(
    d_mrec_line_id            varchar2(52),
    d_mrec_line_id_no_version varchar2(52),
    metric_definition_id      integer,
    node_id                   integer,
    fmo_eqn                   metrictypes.fmo_equation_details);

  type mrec_line_array is table of mrec_line index by pls_integer;

  type mrec_ref is record(
    def_name           mrec_definition_ref.name%type,
    description        mrec_version_ref.description%type,
    mrec_version_id    integer,
    mrec_definition_id integer,
    mrec_lhs           mrec_line_array,
    --       mrec_lhs_line_id_str varchar2(1000),
    mrec_lhs_line_id_inlist inlisttype,
    mrec_rhs                mrec_line_array,
    --       mrec_rhs_line_id_str varchar2(1000),
    mrec_rhs_line_id_inlist inlisttype,
    mrec_rec                mrec_line,
    d_period_start          date,
    d_period_end            date,
    threshold_definition_id number,
    threshold_version_id    number,
    threshold_sequence_id   number,
    mrec_definition_name    mrec_definition_ref.name%type,
    mrec_category_id        mrec_category_ref.mrec_category_id%type,
    mrec_category_name      mrec_category_ref.category%type,
    graph_id                dgf.graph_ref.graph_id%type,
    graph_name              dgf.graph_ref.name%type);

  type value_by_d_period_list is table of number;
  type d_period_list is table of date;
  type date_list is table of date;
  type number_list is table of number;
  type char_list is table of varchar2(1);
  type name_list is table of varchar2(100);

  /* day or a date */
  type threshold_date_data is record(
    thresh_version_id number,
    from_date         date,
    to_date           date);

  type threshold_day_data is record(
    thresh_version_id number,
    t_day             varchar2(50),
    from_time         number,
    to_time           number);

  type threshold_date_array is table of threshold_date_data index by pls_integer;

  type threshold_day_array is table of threshold_day_data index by pls_integer;

  type threshold_sev_data is record(
    severity_id    number(6),
    priority_id    integer,
    importance     number(6),
    value          number,
    operator       varchar2(2),
    raise_issue    varchar2(1),
    start_state_id number(6),
    start_group_id integer,
    start_user_id  number(6));

  type threshold_sev_data_array is table of threshold_sev_data index by pls_integer;

  type threshold_def_data is record(
    threshold_name      varchar(150),
    threshold_type_name varchar(50),
    active_tv_id        number,  -- can be a large number, TT#15561
    active_td_id        number,
    tvr_description     varchar2(250),
    tvr_is_comparator   varchar2(1),
    date_data           threshold_date_array,
    day_data            threshold_day_array,
    severity_data       threshold_sev_data_array);

  type severity_data is record(
    threshold_breached   boolean,
    severity_id          number,
    priority_id          integer,
    issue_start_state_id number,
    issue_start_group_id integer,
    issue_start_user_id  number,
    raise_issue          varchar2(1),
    value                number,
    operator             varchar2(2));

  -- per edge or node
  type threshold_seq_data_array is table of threshold_def_data index by pls_integer;

  -- for all edges or nodes
  -- associated edge_id or node_id
  type threshold_data_array_by_id is table of threshold_seq_data_array index by pls_integer;

  type source_data is record(
    source_id      source_ref.source_id%TYPE,
    source_name    source_ref.name%TYPE,
    source_type_id source_ref.source_type_id%TYPE);

  type source_data_array is table of source_data index by pls_integer;

  type source_by_type_data is table of inlisttype index by pls_integer;

  type source_by_type_array_str is table of varchar2(32000) index by pls_integer;

  --  type source_by_type_array_tbl is inlisttype;
  type source_by_type_array_tbl_array is table of inlisttype index by pls_integer;

  -- CONSTANTS (start)
  -- Public constant declarations
  adminUserId            constant number := 4000;
  adminUser              constant varchar2(5) := 'Admin';
  startStateId           constant number := 3000;
  mrecIssueType          constant number := 35300;
  metricNoteTypeId       constant number := 35000;
  mrecNoteTypeId         constant number := 35001;
  forceCloseStateId      constant number := 35001;
  forceCloseResolutionId constant number := 35001;
  thresholdComparatorId  constant number := 35000;
  INFINITY_CONST         constant number := 999999999;
  --DAY_AS_MILLIS constant integer := 86400000;
  --JAVA_EPOCH_DATE constant date := to_date('01/01/1970 00:00:00', 'DD/MM/YYYY HH24:MI:SS');

  /***
  * Function/Procedures
  **/

  procedure loadStaticData(the_mrec_ref mrec_ref);

  function getThresholdsForThreshDef(a_thresh_def_id number)
    return threshold_def_data;

  function getThresholdsForThreshSeq(a_thresh_seq_id number)
    return threshold_seq_data_array;

  function getThreshVerIdForDPeriod(a_mrec_version_id integer, a_d_period_id date)
    return integer;

  function getThreshVerIdForDPeriod(current_d_period date)
    return threshold_def_data;

  function validForDates(date_data threshold_date_array, sample_date date)
    return boolean deterministic;

  function validForDays(day_data threshold_day_array, sample_date date)
    return boolean deterministic;

  function alwaysValid(date_data threshold_date_array, day_data threshold_day_array)
    return boolean deterministic;

  function testForBreach(sum_value            number,
                         diff_value           number,
                         a_threshold_def_data threshold_def_data)
    return severity_data;

  function raiseIssue(the_mrec_id            integer,
                      the_severity_data      severity_data,
                      the_mrec_ref           mrec_ref,
                      the_threshold_def_data threshold_def_data,
                      issue_date_raised      date,
                      the_d_period_id        date,
                      lhs_value              number,
                      rhs_value              number,
                      sum_value              number,
                      diff_value             number) return number;

  function executeOp(op varchar2, lval number, rval number) return boolean
    deterministic;

  /*
    function metricReconciliation(a_mrec_def_id  integer,
                                  a_d_period_start date,
                                  a_d_period_end   date
                                 ) return varchar2;
  */

  function metricReconciliation(the_mrec_ref mrec_ref) return varchar2;

  function metricReconciliationBatcher(a_mrec_def_id integer,
                                       offset_days   number,
                                       num_days      number) return varchar2;

  function initialiseMrec(a_mrec_def_id    number,
                          a_d_period_start date,
                          a_d_period_end   date) return mrec_ref;
  /*
    procedure metricReconciliationProc(a_mrec_def_id  integer,
                                  a_d_period_start varchar2,
                                  a_d_period_end   varchar2,
                                  a_job_id         number default 0,
                                  a_debug_flag     varchar2 default 'N');
  */
  procedure metricReconciliationProcBLE(a_mrec_def_id integer,
                                        offset_days   number,
                                        num_days      number,
                                        a_job_id      number default 0,
                                        a_debug_flag  varchar2 default 'N');

  procedure mRecByCategoryProcBLE(a_mrec_cat_id integer,
                                  offset_days   number,
                                  num_days      number,
                                  a_job_id      number default 0,
                                  a_debug_flag  varchar2 default 'N');

  procedure mRecByGraphProcBLE(a_mrec_graph_id integer,
                               offset_days     number,
                               num_days        number,
                               a_job_id        number default 0,
                               a_debug_flag    varchar2 default 'N');

  procedure populateFMRec(the_mrec_ref mrec_ref);

  procedure populateAggFMrec(start_date date, end_date date, p_mrec_definition_id number);

  procedure populateAggFMrecChart(start_date date, end_date date, p_mrec_definition_id number);

  function processMRecLineArray(the_mrec_line_array mrec_line_array,
                                the_mrec_ref        mrec_ref,
                                the_mrec_id         integer,
                                sign                integer) return boolean;

  function insertLineEdrBytes(the_mrec_line mrec_line,
                              the_mrec_ref  mrec_ref,
                              the_mrec_id   integer,
                              sign          integer) return integer;

  function insertLineEdrCount(the_mrec_line mrec_line,
                              the_mrec_ref  mrec_ref,
                              the_mrec_id   integer,
                              sign          integer) return integer;

  function insertLineEdrDuration(the_mrec_line mrec_line,
                                 the_mrec_ref  mrec_ref,
                                 the_mrec_id   integer,
                                 sign          integer) return integer;

  function insertLineEdrValue(the_mrec_line mrec_line,
                              the_mrec_ref  mrec_ref,
                              the_mrec_id   integer,
                              sign          integer) return integer;

  procedure mergeSides(the_d_period_list_lhs          d_period_list,
                       the_d_period_list_rhs          d_period_list,
                       the_d_period_list              IN OUT NOCOPY d_period_list,
                       the_value_by_d_period_list_lhs number_list,
                       the_value_by_d_period_list_rhs number_list,
                       the_value_by_d_period_list     IN OUT NOCOPY number_list,
                       the_diff_by_d_period_list      IN OUT NOCOPY number_list,
                       the_lhs_by_d_period_list       IN OUT NOCOPY number_list,
                       the_rhs_by_d_period_list       IN OUT NOCOPY number_list);

  procedure closeOpenIssues(the_mrec_ref mrec_ref);

  function getThresholdLimit(a_severity_id integer,
                             a_grouping_fn varchar2,
                             a_threshold_version_id integer,
                             a_sum_lhs number) return number;

  -- debug stuff
  procedure showMRecRef(the_mrec_ref mrec_ref);
  procedure logger(msg varchar2);
  procedure loggerForce(msg varchar2);

  -- copied from utils.table_utils package as cannot call directly from
  -- within this package
  procedure putMessageAuto(pModuleName in utils.Messages.Module%type,
                           pMessage    in utils.Messages.Msg%type,
                           pJobId      in utils.Messages.Job_Id%type);

  function getGlobalMetricFunction(a_metric_definition_id number)
    return metrictypes.fmo_equation_details;

  procedure loadSourceRef;

  procedure MrecVersionDuplicateRecCheck(the_mrec_ref mrec_ref);

end volumetricrec_daily;
/
create or replace package body volumetricrec_daily is

  global_job_id number;
  global_debug  integer;

  global_thresh_seq_data      threshold_seq_data_array;
  global_source_data_array    source_data_array;
  global_source_by_type_array source_by_type_data;

  ---------------------------------------------------------------
  -- Wrapper of metricReconciliation allowing call from BLE job
  ---------------------------------------------------------------
  procedure metricReconciliationProcBLE(a_mrec_def_id integer,
                                        offset_days   number,
                                        num_days      number,
                                        a_job_id      number default 0,
                                        a_debug_flag  varchar2 default 'N') is
    retMsg varchar2(500);

    daily  varchar2(1) := 'N';
    daily_mrec_id_list   number_list;
    daily_mrec_id        integer;

  begin
    global_job_id := a_job_id;

    if a_debug_flag = 'yes' then
      global_debug := 1;
    else
      global_debug := 0;
    end if;

    select mrec_definition_id bulk collect into daily_mrec_id_list from customer.daily_mrecs;

    logger('metricReconciliationProcBLE: mrec_def_id: ' || a_mrec_def_id);

    for j in daily_mrec_id_list.FIRST .. daily_mrec_id_list.LAST loop
      daily_mrec_id := daily_mrec_id_list(j);
      if a_mrec_def_id = daily_mrec_id then
         loggerForce('Running daily reconciliation for mrec: ' || a_mrec_def_id);
         daily := 'Y';
         retMsg := metricReconciliationBatcher(a_mrec_def_id,
                                               offset_days,
                                               num_days);
      end if;
    end loop;

    if daily = 'N' then
      loggerForce('Running hourly reconciliation for mrec: ' || a_mrec_def_id);
      retMsg := um.volumetricrec.metricReconciliationBatcher(a_mrec_def_id,
                                                             offset_days,
                                                             num_days);
    end if;

    logger('metricReconciliationProcBLE: mrec_def_id:');
    logger(retMsg);

  exception
    -- record and return any exception message
    when others then

      -- rollback any uncommited transactions
      rollback;

      loggerForce('Exception: ' || SUBSTR(SQLERRM, 1, 4000));
      RAISE_APPLICATION_ERROR(-20001,
                              'Exception: ' || SUBSTR(SQLERRM, 1, 4000));
  end;


  ---------------------------------------------------------------
  -- BLE job Volumetric Reconcilaition by Category
  --
  -- simple loop calling metricReconciliationProcBLE
  -- for each mrec_definition in a mrec_category
  ---------------------------------------------------------------
  procedure mRecByCategoryProcBLE(a_mrec_cat_id integer,
                                  offset_days   number,
                                  num_days      number,
                                  a_job_id      number default 0,
                                  a_debug_flag  varchar2 default 'N') is
    retMsg             varchar2(500);
    i                  integer;
    mrec_def_id        integer;
    mrec_def_id_list   number_list;
    mrec_def_name_list name_list;
    mrec_cat_name      mrec_category_ref.category%type;

    daily_mrec_id_list number_list;
    daily_mrec_id      integer;
    daily              varchar2(1);

  begin
    global_job_id := a_job_id;

    if a_debug_flag = 'yes' then
      global_debug := 1;
    else
      global_debug := 0;
    end if;

    select mcr.category
      into mrec_cat_name
      from mrec_category_ref mcr
     where mcr.mrec_category_id = a_mrec_cat_id;

    select mdr.mrec_definition_id, mdr.name bulk collect
      into mrec_def_id_list, mrec_def_name_list
      from mrec_definition_ref mdr, mrec_category_ref mcr
     where mdr.mrec_category_id = mcr.mrec_category_id
       and mdr.mrec_category_id = a_mrec_cat_id
     order by mdr.mrec_definition_id;

    select mrec_definition_id bulk collect into daily_mrec_id_list from customer.daily_mrecs;

    if mrec_def_id_list.count > 0 then
      loggerForce('Running reconciliations for category: ' ||
                  mrec_cat_name);

      -- for each mrec
      for i in mrec_def_id_list.first .. mrec_def_id_list.last loop

        mrec_def_id := mrec_def_id_list(i);

        daily := 'N';

        begin
          -- Batch it!

          for j in daily_mrec_id_list.FIRST .. daily_mrec_id_list.LAST loop
            daily_mrec_id := daily_mrec_id_list(j);
            if mrec_def_id = daily_mrec_id then
              loggerForce('Running daily reconciliation for mrec: ' || mrec_def_id);
              daily := 'Y';
              retMsg := um.volumetricrec_daily.metricReconciliationBatcher(mrec_def_id,offset_days,num_days);
            end if;
          end loop;

          if daily = 'N' then
            loggerForce('Running hourly reconciliation for mrec: ' || mrec_def_id);
            retMsg := um.volumetricrec.metricReconciliationBatcher(mrec_def_id,offset_days,num_days);
          end if;

          --loggerForce(mrec_def_name_list(i) || ' : ' || retMsg);
          loggerForce('Success: ' || mrec_def_name_list(i) || ' -- (id: ' ||
                      mrec_def_id_list(i) || ')');

        exception
          when others then
            -- rollback any uncommited transactions
            rollback;
            -- log, continue....
            loggerForce('Error: ' || mrec_def_name_list(i) || ' -- (id: ' ||
                        mrec_def_id_list(i) || ')');
            loggerForce('Exception: ' || SUBSTR(SQLERRM, 1, 4000));
        end;

      end loop;

    else
      loggerForce('No reconciliations defined for category ' ||
                  mrec_cat_name);
    end if;

  exception
    -- catch any other unexpected exceptions
    when others then
      -- rollback any uncommited transactions
      rollback;
      loggerForce('Exception: ' || SUBSTR(SQLERRM, 1, 4000));
      RAISE_APPLICATION_ERROR(-20001,
                              'Exception: ' || SUBSTR(SQLERRM, 1, 4000));

  end;

  ---------------------------------------------------------------
  -- BLE job Volumetric Reconcilaition by Billing Chain
  --
  -- simple loop calling metricReconciliationProcBLE
  -- for each mrec_definition in a billing chain
  ---------------------------------------------------------------
  procedure mRecByGraphProcBLE(a_mrec_graph_id integer,
                               offset_days     number,
                               num_days        number,
                               a_job_id        number default 0,
                               a_debug_flag    varchar2 default 'N') is
    retMsg             varchar2(500);
    i                  integer;
    mrec_def_id        integer;
    mrec_def_id_list   number_list;
    mrec_def_name_list name_list;
    mrec_graph_name    dgf.graph_ref.name%type;

    daily_mrec_id_list number_list;
    daily_mrec_id      integer;
    daily              varchar2(1);

  begin
    global_job_id := a_job_id;

    if a_debug_flag = 'yes' then
      global_debug := 1;
    else
      global_debug := 0;
    end if;

    select gr.name
      into mrec_graph_name
      from dgf.graph_ref gr
     where gr.graph_id = a_mrec_graph_id;

    select mdr.mrec_definition_id, mdr.name bulk collect
      into mrec_def_id_list, mrec_def_name_list
      from mrec_definition_ref mdr, dgf.graph_ref gr
     where mdr.graph_id = gr.graph_id
       and mdr.graph_id = a_mrec_graph_id
     order by mdr.mrec_definition_id;

    select mrec_definition_id bulk collect into daily_mrec_id_list from customer.daily_mrecs;

    if mrec_def_id_list.count > 0 then
      loggerForce('Running reconciliations for billing chain: ' ||
                  mrec_graph_name);

      -- for each MREC
      for i in mrec_def_id_list.first .. mrec_def_id_list.last loop

        mrec_def_id := mrec_def_id_list(i);

        daily := 'N';

        begin

          for j in daily_mrec_id_list.FIRST .. daily_mrec_id_list.LAST loop
            daily_mrec_id := daily_mrec_id_list(j);
            if mrec_def_id = daily_mrec_id then
              loggerForce('Running daily reconciliation for mrec: ' || mrec_def_id);
              daily := 'Y';
              retMsg := um.volumetricrec_daily.metricReconciliationBatcher(mrec_def_id,offset_days,num_days);
            end if;
          end loop;

          if daily = 'N' then
            loggerForce('Running hourly reconciliation for mrec: ' || mrec_def_id);
            retMsg := um.volumetricrec.metricReconciliationBatcher(mrec_def_id,offset_days,num_days);
          end if;

          --loggerForce(mrec_def_name_list(i) || ' : ' || retMsg);
          loggerForce('Success: ' || mrec_def_name_list(i) || ' -- (id: ' ||
                      mrec_def_id_list(i) || ')');

        exception
          when others then
            -- rollback any uncommited transactions
            rollback;
            -- log, continue....
            loggerForce('Error: ' || mrec_def_name_list(i) || ' -- (id: ' ||
                        mrec_def_id_list(i) || ')');
            loggerForce('Exception: ' || SUBSTR(SQLERRM, 1, 4000));

        end;

      end loop;

    else
      loggerForce('No reconciliations defined for billing chain ' ||
                  mrec_graph_name);
    end if;

  exception
    -- catch any other unexpected exceptions
    when others then
      -- rollback any uncommited transactions
      rollback;
      loggerForce('Exception: ' || SUBSTR(SQLERRM, 1, 4000));
      RAISE_APPLICATION_ERROR(-20001,
                              'Exception: ' || SUBSTR(SQLERRM, 1, 4000));

  end;

  function metricReconciliationBatcher(a_mrec_def_id integer,
                                       offset_days   number,
                                       num_days      number) return varchar2 is

    retMsg     varchar2(500);
    s_date     date;
    e_date     date;
    start_date date;
    end_date   date;

    the_mrec_ref mrec_ref;

    rec_interval constant pls_integer := um.etl.getDPeriodResolutionMinutes(sysdate);
  begin

    -- initialise the mrec_ref
    -- set the d_period_start/end as we batch
    the_mrec_ref := initialiseMrec(a_mrec_def_id, null, null);

    -- start on a HH24:00:00 boundary
    start_date := trunc(sysdate - offset_days, 'DD');
    end_date   := start_date + num_days;

    if start_date >= end_date then
      return 'Start Date must be less than End Date';
    end if;

    s_date := start_date;
    e_date := s_date + 1;

    -- TODO check boundary condition
    -- as rec_interval is integer and s_date
    -- always starts on HH:00:00 boundary then
    -- e_date will maintain HH:00:00 boundary

    logger('metricReconciliationProcBatcher: mrec_def_id: ' || a_mrec_def_id);

    -- run reconciliation from start_date to end_date
    -- in batches of contiguous rec_interval/24 hour blocks
    while s_date < end_date loop

      logger('metricReconciliationProcBLE: step start: ' || to_char(s_date, 'YYYY/MM/DD HH24:MI:SS'));
      logger('metricReconciliationProcBLE: step end: ' || to_char(e_date, 'YYYY/MM/DD HH24:MI:SS'));

      the_mrec_ref.d_period_start := s_date;
      the_mrec_ref.d_period_end   := e_date;

      retMsg := metricReconciliation(the_mrec_ref);

      -- TODO we could make this commit depend on the number of rows
      -- generated by the reconciliation
      commit;
      logger('metricReconciliationProcBatcher: retMsg: ' || retMsg);

      -- next block
      s_date := e_date;
      e_date := e_date + 1;

      if e_date > end_date then
        e_date := end_date;
      end if;

    end loop;

    -- AGG_F_MREC used by olap reports
    populateAggFMrec(start_date, end_date, a_mrec_def_id);

    -- AGG_F_MREC_CHART used by Reconciliation chart
    populateAggFMrecChart(start_date, end_date, a_mrec_def_id);

    logger('metricReconciliationProcBatcher: Completed');
    return 'metricReconciliationProcBatcher: Completed'; -- TODO !!

  end;

  ---------------------------------------------------------------
  -- Main entry point to the Metric Reconciliation Function
  -- requires a commit if called directly
  ---------------------------------------------------------------
  function metricReconciliation(the_mrec_ref mrec_ref) return varchar2 is

    retMsg varchar2(1000);

  begin
    -- populate F_MREC for current reconciliation

    populateFMRec(the_mrec_ref);

    retMsg := 'Successful Reconcilliation -- Id: ' ||
              the_mrec_ref.mrec_definition_id || ': ' ||
              to_char(the_mrec_ref.d_period_start, 'MM/YY HH24:MI:SS') ||
              ' - ' ||
              to_char(the_mrec_ref.d_period_end, 'MM/YY HH24:MI:SS');

    return retMsg;

  end;

  /***********************************************
  * Populate the F_MREC table
  ************************************************/
  procedure populateFMRec(the_mrec_ref mrec_ref) is
    the_mrec_lhs mrec_line_array;
    the_mrec_rhs mrec_line_array;

    the_value_by_d_period_list     number_list; -- holds the sum per d_period
    the_diff_by_d_period_list      number_list; -- holds the percent diff per d_period
    the_lhs_by_d_period_list       number_list; -- holds the sum of lhs per d_period
    the_rhs_by_d_period_list       number_list; -- holds the sum of rhs per d_period
    the_value_by_d_period_list_lhs number_list;
    the_value_by_d_period_list_rhs number_list;
    the_d_period_list              d_period_list;
    the_d_period_list_lhs          d_period_list;
    the_d_period_list_rhs          d_period_list;
    the_thresh_ver_id              number;

    the_f_mrec_id_list  number_list := number_list();
    the_mrec_id         integer;

    the_issue_id_list   number_list := number_list();
    the_issue_date_list date_list := date_list();
    got_issues          boolean := false;

    the_threshold_def_data threshold_def_data;
    the_severity_data      severity_data;
    issue_id               number;
    issue_date_raised      date;
    l_d_period_id          date;
    new_data               boolean;

  begin
    logger('populateFMRec: ');

    the_mrec_lhs := the_mrec_ref.mrec_lhs;
    the_mrec_rhs := the_mrec_ref.mrec_rhs;

    -- obtain new MREC_ID value
    select SEQ_MREC_ID.nextval into the_mrec_id from dual;

    -- Process LHS
    new_data := processMRecLineArray(the_mrec_lhs, the_mrec_ref, the_mrec_id, -1);

    -- Process RHS
    new_data := processMRecLineArray(the_mrec_rhs, the_mrec_ref, the_mrec_id, 1) or
                new_data;

    -- If no data has changed, then no need to proceed with the reconciliation
    if new_data then
      logger('populateFMRec: new data');

      -- close any issues that were opened as a result of a previous reconciliation
      closeOpenIssues(the_mrec_ref);

      -- calculate the lhs and rhs line values grouped by d_period_id
      -- LHS (-1)
      select trunc(f.d_period_id), sum(mrec) bulk collect
        into the_d_period_list_lhs, the_value_by_d_period_list_lhs
        from f_mrec f,
             d_mrec_line_mv ml
       where f.d_period_id >= the_mrec_ref.d_period_start
         and f.d_period_id < the_mrec_ref.d_period_end
         and f.mrec_set = -1
         and f.d_mrec_line_id = ml.d_mrec_line_id
         and ml.mrec_definition_id = the_mrec_ref.mrec_definition_id
       group by trunc(f.d_period_id)
       order by trunc(f.d_period_id);

      -- RHS (1)
      select trunc(f.d_period_id), sum(mrec) bulk collect
        into the_d_period_list_rhs, the_value_by_d_period_list_rhs
        from f_mrec f,
             d_mrec_line_mv ml
       where f.d_period_id >= the_mrec_ref.d_period_start
         and f.d_period_id < the_mrec_ref.d_period_end
         and f.mrec_set = 1
         and f.d_mrec_line_id = ml.d_mrec_line_id
         and ml.mrec_definition_id = the_mrec_ref.mrec_definition_id
       group by trunc(f.d_period_id)
       order by trunc(f.d_period_id);

      -- merge the lists
      -- Ideally we would have balanced d_period lists on both sides
      -- unfortunaley this may not be the case, so here we merge the lhs and ths lists
      -- into 3 lists
      --     one holds d_period_id
      --     one holds the sum of lhs and rhs
      --     one holds the percentage difference of lhs and rhs (used in threshold tests)
      -- initialise result lists
      the_d_period_list          := d_period_list();
      the_value_by_d_period_list := number_list();
      the_diff_by_d_period_list  := number_list();
      the_lhs_by_d_period_list   := number_list();
      the_rhs_by_d_period_list   := number_list();

      -- do the merge!
      mergeSides(the_d_period_list_lhs,
                 the_d_period_list_rhs,
                 the_d_period_list,
                 the_value_by_d_period_list_lhs,
                 the_value_by_d_period_list_rhs,
                 the_value_by_d_period_list,
                 the_diff_by_d_period_list,
                 the_lhs_by_d_period_list,
                 the_rhs_by_d_period_list);

      -- load threshold data into memory
      loadStaticData(the_mrec_ref);

      the_f_mrec_id_list.extend(the_d_period_list.count);
      the_issue_id_list.extend(the_d_period_list.count);
      the_issue_date_list.extend(the_d_period_list.count);

      -- if any issues are raised, then use this date
      issue_date_raised := sysdate;

      -- Load the thresholds for each d_period
      for i in the_d_period_list.first .. the_d_period_list.last loop

        -- defaults
        select SEQ_F_MREC_ID.nextval into the_f_mrec_id_list(i) from dual;

        the_issue_id_list(i) := null;

        the_threshold_def_data := getThreshVerIdForDPeriod(the_d_period_list(i));

        begin
          the_thresh_ver_id := the_threshold_def_data.active_tv_id;
        exception
          when others then
            the_thresh_ver_id := null;
        end;

        if the_thresh_ver_id is not null then

          -- test for a threashold breach
          the_severity_data := testForBreach(the_value_by_d_period_list(i),
                                             the_diff_by_d_period_list(i),
                                             the_threshold_def_data);

          if the_severity_data.raise_issue = 'Y' then
            logger('issue detected');
            got_issues := true;

            -- RAISE IT in IMM!
            issue_id := raiseIssue(the_mrec_id,
                                   the_severity_data,
                                   the_mrec_ref,
                                   the_threshold_def_data,
                                   issue_date_raised,
                                   the_d_period_list(i),
                                   the_lhs_by_d_period_list(i),
                                   the_rhs_by_d_period_list(i),
                                   the_value_by_d_period_list(i),
                                   the_diff_by_d_period_list(i));

            -- track the issue_ids (unless Daily Issue Limit has been breached
            if issue_id != IMM.Issues.DAILY_LIMIT_BREACH_FLAG then
              the_issue_id_list(i) := issue_id;
              the_issue_date_list(i) := issue_date_raised;
            end if;

          end if;

        end if;

        if global_debug = 1 then
          logger('d_period: ' ||
                 to_char(the_d_period_list(i), 'DD-MM-YYYY HH24:MI:SS'));
          logger('thresh_ver_id: ' || the_thresh_ver_id);
          logger('thresh_def_id: ' || the_threshold_def_data.active_td_id);
        end if;
      end loop;

      -- clear previous reconciliation data and close any issues that were opened
      -- bulk delete reconcilaition rows from F_MREC
      forall i in the_d_period_list.first .. the_d_period_list.last
        delete from   f_mrec fmr
        where  fmr.d_period_id = the_d_period_list(i)
        and    fmr.mrec_set = 0
        and    exists (select 1 
                       from   um.d_mrec_line_mv mv
                       where mv.mrec_definition_id = the_mrec_ref.mrec_definition_id
                       and   mv.d_mrec_line_id = fmr.d_mrec_line_id
                       and   mv.line_type = 0);


      -- bulk load F_MREC reconciliation values
      for i in the_d_period_list.first .. the_d_period_list.last
      loop
          insert into f_mrec f (
             D_PERIOD_ID,
             F_MREC_ID,
             F_FILE_ID,
             F_ATTRIBUTE_ID,
             MREC_ID,
             MREC_SET,
             D_MREC_LINE_ID,
             MREC_TYPE,
             MEASURE_TYPE,
             MREC
          )
          values (
             the_d_period_list(i),
             the_f_mrec_id_list(i),
             -1,
             -1,
             the_mrec_id,
             0,
             the_mrec_ref.mrec_rec.d_mrec_line_id,
             'T',
             the_mrec_ref.mrec_rec.fmo_eqn.field_type,
             the_value_by_d_period_list(i)
          );
      end loop;

      -- get the system date
      l_d_period_id := etl.get_d_period(sysdate);

      -- load normalised MREC table
      insert into MREC (
          D_PERIOD_ID,
          MREC_ID,
          MREC_DEFINITION_ID,
          MREC_VERSION_ID,
          THRESHOLD_SEQUENCE_ID,
          THRESHOLD_DEFINITION_ID,
          THRESHOLD_VERSION_ID
      )
      values (
          l_d_period_id,
          the_mrec_id,
          the_mrec_ref.mrec_definition_id,
          the_mrec_ref.mrec_version_id,
          the_mrec_ref.threshold_sequence_id,
          the_mrec_ref.threshold_definition_id,
          the_mrec_ref.threshold_version_id
      );

      if got_issues then
        -- load MREC_ISSUE_JN values
        for i in the_d_period_list.first .. the_d_period_list.last loop
          if the_issue_id_list(i) is not null then
            insert into mrec_issue_jn (
               D_PERIOD_ID,
               MREC_ID,
               ISSUE_ID,
               DATE_RAISED,
               MREC_DEFINITION_ID,
               ISSUE_STATUS
            )
            values (
               the_d_period_list(i),
               the_mrec_id,
               the_issue_id_list(i),
               the_issue_date_list(i),
               the_mrec_ref.mrec_definition_id,
               'O'
            );

          end if;
        end loop;
      end if;

    end if;

    logger('populateFMRec: DONE!');

  end;


     ----------------------------------------------------------------
    -- Aggregates F_MREC records to populate AGG_F_MREC_CHART
    --
    ----------------------------------------------------------------
  procedure populateAggFMrec(start_date date, end_date date, p_mrec_definition_id number) is
    rows integer;

    cursor c_dates (c_start date, c_end date) is
    select d_day_id, to_date(d_day_id || ' 00:00:00', 'DD/MM/RRRR HH24:MI:SS') day_start,
                     to_date(d_day_id || ' 23:59:59', 'DD/MM/RRRR HH24:MI:SS') day_end
    from   d_day
    where  d_day_id between c_start and c_end;

  begin

    logger('populateAggFMrec: START. Inserting for dates between: ' ||
           to_char(start_date, 'DD:MM HH24:MI:SS') || ' and ' ||
           to_char(end_date, 'DD:MM HH24:MI:SS'));

    rows := 0;

    FOR p_dates in c_dates (start_date, end_date) LOOP

        MERGE INTO UM.AGG_F_MREC afm
        USING (SELECT trunc(fm2.d_period_id) d_day_id,
                     fm2.d_mrec_line_id,
                     fm2.d_edge_id,
                     fa.d_edr_type_id,
                     fa.d_node_id,
                     fa.d_measure_type_id,
                     fa.d_source_id,
                     fm2.measure_type,
                     sum(fm2.mrec) mrec,
                     count(*) f_mrec_count,
                     DBMS_MVIEW.PMARKER(fm2.ROWID) f_mrec_pmarker
               FROM  um.f_mrec fm2,
                     um.f_attribute fa,
                     um.d_mrec_line_mv v
               WHERE fa.f_attribute_id(+) = fm2.f_attribute_id
               AND   fm2.d_mrec_line_id = v.d_mrec_line_id
               AND   v.mrec_definition_id = p_mrec_definition_id
               AND   fm2.d_period_id between p_dates.day_start and p_dates.day_end
               GROUP BY TRUNC(fm2.d_period_id),
                        fm2.d_mrec_line_id,
                        fm2.d_edge_id,
                        fa.d_edr_type_id,
                        fa.d_node_id,
                        fa.d_measure_type_id,
                        fa.d_source_id,
                        fm2.measure_type,
                        DBMS_MVIEW.PMARKER(fm2.ROWID)) fm
        ON (
                    afm.d_mrec_line_id = fm.d_mrec_line_id
              and   afm.d_day_id = fm.d_day_id
              and   afm.d_day_id = p_dates.d_day_id
              and   nvl(afm.d_edge_id,-1) = nvl(fm.d_edge_id,-1)
              and   nvl(afm.d_edr_type_id,-1) = nvl(fm.d_edr_type_id,-1)
              and   nvl(afm.d_node_id,-1) = nvl(fm.d_node_id,-1)
              and   nvl(afm.d_measure_type_id,-1) = nvl(fm.d_measure_type_id,-1)
              and   nvl(afm.d_source_id,-1) = nvl(fm.d_source_id,-1)
              and   nvl(afm.measure_type,-1)= nvl(fm.measure_type,-1)
            )
        WHEN MATCHED THEN
          UPDATE SET
                afm.mrec = fm.mrec,
                afm.f_mrec_count = fm.f_mrec_count,
                afm.f_mrec_pmarker = fm.f_mrec_pmarker
          WHERE afm.d_day_id = p_dates.d_day_id
        WHEN NOT MATCHED THEN
          INSERT
              (d_day_id,
               d_mrec_line_id,
               d_edge_id,
               d_edr_type_id,
               d_node_id,
               d_measure_type_id,
               d_source_id,
               measure_type,
               mrec,
               f_mrec_count,
               f_mrec_pmarker
               )
          VALUES
              (fm.d_day_id,
               fm.d_mrec_line_id,
               fm.d_edge_id,
               fm.d_edr_type_id,
               fm.d_node_id,
               fm.d_measure_type_id,
               fm.d_source_id,
               fm.measure_type,
               fm.mrec,
               fm.f_mrec_count,
               fm.f_mrec_pmarker
              );

         rows := rows + SQL%ROWCOUNT;

         COMMIT;

    END LOOP;


    logger('populateAggFMrec: END. Merged ' || rows ||
           ' into AGG_F_MREC');

  end;


    ----------------------------------------------------------------
    -- Aggregates F_MREC records to populate AGG_F_MREC_CHART
    --
    ----------------------------------------------------------------
  procedure populateAggFMrecChart(start_date date, end_date date, p_mrec_definition_id number) is
    rows integer;

    cursor c_dates (c_start date, c_end date) is
    select d_day_id, to_date(d_day_id || ' 00:00:00', 'DD/MM/RRRR HH24:MI:SS') day_start,
                     to_date(d_day_id || ' 23:59:59', 'DD/MM/RRRR HH24:MI:SS') day_end
    from   d_day
    where  d_day_id between c_start and c_end;

  begin

    logger('populateAggFMrecChart: START. Inserting for dates between: ' ||
           to_char(start_date, 'DD:MM HH24:MI:SS') || ' and ' ||
           to_char(end_date, 'DD:MM HH24:MI:SS'));

    rows := 0;

    FOR p_dates in c_dates (start_date, end_date) LOOP

        MERGE INTO um.agg_f_mrec_chart afmc
        USING (SELECT trunc(fm.d_period_id) d_day_id,
                           fm.d_mrec_line_id,
                           fm.d_edge_id,
                           fa.d_node_id,
                           fm.measure_type,
                           sum(fm.mrec) mrec,
                           count(*) f_mrec_count,
                           DBMS_MVIEW.PMARKER(fm.ROWID) f_mrec_pmarker
                      FROM um.f_mrec fm,
                           um.f_attribute fa,
                           um.d_mrec_line_mv v
                     WHERE fa.f_attribute_id(+) = fm.f_attribute_id
                     AND   fm.d_mrec_line_id = v.d_mrec_line_id
                     AND   v.mrec_definition_id = p_mrec_definition_id
                     AND   fm.d_period_id between p_dates.day_start and p_dates.day_end
                     GROUP BY TRUNC(fm.d_period_id),
                              fm.d_mrec_line_id,
                              fm.d_edge_id,
                              fa.d_node_id,
                              fm.measure_type,
                              DBMS_MVIEW.PMARKER(fm.ROWID)) fm
        ON (
                  afmc.d_day_id = fm.d_day_id
              and afmc.d_mrec_line_id = fm.d_mrec_line_id
              and afmc.d_day_id = p_dates.d_day_id
              and nvl(afmc.d_edge_id,-1) = nvl(fm.d_edge_id,-1)
              and nvl(afmc.d_node_id,-1) = nvl(fm.d_node_id,-1)
              and nvl(afmc.measure_type,-1)= nvl(fm.measure_type,-1)
            )
        WHEN MATCHED THEN
          UPDATE SET
                afmc.mrec = fm.mrec,
                afmc.f_mrec_count = fm.f_mrec_count,
                afmc.f_mrec_pmarker = fm.f_mrec_pmarker
          WHERE afmc.d_day_id = p_dates.d_day_id
        WHEN NOT MATCHED THEN
          INSERT
             (d_day_id,
              d_mrec_line_id,
              d_edge_id,
              d_node_id,
              measure_type,
              mrec,
              f_mrec_count,
              f_mrec_pmarker
             )
          VALUES
              (fm.d_day_id,
               fm.d_mrec_line_id,
               fm.d_edge_id,
               fm.d_node_id,
               fm.measure_type,
               fm.mrec,
               fm.f_mrec_count,
               fm.f_mrec_pmarker
              );

          rows := rows + SQL%ROWCOUNT;

          COMMIT;

    END LOOP;

    logger('populateAggFMrecChart: END. Inserted ' || rows ||
           ' into AGG_F_MREC');

  end;

  ----------------------------------------------------------------
  -- Process all LINEs belonging to a SIDE (rhs or lhs)
  -- sign will be either -1 (lhs) or +1 (rhs)
  --
  -- Return row_count used to determine if new data loaded
  -- (this occurs on the first run of the reconciliation and
  --  when new data is added to F_FILE for records that
  --  are part of the reconciliation)
  ----------------------------------------------------------------
  function processMRecLineArray(the_mrec_line_array mrec_line_array,
                                the_mrec_ref        mrec_ref,
                                the_mrec_id         integer,
                                sign                integer) return boolean is
    the_mrec_line mrec_line;
    counter       pls_integer;
    row_count     integer := 0;

  begin
    logger('processMRecLineArray: sign: ' || sign);
    if the_mrec_line_array is not null then
      counter := the_mrec_line_array.FIRST;
      while (counter is not null) loop
        the_mrec_line := the_mrec_line_array(counter);
        logger('processMRecLineArray: line: ' ||
               the_mrec_line.metric_definition_id);

        case the_mrec_line.fmo_eqn.field_type

          when 'B' then
            row_count := row_count + insertLineEdrBytes(the_mrec_line,
                                                        the_mrec_ref,
                                                        the_mrec_id,
                                                        sign);

          when 'C' then
            row_count := row_count + insertLineEdrCount(the_mrec_line,
                                                        the_mrec_ref,
                                                        the_mrec_id,
                                                        sign);

          when 'D' then
            row_count := row_count + insertLineEdrDuration(the_mrec_line,
                                                           the_mrec_ref,
                                                           the_mrec_id,
                                                           sign);

          when 'V' then
            row_count := row_count + insertLineEdrValue(the_mrec_line,
                                                        the_mrec_ref,
                                                        the_mrec_id,
                                                        sign);

        end case;

        counter := the_mrec_line_array.NEXT(counter);
        logger('processMRecLineArray: row count ' || row_count);
      end loop;
    end if;

    if row_count > 0 then
      return true;
    else
      return false;
    end if;
  end;

  ----------------------------------------------------------------
  -- to avoid dynamic sql we use hard coded edr_field_type
  -- code duplication but better peformance
  --
  -- TODO another way to do this would be to calculate for all
  -- field types (B,C,D,V) in one function call/one sql statement
  -- and use a switch to grab the right value
  ----------------------------------------------------------------
  function insertLineEdrBytes(the_mrec_line mrec_line,
                              the_mrec_ref  mrec_ref,
                              the_mrec_id   integer,
                              sign          integer)
  return integer is
    l_rows integer := 0;
    current_fmo_eqn metrictypes.fmo_equation_details;
    adjuster number;
  begin
    logger('insertLineEdrBytes: lineId: ' || the_mrec_line.d_mrec_line_id);

    current_fmo_eqn := the_mrec_line.fmo_eqn;
    adjuster := nvl(current_fmo_eqn.adjuster,1);

    MERGE into f_mrec f
    --USING (select TRUNC(ff.d_period_id, 'HH24') as dp,
    USING (select ff.d_period_id as dp,
                  ff.f_file_id   as f_file_id,
                  ff.f_attribute_id,
                  the_mrec_line.d_mrec_line_id as d_mrec_line_id,
                  fa.d_node_id                 as d_node_id,
                  fa.d_source_id               as d_source_id,
                  fa.d_edr_type_id             as d_edr_type_id,
                  fa.d_payment_type_id         as d_payment_type_id,
                  fa.d_call_type_id            as d_call_type_id,
                  fa.d_customer_type_id        as d_customer_type_id,
                  fa.d_service_provider_id     as d_service_provider_id,
                  fa.d_measure_type_id         as d_measure_type_id,
                  fa.d_custom_01_id            as d_custom_01_id,
                  fa.d_custom_02_id            as d_custom_02_id,
                  fa.d_custom_03_id            as d_custom_03_id,
                  fa.d_custom_04_id            as d_custom_04_id,
                  fa.d_custom_05_id            as d_custom_05_id,
                  fa.d_custom_06_id            as d_custom_06_id,
                  fa.d_custom_07_id            as d_custom_07_id,
                  fa.d_custom_08_id            as d_custom_08_id,
                  fa.d_custom_09_id            as d_custom_09_id,
                  fa.d_custom_10_id            as d_custom_10_id,
                  fa.d_custom_11_id            as d_custom_11_id,
                  fa.d_custom_12_id            as d_custom_12_id,
                  fa.d_custom_13_id            as d_custom_13_id,
                  fa.d_custom_14_id            as d_custom_14_id,
                  fa.d_custom_15_id            as d_custom_15_id,
                  fa.d_custom_16_id            as d_custom_16_id,
                  fa.d_custom_17_id            as d_custom_17_id,
                  fa.d_custom_18_id            as d_custom_18_id,
                  fa.d_custom_19_id            as d_custom_19_id,
                  fa.d_custom_20_id            as d_custom_20_id,
                  ff.edr_bytes * adjuster      as mrecval
             from (select trunc(d_period_id) d_period_id, min(f_file_id) f_file_id, f_attribute_id, sum(edr_bytes) edr_bytes from f_file
                   group by trunc(d_period_id), f_attribute_id) ff,
                  f_attribute fa
                  left outer join um.d_edr_type_mv detmv
                               on detmv.d_edr_type_id = fa.d_edr_type_id
            where ff.f_attribute_id = fa.f_attribute_id
              and ff.d_period_id >= the_mrec_ref.d_period_start
              and ff.d_period_id < the_mrec_ref.d_period_end
              and fa.d_node_id = the_mrec_line.node_id

              and (current_fmo_eqn.source_id = -1 OR
                  fa.d_source_id = current_fmo_eqn.source_id)

              and (current_fmo_eqn.source_type_id = -1 OR EXISTS
                  (select source_id
                     from source_ref s
                    where source_type_id = current_fmo_eqn.source_type_id
                      and s.source_id = fa.d_source_id))

              and (current_fmo_eqn.i_d_measure_type_id = -1 OR
                  fa.d_measure_type_id =
                  current_fmo_eqn.i_d_measure_type_id)

              and (current_fmo_eqn.edr_type_id = -1 or detmv.edr_type_uid = current_fmo_eqn.edr_type_id)
              and (current_fmo_eqn.edr_sub_type_id = -1 or detmv.edr_sub_type_id = current_fmo_eqn.edr_sub_type_id)

              and (current_fmo_eqn.d_payment_type_id = -1 OR
                  fa.d_payment_type_id = current_fmo_eqn.d_payment_type_id)
              and (current_fmo_eqn.d_call_type_id = -1 OR
                  fa.d_call_type_id = current_fmo_eqn.d_call_type_id)
              and (current_fmo_eqn.d_customer_type_id = -1 OR
                  fa.d_customer_type_id =
                  current_fmo_eqn.d_customer_type_id)
              and (current_fmo_eqn.d_service_provider_id = -1 OR
                  fa.d_service_provider_id =
                  current_fmo_eqn.d_service_provider_id)

              and (current_fmo_eqn.d_custom_01_list is null OR fa.d_custom_01_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_01_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_02_list is null OR fa.d_custom_02_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_02_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_03_list is null OR fa.d_custom_03_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_03_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_04_list is null OR fa.d_custom_04_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_04_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_05_list is null OR fa.d_custom_05_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_05_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_06_list is null OR fa.d_custom_06_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_06_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_07_list is null OR fa.d_custom_07_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_07_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_08_list is null OR fa.d_custom_08_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_08_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_09_list is null OR fa.d_custom_09_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_09_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_10_list is null OR fa.d_custom_10_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_10_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_11_list is null OR fa.d_custom_11_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_11_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_12_list is null OR fa.d_custom_12_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_12_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_13_list is null OR fa.d_custom_13_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_13_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_14_list is null OR fa.d_custom_14_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_14_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_15_list is null OR fa.d_custom_15_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_15_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_16_list is null OR fa.d_custom_16_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_16_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_17_list is null OR fa.d_custom_17_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_17_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_18_list is null OR fa.d_custom_18_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_18_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_19_list is null OR fa.d_custom_19_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_19_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_20_list is null OR fa.d_custom_20_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_20_list as inlisttype) from dual)))
/*
              and (current_fmo_eqn.d_custom_01_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_01_list_csv || ','), (',' || fa.d_custom_01_id || ',')))
              and (current_fmo_eqn.d_custom_02_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_02_list_csv || ','), (',' || fa.d_custom_02_id || ',')))
              and (current_fmo_eqn.d_custom_03_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_03_list_csv || ','), (',' || fa.d_custom_03_id || ',')))
              and (current_fmo_eqn.d_custom_04_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_04_list_csv || ','), (',' || fa.d_custom_04_id || ',')))
              and (current_fmo_eqn.d_custom_05_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_05_list_csv || ','), (',' || fa.d_custom_05_id || ',')))
              and (current_fmo_eqn.d_custom_06_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_06_list_csv || ','), (',' || fa.d_custom_06_id || ',')))
              and (current_fmo_eqn.d_custom_07_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_07_list_csv || ','), (',' || fa.d_custom_07_id || ',')))
              and (current_fmo_eqn.d_custom_08_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_08_list_csv || ','), (',' || fa.d_custom_08_id || ',')))
              and (current_fmo_eqn.d_custom_09_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_09_list_csv || ','), (',' || fa.d_custom_09_id || ',')))
              and (current_fmo_eqn.d_custom_10_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_10_list_csv || ','), (',' || fa.d_custom_10_id || ',')))
              and (current_fmo_eqn.d_custom_11_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_11_list_csv || ','), (',' || fa.d_custom_11_id || ',')))
              and (current_fmo_eqn.d_custom_12_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_12_list_csv || ','), (',' || fa.d_custom_12_id || ',')))
              and (current_fmo_eqn.d_custom_13_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_13_list_csv || ','), (',' || fa.d_custom_13_id || ',')))
              and (current_fmo_eqn.d_custom_14_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_14_list_csv || ','), (',' || fa.d_custom_14_id || ',')))
              and (current_fmo_eqn.d_custom_15_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_15_list_csv || ','), (',' || fa.d_custom_15_id || ',')))
              and (current_fmo_eqn.d_custom_16_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_16_list_csv || ','), (',' || fa.d_custom_16_id || ',')))
              and (current_fmo_eqn.d_custom_17_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_17_list_csv || ','), (',' || fa.d_custom_17_id || ',')))
              and (current_fmo_eqn.d_custom_18_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_18_list_csv || ','), (',' || fa.d_custom_18_id || ',')))
              and (current_fmo_eqn.d_custom_19_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_19_list_csv || ','), (',' || fa.d_custom_19_id || ',')))
              and (current_fmo_eqn.d_custom_20_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_20_list_csv || ','), (',' || fa.d_custom_20_id || ',')))
*/
           ) fff
    ON (f.f_file_id = fff.f_file_id and f.d_mrec_line_id = fff.d_mrec_line_id and fff.dp = f.d_period_id)
    WHEN NOT MATCHED THEN
      insert (
         D_PERIOD_ID,
         F_MREC_ID,
         F_FILE_ID,
         f_attribute_id,
         MREC_ID,
         MREC_SET,
         D_MREC_LINE_ID,
         MREC_TYPE,
         MEASURE_TYPE,
         MREC
      )
      values (
         fff.dp,
         SEQ_F_MREC_ID.nextval,
         fff.f_file_id,
         fff.f_attribute_id,
         the_mrec_id,
         sign,
         the_mrec_line.d_mrec_line_id,
         'T',
         current_fmo_eqn.field_type,
         fff.mrecval * sign
      );

    l_rows := SQL%ROWCOUNT;

    return l_rows;
  end;

  ----------------------------------------------------------------
  -- to avoid dynamic sql we use hard coded edr_field_type
  -- code duplication but better peformance
  --
  -- TODO another way to do this would be to calculate for all
  -- field types (B,C,D,V) in one function call/one sql statement
  -- and use a switch to grab the right value
  ----------------------------------------------------------------
  function insertLineEdrCount(the_mrec_line mrec_line,
                              the_mrec_ref  mrec_ref,
                              the_mrec_id   integer,
                              sign          integer)
  return integer is
    l_rows integer := 0;
    current_fmo_eqn        metrictypes.fmo_equation_details;
    adjuster number;
  begin
    logger('insertLineEdrCount: lineId: ' || the_mrec_line.d_mrec_line_id);

    current_fmo_eqn := the_mrec_line.fmo_eqn;
    adjuster := nvl(current_fmo_eqn.adjuster,1);

    MERGE into f_mrec f
    --USING (select TRUNC(ff.d_period_id, 'HH24') as dp,
    USING (select ff.d_period_id as dp,
                  ff.f_file_id   as f_file_id,
                  ff.f_attribute_id,
                  the_mrec_line.d_mrec_line_id as d_mrec_line_id,
                  fa.d_node_id                 as d_node_id,
                  fa.d_source_id               as d_source_id,
                  fa.d_edr_type_id             as d_edr_type_id,
                  fa.d_payment_type_id         as d_payment_type_id,
                  fa.d_call_type_id            as d_call_type_id,
                  fa.d_customer_type_id        as d_customer_type_id,
                  fa.d_service_provider_id     as d_service_provider_id,
                  fa.d_custom_01_id            as d_custom_01_id,
                  fa.d_custom_02_id            as d_custom_02_id,
                  fa.d_custom_03_id            as d_custom_03_id,
                  fa.d_custom_04_id            as d_custom_04_id,
                  fa.d_custom_05_id            as d_custom_05_id,
                  fa.d_custom_06_id            as d_custom_06_id,
                  fa.d_custom_07_id            as d_custom_07_id,
                  fa.d_custom_08_id            as d_custom_08_id,
                  fa.d_custom_09_id            as d_custom_09_id,
                  fa.d_custom_10_id            as d_custom_10_id,
                  fa.d_custom_11_id            as d_custom_11_id,
                  fa.d_custom_12_id            as d_custom_12_id,
                  fa.d_custom_13_id            as d_custom_13_id,
                  fa.d_custom_14_id            as d_custom_14_id,
                  fa.d_custom_15_id            as d_custom_15_id,
                  fa.d_custom_16_id            as d_custom_16_id,
                  fa.d_custom_17_id            as d_custom_17_id,
                  fa.d_custom_18_id            as d_custom_18_id,
                  fa.d_custom_19_id            as d_custom_19_id,
                  fa.d_custom_20_id            as d_custom_20_id,
                  ff.edr_count * adjuster      as mrecval
             from f_file ff,
                  f_attribute fa
                  left outer join um.d_edr_type_mv detmv
                               on detmv.d_edr_type_id = fa.d_edr_type_id
            where ff.f_attribute_id = fa.f_attribute_id
              and ff.d_period_id >= the_mrec_ref.d_period_start
              and ff.d_period_id < the_mrec_ref.d_period_end
              and fa.d_node_id = the_mrec_line.node_id

              and (current_fmo_eqn.source_id = -1 OR
                  fa.d_source_id = current_fmo_eqn.source_id)

              and (current_fmo_eqn.source_type_id = -1 OR EXISTS
                  (select source_id
                     from source_ref s
                    where source_type_id = current_fmo_eqn.source_type_id
                      and s.source_id = fa.d_source_id))

              and (current_fmo_eqn.i_d_measure_type_id = -1 OR
                  fa.d_measure_type_id =
                  current_fmo_eqn.i_d_measure_type_id)

              and (current_fmo_eqn.edr_type_id = -1 or detmv.edr_type_uid = current_fmo_eqn.edr_type_id)
              and (current_fmo_eqn.edr_sub_type_id = -1 or detmv.edr_sub_type_id = current_fmo_eqn.edr_sub_type_id)

              and (current_fmo_eqn.d_payment_type_id = -1 OR
                  fa.d_payment_type_id = current_fmo_eqn.d_payment_type_id)
              and (current_fmo_eqn.d_call_type_id = -1 OR
                  fa.d_call_type_id = current_fmo_eqn.d_call_type_id)
              and (current_fmo_eqn.d_customer_type_id = -1 OR
                  fa.d_customer_type_id =
                  current_fmo_eqn.d_customer_type_id)
              and (current_fmo_eqn.d_service_provider_id = -1 OR
                  fa.d_service_provider_id =
                  current_fmo_eqn.d_service_provider_id)

              and (current_fmo_eqn.d_custom_01_list is null OR fa.d_custom_01_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_01_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_02_list is null OR fa.d_custom_02_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_02_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_03_list is null OR fa.d_custom_03_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_03_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_04_list is null OR fa.d_custom_04_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_04_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_05_list is null OR fa.d_custom_05_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_05_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_06_list is null OR fa.d_custom_06_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_06_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_07_list is null OR fa.d_custom_07_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_07_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_08_list is null OR fa.d_custom_08_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_08_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_09_list is null OR fa.d_custom_09_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_09_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_10_list is null OR fa.d_custom_10_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_10_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_11_list is null OR fa.d_custom_11_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_11_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_12_list is null OR fa.d_custom_12_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_12_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_13_list is null OR fa.d_custom_13_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_13_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_14_list is null OR fa.d_custom_14_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_14_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_15_list is null OR fa.d_custom_15_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_15_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_16_list is null OR fa.d_custom_16_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_16_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_17_list is null OR fa.d_custom_17_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_17_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_18_list is null OR fa.d_custom_18_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_18_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_19_list is null OR fa.d_custom_19_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_19_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_20_list is null OR fa.d_custom_20_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_20_list as inlisttype) from dual)))
/*
              and (current_fmo_eqn.d_custom_01_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_01_list_csv || ','), (',' || fa.d_custom_01_id || ',')))
              and (current_fmo_eqn.d_custom_02_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_02_list_csv || ','), (',' || fa.d_custom_02_id || ',')))
              and (current_fmo_eqn.d_custom_03_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_03_list_csv || ','), (',' || fa.d_custom_03_id || ',')))
              and (current_fmo_eqn.d_custom_04_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_04_list_csv || ','), (',' || fa.d_custom_04_id || ',')))
              and (current_fmo_eqn.d_custom_05_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_05_list_csv || ','), (',' || fa.d_custom_05_id || ',')))
              and (current_fmo_eqn.d_custom_06_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_06_list_csv || ','), (',' || fa.d_custom_06_id || ',')))
              and (current_fmo_eqn.d_custom_07_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_07_list_csv || ','), (',' || fa.d_custom_07_id || ',')))
              and (current_fmo_eqn.d_custom_08_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_08_list_csv || ','), (',' || fa.d_custom_08_id || ',')))
              and (current_fmo_eqn.d_custom_09_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_09_list_csv || ','), (',' || fa.d_custom_09_id || ',')))
              and (current_fmo_eqn.d_custom_10_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_10_list_csv || ','), (',' || fa.d_custom_10_id || ',')))
              and (current_fmo_eqn.d_custom_11_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_11_list_csv || ','), (',' || fa.d_custom_11_id || ',')))
              and (current_fmo_eqn.d_custom_12_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_12_list_csv || ','), (',' || fa.d_custom_12_id || ',')))
              and (current_fmo_eqn.d_custom_13_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_13_list_csv || ','), (',' || fa.d_custom_13_id || ',')))
              and (current_fmo_eqn.d_custom_14_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_14_list_csv || ','), (',' || fa.d_custom_14_id || ',')))
              and (current_fmo_eqn.d_custom_15_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_15_list_csv || ','), (',' || fa.d_custom_15_id || ',')))
              and (current_fmo_eqn.d_custom_16_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_16_list_csv || ','), (',' || fa.d_custom_16_id || ',')))
              and (current_fmo_eqn.d_custom_17_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_17_list_csv || ','), (',' || fa.d_custom_17_id || ',')))
              and (current_fmo_eqn.d_custom_18_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_18_list_csv || ','), (',' || fa.d_custom_18_id || ',')))
              and (current_fmo_eqn.d_custom_19_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_19_list_csv || ','), (',' || fa.d_custom_19_id || ',')))
              and (current_fmo_eqn.d_custom_20_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_20_list_csv || ','), (',' || fa.d_custom_20_id || ',')))
*/

           ) fff
    ON (f.f_file_id = fff.f_file_id and f.d_mrec_line_id = fff.d_mrec_line_id and fff.dp = f.d_period_id)
    WHEN NOT MATCHED THEN
      insert (
         D_PERIOD_ID,
         F_MREC_ID,
         F_FILE_ID,
         F_ATTRIBUTE_ID,
         MREC_ID,
         MREC_SET,
         D_MREC_LINE_ID,
         MREC_TYPE,
         MEASURE_TYPE,
         MREC)
      values (
         fff.dp,
         SEQ_F_MREC_ID.nextval,
         fff.f_file_id,
         fff.f_attribute_id,
         the_mrec_id,
         sign,
         the_mrec_line.d_mrec_line_id,
         'T',
         current_fmo_eqn.field_type,
         fff.mrecval * sign
      );

    l_rows := SQL%ROWCOUNT;

    logger('insertLineEdrCount: DONE lineId: ' || the_mrec_line.d_mrec_line_id);
    logger('insertLineEdrCount: ROWS: ' || l_rows);

    return l_rows;
  end;


  ----------------------------------------------------------------
  -- to avoid dynamic sql we use hard coded edr_field_type
  -- code duplication but better peformance
  --
  -- TODO another way to do this would be to calculate for all
  -- field types (B,C,D,V) in one function call/one sql statement
  -- and use a switch to grab the right value
  ----------------------------------------------------------------
  function insertLineEdrDuration(the_mrec_line mrec_line,
                                 the_mrec_ref  mrec_ref,
                                 the_mrec_id   integer,
                                 sign          integer)
  return integer is
    l_rows integer := 0;
    current_fmo_eqn metrictypes.fmo_equation_details;
    adjuster number;
  begin
    logger('insertLineEdrDuration: lineId: ' || the_mrec_line.d_mrec_line_id);

    current_fmo_eqn := the_mrec_line.fmo_eqn;
    adjuster := nvl(current_fmo_eqn.adjuster,1);

    MERGE into f_mrec f
    --USING (select TRUNC(ff.d_period_id, 'HH24') as dp,
    USING (select ff.d_period_id as dp,
                  ff.f_file_id   as f_file_id,
                  ff.f_attribute_id,
                  the_mrec_line.d_mrec_line_id as d_mrec_line_id,
                  fa.d_node_id                 as d_node_id,
                  fa.d_source_id               as d_source_id,
                  fa.d_edr_type_id             as d_edr_type_id,
                  fa.d_payment_type_id         as d_payment_type_id,
                  fa.d_call_type_id            as d_call_type_id,
                  fa.d_customer_type_id        as d_customer_type_id,
                  fa.d_service_provider_id     as d_service_provider_id,
                  fa.d_measure_type_id         as d_measure_type_id,
                  fa.d_custom_01_id            as d_custom_01_id,
                  fa.d_custom_02_id            as d_custom_02_id,
                  fa.d_custom_03_id            as d_custom_03_id,
                  fa.d_custom_04_id            as d_custom_04_id,
                  fa.d_custom_05_id            as d_custom_05_id,
                  fa.d_custom_06_id            as d_custom_06_id,
                  fa.d_custom_07_id            as d_custom_07_id,
                  fa.d_custom_08_id            as d_custom_08_id,
                  fa.d_custom_09_id            as d_custom_09_id,
                  fa.d_custom_10_id            as d_custom_10_id,
                  fa.d_custom_11_id            as d_custom_11_id,
                  fa.d_custom_12_id            as d_custom_12_id,
                  fa.d_custom_13_id            as d_custom_13_id,
                  fa.d_custom_14_id            as d_custom_14_id,
                  fa.d_custom_15_id            as d_custom_15_id,
                  fa.d_custom_16_id            as d_custom_16_id,
                  fa.d_custom_17_id            as d_custom_17_id,
                  fa.d_custom_18_id            as d_custom_18_id,
                  fa.d_custom_19_id            as d_custom_19_id,
                  fa.d_custom_20_id            as d_custom_20_id,
                  ff.edr_duration * adjuster   as mrecval
             from f_file ff,
                  f_attribute fa
                  left outer join um.d_edr_type_mv detmv
                               on detmv.d_edr_type_id = fa.d_edr_type_id
            where ff.f_attribute_id = fa.f_attribute_id
              and ff.d_period_id >= the_mrec_ref.d_period_start
              and ff.d_period_id < the_mrec_ref.d_period_end
              and fa.d_node_id = the_mrec_line.node_id

              and (current_fmo_eqn.source_id = -1 OR
                  fa.d_source_id = current_fmo_eqn.source_id)

              and (current_fmo_eqn.source_type_id = -1 OR EXISTS
                  (select source_id
                     from source_ref s
                    where source_type_id = current_fmo_eqn.source_type_id
                      and s.source_id = fa.d_source_id))

              and (current_fmo_eqn.i_d_measure_type_id = -1 OR
                  fa.d_measure_type_id =
                  current_fmo_eqn.i_d_measure_type_id)

              and (current_fmo_eqn.edr_type_id = -1 or detmv.edr_type_uid = current_fmo_eqn.edr_type_id)
              and (current_fmo_eqn.edr_sub_type_id = -1 or detmv.edr_sub_type_id = current_fmo_eqn.edr_sub_type_id)

              and (current_fmo_eqn.d_payment_type_id = -1 OR
                  fa.d_payment_type_id = current_fmo_eqn.d_payment_type_id)
              and (current_fmo_eqn.d_call_type_id = -1 OR
                  fa.d_call_type_id = current_fmo_eqn.d_call_type_id)
              and (current_fmo_eqn.d_customer_type_id = -1 OR
                  fa.d_customer_type_id =
                  current_fmo_eqn.d_customer_type_id)
              and (current_fmo_eqn.d_service_provider_id = -1 OR
                  fa.d_service_provider_id =
                  current_fmo_eqn.d_service_provider_id)

              and (current_fmo_eqn.d_custom_01_list is null OR fa.d_custom_01_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_01_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_02_list is null OR fa.d_custom_02_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_02_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_03_list is null OR fa.d_custom_03_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_03_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_04_list is null OR fa.d_custom_04_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_04_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_05_list is null OR fa.d_custom_05_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_05_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_06_list is null OR fa.d_custom_06_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_06_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_07_list is null OR fa.d_custom_07_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_07_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_08_list is null OR fa.d_custom_08_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_08_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_09_list is null OR fa.d_custom_09_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_09_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_10_list is null OR fa.d_custom_10_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_10_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_11_list is null OR fa.d_custom_11_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_11_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_12_list is null OR fa.d_custom_12_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_12_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_13_list is null OR fa.d_custom_13_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_13_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_14_list is null OR fa.d_custom_14_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_14_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_15_list is null OR fa.d_custom_15_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_15_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_16_list is null OR fa.d_custom_16_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_16_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_17_list is null OR fa.d_custom_17_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_17_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_18_list is null OR fa.d_custom_18_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_18_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_19_list is null OR fa.d_custom_19_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_19_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_20_list is null OR fa.d_custom_20_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_20_list as inlisttype) from dual)))
/*
              and (current_fmo_eqn.d_custom_01_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_01_list_csv || ','), (',' || fa.d_custom_01_id || ',')))
              and (current_fmo_eqn.d_custom_02_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_02_list_csv || ','), (',' || fa.d_custom_02_id || ',')))
              and (current_fmo_eqn.d_custom_03_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_03_list_csv || ','), (',' || fa.d_custom_03_id || ',')))
              and (current_fmo_eqn.d_custom_04_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_04_list_csv || ','), (',' || fa.d_custom_04_id || ',')))
              and (current_fmo_eqn.d_custom_05_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_05_list_csv || ','), (',' || fa.d_custom_05_id || ',')))
              and (current_fmo_eqn.d_custom_06_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_06_list_csv || ','), (',' || fa.d_custom_06_id || ',')))
              and (current_fmo_eqn.d_custom_07_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_07_list_csv || ','), (',' || fa.d_custom_07_id || ',')))
              and (current_fmo_eqn.d_custom_08_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_08_list_csv || ','), (',' || fa.d_custom_08_id || ',')))
              and (current_fmo_eqn.d_custom_09_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_09_list_csv || ','), (',' || fa.d_custom_09_id || ',')))
              and (current_fmo_eqn.d_custom_10_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_10_list_csv || ','), (',' || fa.d_custom_10_id || ',')))
              and (current_fmo_eqn.d_custom_11_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_11_list_csv || ','), (',' || fa.d_custom_11_id || ',')))
              and (current_fmo_eqn.d_custom_12_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_12_list_csv || ','), (',' || fa.d_custom_12_id || ',')))
              and (current_fmo_eqn.d_custom_13_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_13_list_csv || ','), (',' || fa.d_custom_13_id || ',')))
              and (current_fmo_eqn.d_custom_14_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_14_list_csv || ','), (',' || fa.d_custom_14_id || ',')))
              and (current_fmo_eqn.d_custom_15_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_15_list_csv || ','), (',' || fa.d_custom_15_id || ',')))
              and (current_fmo_eqn.d_custom_16_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_16_list_csv || ','), (',' || fa.d_custom_16_id || ',')))
              and (current_fmo_eqn.d_custom_17_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_17_list_csv || ','), (',' || fa.d_custom_17_id || ',')))
              and (current_fmo_eqn.d_custom_18_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_18_list_csv || ','), (',' || fa.d_custom_18_id || ',')))
              and (current_fmo_eqn.d_custom_19_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_19_list_csv || ','), (',' || fa.d_custom_19_id || ',')))
              and (current_fmo_eqn.d_custom_20_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_20_list_csv || ','), (',' || fa.d_custom_20_id || ',')))
*/

           ) fff
    ON (f.f_file_id = fff.f_file_id and f.d_mrec_line_id = fff.d_mrec_line_id and fff.dp = f.d_period_id)
    WHEN NOT MATCHED THEN
      insert (
         D_PERIOD_ID,
         F_MREC_ID,
         F_FILE_ID,
         F_ATTRIBUTE_ID,
         MREC_ID,
         MREC_SET,
         D_MREC_LINE_ID,
         MREC_TYPE,
         MEASURE_TYPE,
         MREC
      )
      values (
         fff.dp,
         SEQ_F_MREC_ID.nextval,
         fff.f_file_id,
         fff.f_attribute_id,
         the_mrec_id,
         sign,
         the_mrec_line.d_mrec_line_id,
         'T',
         current_fmo_eqn.field_type,
         fff.mrecval * sign
      );
    l_rows := SQL%ROWCOUNT;

    return l_rows;
  end;

  ----------------------------------------------------------------
  -- to avoid dynamic sql we use hard coded edr_field_type
  -- code duplication but better peformance
  --
  -- TODO another way to do this would be to calculate for all
  -- field types (B,C,D,V) in one function call/one sql statement
  -- and use a switch to grab the right value
  ----------------------------------------------------------------
  function insertLineEdrValue(the_mrec_line mrec_line,
                              the_mrec_ref  mrec_ref,
                              the_mrec_id   integer,
                              sign          integer)

  return integer is
    l_rows integer := 0;
    current_fmo_eqn metrictypes.fmo_equation_details;
    adjuster number;
  begin
    logger('insertLineEdrValue: lineId: ' || the_mrec_line.d_mrec_line_id);

    current_fmo_eqn := the_mrec_line.fmo_eqn;
    adjuster := nvl(current_fmo_eqn.adjuster,1);

    MERGE into f_mrec f
    --USING (select TRUNC(ff.d_period_id, 'HH24') as dp,
    USING (select ff.d_period_id as dp,
                  ff.f_file_id   as f_file_id,
                  ff.f_attribute_id,
                  the_mrec_line.d_mrec_line_id as d_mrec_line_id,
                  fa.d_node_id                 as d_node_id,
                  fa.d_source_id               as d_source_id,
                  fa.d_edr_type_id             as d_edr_type_id,
                  fa.d_payment_type_id         as d_payment_type_id,
                  fa.d_call_type_id            as d_call_type_id,
                  fa.d_customer_type_id        as d_customer_type_id,
                  fa.d_service_provider_id     as d_service_provider_id,
                  fa.d_measure_type_id         as d_measure_type_id,
                  fa.d_custom_01_id            as d_custom_01_id,
                  fa.d_custom_02_id            as d_custom_02_id,
                  fa.d_custom_03_id            as d_custom_03_id,
                  fa.d_custom_04_id            as d_custom_04_id,
                  fa.d_custom_05_id            as d_custom_05_id,
                  fa.d_custom_06_id            as d_custom_06_id,
                  fa.d_custom_07_id            as d_custom_07_id,
                  fa.d_custom_08_id            as d_custom_08_id,
                  fa.d_custom_09_id            as d_custom_09_id,
                  fa.d_custom_10_id            as d_custom_10_id,
                  fa.d_custom_11_id            as d_custom_11_id,
                  fa.d_custom_12_id            as d_custom_12_id,
                  fa.d_custom_13_id            as d_custom_13_id,
                  fa.d_custom_14_id            as d_custom_14_id,
                  fa.d_custom_15_id            as d_custom_15_id,
                  fa.d_custom_16_id            as d_custom_16_id,
                  fa.d_custom_17_id            as d_custom_17_id,
                  fa.d_custom_18_id            as d_custom_18_id,
                  fa.d_custom_19_id            as d_custom_19_id,
                  fa.d_custom_20_id            as d_custom_20_id,
                  ff.edr_value * adjuster      as mrecval
             from f_file ff,
                  f_attribute fa
                  left outer join um.d_edr_type_mv detmv
                               on detmv.d_edr_type_id = fa.d_edr_type_id
            where ff.f_attribute_id = fa.f_attribute_id
              and ff.d_period_id >= the_mrec_ref.d_period_start
              and ff.d_period_id < the_mrec_ref.d_period_end
              and fa.d_node_id = the_mrec_line.node_id

              and (current_fmo_eqn.source_id = -1 OR
                  fa.d_source_id = current_fmo_eqn.source_id)

              and (current_fmo_eqn.source_type_id = -1 OR EXISTS
                  (select source_id
                     from source_ref s
                    where source_type_id = current_fmo_eqn.source_type_id
                      and s.source_id = fa.d_source_id))

              and (current_fmo_eqn.i_d_measure_type_id = -1 OR
                  fa.d_measure_type_id =
                  current_fmo_eqn.i_d_measure_type_id)

              and (current_fmo_eqn.edr_type_id = -1 or detmv.edr_type_uid = current_fmo_eqn.edr_type_id)
              and (current_fmo_eqn.edr_sub_type_id = -1 or detmv.edr_sub_type_id = current_fmo_eqn.edr_sub_type_id)

              and (current_fmo_eqn.d_payment_type_id = -1 OR
                  fa.d_payment_type_id = current_fmo_eqn.d_payment_type_id)
              and (current_fmo_eqn.d_call_type_id = -1 OR
                  fa.d_call_type_id = current_fmo_eqn.d_call_type_id)
              and (current_fmo_eqn.d_customer_type_id = -1 OR
                  fa.d_customer_type_id =
                  current_fmo_eqn.d_customer_type_id)
              and (current_fmo_eqn.d_service_provider_id = -1 OR
                  fa.d_service_provider_id =
                  current_fmo_eqn.d_service_provider_id)

              and (current_fmo_eqn.d_custom_01_list is null OR fa.d_custom_01_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_01_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_02_list is null OR fa.d_custom_02_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_02_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_03_list is null OR fa.d_custom_03_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_03_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_04_list is null OR fa.d_custom_04_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_04_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_05_list is null OR fa.d_custom_05_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_05_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_06_list is null OR fa.d_custom_06_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_06_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_07_list is null OR fa.d_custom_07_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_07_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_08_list is null OR fa.d_custom_08_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_08_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_09_list is null OR fa.d_custom_09_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_09_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_10_list is null OR fa.d_custom_10_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_10_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_11_list is null OR fa.d_custom_11_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_11_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_12_list is null OR fa.d_custom_12_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_12_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_13_list is null OR fa.d_custom_13_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_13_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_14_list is null OR fa.d_custom_14_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_14_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_15_list is null OR fa.d_custom_15_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_15_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_16_list is null OR fa.d_custom_16_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_16_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_17_list is null OR fa.d_custom_17_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_17_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_18_list is null OR fa.d_custom_18_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_18_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_19_list is null OR fa.d_custom_19_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_19_list as inlisttype) from dual)))
              and (current_fmo_eqn.d_custom_20_list is null OR fa.d_custom_20_id IN (select * from THE (select cast(current_fmo_eqn.d_custom_20_list as inlisttype) from dual)))
/*
              and (current_fmo_eqn.d_custom_01_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_01_list_csv || ','), (',' || fa.d_custom_01_id || ',')))
              and (current_fmo_eqn.d_custom_02_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_02_list_csv || ','), (',' || fa.d_custom_02_id || ',')))
              and (current_fmo_eqn.d_custom_03_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_03_list_csv || ','), (',' || fa.d_custom_03_id || ',')))
              and (current_fmo_eqn.d_custom_04_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_04_list_csv || ','), (',' || fa.d_custom_04_id || ',')))
              and (current_fmo_eqn.d_custom_05_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_05_list_csv || ','), (',' || fa.d_custom_05_id || ',')))
              and (current_fmo_eqn.d_custom_06_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_06_list_csv || ','), (',' || fa.d_custom_06_id || ',')))
              and (current_fmo_eqn.d_custom_07_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_07_list_csv || ','), (',' || fa.d_custom_07_id || ',')))
              and (current_fmo_eqn.d_custom_08_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_08_list_csv || ','), (',' || fa.d_custom_08_id || ',')))
              and (current_fmo_eqn.d_custom_09_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_09_list_csv || ','), (',' || fa.d_custom_09_id || ',')))
              and (current_fmo_eqn.d_custom_10_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_10_list_csv || ','), (',' || fa.d_custom_10_id || ',')))
              and (current_fmo_eqn.d_custom_11_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_11_list_csv || ','), (',' || fa.d_custom_11_id || ',')))
              and (current_fmo_eqn.d_custom_12_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_12_list_csv || ','), (',' || fa.d_custom_12_id || ',')))
              and (current_fmo_eqn.d_custom_13_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_13_list_csv || ','), (',' || fa.d_custom_13_id || ',')))
              and (current_fmo_eqn.d_custom_14_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_14_list_csv || ','), (',' || fa.d_custom_14_id || ',')))
              and (current_fmo_eqn.d_custom_15_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_15_list_csv || ','), (',' || fa.d_custom_15_id || ',')))
              and (current_fmo_eqn.d_custom_16_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_16_list_csv || ','), (',' || fa.d_custom_16_id || ',')))
              and (current_fmo_eqn.d_custom_17_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_17_list_csv || ','), (',' || fa.d_custom_17_id || ',')))
              and (current_fmo_eqn.d_custom_18_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_18_list_csv || ','), (',' || fa.d_custom_18_id || ',')))
              and (current_fmo_eqn.d_custom_19_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_19_list_csv || ','), (',' || fa.d_custom_19_id || ',')))
              and (current_fmo_eqn.d_custom_20_list_csv is null or regexp_like((',' || current_fmo_eqn.d_custom_20_list_csv || ','), (',' || fa.d_custom_20_id || ',')))
*/

           ) fff
    ON (f.f_file_id = fff.f_file_id and f.d_mrec_line_id = fff.d_mrec_line_id and fff.dp = f.d_period_id)
    WHEN NOT MATCHED THEN
      insert (
         D_PERIOD_ID,
         F_MREC_ID,
         F_FILE_ID,
         F_ATTRIBUTE_ID,
         MREC_ID,
         MREC_SET,
         D_MREC_LINE_ID,
         MREC_TYPE,
         MEASURE_TYPE,
         MREC
      )
      values (
         fff.dp,
         SEQ_F_MREC_ID.nextval,
         fff.f_file_id,
         fff.f_attribute_id,
         the_mrec_id,
         sign,
         the_mrec_line.d_mrec_line_id,
         'T',
         current_fmo_eqn.field_type,
         fff.mrecval * sign
      );
    l_rows := SQL%ROWCOUNT;

    return l_rows;
  end;


  ----------------------------------------------------------------------------------
  -- Merge the lhs and rhs value/d_period lists
  -- into 3 lists
  --     one holds (all) d_period_id's
  --     one holds the sum of lhs and rhs for each dp
  --     one holds the percentage difference of lhs and rhs (used in threshold tests)
  -- AND
  --     one holds the sum of lhs for each dp (this is the merged list so may be padded with nulls)
  --     one holds the sum of rhs for each dp (this is the merged list so may be padded with nulls)
  -----------------------------------------------------------------------------------
  procedure mergeSides(the_d_period_list_lhs          d_period_list,
                       the_d_period_list_rhs          d_period_list,
                       the_d_period_list              IN OUT NOCOPY d_period_list,
                       the_value_by_d_period_list_lhs number_list,
                       the_value_by_d_period_list_rhs number_list,
                       the_value_by_d_period_list     IN OUT NOCOPY number_list,
                       the_diff_by_d_period_list      IN OUT NOCOPY number_list,
                       the_lhs_by_d_period_list       IN OUT NOCOPY number_list,
                       the_rhs_by_d_period_list       IN OUT NOCOPY number_list) is
    lhs_counter   pls_integer;
    rhs_counter   pls_integer;
    merge_counter pls_integer;

  begin

    if global_debug = 1 then
      if the_d_period_list_lhs.count > 0 then
        for i in the_d_period_list_lhs.first .. the_d_period_list_lhs.last loop
          logger('mergeSides: LHS dp: ' || i || ' : ' ||
                 to_char(the_d_period_list_lhs(i), 'DD:MM:YYYY HH24:MI:SS'));
          logger('mergeSides: LHS val: ' ||
                 the_value_by_d_period_list_lhs(i));
        end loop;
      end if;
      if the_d_period_list_rhs.count > 0 then
        for i in the_d_period_list_rhs.first .. the_d_period_list_rhs.last loop
          logger('mergeSides: RHS dp: ' || i || ' : ' ||
                 to_char(the_d_period_list_rhs(i), 'DD:MM:YYYY HH24:MI:SS'));
          logger('mergeSides: RHS val: ' ||
                 the_value_by_d_period_list_rhs(i));
        end loop;
      end if;
    end if;

    if the_d_period_list_lhs.count > 0 or the_d_period_list_rhs.count > 0 then
      logger('mergeSides: start');
      -- start
      lhs_counter   := 1;
      rhs_counter   := 1;
      merge_counter := 1;

      while (true) loop
        if rhs_counter > the_d_period_list_rhs.count then
          -- add the rest of lhs and quit
          if lhs_counter <= the_d_period_list_lhs.count then
            for i in lhs_counter .. the_d_period_list_lhs.count loop
              the_d_period_list.extend();
              the_d_period_list(merge_counter) := the_d_period_list_lhs(i);

              the_value_by_d_period_list.extend();
              the_value_by_d_period_list(merge_counter) := the_value_by_d_period_list_lhs(i);
              the_diff_by_d_period_list.extend();
              the_diff_by_d_period_list(merge_counter) := INFINITY_CONST; -- TODO infinite!!

              -- LHS
              the_lhs_by_d_period_list.extend();
              the_lhs_by_d_period_list(merge_counter) := the_value_by_d_period_list_lhs(i);

              -- RHS
              the_rhs_by_d_period_list.extend();
              the_rhs_by_d_period_list(merge_counter) := null; -- TODO is this okay?

              merge_counter := merge_counter + 1;
            end loop;
          end if;
          exit; -- exit while loop
        end if;

        if lhs_counter > the_d_period_list_lhs.count then
          -- add the rest of rhs and quit
          if rhs_counter <= the_d_period_list_rhs.count then
            for i in rhs_counter .. the_d_period_list_rhs.count loop
              the_d_period_list.extend();
              the_d_period_list(merge_counter) := the_d_period_list_rhs(i);

              the_value_by_d_period_list.extend();
              the_value_by_d_period_list(merge_counter) := the_value_by_d_period_list_rhs(i);
              the_diff_by_d_period_list.extend();
              the_diff_by_d_period_list(merge_counter) := INFINITY_CONST; -- TODO infinite?? zero??

              -- LHS
              the_lhs_by_d_period_list.extend();
              the_lhs_by_d_period_list(merge_counter) := null; -- TODO is this okay?

              -- RHS
              the_rhs_by_d_period_list.extend();
              the_rhs_by_d_period_list(merge_counter) := the_value_by_d_period_list_rhs(i);

              merge_counter := merge_counter + 1;
            end loop;
          end if;
          exit; -- exit while loop
        end if;

        if the_d_period_list_lhs(lhs_counter) >
           the_d_period_list_rhs(rhs_counter) then
          -- add the rhs dp
          the_d_period_list.extend();
          the_d_period_list(merge_counter) := the_d_period_list_rhs(rhs_counter);

          the_value_by_d_period_list.extend();
          the_value_by_d_period_list(merge_counter) := the_value_by_d_period_list_rhs(rhs_counter);
          the_diff_by_d_period_list.extend();
          the_diff_by_d_period_list(merge_counter) := INFINITY_CONST; -- TODO infinite!!

          -- LHS
          the_lhs_by_d_period_list.extend();
          the_lhs_by_d_period_list(merge_counter) := null; -- TODO is this okay?

          -- RHS
          the_rhs_by_d_period_list.extend();
          the_rhs_by_d_period_list(merge_counter) := the_value_by_d_period_list_rhs(rhs_counter);

          rhs_counter := rhs_counter + 1;
        elsif the_d_period_list_rhs(rhs_counter) >
              the_d_period_list_lhs(lhs_counter) then
          -- add the lhs dp
          the_d_period_list.extend();
          the_d_period_list(merge_counter) := the_d_period_list_lhs(lhs_counter);

          the_value_by_d_period_list.extend();
          the_value_by_d_period_list(merge_counter) := the_value_by_d_period_list_lhs(lhs_counter);
          the_diff_by_d_period_list.extend();
          the_diff_by_d_period_list(merge_counter) := INFINITY_CONST; -- TODO infinite!!

          -- LHS
          the_lhs_by_d_period_list.extend();
          the_lhs_by_d_period_list(merge_counter) := the_value_by_d_period_list_lhs(lhs_counter);

          -- RHS
          the_rhs_by_d_period_list.extend();
          the_rhs_by_d_period_list(merge_counter) := null; -- TODO is this okay?

          lhs_counter := lhs_counter + 1;
        else
          -- add the lhs dp , bump both
          the_d_period_list.extend();
          the_d_period_list(merge_counter) := the_d_period_list_lhs(lhs_counter);

          the_value_by_d_period_list.extend();
          the_value_by_d_period_list(merge_counter) := the_value_by_d_period_list_lhs(lhs_counter) +
                                                       the_value_by_d_period_list_rhs(rhs_counter);
          the_diff_by_d_period_list.extend();
          if the_value_by_d_period_list_lhs(lhs_counter) = 0 then
            if the_value_by_d_period_list_rhs(rhs_counter) = 0 then
              the_diff_by_d_period_list(merge_counter) := 0; -- if both LHS and RHS are 0, diff is 0
            else
              the_diff_by_d_period_list(merge_counter) := INFINITY_CONST; -- TODO infinite!!
            end if;
          else
            -- NOTE rounding to 4 decimal places here
            -- but display in issue note will be be multipled by 100
            -- ie finally displayed to 2 decimal places
            the_diff_by_d_period_list(merge_counter) := round((the_value_by_d_period_list_lhs(lhs_counter) +
                                                              the_value_by_d_period_list_rhs(rhs_counter)) /
                                                              abs(the_value_by_d_period_list_lhs(lhs_counter)),
                                                              4);
          end if;

          -- LHS
          the_lhs_by_d_period_list.extend();
          the_lhs_by_d_period_list(merge_counter) := the_value_by_d_period_list_lhs(lhs_counter);

          -- RHS
          the_rhs_by_d_period_list.extend();
          the_rhs_by_d_period_list(merge_counter) := the_value_by_d_period_list_rhs(rhs_counter);

          lhs_counter := lhs_counter + 1;
          rhs_counter := rhs_counter + 1;
        end if;

        merge_counter := merge_counter + 1;

      end loop;

    end if;

    if global_debug = 1 then
      if the_d_period_list.count > 0 then
        for i in the_d_period_list.first .. the_d_period_list.last loop
          logger('mergeSides: dp: ' || i || ' : ' ||
                 to_char(the_d_period_list(i), 'DD:MM:YYYY HH24:MI:SS'));
          logger('mergeSides: sum: ' || the_value_by_d_period_list(i));
          logger('mergeSides: diff: ' || the_diff_by_d_period_list(i));
        end loop;
      end if;
      logger('mergeSides: done');
    end if;

  end;

  /******************************************************************
  * Close previously opened issues and
  * delete entries from mrec_issue_jn
  *******************************************************************/
  procedure closeOpenIssues(the_mrec_ref mrec_ref)

   is

    the_issue_id_list       number_list := number_list();
    the_date_raised_id_list date_list := date_list();
    issueExists             boolean;

  begin
    logger('closeOpenIssues: ');

    select mij.issue_id, mij.date_raised bulk collect
      into the_issue_id_list, the_date_raised_id_list
      from mrec_issue_jn mij
     where mij.d_period_id >= the_mrec_ref.d_period_start
       and mij.d_period_id < the_mrec_ref.d_period_end
       and mij.issue_status = 'O'
       and mij.mrec_definition_id = the_mrec_ref.mrec_definition_id;

    if the_issue_id_list.count > 0 then
      for i in the_issue_id_list.first .. the_issue_id_list.last loop
        issueExists := IMM.Issues.closeIssue(the_issue_id_list(i),
                                             forceCloseStateId,
                                             forceCloseResolutionId,
                                             adminUserId,
                                             the_date_raised_id_list(i)
                                             );
        if issueExists then
          -- add a note
          IMM.Issues.addNote(the_issue_id_list(i),
                             adminUserId,
                             mrecNoteTypeId,
                             '<b>Issue auto-closed as a result of a metric reconciliation run.</b>',
                             null, null);
        end if;
      end loop;

      forall i in the_issue_id_list.first .. the_issue_id_list.last
        delete from mrec_issue_jn mij
         where mij.d_period_id >= the_mrec_ref.d_period_start
           and mij.d_period_id < the_mrec_ref.d_period_end
           and mij.issue_id = the_issue_id_list(i)
           and mij.date_raised = the_date_raised_id_list(i);
    end if;
  end;

  /******************************************************************
  * START
  * Initialisation:
  *
  * COPIED from METRICS package
  *
  * TODO remove global variables to allow code sharing between the
  * packages
  *
  * This section contains initialisation code called at the start of
  * and metricrec process
  *******************************************************************/
  procedure loadStaticData(the_mrec_ref mrec_ref) is
    the_thresh_def_id      number;
    the_thresh_seq_id      number;
    the_threshold_def_data threshold_def_data;
  begin
    logger('loadStaticData: ');

    global_thresh_seq_data.delete;

    the_thresh_def_id := the_mrec_ref.threshold_definition_id;
    the_thresh_seq_id := the_mrec_ref.threshold_sequence_id;

    if the_thresh_def_id is not null then
      the_threshold_def_data := getThresholdsForThreshDef(the_thresh_def_id);
      -- add this threshold_def_data to threshold_def_data assoc. array
      -- indexed against active_threshold_version_id
      global_thresh_seq_data(0) := the_threshold_def_data;
      --global_thresh_seq_data(the_threshold_def_data.active_tv_id) := the_threshold_def_data;
    elsif the_thresh_seq_id is not null then
      global_thresh_seq_data := getThresholdsForThreshSeq(the_thresh_seq_id);
    end if;

    logger('loadStaticData: done');
  end;

  --------------------
  -- Load source data into memory
  -- organised as lists of source_ids keyed by source_type_id
  --------------------
  function initialiseMrec(a_mrec_def_id    number,
                          a_d_period_start date,
                          a_d_period_end   date)
  return mrec_ref is
    the_mrec_line mrec_line;

    the_mrec_ref mrec_ref;
    the_mrec_lhs mrec_line_array;
    the_mrec_rhs mrec_line_array;
    counter      pls_integer;

    mrec_lhs_line_id_str varchar(1000);
    mrec_rhs_line_id_str varchar(1000);

    cursor mrec_lines(v_mrec_version_id integer, v_line_type integer) is
      select ml.metric_definition_id, ml.node_id, ml.d_mrec_line_id
        from d_mrec_line_mv ml
       where ml.mrec_version_id = v_mrec_version_id
         and ml.line_type = v_line_type;

  begin
    -- Initialisation
    logger('initialiseMrec - START');

    -- load source_ref into memory
    -- do this as workaround to mysterious MERGE INTO
    -- bug that prevents using SOURCE_REF table within the query
    loadSourceRef;

    -- load mrec_ref details

    -- mrec_ref fields
    -- load details of the active metric rec for this metric_def_id
    begin
      select mvr.mrec_version_id,
             a_mrec_def_id,
             mvr.threshold_definition_id,
             mvr.threshold_sequence_id,
             mvr.description,
             mdr.name,
             mcr.mrec_category_id,
             mcr.category,
             gr.graph_id,
             gr.name
        into the_mrec_ref.mrec_version_id,
             the_mrec_ref.mrec_definition_id,
             the_mrec_ref.threshold_definition_id,
             the_mrec_ref.threshold_sequence_id,
             the_mrec_ref.description,
             the_mrec_ref.def_name,
             the_mrec_ref.mrec_category_id,
             the_mrec_ref.mrec_category_name,
             the_mrec_ref.graph_id,
             the_mrec_ref.graph_name
        from mrec_version_ref    mvr,
             mrec_definition_ref mdr,
             mrec_category_ref   mcr,
             dgf.graph_ref       gr
       where mvr.mrec_definition_id = a_mrec_def_id
         and mvr.mrec_definition_id = mdr.mrec_definition_id
         and mcr.mrec_category_id = mdr.mrec_category_id
         and gr.graph_id = mdr.graph_id
         and mvr.valid_from <= sysdate
         and mvr.valid_to >= sysdate
         and mvr.status = 'A'
         and mvr.valid_from = (select max(valid_from)
                                 from mrec_version_ref
                                where mrec_definition_id = a_mrec_def_id
                                  and valid_from <= sysdate
                                  and valid_to >= sysdate
                                  and status = 'A');
    exception
      when no_data_found then
        loggerForce('No Active Version for mrec_def_id: ' || a_mrec_def_id);

        -- re-throw any exception
        raise;
    end;

    -- load mrec data

    -- LHS
    counter              := 0;
    mrec_lhs_line_id_str := '';
    -- for each metric_definition (ie line)
    for a_mrec_line in mrec_lines(the_mrec_ref.mrec_version_id, -1) loop
      the_mrec_line.metric_definition_id := a_mrec_line.metric_definition_id;
      the_mrec_line.node_id              := a_mrec_line.node_id;
      the_mrec_line.d_mrec_line_id       := a_mrec_line.d_mrec_line_id;
      the_mrec_line.fmo_eqn              := getGlobalMetricFunction(a_mrec_line.metric_definition_id);

      -- add to array of LHS lines
      the_mrec_lhs(counter) := the_mrec_line;
      if (counter > 0) then
        mrec_lhs_line_id_str := mrec_lhs_line_id_str || ',';
      end if;
      mrec_lhs_line_id_str := mrec_lhs_line_id_str || the_mrec_line.d_mrec_line_id;
      counter := counter + 1;
    end loop;

    -- a comma seperated list of line_ids (d_mrec_line_ids) in in_list format
    -- (ie can be used as part of an IN expression
    the_mrec_ref.mrec_lhs_line_id_inlist := Metrics.in_list(mrec_lhs_line_id_str);

    -- RHS
    counter              := 0;
    mrec_rhs_line_id_str := '';
    -- for each metric_definition (ie line)
    for a_mrec_line in mrec_lines(the_mrec_ref.mrec_version_id, 1) loop
      the_mrec_line.metric_definition_id := a_mrec_line.metric_definition_id;
      the_mrec_line.node_id              := a_mrec_line.node_id;
      the_mrec_line.d_mrec_line_id       := a_mrec_line.d_mrec_line_id;
      the_mrec_line.fmo_eqn              := getGlobalMetricFunction(a_mrec_line.metric_definition_id);

      -- add to array of RHS lines
      the_mrec_rhs(counter) := the_mrec_line;
      if (counter > 0) then
        mrec_rhs_line_id_str := mrec_rhs_line_id_str || ',';
      end if;
      mrec_rhs_line_id_str := mrec_rhs_line_id_str || the_mrec_line.d_mrec_line_id;
      counter := counter + 1;
    end loop;

    -- a comma seperated list of line_ids (d_mrec_line_ids) in in_list format
    -- (ie can be used as part of an IN expression
    the_mrec_ref.mrec_rhs_line_id_inlist := Metrics.in_list(mrec_rhs_line_id_str);

    -- REC - only one row returned so loop not really needed
    for a_mrec_line in mrec_lines(the_mrec_ref.mrec_version_id, 0) loop
      the_mrec_line.metric_definition_id := null;
      the_mrec_line.node_id              := null;
      the_mrec_line.d_mrec_line_id       := a_mrec_line.d_mrec_line_id;
    end loop;
    the_mrec_ref.mrec_rec := the_mrec_line;

    -- MREC_REF
    the_mrec_ref.mrec_lhs       := the_mrec_lhs;
    the_mrec_ref.mrec_rhs       := the_mrec_rhs;
    the_mrec_ref.d_period_start := a_d_period_start;
    the_mrec_ref.d_period_end   := a_d_period_end;

    return the_mrec_ref;

  end;

  --------------------
  -- Load source data into memory
  -- organised as lists of source_ids keyed by source_type_id
  --------------------
  procedure loadSourceRef is
    the_source_data source_data;

    a_source_by_type_array_tbl  inLIstType;
    a_src_by_type_arr_tbl_array source_by_type_array_tbl_array;
    counter                     pls_integer;

    cursor source_data_cur is
      select src.source_id, src.name, src.source_type_id
        from source_ref src;
  begin
    logger('loadSourceRef');

    open source_data_cur;
    while true loop
      fetch source_data_cur
        into the_source_data;
      if source_data_cur%NOTFOUND then
        close source_data_cur;
        exit;
      else
        global_source_data_array(the_source_data.source_id) := the_source_data;

        if not
            a_src_by_type_arr_tbl_array.EXISTS(the_source_data.source_type_id) then

          a_source_by_type_array_tbl := inlisttype();
          a_source_by_type_array_tbl.extend;
          a_source_by_type_array_tbl(a_source_by_type_array_tbl.count) := the_source_data.source_id;
          a_src_by_type_arr_tbl_array(the_source_data.source_type_id) := a_source_by_type_array_tbl;
        else

          a_source_by_type_array_tbl := a_src_by_type_arr_tbl_array(the_source_data.source_type_id);
          a_src_by_type_arr_tbl_array(the_source_data.source_type_id) .extend;
          a_src_by_type_arr_tbl_array(the_source_data.source_type_id)(a_src_by_type_arr_tbl_array(the_source_data.source_type_id).count) := the_source_data.source_id;

        end if;

      end if;
    end loop;

    logger('loadSourceRef: num sources: ' ||
           global_source_data_array.count);
    logger('loadSourceRef: num source types: ' ||
           a_src_by_type_arr_tbl_array.count);

    counter := a_src_by_type_arr_tbl_array.first;
    while (counter is not null) loop
      --logger('loadSourceRef: add inList for SRC TYPE ID: '|| counter);
      global_source_by_type_array(counter) := a_src_by_type_arr_tbl_array(counter);

      counter := a_src_by_type_arr_tbl_array.next(counter);
    end loop;

  end;

  ------------------------------------------------
  -- Read FMO_EQUATION
  ------------------------------------------------
  function getGlobalMetricFunction(a_metric_definition_id number)
    return metrictypes.fmo_equation_details is
    a_fmo_equation metrictypes.fmo_equation_details;
  begin

    --read from fmo_equation
    select mor.metric_operator_id,
           field_type,
           operator,
           adjuster,
           NVL(source_id, -1),
           NVL(source_type_id, -1),
           NVL(edr_type_id, -1),
           NVL(edr_sub_type_id, -1),
           NVL(i_d_measure_type_id, -1),
           NVL(j_d_measure_type_id, -1),

           NVL(d_payment_type_id, -1),
           NVL(d_call_type_id, -1),
           NVL(d_customer_type_id, -1),
           NVL(d_service_provider_id, -1),

           -- use inlist types
           NVL2(d_custom_01_list, Metrics.in_list(d_custom_01_list), null),
           NVL2(d_custom_02_list, Metrics.in_list(d_custom_02_list), null),
           NVL2(d_custom_03_list, Metrics.in_list(d_custom_03_list), null),
           NVL2(d_custom_04_list, Metrics.in_list(d_custom_04_list), null),
           NVL2(d_custom_05_list, Metrics.in_list(d_custom_05_list), null),
           NVL2(d_custom_06_list, Metrics.in_list(d_custom_06_list), null),
           NVL2(d_custom_07_list, Metrics.in_list(d_custom_07_list), null),
           NVL2(d_custom_08_list, Metrics.in_list(d_custom_08_list), null),
           NVL2(d_custom_09_list, Metrics.in_list(d_custom_09_list), null),
           NVL2(d_custom_10_list, Metrics.in_list(d_custom_10_list), null),
           NVL2(d_custom_11_list, Metrics.in_list(d_custom_11_list), null),
           NVL2(d_custom_12_list, Metrics.in_list(d_custom_12_list), null),
           NVL2(d_custom_13_list, Metrics.in_list(d_custom_13_list), null),
           NVL2(d_custom_14_list, Metrics.in_list(d_custom_14_list), null),
           NVL2(d_custom_15_list, Metrics.in_list(d_custom_15_list), null),
           NVL2(d_custom_16_list, Metrics.in_list(d_custom_16_list), null),
           NVL2(d_custom_17_list, Metrics.in_list(d_custom_17_list), null),
           NVL2(d_custom_18_list, Metrics.in_list(d_custom_18_list), null),
           NVL2(d_custom_19_list, Metrics.in_list(d_custom_19_list), null),
           NVL2(d_custom_20_list, Metrics.in_list(d_custom_20_list), null),

           -- use csv strings directly - TODO remove ????
           d_custom_01_list,
           d_custom_02_list,
           d_custom_03_list,
           d_custom_04_list,
           d_custom_05_list,
           d_custom_06_list,
           d_custom_07_list,
           d_custom_08_list,
           d_custom_09_list,
           d_custom_10_list,
           d_custom_11_list,
           d_custom_12_list,
           d_custom_13_list,
           d_custom_14_list,
           d_custom_15_list,
           d_custom_16_list,
           d_custom_17_list,
           d_custom_18_list,
           d_custom_19_list,
           d_custom_20_list

      into a_fmo_equation
      from metric_version_ref  mvr,
           metric_operator_ref mor,
           fmo_equation        feqn
     where mvr.metric_definition_id = a_metric_definition_id
       and mvr.metric_version_id = mor.metric_version_id
       and mor.metric_operator_id = feqn.metric_operator_id
       and mvr.valid_from <= sysdate
       and mvr.valid_to >= sysdate
       and mvr.status = 'A'
       and mvr.valid_from =
           (select max(valid_from)
              from metric_version_ref
             where metric_definition_id = a_metric_definition_id
               and valid_from <= sysdate
               and valid_to >= sysdate
               and status = 'A');

    return a_fmo_equation;

  exception
    -- record and return any exception message
    when others then
      loggerForce('setGlobalMetricFunction: problem with fmoEquation for this metric definition: ' ||
                  a_metric_definition_id);
      loggerForce('Exception: ' || SUBSTR(SQLERRM, 1, 4000));

      -- re-throw any exception -- TODO
      raise;

  end;

  /**********************************
  *  load up the threshold_day_date data array
  ***********************************/
  function getThresholdsForThreshDef(a_thresh_def_id number)
    return threshold_def_data is

    cursor thresh_dates_cur(act_thresh_ver_id number) is
      select tvr.threshold_version_id,
             trunc(edr.exception_date) + (from_time / 86400) as from_date,
             trunc(edr.exception_date) + (to_time / 86400) as to_date
        from imm.date_threshold_ref datetr
       inner join imm.exception_date_ref edr on (datetr.exception_date_id =
                                                edr.exception_date_id)
       inner join imm.threshold_version_ref tvr on (tvr.threshold_version_id =
                                                   datetr.threshold_version_id)
                                               and tvr.threshold_version_id =
                                                   act_thresh_ver_id;

    cursor thresh_days_cur(act_thresh_ver_id number) is
      select tvr.threshold_version_id,
             wdr.day,
             daytr.from_time,
             daytr.to_time
        from imm.day_threshold_ref daytr
       inner join imm.week_day_ref wdr on (daytr.day_id = wdr.day_id)
       inner join imm.threshold_version_ref tvr on (tvr.threshold_version_id =
                                                   daytr.threshold_version_id)
                                               and tvr.threshold_version_id =
                                                   act_thresh_ver_id;

    -- severity data
    cursor thresh_severities(act_thresh_ver_id number) is
      select tsr.severity_id,
             tsr.priority_id,
             sr.importance,
             tsr.value,
             tsr.operator,
             tsr.raise_issue,
             str.state_id,
             tsr.start_group_id,
             tsr.start_user_id
        from imm.threshold_severity_ref tsr,
             imm.severity_ref           sr,
             imm.state_ref              str,
             imm.issue_type_ref         itr
       where sr.severity_id = tsr.severity_id
         and tsr.issue_type_id = itr.issue_type_id
         and str.state_id = startStateId
         and tsr.threshold_version_id = act_thresh_ver_id
       order by importance desc;


    the_threshold_date_data threshold_date_data;
    the_thresh_date_array   threshold_date_array;
    the_threshold_day_data  threshold_day_data;
    the_thresh_day_array    threshold_day_array;

    the_threshold_def_data       threshold_def_data;
    the_threshold_sev_data       threshold_sev_data;
    the_threshold_sev_data_array threshold_sev_data_array;
    counter                      pls_integer;

    active_threshold_version_id    number;
    active_threshold_definition_id number;
    thresh_def_name                varchar2(150);
    thresh_def_type                varchar2(50);

  begin
    --logger('loadThresholdsForThreshDef: ');
    -- grab active_threshold_version_id
    -- if there is no active version then return empty-handed
    begin
      select tvr.threshold_version_id,
             tvr.threshold_definition_id,
             tdr.description,
             tdr.type
        into active_threshold_version_id,
             active_threshold_definition_id,
             thresh_def_name,
             thresh_def_type
        from imm.threshold_version_ref    tvr,
             imm.threshold_definition_ref tdr
       where tvr.threshold_definition_id = a_thresh_def_id
         and tvr.threshold_definition_id = tdr.threshold_definition_id
         and tvr.status = 'A';
    exception
      when no_data_found then
        return null;
    end;

    -- load dates (if any) for this threshold_definition
    counter := 0;

    open thresh_dates_cur(active_threshold_version_id);
    while true loop
      fetch thresh_dates_cur
        into the_threshold_date_data;
      if thresh_dates_cur%NOTFOUND then
        close thresh_dates_cur;
        exit;
      else
        counter := counter + 1;
        the_thresh_date_array(counter) := the_threshold_date_data;
      end if;
    end loop;

    -- load days (if any) for this threshold_definition
    counter := 0;
    open thresh_days_cur(active_threshold_version_id);
    while true loop
      fetch thresh_days_cur
        into the_threshold_day_data;
      if thresh_days_cur%NOTFOUND then
        close thresh_days_cur;
        exit;
      else
        counter := counter + 1;
        the_thresh_day_array(counter) := the_threshold_day_data;
      end if;
    end loop;

    -- severities
    counter := 0;
    open thresh_severities(active_threshold_version_id);
    while true loop
      fetch thresh_severities
        into the_threshold_sev_data;
      if thresh_severities%NOTFOUND then
        close thresh_severities;
        exit;
      else
        counter := counter + 1;
        the_threshold_sev_data_array(counter) := the_threshold_sev_data;
      end if;
    end loop;

    the_threshold_def_data.active_tv_id        := active_threshold_version_id;
    the_threshold_def_data.active_td_id        := active_threshold_definition_id;
    the_threshold_def_data.threshold_name      := thresh_def_name;
    the_threshold_def_data.threshold_type_name := thresh_def_type;
    -- day/dates
    the_threshold_def_data.day_data  := the_thresh_day_array;
    the_threshold_def_data.date_data := the_thresh_date_array;

    -- thresh_version fields
    begin
      with filtered_attributes as(
        select *
          from imm.threshold_version_attr t
         where t.attribute_id = thresholdComparatorId)
          select tvr.description, fa.value
            into the_threshold_def_data.tvr_description,
           the_threshold_def_data.tvr_is_comparator
            from imm.threshold_version_ref tvr
           inner join filtered_attributes fa on fa.threshold_version_id =
                                                tvr.threshold_version_id
                                            and tvr.threshold_version_id =
                                                active_threshold_version_id;


    exception
      when no_data_found then
        the_threshold_def_data.tvr_description   := 'N/A';
        the_threshold_def_data.tvr_is_comparator := 'N'; -- TODO !! Not used by MREC
    end;
    -- thresh_sev_data
    the_threshold_def_data.severity_data := the_threshold_sev_data_array;

    return the_threshold_def_data;
    --logger('loadThresholdsForThreshDef: done');
  end;

  function getThresholdsForThreshSeq(a_thresh_seq_id number)
    return threshold_seq_data_array is

    cursor threshold_defs is
      select threshold_definition_id, order_no
        from imm.threshold_sequence_jn
       where threshold_sequence_id = a_thresh_seq_id
       order by order_no asc;

    thresh_def_id                number;
    the_order_no                 number;
    the_threshold_def_data       threshold_def_data;
    the_threshold_seq_data_array threshold_seq_data_array;
  begin
    --logger('loadThresholdsForThreshSeq: ');
    open threshold_defs;
    while true loop

      fetch threshold_defs
        into thresh_def_id, the_order_no;
      if threshold_defs%NOTFOUND then
        close threshold_defs;
        exit;
      else
        the_threshold_def_data := getThresholdsForThreshDef(thresh_def_id);
        the_threshold_seq_data_array(the_order_no) := the_threshold_def_data;
        --the_threshold_seq_data_array(the_threshold_def_data.active_tv_id) := the_threshold_def_data;
      end if;

    end loop;

    return the_threshold_seq_data_array;
  end;

  /**********************************************
  * Given a threshold seq (global_thresh_seq_data) TODO remove global
  * return the valid threshold_version_id
  * or null
  ***********************************************/
  function getThreshVerIdForDPeriod(current_d_period date)
    return threshold_def_data as

    the_threshold_seq_data_array threshold_seq_data_array;
    order_as_counter             pls_integer;

    the_threshold_def_data threshold_def_data;

  begin
    --logger('getThreshVerIdForDPeriod: dp: '||current_d_period);

    begin
      the_threshold_def_data       := null;
      the_threshold_seq_data_array := global_thresh_seq_data; -- TODO deglobalise!

      -- loop through the thresh seq data
      order_as_counter := the_threshold_seq_data_array.FIRST;
      while (order_as_counter is not null) loop

        the_threshold_def_data := the_threshold_seq_data_array(order_as_counter);

        -- contained in exception dates?
        if validForDates(the_threshold_def_data.date_data, current_d_period) then
          --logger('Twas valid for date');
          return the_threshold_def_data;
        end if;

        -- contained in days?
        if validForDays(the_threshold_def_data.day_data, current_d_period) then
          --logger('Twas valid for day');
          return the_threshold_def_data;
        end if;

        -- always valid?
        if alwaysValid(the_threshold_def_data.date_data, the_threshold_def_data.day_data) then
          return the_threshold_def_data;
        end if;

        --logger('next the_threshold_seq_data_array');
        order_as_counter := the_threshold_seq_data_array.NEXT(order_as_counter);
      end loop;
      --logger('getThreshVerIdForDPeriod: done');

    exception
      when no_data_found then
        the_threshold_def_data := null;
        loggerForce('Exception: ' || SUBSTR(SQLERRM, 1, 100));

      when value_error then
        the_threshold_def_data := null;
        loggerForce('Exception: ' || SUBSTR(SQLERRM, 1, 100));

    end;

    return the_threshold_def_data;

  end;

  /**********************************************
  * Given a mrec_version_id and d_period_id,
  * return the valid threshold_version_id or null
  ***********************************************/
  function getThreshVerIdForDPeriod(a_mrec_version_id integer, a_d_period_id date)
    return integer as

    the_mrec_ref mrec_ref;
    the_threshold_def_data threshold_def_data;

  begin

    select threshold_definition_id, threshold_sequence_id
      into the_mrec_ref.threshold_definition_id, the_mrec_ref.threshold_sequence_id
      from um.mrec_version_ref
     where mrec_version_id = a_mrec_version_id;

    loadStaticData(the_mrec_ref);
    the_threshold_def_data := getThreshVerIdForDPeriod(a_d_period_id);

    return the_threshold_def_data.active_tv_id;

    exception
      when no_data_found then
        loggerForce('Invalid MREC_VERSION_ID ' || a_mrec_version_id);
        return null;
  end;

  ----------------------------------------------------------
  -- Is sample_date contained within this threshold
  ----------------------------------------------------------
  function validForDates(date_data threshold_date_array, sample_date date)
    return boolean deterministic as
    the_threshold_date_data threshold_date_data;
    counter                 pls_integer;

  begin
    --logger('validForDates: dp: '||sample_date);
    counter := date_data.FIRST;
    while (counter is not null) loop
      the_threshold_date_data := date_data(counter);

      if (sample_date >= the_threshold_date_data.from_date) AND
         (sample_date <= the_threshold_date_data.to_date) then
        return true;
      end if;

      counter := date_data.NEXT(counter);
    end loop;

    return false;
  end;

  ----------------------------------------------------------
  -- Is the day (sample_date)  contained within this threshold
  ----------------------------------------------------------
  function validForDays(day_data threshold_day_array, sample_date date)
    return boolean deterministic as
    the_threshold_day_data threshold_day_data;
    counter                pls_integer;

    sample_date_seconds number;
    sample_date_day     varchar2(10);
  begin
    --logger('validForDays: dp: '||sample_date);
    counter := day_data.FIRST;

    while (counter is not null) loop
      the_threshold_day_data := day_data(counter);

      sample_date_seconds := to_number(to_char(sample_date, 'SSSSS'));
      sample_date_day     := trim(to_char(sample_date, 'Day'));

      if (sample_date_day = the_threshold_day_data.t_day) then
        if (sample_date_seconds >= the_threshold_day_data.from_time) AND
           (sample_date_seconds <= the_threshold_day_data.to_time) then
          return true;
        end if;
      end if;

      counter := day_data.NEXT(counter);
    end loop;

    return false;

  end;

  ----------------------------------------------------------
  -- If tables IMM.DATE_THRESHOLD_REF and IMM.DAY_THRESHOLD_REF
  -- don't contain any reference to this threshold, then it is
  -- always valid
  ----------------------------------------------------------
  function alwaysValid(date_data threshold_date_array, day_data threshold_day_array)
    return boolean deterministic as
    counter                pls_integer;
  begin

    counter := date_data.FIRST;
    if (counter is null) then
        counter := day_data.FIRST;
        if (counter is null) then
            -- no records related to this threshold version in IMM.DATE_THRESHOLD_REF and
            -- IMM.DAY_THRESHOLD_REF --> always valid
            return true;
        end if;
    end if;

    return false;
  end;


  -------------------------------------------------------
  -- Test for threshold breach
  -- Return null if no breach
  -- otherwise return a populated severity_data object
  -------------------------------------------------------
  function testForBreach(sum_value            number,
                         diff_value           number,
                         a_threshold_def_data threshold_def_data)
    return severity_data is

    the_threshold_sev_data_array threshold_sev_data_array;
    the_threshold_sev_data       threshold_sev_data;
    severity_data_ret            severity_data;
    test_value                   number;
  begin
    the_threshold_sev_data_array := a_threshold_def_data.severity_data;

    -- If this is a 'Percentage' threshold then test the diff_value
    -- against the threshold value (note that diff_value is actually a percentage difference)
    -- If this is a 'Absolute' threshold then test the sum_value
    -- against the threshold value
    if a_threshold_def_data.threshold_type_name = 'Percentage' then
      test_value := diff_value;
    else
      -- 'Absolute'
      test_value := sum_value;
    end if;

    for counter in the_threshold_sev_data_array.first .. the_threshold_sev_data_array.last loop
      the_threshold_sev_data := the_threshold_sev_data_array(counter);

      if executeOp(the_threshold_sev_data.operator,
                   test_value,
                   the_threshold_sev_data.value) then
        severity_data_ret.severity_id          := the_threshold_sev_data.severity_id;
        severity_data_ret.priority_id          := the_threshold_sev_data.priority_id;
        severity_data_ret.issue_start_state_id := the_threshold_sev_data.start_state_id;
        severity_data_ret.issue_start_group_id := the_threshold_sev_data.start_group_id;
        severity_data_ret.issue_start_user_id  := the_threshold_sev_data.start_user_id;
        severity_data_ret.raise_issue          := the_threshold_sev_data.raise_issue;
        severity_data_ret.threshold_breached   := true;
        severity_data_ret.value                := the_threshold_sev_data.value;
        severity_data_ret.operator             := the_threshold_sev_data.operator;

        --logger('Threshold Breached');
        return severity_data_ret;
      end if;

    end loop;

    return null;

  exception
    when others then
      loggerForce('Exception: ' || SUBSTR(SQLERRM, 1, 4000));
      return null; --TODO this will hide any errors due to bad threshold reference data
  end;

  -------------------------------------------------------
  -- Raise an issue and add initial note
  -------------------------------------------------------
  function raiseIssue(the_mrec_id            integer,
                      the_severity_data      severity_data,
                      the_mrec_ref           mrec_ref,
                      the_threshold_def_data threshold_def_data,
                      issue_date_raised      date,
                      the_d_period_id        date,
                      lhs_value              number,
                      rhs_value              number,
                      sum_value              number,
                      diff_value             number) return number is

    issue_id         number;
    note_text        varchar2(4000);
    date_widget_from varchar2(50);
    date_widget_to   varchar2(50);

    -- The searchable attributes of
    issue_attrs imm.issues.bin_array;

    MREC_DEFINITION_ATTR_ID          constant integer := 35004;
    SAMPLE_DATE_ATTR_ID              constant integer := 35024;
    PERIOD_ATTR_ID                   constant integer := 35030;
    MREC_ID_ATTR_ID                  constant integer := 35032;

  begin
    --logger('raiseIssue');
    issue_attrs(MREC_DEFINITION_ATTR_ID) := the_mrec_ref.mrec_definition_id;
    issue_attrs(SAMPLE_DATE_ATTR_ID) := to_char(the_d_period_id, 'Dy, DD FMMonth YYYY');
    issue_attrs(PERIOD_ATTR_ID) := to_char(the_d_period_id, 'Dy, DD FMMonth YYYY')||to_char(the_d_period_id, ' HH24:MI');
    issue_attrs(MREC_ID_ATTR_ID) := the_mrec_id;

    issue_id := IMM.Issues.insertIssue(mrecIssueType,
                                       the_severity_data.severity_id,
                                       the_severity_data.priority_id,
                                       NVL(the_mrec_ref.def_name,
                                           the_mrec_ref.description),
                                       adminUserId,
                                       the_severity_data.issue_start_group_id,
                                       the_severity_data.issue_start_user_id,
                                       issue_date_raised,
                                       null,
                                           issueAttrs => issue_attrs);

    -- if DAILY ISSUE LIMIT breached
    -- then return immediately
    if issue_id = IMM.Issues.DAILY_LIMIT_BREACH_FLAG then
      return issue_id;
    end if;

    -- Need to create a URL linking to the Metric Reconciliation Chart page
    -- this url takes Date Widget Parameters of the form (eg) "Mon,+01+January+2007"
    date_widget_from := replace(to_char(the_d_period_id - 7,
                                        'Dy,+DD+Month+YYYY'),
                                ' ',
                                '');
    date_widget_to   := replace(to_char(the_d_period_id + 7,
                                        'Dy,+DD+Month+YYYY'),
                                ' ',
                                '');

    -- Add Metric Note
    note_text := '<tr><td><table>' ||
                 '<tr><td><a href="/um/um/mrecChartProcess.do?from=' ||
                 to_char(date_widget_from) || '&' || 'to=' ||
                 to_char(date_widget_to) || '&' || 'mrecDefinitionId_time=' ||
                 the_mrec_ref.mrec_definition_id || '&' || 'mrecType=TIME' || '&' || 'id=mrec' || '&' ||
                 'method=Generate&' || 'chartType=DISCRETE">' ||
                 'View Reconciliation Chart</a></td></tr><tr><td colspan="2"></td></tr>' ||

                 '<tr><td colspan="2"><b>Metric Reconciliation Details</b></td></tr><tr><td>Reconciliation Name:</td><td>' ||
                 the_mrec_ref.def_name ||
                 '</td></tr><tr><td>Reconciliation Version:</td><td>' ||
                 the_mrec_ref.description ||
                 '</td></tr><tr><td>Time Period:</td><td>' ||
                 to_char(the_d_period_id, 'Dy, DD FMMonth YYYY') || to_char(the_d_period_id, ' HH24:MI') ||

                 '</td></tr><tr><td>i Side:</td><td>' || lhs_value ||
                 '</td></tr><tr><td>j Side:</td><td>' || rhs_value ||

                 '</td></tr><tr><td>Reconciliation:</td><td>' || sum_value;

    if diff_value is not null and diff_value = INFINITY_CONST then
      note_text := note_text ||
                   '</td></tr><tr><td>Percent Difference:</td><td>' ||
                   'Infinite';
    elsif diff_value is not null then
      note_text := note_text ||
                   '</td></tr><tr><td>Percent Difference:</td><td>' ||
                   diff_value * 100;
    end if;

    note_text := note_text || '</td></tr><tr><td>' || '&' || 'nbsp;' ||
                 '</td></tr><tr><td colspan="2"><b>Threshold Details</b></td></tr><tr><td>Threshold Name:</td><td>' ||
                 the_threshold_def_data.threshold_name ||
                 '</td></tr><tr><td>Threshold Type:</td><td>' ||
                 the_threshold_def_data.threshold_type_name ||
                 '</td></tr><tr><td>Threshold Version Id:</td><td>' ||
                 the_threshold_def_data.active_tv_id ||
                 '</td></tr><tr><td nowrap>Threshold Breach Criteria:' || '&' ||
                 'nbsp;' || '&' || 'nbsp;' || '&' || 'nbsp;' || '&' ||
                 'nbsp;' || '&' || 'nbsp;' || '&' || 'nbsp;' || '&' ||
                 'nbsp;</td><td>' || the_severity_data.operator || '&' ||
                 'nbsp;' || the_severity_data.value || '</td></tr><tr><td>' || '&' ||
                 'nbsp;</td></tr>';

    note_text := note_text ||
                 '<tr><td colspan="2"><b>Issue Details</b></td></tr>' ||
                 '</td></tr><tr><td>Raised By:</td><td>' || adminUser || -- raised by
                 '</td></tr><tr><td>Creation Date:</td><td>' ||
                 to_char(issue_date_raised, 'Dy, DD FMMonth YYYY') || to_char(issue_date_raised, ' HH24:MM:SS') ||
                 '</td></tr><tr><td>' || '&' ||
                 'nbsp;</td></tr></table></td></tr>';

    IMM.Issues.addNote(issue_id,
                       adminUserId,
                       mrecNoteTypeId,
                       note_text,
                       null,
                       null);

    return issue_id;
  end;

  -----------------------------------------
  -- execute binary operator (eg IS 2>4 )
  -----------------------------------------
  function executeOp(op varchar2, lval number, rval number) return boolean
    deterministic is
    retval number;
    stmt   varchar2(1000);
  begin

    stmt := 'select nvl((select 1 from dual where ' || to_char(lval) || op ||
            to_char(rval) || '), 0) from dual';

    --logger('Stmt: ' || stmt);

    execute immediate stmt
      into retval;

    if retval > 0 then
      return true;
    else
      return false;
    end if;
  end;

    ---------------------------------------------------------------------
    -- Returns the threshold limit for the given threshold version
    -- a_grouping_fn => 'MIN' or 'MAX'
    -- a_sum_lhs => sum for reconciliation on i side (used to calculate percentage thresholds)
    ---------------------------------------------------------------------
    function getThresholdLimit(
      a_severity_id integer,
      a_grouping_fn varchar2,
      a_threshold_version_id integer,
      a_sum_lhs number)
    return number
    as
      v_result number;

      cursor c_threshold_limits is
      select tdr.type threshold_type,
             max(case when tsr.severity_id = a_severity_id and tsr.operator in ('>', '>=', '=') then tsr.value else null end) max_threshold,
             min(case when tsr.severity_id = a_severity_id and tsr.operator in ('<', '<=', '=') then tsr.value else null end) min_threshold
        from imm.threshold_version_ref tvr
        join imm.threshold_definition_ref tdr on tvr.threshold_definition_id = tdr.threshold_definition_id
        left outer join imm.threshold_severity_ref tsr on tsr.threshold_version_id = tvr.threshold_version_id
       where tvr.status = 'A'
         and tvr.threshold_version_id = a_threshold_version_id
       group by tdr.type;
    begin

      if a_threshold_version_id is null then
        return null;
      end if;

      for r_threshold_limits in c_threshold_limits loop

        if r_threshold_limits.threshold_type = 'Absolute' then
          select decode(upper(a_grouping_fn),
                      'MAX', r_threshold_limits.max_threshold,
                      'MIN', r_threshold_limits.min_threshold, null)
            into v_result
            from dual;

        elsif r_threshold_limits.threshold_type = 'Percentage' then
          select decode(upper(a_grouping_fn),
                      'MAX', -1 * a_sum_lhs * r_threshold_limits.max_threshold,
                      'MIN', -1 * a_sum_lhs * r_threshold_limits.min_threshold, null)
            into v_result
            from dual;

        end if;
      end loop;

      return v_result;

    end;

  ---------------------------------------
  -- Debug stuff
  ---------------------------------------
  procedure showMRecRef(the_mrec_ref mrec_ref) is
    the_mrec_lhs  mrec_line_array;
    the_mrec_rhs  mrec_line_array;
    the_mrec_line mrec_line;

    counter pls_integer;
  begin
    logger('showMRecRef');

    the_mrec_lhs := the_mrec_ref.mrec_lhs;
    the_mrec_rhs := the_mrec_ref.mrec_rhs;

    logger('mrec_ref: mrec_ref.mrec_version_id: ' ||
           the_mrec_ref.mrec_version_id);
    logger('mrec_ref: the_mrec_ref.mrec_definition_id: ' ||
           the_mrec_ref.mrec_definition_id);
    logger('mrec_ref: mrec_ref.d_period_start: ' ||
           the_mrec_ref.d_period_start);
    logger('mrec_ref: mrec_ref.d_period_end: ' ||
           the_mrec_ref.d_period_end);
    logger('mrec_ref: threshold_definition_id: ' ||
           the_mrec_ref.threshold_definition_id);
    logger('mrec_ref: threshold_sequence_id: ' ||
           the_mrec_ref.threshold_sequence_id);

    if the_mrec_lhs is not null then
      counter := the_mrec_lhs.FIRST;
      while (counter is not null) loop
        the_mrec_line := the_mrec_lhs(counter);

        logger('LHS: the_mrec_line.d_mrec_line_id: ' ||
               the_mrec_line.d_mrec_line_id);
        logger('LHS: the_mrec_line.metric_definition_id: ' ||
               the_mrec_line.metric_definition_id);
        logger('LHS: the_mrec_line.node_id: ' || the_mrec_line.node_id);
        --        logger('LHS: the_mrec_line.metric_creation_date: ' || the_mrec_line.metric_creation_date);

        counter := the_mrec_lhs.NEXT(counter);
      end loop;
    end if;

    if the_mrec_rhs is not null then
      counter := the_mrec_rhs.FIRST;
      while (counter is not null) loop
        the_mrec_line := the_mrec_rhs(counter);

        logger('RHS: the_mrec_line.d_mrec_line_id: ' ||
               the_mrec_line.d_mrec_line_id);
        logger('RHS: the_mrec_line.metric_definition_id: ' ||
               the_mrec_line.metric_definition_id);
        logger('RHS: the_mrec_line.node_id: ' || the_mrec_line.node_id);
        --        logger('RHS: the_mrec_line.metric_creation_date: ' || the_mrec_line.metric_creation_date);

        counter := the_mrec_rhs.NEXT(counter);
      end loop;
    end if;

    logger('showMRecRef done!');
  end;

  procedure logger(msg varchar2) is
  begin
    if global_debug = 1 then
      putMessageAuto('UM', substr(msg, 1, 3999), global_job_id);
    end if;
  end;

  procedure loggerForce(msg varchar2) is
  begin
    putMessageAuto('UM', substr(msg, 1, 3999), global_job_id);
  end;

  -- copied from utils.table_utils package as cannot call directly from
  -- within this package
  procedure putMessageAuto(pModuleName in utils.Messages.Module%type,
                           pMessage    in utils.Messages.Msg%type,
                           pJobId      in utils.Messages.Job_Id%type) is
    pragma autonomous_transaction;
  BEGIN

    Insert into utils.Messages
      (msg_id, msg_date, module, msg, job_id)
    values
      (utils.seq_Msg_id.nextval,
       sysdate,
       pModuleName,
       substr(pMessage, 1, 4000),
       pJobId);
    COMMIT;

    return;
  END putMessageAuto;

  ----------------------------------------------------------------
  -- MrecVersionDuplicateRecCheck
  --   If a new MREC version has been created then we may have inserted
  --   duplicate F_MREC records. This procedure finds and removes the
  --   old/previous mrec versions F_MREC records if found.
  ----------------------------------------------------------------
  procedure MrecVersionDuplicateRecCheck(the_mrec_ref mrec_ref) IS

    l_rows integer := 0;

  begin
    logger('MrecVersionDuplicateRecCheck: start: ' || the_mrec_ref.mrec_version_id);

    DELETE FROM um.f_mrec fm
    WHERE  fm.d_period_id between the_mrec_ref.d_period_start and the_mrec_ref.d_period_end
    AND    EXISTS (SELECT 1
                   FROM   um.d_mrec_line_mv d,
                          um.f_mrec fm2,
                          um.d_mrec_line_mv d2
                   WHERE  1 = 1
                   -- d = other mrec_version_ids for this mrec lines
                   AND    d.mrec_definition_id = the_mrec_ref.mrec_definition_id
                   AND    d.mrec_version_id != the_mrec_ref.mrec_version_id
                   -- join fm to d (all f_mrecs for other mrec_version_ids)
                   AND    d.d_mrec_line_id = fm.d_mrec_line_id
                   -- d2 = this mrec_version_id lines
                   AND    d2.mrec_definition_id = the_mrec_ref.mrec_definition_id
                   AND    d2.mrec_version_id = the_mrec_ref.mrec_version_id
                   AND    d2.line_type = d.line_type
                   -- join fm2 to d2 (all f_mrecs for this mrec_version_id)
                   AND    fm2.d_mrec_line_id = d2.d_mrec_line_id
                   -- ensure this and other mrec version are for the same metric/node
                   AND    nvl(d2.metric_definition_id,1) = nvl(d.metric_definition_id,1)
                   AND    nvl(d2.node_id,1) = nvl(d.node_id,1)
                   -- join fm and fm2 to check for duplicate records
                   AND    fm.f_file_id = fm2.f_file_id
                   AND    fm.f_attribute_id = fm2.f_attribute_id
                   AND    fm.d_period_id = fm2.d_period_id
                  );


    l_rows := SQL%ROWCOUNT;

    logger('MrecVersionDuplicateRecCheck: DONE ');
    logger('MrecVersionDuplicateRecCheck: ROWS: ' || l_rows);

  end;

end volumetricrec_daily;
/

exit
