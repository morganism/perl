create or replace package metrics is

  -- Author : DPLANT
  -- Created : 14/08/2006 16:19:55

  type severity_data is record(
    threshold_breached   boolean,
    severity_id          integer,
    priority_id          integer,
    issue_start_state_id integer,
    issue_start_issue_type integer,
    issue_start_group_id integer,
    issue_start_user_id  number,
    raise_issue varchar2(1),
    last_metric_id number,
    last_metric_value number,
    issue_raised varchar2(1));

  /* day or a date */
  type threshold_date_data is record(
    thresh_version_id number,
    from_date  date,
    to_date    date
    );

  type threshold_day_data is record(
    thresh_version_id number,
    t_day     varchar2(50),
    from_time number,
    to_time   number
    );

  type threshold_date_array is table of threshold_date_data
    index by pls_integer;

  type threshold_day_array is table of threshold_day_data
    index by pls_integer;

  type source_id_array is table of number
    index by pls_integer;

  type id_list is table of number
    index by pls_integer;

  type date_list is table of date
    index by pls_integer;

  type source_type_id_array is table of number
    index by pls_integer;

  type edr_type_id_array is table of number
    index by pls_integer;

  type edr_sub_type_id_array is table of number
    index by pls_integer;

  type parameter_hash is table of varchar2(200)
    index by varchar2(200);

  type custom_sqls is record (
       i_value_sql varchar2(4000),
       j_value_sql varchar2(4000),
       metric_sql varchar2(4000),
       raw_value_sql varchar2(4000));

  type threshold_sev_data is record (
     severity_id integer,
     priority_id integer,
     value number,
     operator varchar2(2),
     raise_issue varchar2(1),
     start_state_id integer,
     start_issue_type_id integer,
     start_group_id integer,
     start_user_id integer);

  type threshold_sev_data_array is table of threshold_sev_data
    index by pls_integer;

  type threshold_def_data is record (
     threshold_name varchar(150),
     threshold_type_name varchar(50),
     edge_id number(6),
     edge_name varchar2(100),
     node_id number(6),
     node_name varchar2(100),
     active_tv_id number,
     active_td_id number,
     tvr_description varchar2(250),
     tvr_is_comparator  varchar2(1),
     tvr_min_level  number, -- min level at which this threshold can be applied
     date_data threshold_date_array,
     day_data threshold_day_array,
     source_ids source_id_array,
     source_type_ids source_type_id_array,
     severity_data threshold_sev_data_array,
     edr_type_ids edr_type_id_array,
     edr_sub_type_ids edr_sub_type_id_array);

  -- per edge or node
  type threshold_seq_data_array is table of threshold_def_data
     index by pls_integer;

  -- for all edges or nodes
  -- associated edge_id or node_id
  type threshold_data_array_by_id is table of threshold_seq_data_array
     index by pls_integer;

  type source_data is record (
       source_id number,
       source_name varchar2(250),
       source_type_id number,
       source_type_description varchar2(250));

  type source_data_array is table of source_data
     index by pls_integer;

  type source_type_data is record (
       source_type_id number,
       source_type_name varchar2(100),
       source_type_description varchar2(250));

  type source_type_data_array is table of source_type_data
     index by pls_integer;

  -- holder for metric calulation values

  type metric_return_value is record (
       i_value number(22,4),
       j_value number(22,4),
       raw_value number(22,4),
       metric_value number(22,4),
       compare_value number(22,4), -- difference between forecast and metric
       forecast_value number(22,4),
       threshold_value number(22,4), -- value used to test against thresholds

       d_source_id f_metric.d_source_id%type,
       d_source_type_id f_metric.source_type_id%type,
       d_edr_type_id f_metric.edr_type_id%type,
       edr_sub_type_id f_metric.edr_sub_type_id%type,

       d_billing_type_id f_metric.d_billing_type_id%type,

       d_payment_type_id f_metric.d_payment_type_id%type,
       d_call_type_id f_metric.d_call_type_id%type,
       d_customer_type_id f_metric.d_customer_type_id%type,
       d_service_provider_id f_metric.d_service_provider_id%type,

       d_custom_01_list varchar2(4000),
       d_custom_02_list varchar2(4000),
       d_custom_03_list varchar2(4000),
       d_custom_04_list varchar2(4000),
       d_custom_05_list varchar2(4000),
       d_custom_06_list varchar2(4000),
       d_custom_07_list varchar2(4000),
       d_custom_08_list varchar2(4000),
       d_custom_09_list varchar2(4000),
       d_custom_10_list varchar2(4000),
       d_custom_11_list varchar2(4000),
       d_custom_12_list varchar2(4000),
       d_custom_13_list varchar2(4000),
       d_custom_14_list varchar2(4000),
       d_custom_15_list varchar2(4000),
       d_custom_16_list varchar2(4000),
       d_custom_17_list varchar2(4000),
       d_custom_18_list varchar2(4000),
       d_custom_19_list varchar2(4000),
       d_custom_20_list varchar2(4000)
  );


   type last_value_data is record (
       d_period_id date,
       node_id number(8),
       edge_id number(8),
       source_id number(8),
       source_type_id number(8),
       metric_operator_id number(8),
       metric_definition_id number(8),
       operator_order number(8));

   type last_value is record (
        last_metric_value number(20,4),
        last_metric_id number(8));

 -- CONSTANTS (start)
  -- Public constant declarations
  raisedByUserId constant integer := 4000;
  raisedByUser constant varchar2(5) := 'Admin';
  startStateId constant integer := 3000;

  forceCloseStateId constant number := 3000;--35000;
  forceCloseResolutionId constant number := 35000;

  metricIssueClass constant number := 35100;
  metricIssueType constant number := 35200;
  metricNoteTypeId constant number := 35000;

  thresholdComparatorId constant number := 35000;
  thresholdMinLevelId constant number := 35010;

  UNSPECIFIED_SRC_ID constant number := -1;
  EDR_TYPE_UNSPECIFIED constant number := -1;
  EDR_SUB_TYPE_UNSPECIFIED constant number := -1;

  -- metric calculation identifiers
  edgeEDRCount constant varchar(25) := 'edgeEDRCount';

  -- last value range constants (eg 7 days + 30 mins, 7 days - 30 mins, etc )
  ONE_WEEK_AND_30_MINS constant number := 337/48;
  ONE_WEEK_LESS_30_MINS constant number := 335/48;
  TWO_WEEKS_AND_30_MINS constant number := 673/48;
  TWO_WEEKS_LESS_30_MINS constant number := 671/48;
  THREE_WEEKS_AND_30_MINS constant number := 1009/48;
  THREE_WEEKS_LESS_30_MINS constant number := 1007/48;
  FOUR_WEEKS_AND_30_MINS constant number := 1345/48;
  FOUR_WEEKS_LESS_30_MINS constant number := 1343/48;
 -- CONSTANTS (end)


  procedure loadSources;
  procedure loadStaticData(a_edge_id number, a_node_id number, a_metric_id number);
  procedure loadThresholdsForThreshDef(a_thresh_def_id number,
                                       a_edge_id number,
                                       a_node_id       number,
                                       a_order number,
                                       a_threshold_seq_data_array IN OUT NOCOPY threshold_seq_data_array);
  procedure loadThresholdsForThreshSeq(a_thresh_seq_id number,
                                       a_edge_id number,
                                       a_node_id number,
                                       a_threshold_seq_data_array IN OUT NOCOPY threshold_seq_data_array);

  function getNewThresholdVersionId(edge_or_node_id number,
                                    current_source_id number,
                                    current_source_type_id number,
                                    current_date date,
                                    current_edr_type_id number,
                                    current_edr_sub_type_id number)
  return number deterministic;

  function validForDates(date_data threshold_date_array,
                         creation_date date)
  return boolean deterministic;

  function validForDays(day_data threshold_day_array,
                         creation_date date)
  return boolean deterministic;

  function alwaysValid(date_data threshold_date_array,
                       day_data threshold_day_array)
  return boolean deterministic;

  function validForSources(a_threshold_def_data threshold_def_data,
                           current_source_id number,
                           current_source_type_id number)
  return boolean deterministic;

  function validForEdrs(a_threshold_def_data     threshold_def_data,
                        current_edr_type_id      number,
                        current_edr_sub_type_id  number)
  return boolean deterministic;

  ----------------------------------------------
  -- return null if threshold not breached
  ----------------------------------------------
  function getSeverityIfBreachedValue(a_metric_return_value  metric_return_value,
                                      a_last_value_data last_value_data)
    return severity_data;

  function executeOp(op varchar2,
                     lval number,
                     rval number) return boolean deterministic;

  function executeOpRelative(op varchar2,
                     lval1 number,
                     lval2 number,
                     rval number,
                     optype varchar2) return boolean deterministic;

  function getLastValue(a_d_period_id date,
                        a_node_id integer,
                        a_edge_id integer,
                        a_source_id integer,
                        a_source_type_id integer,
                        a_metric_operator_id integer,
                        a_metric_definition_id integer,
                        a_operator_order integer) return number;

  function getLastValue(a_last_value_data last_value_data) return last_value;
  function getLastValueAux(a_last_value_data last_value_data,
                            from_date date, to_date date)   return last_value;


  function mergeResults(a_operator_id  number,
                        b_thread_id    number,
                        all_parameters varchar2,
                        a_debug        varchar2,
                        ignore_deadlock varchar2) return varchar2;

  function coreMatchedFileMetricCalc(a_operator_id    number,
                               b_thread_id     number,
                               job_start_ts timestamp,
                               d_metric_version_id number,
                               a_relative number,
                               a_edge_ids varchar2,
                               a_node_ids varchar2,
                               all_parameters varchar2,
                               a_debug varchar2
                               ) return varchar2;

  function coreUnMatchedFileMetricCalc(a_operator_id    number,
                               b_thread_id     number,
                               job_start_ts timestamp,
                               d_metric_version_id number,
                               a_relative number,
                               a_edge_ids varchar2,
                               a_node_ids varchar2,
                               all_parameters varchar2,
                               a_debug varchar2
                               ) return varchar2;

  function coreMatchedForecastMetricCalc(a_operator_id    number,
                               b_thread_id     number,
                               job_start_ts timestamp,
                               d_metric_version_id number,
                               a_relative number,
                               a_edge_ids varchar2,
                               a_node_ids varchar2,
                               forecast_metric_id number,
                               all_parameters varchar2,
                               a_debug varchar2
                               ) return varchar2;

  function coreUnMatchForeMetricCalc(a_operator_id    number,
                               b_thread_id     number,
                               job_start_ts timestamp,
                               d_metric_version_id number,
                               a_relative number,
                               a_edge_ids varchar2,
                               a_node_ids varchar2,
                               forecast_metric_id number,
                               all_parameters varchar2,
                               a_debug varchar2
                               ) return varchar2;

  function coreMetricCalc(a_operator_id    number,
                               b_thread_id     number,
                               a_metric_creation_date     date,
                               d_metric_version_id number,
                               a_relative number,
                               a_edge_ids varchar2,
                               a_node_ids varchar2,
                               matched_file_metric boolean,
                               a_forecast_metric_id number default null                              )
  return varchar2;

  procedure  showGlobalThreshData;

  procedure forecastAdjustment(a_metric_return_value IN OUT NOCOPY metric_return_value,
                           a_forecast_metric_id number,
                           a_node_id number,
                           a_edge_id number,
                           a_source_id number,
                           grouping_edr_type_id number,
                           grouping_edr_sub_type_id number,
                           a_d_period date,
                           a_source_type_id number);

  function raiseIssueIfBreached(a_threshold_version_id number,
                                a_metric_return_value  metric_return_value,
                                sample_date            date,
                                d_period_id            date,
                                metric_id              number,
                                a_metric_def_id        number,
                                a_edge_id              number,
                                a_node_id              number,
                                a_source_id            number,
                                a_source_type_id       number,
                                a_edr_type_id          number,
                                a_edr_sub_type_id      number,
                                regen_metric_id        number,
                                a_i_fileset_id           number,
                                a_j_fileset_id           number,
                                a_last_value_data      last_value_data)
                           return severity_data;

  function edrCalcMetricFmoEqn(a_i_fileset_id number,
                               a_i_min_d_period_id date,
                               a_i_max_d_period_id date,
                               a_j_fileset_id number,
                               a_j_min_d_period_id date,
                               a_j_max_d_period_id date,
                               a_edr_type_id number,
                               a_edr_sub_type_id number
                               )
                           return metric_return_value;


  function edrCountSumMetric(a_i_fileset_id number,
                              a_i_min_d_period_id date,
                              a_i_max_d_period_id date,
                              a_edr_type_id         number,
                              a_edr_sub_type_id     number
                              ) return metric_return_value;

  function edrCountMinusMetric(a_i_fileset_id number,
                              a_i_min_d_period_id date,
                              a_i_max_d_period_id date,
                              a_j_fileset_id number,
                              a_j_min_d_period_id date,
                              a_j_max_d_period_id date,
                              a_edr_type_id         number,
                              a_edr_sub_type_id     number
                              ) return metric_return_value;

  function edrCountPercentMetric(a_i_fileset_id number,
                              a_i_min_d_period_id date,
                              a_i_max_d_period_id date,
                              a_j_fileset_id number,
                              a_j_min_d_period_id date,
                              a_j_max_d_period_id date,
                              a_edr_type_id         number,
                              a_edr_sub_type_id     number
                              ) return metric_return_value;

  function edrCountDifferenceMetric(a_i_fileset_id number,
                              a_i_min_d_period_id date,
                              a_i_max_d_period_id date,
                              a_j_fileset_id number,
                              a_j_min_d_period_id date,
                              a_j_max_d_period_id date,
                              a_edr_type_id         number,
                              a_edr_sub_type_id     number
                              ) return metric_return_value;

  function edrDurationSumMetric(a_i_fileset_id number,
                              a_i_min_d_period_id date,
                              a_i_max_d_period_id date,
                              a_edr_type_id         number,
                              a_edr_sub_type_id     number
                              ) return metric_return_value;


  function edrDurationMinusMetric(a_i_fileset_id number,
                              a_i_min_d_period_id date,
                              a_i_max_d_period_id date,
                              a_j_fileset_id number,
                              a_j_min_d_period_id date,
                              a_j_max_d_period_id date,
                              a_edr_type_id         number,
                              a_edr_sub_type_id     number
                              ) return metric_return_value;

  function edrDurationPercentMetric(a_i_fileset_id number,
                              a_i_min_d_period_id date,
                              a_i_max_d_period_id date,
                              a_j_fileset_id number,
                              a_j_min_d_period_id date,
                              a_j_max_d_period_id date,
                              a_edr_type_id         number,
                              a_edr_sub_type_id     number
                              ) return metric_return_value;

  function edrDurationDifferenceMetric(a_i_fileset_id number,
                              a_i_min_d_period_id date,
                              a_i_max_d_period_id date,
                              a_j_fileset_id number,
                              a_j_min_d_period_id date,
                              a_j_max_d_period_id date,
                              a_edr_type_id         number,
                              a_edr_sub_type_id     number
                              ) return metric_return_value;

 function edrValueSumMetric(a_i_fileset_id number,
                              a_i_min_d_period_id date,
                              a_i_max_d_period_id date,
                              a_edr_type_id         number,
                              a_edr_sub_type_id     number
                              ) return metric_return_value;


  function edrValueMinusMetric(a_i_fileset_id number,
                              a_i_min_d_period_id date,
                              a_i_max_d_period_id date,
                              a_j_fileset_id number,
                              a_j_min_d_period_id date,
                              a_j_max_d_period_id date,
                              a_edr_type_id         number,
                              a_edr_sub_type_id     number
                              ) return metric_return_value;

  function edrValuePercentMetric(a_i_fileset_id number,
                              a_i_min_d_period_id date,
                              a_i_max_d_period_id date,
                              a_j_fileset_id number,
                              a_j_min_d_period_id date,
                              a_j_max_d_period_id date,
                              a_edr_type_id         number,
                              a_edr_sub_type_id     number
                              ) return metric_return_value;

  function edrValueDifferenceMetric(a_i_fileset_id number,
                              a_i_min_d_period_id date,
                              a_i_max_d_period_id date,
                              a_j_fileset_id number,
                              a_j_min_d_period_id date,
                              a_j_max_d_period_id date,
                              a_edr_type_id         number,
                              a_edr_sub_type_id     number
                              ) return metric_return_value;

  function edrBytesSumMetric(a_i_fileset_id number,
                              a_i_min_d_period_id date,
                              a_i_max_d_period_id date,
                              a_edr_type_id         number,
                              a_edr_sub_type_id     number
                              ) return metric_return_value;

  function edrBytesMinusMetric(a_i_fileset_id number,
                              a_i_min_d_period_id date,
                              a_i_max_d_period_id date,
                              a_j_fileset_id number,
                              a_j_min_d_period_id date,
                              a_j_max_d_period_id date,
                              a_edr_type_id         number,
                              a_edr_sub_type_id     number
                              ) return metric_return_value;

  function edrBytesPercentMetric(a_i_fileset_id number,
                              a_i_min_d_period_id date,
                              a_i_max_d_period_id date,
                              a_j_fileset_id number,
                              a_j_min_d_period_id date,
                              a_j_max_d_period_id date,
                              a_edr_type_id         number,
                              a_edr_sub_type_id     number
                              ) return metric_return_value;

  function edrBytesDifferenceMetric(a_i_fileset_id number,
                              a_i_min_d_period_id date,
                              a_i_max_d_period_id date,
                              a_j_fileset_id number,
                              a_j_min_d_period_id date,
                              a_j_max_d_period_id date,
                              a_edr_type_id         number,
                              a_edr_sub_type_id     number
                              ) return metric_return_value;


  procedure getEdrCountValue(a_fileset_id        number,
                             a_min_d_period_id   date,
                             a_max_d_period_id   date,
                             a_d_source_id       number,
                             a_d_source_type_id  number,
                             a_d_measure_type_id number,
                             a_edr_type_id       number,
                             a_edr_sub_type_id   number,
                             a_value             OUT NOCOPY number);

  procedure getEdrValueValue(a_fileset_id        number,
                             a_min_d_period_id   date,
                             a_max_d_period_id   date,
                             a_d_source_id       number,
                             a_d_source_type_id  number,
                             a_d_measure_type_id number,
                             a_edr_type_id       number,
                             a_edr_sub_type_id   number,
                             a_value             OUT NOCOPY number);

  procedure getEdrDurationValue(a_fileset_id        number,
                                a_min_d_period_id   date,
                                a_max_d_period_id   date,
                                a_d_source_id       number,
                                a_d_source_type_id  number,
                                a_d_measure_type_id number,
                                a_edr_type_id       number,
                                a_edr_sub_type_id   number,
                                a_value             OUT NOCOPY number);

  procedure getEdrBytesValue(a_fileset_id        number,
                             a_min_d_period_id   date,
                             a_max_d_period_id   date,
                             a_d_source_id       number,
                             a_d_source_type_id  number,
                             a_d_measure_type_id number,
                             a_edr_type_id       number,
                             a_edr_sub_type_id   number,
                             a_value             OUT NOCOPY number);

  procedure setGlobalMetricFunction(a_metric_operator_id number);

  function in_list( p_string in varchar2 ) return inListType;
  function inlist2varchar( p_in_list in inListType ) return varchar2;

  procedure loggerAuto(msg varchar2);
  procedure loggerDebug(msg varchar2);
  procedure loggerDebugWithTest(msg varchar2, okay boolean);

  procedure setParameters(all_parameters varchar2);
  procedure setCustomSQLMetricFunction(a_metric_operator number);

  function edrCustomSQLMetric(  a_i_fileset_id number,
                              a_i_min_d_period_id date,
                              a_i_max_d_period_id date,
                              a_j_fileset_id number,
                              a_j_min_d_period_id date,
                              a_j_max_d_period_id date) return metric_return_value;

  function getActiveOperatorId( metric_def_id NUMBER) return NUMBER;

    procedure forceMsg(jobId integer, msg varchar);


/*
  procedure calculateMetaMetric(the_metric_return_value OUT metric_return_value,
                             a_forecast_def_id number,
                             current_node_id number,
                             current_edge_id number,
                             regen_f_metric_id number,
                             regen_metric_issue_id OUT number,
                             current_threshold_version_id OUT number,
                             the_severity_data OUT severity_data,
                             summary_num_issues OUT number);
*/
end Metrics;
/
create or replace package body metrics is

  ---------------------------------------------
  -- global variables
  -- to hold operator_id and thread_id which
  -- should make logging much easier (ie no need
  -- to pass operator_id and thread_id as parameters
  -- into every function call
  --
  -- just remember to set these variables when first
  -- enter the entry-level procedure/function
  ---------------------------------------------

  global_operator_id number;
  global_thread_id   number;

  global_debug pls_integer;

  global_operator_desc varchar2(250);

  global_metric_definition_name metric_definition_ref.name%type;
  global_metric_category_id     metric_category_ref.metric_category_id%type;
  global_metric_category_name   metric_category_ref.category%type;

  global_thresh_seq_data   threshold_seq_data_array;
  global_thresh_data_by_id threshold_data_array_by_id;

  global_current_thresh_def_data threshold_def_data;
  global_current_thresh_sev_data threshold_sev_data;

  global_source_data_array      source_data_array;
  global_source_type_data_array source_type_data_array;

  global_metric_function_id varchar(40);
  global_fmo_equation       metrictypes.fmo_equation_details;

  -- parameters
  global_parameters    parameter_hash;
  global_switch_to_raw varchar(3) := 'no';

  global_var_function_id varchar(6) := 'sum';

  -- Declarations for custom metrics
  global_custom_sqls custom_sqls;

  procedure getEdrXXXValue(a_fileset_id        number,
                           a_min_d_period_id   date,
                           a_max_d_period_id   date,
                           a_d_source_id       number,
                           a_d_source_type_id  number,
                           a_d_measure_type_id number,
                           a_edr_type_id       number,
                           a_edr_sub_type_id   number,
                           count_value         OUT NOCOPY number,
                           value_value         OUT NOCOPY number,
                           bytes_value         OUT NOCOPY number,
                           duration_value      OUT NOCOPY number);

  /******************************************************************
  * START
  * Initialisation:
  *
  * This section contains initialisation code called at the start of
  * and metric operation
  *******************************************************************/

  --------------------
  -- Load static data
  --------------------
  procedure loadStaticData(a_edge_id   number,
                           a_node_id   number,
                           a_metric_id number) is
    the_thresh_def_id number;
    the_thresh_seq_id number;
  begin

    loggerDebug('Loading Static Data...');

    global_current_thresh_def_data := null;
    global_current_thresh_sev_data := null;
    global_thresh_seq_data.delete;
    global_thresh_data_by_id.delete;

    if a_edge_id is not null then
      begin
        select threshold_definition_id, threshold_sequence_id
          into the_thresh_def_id, the_thresh_seq_id
          from edge_metric_jn
         where edge_id = a_edge_id
           and metric_definition_id = a_metric_id;
      exception
        when NO_DATA_FOUND then
          the_thresh_def_id := null;
          the_thresh_seq_id := null;
        when TOO_MANY_ROWS then
          the_thresh_def_id := null;
          the_thresh_seq_id := null;
      end;
    elsif a_node_id is not null then
      begin
        select threshold_definition_id, threshold_sequence_id
          into the_thresh_def_id, the_thresh_seq_id
          from node_metric_jn
         where node_id = a_node_id
           and metric_definition_id = a_metric_id;
      exception
        when NO_DATA_FOUND then
          the_thresh_def_id := null;
          the_thresh_seq_id := null;
        when TOO_MANY_ROWS then
          the_thresh_def_id := null;
          the_thresh_seq_id := null;
      end;
    else
      the_thresh_def_id := null;
      the_thresh_seq_id := null;
    end if;

    if the_thresh_def_id is not null then
      loggerDebug('Load Thresholds: thresh_def_id =' || the_thresh_def_id);
      loadThresholdsForThreshDef(the_thresh_def_id,
                                 a_edge_id,
                                 a_node_id,
                                 0,
                                 global_thresh_seq_data);
    elsif the_thresh_seq_id is not null then
      loggerDebug('Load Thresholds: thresh_seq_id =' || the_thresh_seq_id);
      loadThresholdsForThreshSeq(the_thresh_seq_id,
                                 a_edge_id,
                                 a_node_id,
                                 global_thresh_seq_data);
    end if;

    -- associate by edge
    if a_edge_id is not null then
      global_thresh_data_by_id(a_edge_id) := global_thresh_seq_data;
    elsif a_node_id is not null then
      global_thresh_data_by_id(a_node_id) := global_thresh_seq_data;
    end if;

    loggerDebug('Loading Static Data...Done');
  end;

  --------------------
  -- Load source data
  -- into an associative array , keyed on source_id
  -- (all sources)
  --------------------
  procedure loadSources is
    the_source_data      source_data;
    the_source_type_data source_type_data;

    cursor source_data_cur is
      select src.source_id, src.name, srct.source_type_id, srct.description
        from source_ref src, source_type_ref srct
       where src.source_type_id = srct.source_type_id;

    cursor source_type_data_cur is
      select srct.source_type_id, srct.source_type, srct.description
        from source_type_ref srct;

  begin

    global_source_data_array.delete();
    global_source_type_data_array.delete();

    open source_data_cur;
    while true loop
      fetch source_data_cur
        into the_source_data;
      if source_data_cur%NOTFOUND then
        close source_data_cur;
        exit;
      else
        global_source_data_array(the_source_data.source_id) := the_source_data;
      end if;
    end loop;

    open source_type_data_cur;
    while true loop
      fetch source_type_data_cur
        into the_source_type_data;
      if source_type_data_cur%NOTFOUND then
        close source_type_data_cur;
        exit;
      else
        global_source_type_data_array(the_source_type_data.source_type_id) := the_source_type_data;
      end if;
    end loop;

  end;

  /*
    load up the threshold_day_date data array
  */
  procedure loadThresholdsForThreshDef(a_thresh_def_id            number,
                                       a_edge_id                  number,
                                       a_node_id                  number,
                                       a_order                    number,
                                       a_threshold_seq_data_array IN OUT NOCOPY threshold_seq_data_array) is
    cursor thresh_dates_cur(act_thresh_ver_id number) is
      select tvr.threshold_version_id,
             trunc(edr.exception_date) + (from_time / 86400) as from_date,
             trunc(edr.exception_date) + (to_time / 86400) as to_date
        from imm.date_threshold_ref datetr
       inner join imm.exception_date_ref edr
          on (datetr.exception_date_id = edr.exception_date_id)
       inner join imm.threshold_version_ref tvr
          on (tvr.threshold_version_id = datetr.threshold_version_id)
         and tvr.threshold_version_id = act_thresh_ver_id;

    cursor thresh_days_cur(act_thresh_ver_id number) is
      select tvr.threshold_version_id,
             wdr.day,
             daytr.from_time,
             daytr.to_time
        from imm.day_threshold_ref daytr
       inner join imm.week_day_ref wdr
          on (daytr.day_id = wdr.day_id)
       inner join imm.threshold_version_ref tvr
          on (tvr.threshold_version_id = daytr.threshold_version_id)
         and tvr.threshold_version_id = act_thresh_ver_id;

    -- sources
    cursor source_ids_cur(act_thresh_ver_id number) is
      select source_id
        from source_threshold_jn stj
       where stj.threshold_version_id = act_thresh_ver_id;

    -- source types
    cursor source_type_ids_cur(act_thresh_ver_id number) is
      select source_type_id
        from source_type_thld_jn sttj
       where sttj.threshold_version_id = act_thresh_ver_id;

    -- severity data
    cursor thresh_severities(act_thresh_ver_id number) is
      select tsr.severity_id,
             tsr.priority_id,
             tsr.value,
             tsr.operator,
             tsr.raise_issue,
             str.state_id,
             tsr.issue_type_id,
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

    -- edr sub-types
    cursor edr_sub_type_ids_cur(act_thresh_ver_id number) is
      select esttj.edr_sub_type_id
        from edr_sub_type_threshold_jn esttj
       where esttj.threshold_version_id = act_thresh_ver_id;

    -- edr types
    cursor edr_type_ids_cur(act_thresh_ver_id number) is
      select ettj.edr_type_id
        from edr_type_threshold_jn ettj
       where ettj.threshold_version_id = act_thresh_ver_id;

    the_threshold_date_data threshold_date_data;
    the_thresh_date_array   threshold_date_array;
    the_threshold_day_data  threshold_day_data;
    the_thresh_day_array    threshold_day_array;

    the_source_ids_array       source_id_array;
    the_source_type_ids_array  source_type_id_array;
    the_edr_sub_type_ids_array edr_sub_type_id_array;
    the_edr_type_ids_array     edr_type_id_array;
    temp_id                    number;

    the_threshold_def_data       threshold_def_data;
    the_threshold_sev_data       threshold_sev_data;
    the_threshold_sev_data_array threshold_sev_data_array;
    counter                      pls_integer;

    active_threshold_version_id    number;
    active_threshold_definition_id number;
    thresh_def_name                varchar2(150);
    thresh_def_type                varchar2(50);

  begin
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
        return;
    end;

    /*
    loggerDebug('active_threshold_version_id: ' || active_threshold_version_id);
    loggerDebug('active_threshold_definition_id: ' || active_threshold_definition_id);
    loggerDebug('thresh_def_name: ' || thresh_def_name);
    */

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

    -- sources
    open source_ids_cur(active_threshold_version_id);
    while true loop
      fetch source_ids_cur
        into temp_id;
      if source_ids_cur%NOTFOUND then
        close source_ids_cur;
        exit;
      else
        the_source_ids_array(temp_id) := temp_id;
      end if;
    end loop;

    -- source types
    open source_type_ids_cur(active_threshold_version_id);
    while true loop
      fetch source_type_ids_cur
        into temp_id;
      if source_type_ids_cur%NOTFOUND then
        close source_type_ids_cur;
        exit;
      else
        --counter:=counter+1;
        the_source_type_ids_array(temp_id) := temp_id;
      end if;
    end loop;

    -- edr sub-types
    open edr_sub_type_ids_cur(active_threshold_version_id);
    while true loop
      fetch edr_sub_type_ids_cur
        into temp_id;
      if edr_sub_type_ids_cur%NOTFOUND then
        close edr_sub_type_ids_cur;
        exit;
      else
        the_edr_sub_type_ids_array(temp_id) := temp_id;
      end if;
    end loop;

    -- edr sub-types
    open edr_type_ids_cur(active_threshold_version_id);
    while true loop
      fetch edr_type_ids_cur
        into temp_id;
      if edr_type_ids_cur%NOTFOUND then
        close edr_type_ids_cur;
        exit;
      else
        the_edr_type_ids_array(temp_id) := temp_id;
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

    the_threshold_def_data.edge_id := a_edge_id;
    if a_edge_id is not null then
      -- edge_name
      begin
        select er.name
          into the_threshold_def_data.edge_name
          from dgf.edge_ref er
         where er.edge_id = a_edge_id;
      exception
        when no_data_found then
          the_threshold_def_data.edge_name := 'N/A';
      end;
    end if;

    the_threshold_def_data.node_id := a_node_id;
    if a_node_id is not null then
      -- node_name
      begin
        select nr.name
          into the_threshold_def_data.node_name
          from dgf.node_ref nr
         where nr.node_id = a_node_id;
      exception
        when no_data_found then
          the_threshold_def_data.node_name := 'N/A';
      end;
    end if;

    the_threshold_def_data.active_tv_id        := active_threshold_version_id;
    the_threshold_def_data.active_td_id        := active_threshold_definition_id;
    the_threshold_def_data.threshold_name      := thresh_def_name;
    the_threshold_def_data.threshold_type_name := thresh_def_type;
    -- day/dates
    the_threshold_def_data.day_data  := the_thresh_day_array;
    the_threshold_def_data.date_data := the_thresh_date_array;
    -- source stuff
    the_threshold_def_data.source_ids      := the_source_ids_array;
    the_threshold_def_data.source_type_ids := the_source_type_ids_array;
    -- edr stuff
    the_threshold_def_data.edr_sub_type_ids := the_edr_sub_type_ids_array;
    the_threshold_def_data.edr_type_ids     := the_edr_type_ids_array;

    -- thresh_version fields
    begin
      -- get tvr_description and is_comparator
      with filtered_attributes as
       (select *
          from imm.threshold_version_attr t
         where t.attribute_id = thresholdComparatorId)
      select tvr.description, fa.value
        into the_threshold_def_data.tvr_description,
             the_threshold_def_data.tvr_is_comparator
        from imm.threshold_version_ref tvr
       inner join filtered_attributes fa
          on fa.threshold_version_id = tvr.threshold_version_id
         and tvr.threshold_version_id = active_threshold_version_id;
    exception
      when no_data_found then
        the_threshold_def_data.tvr_description   := 'N/A';
        the_threshold_def_data.tvr_is_comparator := 'Y'; -- default to comparable if no active threshold version found
    end;
    -- thresh_version fields
    begin
      -- get 'min level' at which this threshold is applicable
      with filtered_attributes as
       (select *
          from imm.threshold_version_attr t
         where t.attribute_id = thresholdMinLevelId)
      select fa.value
        into the_threshold_def_data.tvr_min_level
        from imm.threshold_version_ref tvr
       inner join filtered_attributes fa
          on fa.threshold_version_id = tvr.threshold_version_id
         and tvr.threshold_version_id = active_threshold_version_id;

    exception
      when no_data_found then
        the_threshold_def_data.tvr_min_level := null; -- ??
    end;

    -- thresh_sev_data
    the_threshold_def_data.severity_data := the_threshold_sev_data_array;

    -- add this threshold_def_data to threshold_def_data assoc. array
    -- indexed against order_num
    --global_thresh_seq_data(a_order) := the_threshold_def_data;
    a_threshold_seq_data_array(a_order) := the_threshold_def_data;

  end;

  procedure loadThresholdsForThreshSeq(a_thresh_seq_id            number,
                                       a_edge_id                  number,
                                       a_node_id                  number,
                                       a_threshold_seq_data_array IN OUT NOCOPY threshold_seq_data_array) is

    cursor threshold_defs is
      select threshold_definition_id, order_no
        from imm.threshold_sequence_jn
       where threshold_sequence_id = a_thresh_seq_id
       order by order_no asc;

    thresh_def_id number;
    v_order       number;
  begin
    open threshold_defs;
    while true loop

      fetch threshold_defs
        into thresh_def_id, v_order;
      if threshold_defs%NOTFOUND then
        close threshold_defs;
        exit;
      else
        loadThresholdsForThreshDef(thresh_def_id,
                                   a_edge_id,
                                   a_node_id,
                                   v_order,
                                   a_threshold_seq_data_array);

      end if;

    end loop;
  end;

  /******************************************************************
  * END
  * Initialisation:
  *

  * This section contains initialisation code called at the start of
  * and metric operation
  *******************************************************************/

  /******************************************************************
  * START
  * Thresholds:
  *
  * This section contains code relating to testing of thresholds
  *******************************************************************/

  ----------------------------------------------
  -- Return severity_data, if threshold is breached
  -- (severity, issue_start_state, issue_start_user)
  --
  -- return null if threshold not breached --
  ----------------------------------------------
  function getSeverityIfBreachedValue(a_metric_return_value metric_return_value,
                                      a_last_value_data     last_value_data)
    return severity_data is
    the_threshold_sev_data_array threshold_sev_data_array;
    the_last_value               last_value;
    severity_data_ret            severity_data := null;
    counter                      pls_integer;

    v_metric_value number;
    v_i_value      number;
    v_j_value      number;

  begin
    the_threshold_sev_data_array := global_current_thresh_def_data.severity_data;
    severity_data_ret            := null;

    -- the value we test against the threshold
    v_metric_value := a_metric_return_value.threshold_value;

    -- if there is a MIN_APPLICABLE_LEVEL for the active threshold
    -- then test first. The rule is:
    -- Do not test for a breach if
    -- ABS ( MIN ( i_value, NVL( j_value, i_value ) ) ) < ABS ( MIN_APPLICABLE_LEVEL)
    if global_current_thresh_def_data.tvr_min_level is not null then
      v_i_value := a_metric_return_value.i_value;
      v_j_value := a_metric_return_value.j_value;
      if abs(least(v_i_value, nvl(v_j_value, v_i_value))) <
         abs(global_current_thresh_def_data.tvr_min_level) then
        loggerDebug('Metric value is lower than the MIN_APPLICABLE_LEVEL for this threshold definition');
        return null;
      end if;
    end if;

    counter := the_threshold_sev_data_array.FIRST;

    --  A "LAST VALUE" comparison (if we have a_last_value_data.d_period_id)
    if a_last_value_data.d_period_id is not null then

      the_last_value := getLastValue(a_last_value_data);

      if the_last_value.last_metric_id is null then
        -- no threshold breached
        --loggerDebug('No Last Value found');
        return null;
      end if;

      -- loop through the thresh seq. testing for a breach
      -- this should loop in order of highest importance order_as_counter
      while (counter is not null) loop
        global_current_thresh_sev_data := the_threshold_sev_data_array(counter);

        if executeOpRelative(global_current_thresh_sev_data.operator,
                             v_metric_value,
                             the_last_value.last_metric_value,
                             global_current_thresh_sev_data.value,
                             global_current_thresh_def_data.threshold_type_name) then
          --loggerDebug('Breached!');
          severity_data_ret.severity_id            := global_current_thresh_sev_data.severity_id;
          severity_data_ret.priority_id            := global_current_thresh_sev_data.priority_id;
          severity_data_ret.issue_start_state_id   := global_current_thresh_sev_data.start_state_id;
          severity_data_ret.issue_start_issue_type := global_current_thresh_sev_data.start_issue_type_id;
          severity_data_ret.issue_start_group_id   := global_current_thresh_sev_data.start_group_id;
          severity_data_ret.issue_start_user_id    := global_current_thresh_sev_data.start_user_id;
          severity_data_ret.threshold_breached     := true;
          severity_data_ret.raise_issue            := global_current_thresh_sev_data.raise_issue;
          severity_data_ret.last_metric_id         := the_last_value.last_metric_id;
          severity_data_ret.last_metric_value      := the_last_value.last_metric_value;
          -- done
          return severity_data_ret;
        end if;

        counter := the_threshold_sev_data_array.NEXT(counter);
      end loop;

      return severity_data_ret;
    end if;

    --  NOT A "LAST VALUE" comparison
    if a_last_value_data.d_period_id is null then
      while (counter is not null) loop
        global_current_thresh_sev_data := the_threshold_sev_data_array(counter);

        if executeOp(global_current_thresh_sev_data.operator,
                     v_metric_value,
                     global_current_thresh_sev_data.value) then
          severity_data_ret.severity_id            := global_current_thresh_sev_data.severity_id;
          severity_data_ret.priority_id            := global_current_thresh_sev_data.priority_id;
          severity_data_ret.issue_start_state_id   := global_current_thresh_sev_data.start_state_id;
          severity_data_ret.issue_start_issue_type := global_current_thresh_sev_data.start_issue_type_id;
          severity_data_ret.issue_start_group_id   := global_current_thresh_sev_data.start_group_id;
          severity_data_ret.issue_start_user_id    := global_current_thresh_sev_data.start_user_id;
          severity_data_ret.threshold_breached     := true;
          severity_data_ret.raise_issue            := global_current_thresh_sev_data.raise_issue;
          severity_data_ret.last_metric_id         := null;
          severity_data_ret.last_metric_value      := null;
          -- done
          return severity_data_ret;
        end if;

        counter := the_threshold_sev_data_array.NEXT(counter);
      end loop;
      return severity_data_ret;
    end if;

    return severity_data_ret;

  end;

  /********
  * Returns the last comparable metric value.
  * Convenience function for getLastValue(last_value_data)
  ********/
  function getLastValue(a_d_period_id date,
                        a_node_id integer,
                        a_edge_id integer,
                        a_source_id integer,
                        a_source_type_id integer,
                        a_metric_operator_id integer,
                        a_metric_definition_id integer,
                        a_operator_order integer) return number is
    the_last_value last_value;
    the_last_value_data last_value_data;
  begin
    the_last_value_data.d_period_id := a_d_period_id;
    the_last_value_data.node_id := a_node_id;
    the_last_value_data.edge_id := a_edge_id;
    the_last_value_data.source_id := a_source_id;
    the_last_value_data.source_type_id := a_source_type_id;
    the_last_value_data.metric_operator_id := a_metric_operator_id;
    the_last_value_data.metric_definition_id := a_metric_definition_id;
    the_last_value_data.operator_order := a_operator_order;

    the_last_value := getLastValue(the_last_value_data);
    return the_last_value.last_metric_value;
  end;

  /**********
  * Look for a last comparable metric value.
  *
  * First check one week ago within +- 30 mins
  * if not found check two weeks ago within +- 30 mins
  * if not found check three weeks ago within +- 30 mins
  * if not found check four weeks ago within +- 30 mins
  *
  * If no last value found return null
  ********/
  function getLastValue(a_last_value_data last_value_data) return last_value is
    the_last_value last_value;
  begin

    the_last_value := getLastValueAux(a_last_value_data,
                                      (a_last_value_data.d_period_id -
                                      ONE_WEEK_AND_30_MINS),
                                      (a_last_value_data.d_period_id -
                                      ONE_WEEK_LESS_30_MINS));

    if the_last_value.last_metric_id is not null then
      return the_last_value;
    end if;

    the_last_value := getLastValueAux(a_last_value_data,
                                      a_last_value_data.d_period_id -
                                      TWO_WEEKS_AND_30_MINS,
                                      a_last_value_data.d_period_id -
                                      TWO_WEEKS_LESS_30_MINS);

    if the_last_value.last_metric_id is not null then
      return the_last_value;
    end if;

    the_last_value := getLastValueAux(a_last_value_data,
                                      a_last_value_data.d_period_id -
                                      THREE_WEEKS_AND_30_MINS,
                                      a_last_value_data.d_period_id -
                                      THREE_WEEKS_LESS_30_MINS);

    if the_last_value.last_metric_id is not null then
      return the_last_value;
    end if;

    the_last_value := getLastValueAux(a_last_value_data,
                                      a_last_value_data.d_period_id -
                                      FOUR_WEEKS_AND_30_MINS,
                                      a_last_value_data.d_period_id -
                                      FOUR_WEEKS_LESS_30_MINS);

    return the_last_value;

  end;

  /**********
  * Look for a last comparable metric value.
  * Within the specified range
  *
  * If no last value found return null
  ********/
  function getLastValueAux(a_last_value_data last_value_data,
                           from_date         date,
                           to_date           date) return last_value is
    the_last_value last_value;
  begin

    begin
      select metric, f_metric_id
        into the_last_value
        from f_metric fm
       where fm.metric_definition_id =
             a_last_value_data.metric_definition_id
         and fm.d_period_id between from_date and to_date
         and (a_last_value_data.node_id is null OR
             fm.d_node_id = a_last_value_data.node_id)
         and (a_last_value_data.edge_id is null OR
             fm.d_edge_id = a_last_value_data.edge_id)
         and fm.is_comparator = 'Y'
         and (a_last_value_data.source_id is null OR
             fm.d_source_id = a_last_value_data.source_id)
         and (a_last_value_data.source_type_id is null OR EXISTS
              (select source_id
                 from source_ref
                where source_type_id = a_last_value_data.source_type_id))
            -- assume operator_order = 1 for now TODO
            --          and
            --               fm.operator_order = a_last_value_data.operator_order
         and rownum = 1;

    exception
      when no_data_found then
        the_last_value := null;

    end;

    return the_last_value;
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

    --loggerDebug('Stmt: ' || stmt);

    execute immediate stmt
      into retval;

    if retval > 0 then
      return true;
    else
      return false;
    end if;
  end;

  -----------------------------------------
  -- execute binary operator two with lvalues
  -- eg
  -- if optype = 'Percent' then
  --     if (  -1 + lval2/lval1  ) 'op' rval then return TRUE
  --
  -- if optype = 'Absoulte' then
  --     if ( lval2 - lval1 ) 'op' rval then return TRUE
  --
  -----------------------------------------
  function executeOpRelative(op     varchar2,
                             lval1  number,
                             lval2  number,
                             rval   number,
                             optype varchar2) return boolean deterministic is
    retval number;
    lval   number;
    stmt   varchar2(1000);
  begin

    if optype = 'Percentage' then
      if lval1 is null then
        forceMsg(-99,'lval1 (i side) is null - returning true');
        return true;
      elsif lval2 is null then
        forceMsg(-99,'lval2 (j side) is null - returning true');
        return true;
      elsif lval2 = 0 then
        return true;
      else
        lval := (lval1 / lval2) - 1;
      end if;
    elsif optype = 'Absolute' then
      lval := lval2 - lval1;
    else
      -- shouldn't happen
      loggerAuto('Unknown optype: ' || optype);
      return false;
    end if;

    stmt := 'select nvl((select 1 from dual where ' || to_char(lval) || op ||
            to_char(rval) || '), 0) from dual';

    execute immediate stmt
      into retval;

    if retval > 0 then
      return true;
    else
      return false;
    end if;

  exception
    -- shouldn't happen
    when zero_divide then
      return true;
  end;

  /****
  * Set the value to which we will test the threshold
  * set any forecast data if required
  ****/
  procedure forecastAdjustment(a_metric_return_value    IN OUT NOCOPY metric_return_value,
                               a_forecast_metric_id     number,
                               a_node_id                number,
                               a_edge_id                number,
                               a_source_id              number,
                               grouping_edr_type_id     number,
                               grouping_edr_sub_type_id number,
                               a_d_period               date,
                               a_source_type_id         number) is
  begin

    if a_forecast_metric_id is null then
      -- ie not a forecast metric
      a_metric_return_value.threshold_value := a_metric_return_value.metric_value;
      a_metric_return_value.compare_value   := null;
      a_metric_return_value.forecast_value  := null;
      return;
    else
      -- get the forecast for this metric/edge/src/d_period

      -- VFI-UM: we call the customer version here instead of the out-of-the-box version. reason: it is possible to get
      -- multiple forecasts covering the same time period. the default getforecast() function retrieves an average of
      -- these values. for vfi, because we use time based metrics, we want to return a sum() of only the latest forecasts
      -- for the specified node and sources.

      a_metric_return_value.forecast_value := customer.forecasting.getForecast(a_forecast_metric_id,
                                                                      a_node_id,
                                                                      a_edge_id,
                                                                      a_source_id,
                                                                      grouping_edr_type_id,
                                                                      grouping_edr_sub_type_id,
                                                                      a_d_period,
                                                                      a_source_type_id);

      --loggerAuto('After Profile: forecastValue: '||a_metric_return_value.forecast_value);

      if a_metric_return_value.forecast_value is not null then
        /*
        * Either:
        * take the percentage difference between the forecast and the metric value
        * as the threshold compare value -- this is the DEFAULT method
        * (Ignoring (filter out) any divide-by-zero errors)
        *
        * OR
        * take the absolute difference between the forecast and the metric value
        */

        if global_parameters('-forecast_type') = 'absolute' then
          if a_metric_return_value.metric_value is not null then
            a_metric_return_value.compare_value   := abs(a_metric_return_value.metric_value -
                                                         a_metric_return_value.forecast_value);
            a_metric_return_value.threshold_value := a_metric_return_value.compare_value;
          else
            a_metric_return_value.compare_value   := null;
            a_metric_return_value.threshold_value := null;
          end if;
        else
          -- this is -forecast_type = 'percent'
          if a_metric_return_value.metric_value is not null and
             a_metric_return_value.metric_value != 0 then

            if a_metric_return_value.forecast_value is not null and
               a_metric_return_value.forecast_value != 0 then

              a_metric_return_value.compare_value := (a_metric_return_value.metric_value -
                                                     a_metric_return_value.forecast_value) /
                                                     a_metric_return_value.forecast_value;
            else
              a_metric_return_value.compare_value := (a_metric_return_value.metric_value -
                                                     a_metric_return_value.forecast_value) /
                                                     a_metric_return_value.metric_value;

            end if;
            a_metric_return_value.threshold_value := a_metric_return_value.compare_value;
          else
            a_metric_return_value.compare_value   := null;
            a_metric_return_value.threshold_value := null;
          end if;
        end if;
      else
        a_metric_return_value.compare_value   := null;
        a_metric_return_value.threshold_value := null;
      end if;

    end if;

  end;

  function raiseIssueIfBreached(a_threshold_version_id number,
                                a_metric_return_value  metric_return_value,
                                sample_date            date,
                                d_period_id            date,
                                metric_id              number,
                                a_metric_def_id        number,
                                a_edge_id              number,
                                a_node_id              number,
                                a_source_id            number,
                                a_source_type_id       number,
                                a_edr_type_id          number,
                                a_edr_sub_type_id      number,
                                regen_metric_id        number,
                                a_i_fileset_id         number,
                                a_j_fileset_id         number,
                                a_last_value_data      last_value_data)
    return severity_data as

    the_severity_data severity_data;
    issue_id          number;
    dummy_id          number;
    note_text         varchar2(4000);

    sourceName     varchar2(100);
    sourceTypeName varchar2(100);

    the_source_data      source_data;
    the_source_type_data source_type_data;

    issue_date_raised date;

    issue_attrs imm.issues.bin_array;

    METRIC_DEFINITION_ATTR_ID constant integer := 35000;
    EDGE_ATTR_ID              constant integer := 35010;
    NODE_ATTR_ID              constant integer := 35012;
    SOURCE_ATTR_ID            constant integer := 35016;
    SOURCE_TYPE_ATTR_ID       constant integer := 35018;
    EDR_SUBTYPE_ATTR_ID       constant integer := 35020;
    EDR_TYPE_ATTR_ID          constant integer := 35022;
    SAMPLE_DATE_ATTR_ID       constant integer := 35024;
    I_FILESET_ID              constant integer := 35026;
    J_FILESET_ID              constant integer := 35028;

    v_element_name            varchar2(500);
    
  begin
    -- the 'compare value will be the metric for non-forecast operators
    -- or the value of abs(forecast - metric) for forecast operators
    the_severity_data := getSeverityIfBreachedValue(a_metric_return_value,
                                                    a_last_value_data);

    if the_severity_data.raise_issue = 'Y' then
      --loggerDebug('issue detected');

      issue_date_raised := sysdate;

      -- RAISE IT in IMM!
      issue_attrs(METRIC_DEFINITION_ATTR_ID) := a_metric_def_id;
      issue_attrs(SAMPLE_DATE_ATTR_ID) := to_char(sample_date, 'Dy, DD FMMonth YYYY');

      if a_edge_id is not null then
        issue_attrs(EDGE_ATTR_ID) := a_edge_id;
        
        begin 
          select name
          into   v_element_name
          from   dgf.edge_ref
          where  edge_id = a_edge_id;        
        exception
          when others then            
               v_element_name := '';
        end;
        
      end if;

      if a_node_id is not null then
        issue_attrs(NODE_ATTR_ID) := a_node_id;
       
       begin 
          select name
          into   v_element_name
          from   dgf.node_ref
          where  node_id = a_node_id;        
        exception
          when others then            
               v_element_name := '';
        end;            
        
      end if;

      if a_source_id is not null then
        issue_attrs(SOURCE_ATTR_ID) := a_source_id;
      end if;

      if a_source_type_id is not null then
        issue_attrs(SOURCE_TYPE_ATTR_ID) := a_source_type_id;
      end if;

      if a_edr_type_id is not null then
        issue_attrs(EDR_TYPE_ATTR_ID) := a_edr_type_id;
      end if;

      if a_edr_sub_type_id is not null then
        issue_attrs(EDR_SUBTYPE_ATTR_ID) := a_edr_sub_type_id;
      end if;

      if a_i_fileset_id is not null then
        issue_attrs(I_FILESET_ID) := a_i_fileset_id;
      end if;

      if a_j_fileset_id is not null then
        issue_attrs(J_FILESET_ID) := a_j_fileset_id;
      end if;

      -- insert the issue
      issue_id := IMM.Issues.insertIssue(the_severity_data.issue_start_issue_type,
                                         the_severity_data.severity_id,
                                         the_severity_data.priority_id,
                                         NVL(v_element_name || ': ' || global_metric_definition_name,
                                             global_operator_desc
                                             ),
                                         raisedByUserId, --admin CONSTANT
                                         the_severity_data.issue_start_group_id,
                                         the_severity_data.issue_start_user_id,
                                         issue_date_raised,
                                         null,
                                         issueAttrs => issue_attrs);

      -- if DAILY ISSUE LIMIT breached
      -- then return immediately
      -- THIS shouldn't happen as we now call insertIssueNoLimitCheck()
      if issue_id = IMM.Issues.DAILY_LIMIT_BREACH_FLAG then
        the_severity_data.issue_raised := 'N';
        return the_severity_data;
      else
        the_severity_data.issue_raised := 'Y';
      end if;

      -- Add Metric Note
      begin
        the_source_data      := global_source_data_array(a_source_id);
        sourceName           := the_source_data.source_name;
        the_source_type_data := global_source_type_data_array(a_source_type_id);
        sourceTypeName       := the_source_type_data.source_type_name;
      exception
        when value_error then
          sourceName     := '';
          sourceTypeName := '';
      end;

      -- I think the compiler should be able to optimize this string construction
      -- ( ie no value in defining the component strings as constants )
      note_text := '<tr><td><table>' ||
                   '<tr><td><a href="/web/selectEntityProcess.do?entityId=36004' || '&' ||
                   'hidden_filters=F_METRIC_ID,' || metric_id || '">' ||
                   'View Metric Files</a></td></tr><tr><td colspan="2"></td></tr>' ||
                   '<tr><td colspan="2"><b>Source Details</b></td></tr><tr><td>Source:</td><td>' ||
                   sourceName || '</td></tr><tr><td>Source Type:</td><td>' ||
                   sourceTypeName;

      if global_current_thresh_def_data.edge_name is not null then
        note_text := note_text || '</td></tr><tr><td>Edge:</td><td>' ||
                     global_current_thresh_def_data.edge_name;
      elsif global_current_thresh_def_data.node_name is not null then
        note_text := note_text || '</td></tr><tr><td>Node:</td><td>' ||
                     global_current_thresh_def_data.node_name;
      end if;

      note_text := note_text || '</td></tr><tr><td>' || '&' || 'nbsp;' ||
                   '</td></tr><tr><td colspan="2"><b>Threshold Details</b></td></tr><tr><td>Threshold Name:</td><td>' ||
                   global_current_thresh_def_data.threshold_name ||
                   '</td></tr><tr><td>Threshold Type:</td><td>' ||
                   global_current_thresh_def_data.threshold_type_name ||
                   '</td></tr><tr><td>Threshold Version Id:</td><td>' ||
                   a_threshold_version_id ||
                   '</td></tr><tr><td nowrap>Threshold Breach Criteria:' || '&' ||
                   'nbsp;' || '&' || 'nbsp;' || '&' || 'nbsp;' || '&' ||
                   'nbsp;' || '&' || 'nbsp;' || '&' || 'nbsp;' || '&' ||
                   'nbsp;</td><td>' ||
                   global_current_thresh_sev_data.operator || '&' ||
                   'nbsp;' || global_current_thresh_sev_data.value ||
                   '</td></tr><tr><td>' || '&' ||
                   'nbsp;</td></tr><tr><td colspan="2"><b>Metric Details</b></td></tr><tr><td>Metric Name:</td><td>' ||
                   global_metric_definition_name ||
                   '</td></tr><tr><td>Metric Id:</td><td>' || metric_id;

      if the_severity_data.last_metric_id is not null then
        note_text := note_text ||
                     '</td></tr><tr><td>Previous Metric Id:</td><td>' ||
                     the_severity_data.last_metric_id ||
                     '</td></tr><tr><td>Previous Metric Value:</td><td>' ||
                     the_severity_data.last_metric_value;
      end if;

      note_text := note_text || '</td></tr>' ||
                   '<tr><td>i Fileset:</td><td><a href="/web/emInit.do?emId=35300' || '&' ||
                   'filter_35301=' || a_i_fileset_id || '">' ||
                   a_i_fileset_id || '</a></td></tr>' ||
                   '<tr><td>j Fileset:</td><td><a href="/web/emInit.do?emId=35300' || '&' ||
                   'filter_35301=' || a_j_fileset_id || '">' ||
                   a_j_fileset_id || '</a></td></tr>';

      note_text := note_text || '<tr><td>I Value:</td><td>' ||
                   a_metric_return_value.i_value ||
                   '</td></tr><tr><td>J Value:</td><td>' ||
                   a_metric_return_value.j_value ||
                   '</td></tr><tr><td>Raw Value:</td><td>' ||
                   a_metric_return_value.raw_value ||
                   '</td></tr><tr><td>Metric:</td><td>' ||
                   a_metric_return_value.metric_value;

      if a_metric_return_value.forecast_value is not null then
        note_text := note_text ||
                     '</td></tr><tr><td>Forecast Value:</td><td>' ||
                     a_metric_return_value.forecast_value ||
                     '</td></tr><tr><td>Forecast Difference:</td><td>' ||
                     a_metric_return_value.compare_value * 100 || '%';

      end if;

      note_text := note_text || '</td></tr><tr><td>Sample Date:</td><td>' ||
                   to_char(sample_date, 'Dy, DD FMMonth YYYY') || to_char(sample_date, ' HH24:MI:SS') ||
                   '</td></tr><tr><td>Raised By:</td><td>' || raisedByUser || -- raised by
                   '</td></tr><tr><td>UM Creation Date:</td><td>' ||
                   to_char(issue_date_raised, 'Dy, DD FMMonth YYYY') || to_char(issue_date_raised, ' HH24:MI:SS') ||
                   '</td></tr><tr><td>' || '&' ||
                   'nbsp;</td></tr></table></td></tr>';

      -- add the note
      IMM.Issues.addNote(issue_id,
                         raisedByUserId,
                         metricNoteTypeId,
                         note_text,
                         null,
                         null);

      -- just to avoid compile warnings
      dummy_id := regen_metric_id;
      -- if this is a regen metric, then link to previous (now closed) metric
      --if regen_metric_id is not null then
      --   IMM.Issues.linkIssues(issue_id, regen_metric_id);
      --end if;

      -- insert into (temp) metric_issue_jn table
      if regen_metric_id is null then
        insert into temp_metric_issue_jn
          (d_period_id,
           f_metric_id,
           issue_id,
           date_raised,
           metric_definition_id,
           edge_id,
           node_id,
           issue_status)
        values
          (d_period_id,
           metric_id,
           issue_id,
           issue_date_raised,
           a_metric_def_id,
           a_edge_id,
           a_node_id,
           'O');
      else
        -- it's a regen - use regen temp tables
        insert into temp_metric_issue_jn_regen
          (d_period_id,
           f_metric_id,
           issue_id,
           date_raised,
           metric_definition_id,
           edge_id,
           node_id,
           issue_status)
        values
          (d_period_id,
           metric_id,
           issue_id,
           issue_date_raised,
           a_metric_def_id,
           a_edge_id,
           a_node_id,
           'O');
      end if;

      return the_severity_data;
    end if;

    return the_severity_data;
  end;

  function getNewThresholdVersionId(edge_or_node_id         number,
                                    current_source_id       number,
                                    current_source_type_id  number,
                                    current_date            date,
                                    current_edr_type_id     number,
                                    current_edr_sub_type_id number)
    return number deterministic as
    the_threshold_seq_data_array threshold_seq_data_array;
    v_threshold_version_id       integer;
    order_as_counter             pls_integer;
  begin

    v_threshold_version_id := null;

    begin
      global_current_thresh_def_data := null;
      -- get threshdata for this edge/node
      the_threshold_seq_data_array := global_thresh_data_by_id(edge_or_node_id);

      -- loop through the thresh seq data
      --v_threshold_version_id := the_threshold_seq_data_array.FIRST;
      order_as_counter := the_threshold_seq_data_array.FIRST;

      --while (v_threshold_version_id is not null) loop
      while (order_as_counter is not null) loop

        --the_threshold_def_data := the_threshold_seq_data_array(v_threshold_version_id);
        --global_current_thresh_def_data := the_threshold_seq_data_array(v_threshold_version_id);
        global_current_thresh_def_data := the_threshold_seq_data_array(order_as_counter);

        -- get the threshold_version_id of this threshold
        v_threshold_version_id := global_current_thresh_def_data.active_tv_id;

        -- contained in exception dates?
        if validForDates(global_current_thresh_def_data.date_data,
                         current_date) then
          if validForSources(global_current_thresh_def_data,
                             current_source_id,
                             current_source_type_id) then
            if validForEdrs(global_current_thresh_def_data,
                            current_edr_type_id,
                            current_edr_sub_type_id) then
              return v_threshold_version_id;
            end if;
          end if;

        end if;

        -- contained in days?
        if validForDays(global_current_thresh_def_data.day_data,
                        current_date) then
          if validForSources(global_current_thresh_def_data,
                             current_source_id,
                             current_source_type_id) then
            if validForEdrs(global_current_thresh_def_data,
                            current_edr_type_id,
                            current_edr_sub_type_id) then
              return v_threshold_version_id;
            end if;
          end if;
        end if;

        -- always valid?
        if alwaysValid(global_current_thresh_def_data.date_data,
                       global_current_thresh_def_data.day_data) then
          if validForSources(global_current_thresh_def_data,
                             current_source_id,
                             current_source_type_id) then
            if validForEdrs(global_current_thresh_def_data,
                            current_edr_type_id,
                            current_edr_sub_type_id) then
              return v_threshold_version_id;
            end if;
          end if;
        end if;

        order_as_counter := the_threshold_seq_data_array.NEXT(order_as_counter);
      end loop;

    exception
      when no_data_found then
        global_current_thresh_def_data := null;
        loggerAuto('Exception: ' || SUBSTR(SQLERRM, 1, 100));

      when value_error then
        global_current_thresh_def_data := null;
        loggerAuto('Exception: ' || SUBSTR(SQLERRM, 1, 100));

    end;

    -- no matching threshold version found
    return null;

  end;

  function validForSources(a_threshold_def_data   threshold_def_data,
                           current_source_id      number,
                           current_source_type_id number) return boolean
    deterministic as

  begin
    if (a_threshold_def_data.source_ids.COUNT = 0) and
       (a_threshold_def_data.source_type_ids.COUNT = 0) then
      return true;
    end if;

    return(a_threshold_def_data.source_ids.EXISTS(current_source_id)) OR(a_threshold_def_data.source_type_ids.EXISTS(current_source_type_id));
  end;

  -- function to determine if threshold is valid for threshold
  -- function to determine if threshold is valid for threshold
  function validForEdrs(a_threshold_def_data    threshold_def_data,
                        current_edr_type_id     number,
                        current_edr_sub_type_id number) return boolean
    deterministic as

  begin
    --loggerAuto('validForEdrs: a_threshold_def_data.edr_sub_type_ids.COUNT = ' || a_threshold_def_data.edr_sub_type_ids.COUNT);
    --loggerAuto('validForEdrs: a_threshold_def_data.edr_type_ids.COUNT = ' || a_threshold_def_data.edr_type_ids.COUNT);
    if (a_threshold_def_data.edr_sub_type_ids.COUNT = 0) and
       (a_threshold_def_data.edr_type_ids.COUNT = 0) then
      return true;
    end if;

    return(a_threshold_def_data.edr_type_ids.EXISTS(current_edr_type_id)) OR(a_threshold_def_data.edr_sub_type_ids.EXISTS(current_edr_sub_type_id));
  end;

  function validForDates(date_data     threshold_date_array,
                         creation_date date) return boolean deterministic as
    the_threshold_date_data threshold_date_data;
    counter                 pls_integer;

  begin

    counter := date_data.FIRST;
    while (counter is not null) loop
      the_threshold_date_data := date_data(counter);

      if (creation_date >= the_threshold_date_data.from_date) AND
         (creation_date <= the_threshold_date_data.to_date) then
        return true;
      end if;

      counter := date_data.NEXT(counter);
    end loop;

    return false;
  end;

  function validForDays(day_data threshold_day_array, creation_date date)
    return boolean deterministic as
    the_threshold_day_data threshold_day_data;
    counter                pls_integer;

    creation_date_seconds number;
    creation_date_day     varchar2(10);
  begin
    counter := day_data.FIRST;

    while (counter is not null) loop
      the_threshold_day_data := day_data(counter);

      creation_date_seconds := to_number(to_char(creation_date, 'SSSSS'));
      creation_date_day     := trim(to_char(creation_date, 'Day'));

      if (creation_date_day = the_threshold_day_data.t_day) then
        if (creation_date_seconds >= the_threshold_day_data.from_time) AND
           (creation_date_seconds <= the_threshold_day_data.to_time) then
          return true;
        end if;
      end if;

      counter := day_data.NEXT(counter);
    end loop;

    return false;

  end;

  function alwaysValid(date_data threshold_date_array,
                       day_data  threshold_day_array) return boolean
    deterministic as
    counter pls_integer;
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

  /******************************************************************
  * END
  * Thresholds:
  *
  * This section contains code relating to testing of thresholds
  *******************************************************************/

  /******************************************************************
  * START
  * Core Metric Calculation Entry:
  *
  * Metric operator entry points
  *******************************************************************/

  /*******
  * Merge temporary tables into concrete tables
  *****/
  function mergeResults(a_operator_id   number,
                        b_thread_id     number,
                        all_parameters  varchar2,
                        a_debug         varchar2,
                        ignore_deadlock varchar2) return varchar2

   as
    -- these max/min values are used to speed up the delete from fmo_fileset query
    min_fileset_id number;
    max_fileset_id number;

    -- to hide compile warnings
    dummy_params varchar2(10000);
    dummy_debug  varchar2(10);

    v_issue_count integer;

    v_count integer;

    regen_metric_issue_id number;
    issue_date_raised     date;
    issueExists           boolean;
    j                     NUMBER := 0;
    TYPE MemList IS TABLE OF metric_issue_jn.issue_id%TYPE;
    TYPE DateList IS TABLE OF metric_issue_jn.date_raised%TYPE;
    mi_id MemList;
    dr    DateList;

    cursor close_issue is
      select tmij.issue_id, tmij.date_raised
        from um.metric_issue_jn mij, um.temp_metric_issue_jn_regen tmij
       where mij.f_metric_id = tmij.f_metric_id
         and mij.d_period_id = tmij.d_period_id;

    deadlock_detected EXCEPTION;
    PRAGMA EXCEPTION_INIT(deadlock_detected, -60);

    no_statement_parsed EXCEPTION;
    PRAGMA EXCEPTION_INIT(no_statement_parsed, -1003);

    numeric_error EXCEPTION;
    PRAGMA EXCEPTION_INIT(numeric_error, -6502);

  begin

    -- to hide compile warnings (remove when no longer required)
    dummy_params := all_parameters;
    dummy_debug  := a_debug;

    -- set globals for logging purposes
    global_operator_id := a_operator_id;
    global_thread_id   := b_thread_id;

    loggerAuto('Beginning verbose debugging in mergeResults.');

    -- delete from fmo_metric_queue
    delete from fmo_metric_queue fsq
     where fsq.operator_id = a_operator_id
       and fsq.thread_id = b_thread_id;

    loggerAuto('Deleted entries from fmo_metric_queue.');

    -- if meta metric then aggregate metrics in temp tables before
    -- copying to concrete tables
    /*
        setParameters(all_parameters);


             if global_parameters('-meta_metric') = 'yes' then
                   calculateMetaMetric(the_metric_return_value,
                                       a_forecast_def_id,
                                       current_node_id,
                                       current_edge_id,
                                       regen_f_metric_id,
                                       regen_metric_issue_id,
                                       current_threshold_version_id,
                                       the_severity_data,
                                       summary_num_issues);
                 summary_num_metrics := 1;
             end if;
    */

    -- MERGE temp tables into concrete tables
    -- IF REGEN then MERGE temp tables into concrete table
    UPDATE um.f_metric fm
       SET (fm.threshold_version_id,
            fm.comparison,
            fm.is_issue,
            fm.is_comparator,
            fm.i_value,
            fm.j_value,
            fm.metric,
            fm.raw_value,
            fm.forecast_value,
            fm.i_fileset_id,
            fm.j_fileset_id) =
           (SELECT tfm.threshold_version_id,
                   tfm.comparison,
                   tfm.is_issue,
                   tfm.is_comparator,
                   tfm.i_value,
                   tfm.j_value,
                   tfm.metric,
                   tfm.raw_value,
                   tfm.forecast_value,
                   tfm.i_fileset_id,
                   tfm.j_fileset_id
              FROM um.temp_f_metric_regen tfm
             WHERE fm.f_metric_id = tfm.f_metric_id
               AND tfm.d_period_id = fm.d_period_id)
     WHERE exists (select tfm.d_period_id
              FROM um.temp_f_metric_regen tfm
             where tfm.d_period_id = fm.d_period_id
               AND tfm.f_metric_id = fm.f_metric_id);

    loggerAuto('Updated results in f_metric.');

    SELECT count(*)
      INTO v_count
      FROM temp_f_metric_regen tfm
     where not exists (select 1
              from f_metric fm
             where fm.f_metric_id = tfm.f_metric_id
               and fm.d_period_id = tfm.d_period_id);

    IF v_count > 0 THEN

      insert into f_metric
        (d_period_id,
         f_metric_id,
         d_metric_id,
         d_node_id,
         d_edge_id,
         d_source_id,
         source_type_id,
         d_billing_type_id,
         creation_date,
         sample_date,
         threshold_version_id,
         threshold_definition_id,
         metric_operator_id,
         operator_order,
         metric_definition_id,
         edr_type_id,
         edr_sub_type_id,
         i_value,
         j_value,
         raw_value,
         metric,
         comparison,
         is_issue,
         is_comparator,
         fmo_match_history_id,
         fmo_match_checksum)
        select tfm.d_period_id,
               tfm.f_metric_id,
               tfm.d_metric_id,
               tfm.d_node_id,
               tfm.d_edge_id,
               tfm.d_source_id,
               tfm.source_type_id,
               tfm.d_billing_type_id,
               tfm.creation_date,
               tfm.sample_date,
               tfm.threshold_version_id,
               tfm.threshold_definition_id,
               tfm.metric_operator_id,
               tfm.operator_order,
               tfm.metric_definition_id,
               tfm.edr_type_id,
               tfm.edr_sub_type_id,
               tfm.i_value,
               tfm.j_value,
               tfm.raw_value,
               tfm.metric,
               tfm.comparison,
               tfm.is_issue,
               tfm.is_comparator,
               tfm.fmo_match_history_id,
               tfm.fmo_match_checksum
          FROM temp_f_metric_regen tfm
         where not exists (select 1
                  from f_metric fm
                 where fm.f_metric_id = tfm.f_metric_id
                   and fm.d_period_id = tfm.d_period_id);

      loggerAuto('Inserted results into f_metric from regen');
    END IF;

    /*
      MERGE into f_metric fm
      USING (SELECT * FROM temp_f_metric_regen) tfm
      ON (fm.f_metric_id = tfm.f_metric_id and fm.d_period_id = tfm.d_period_id)
      WHEN MATCHED THEN
        UPDATE
           SET fm.threshold_version_id = tfm.threshold_version_id,
               fm.comparison           = tfm.comparison,
               fm.is_issue             = tfm.is_issue,
               fm.is_comparator        = tfm.is_comparator,
               fm.i_value              = tfm.i_value,
               fm.j_value              = tfm.j_value,
               fm.metric               = tfm.metric,
               fm.raw_value            = tfm.raw_value,
               fm.forecast_value       = tfm.forecast_value,
               fm.i_fileset_id         = tfm.i_fileset_id,
               fm.j_fileset_id         = tfm.j_fileset_id
      WHEN NOT MATCHED THEN
        INSERT
          (d_period_id,
           f_metric_id,
           d_metric_id,
           d_node_id,
           d_edge_id,
           d_source_id,
           source_type_id,
           d_billing_type_id,
           creation_date,
           sample_date,
           threshold_version_id,
           threshold_definition_id,
           metric_operator_id,
           operator_order,
           metric_definition_id,
           edr_type_id,
           edr_sub_type_id,
           i_value,
           j_value,
           raw_value,
           metric,
           comparison,
           is_issue,
           is_comparator,
           fmo_match_history_id,
           fmo_match_checksum)
        VALUES
          (tfm.d_period_id,
           tfm.f_metric_id,
           tfm.d_metric_id,
           tfm.d_node_id,
           tfm.d_edge_id,
           tfm.d_source_id,
           tfm.source_type_id,
           tfm.d_billing_type_id,
           tfm.creation_date,
           tfm.sample_date,
           tfm.threshold_version_id,
           tfm.threshold_definition_id,
           tfm.metric_operator_id,
           tfm.operator_order,
           tfm.metric_definition_id,
           tfm.edr_type_id,
           tfm.edr_sub_type_id,
           tfm.i_value,
           tfm.j_value,
           tfm.raw_value,
           tfm.metric,
           tfm.comparison,
           tfm.is_issue,
           tfm.is_comparator,
           tfm.fmo_match_history_id,
           tfm.fmo_match_checksum);
    */
    -- IF NOT REGEN then INSERT (append) temp tables into concrete table
    -- insert into f_metric
    INSERT /*+ APPEND  */
    into f_metric
      select * from temp_f_metric;

    loggerAuto('Inserted results into f_metric. ');

    UPDATE um.metric_issue_jn mij
       SET (mij.issue_id, mij.date_raised) =
           (SELECT tmij.issue_id, mij.date_raised
              FROM um.temp_metric_issue_jn_regen tmij
             WHERE mij.f_metric_id = tmij.f_metric_id
               AND mij.d_period_id = tmij.d_period_id)
     WHERE exists (select tmij.d_period_id
              FROM um.temp_metric_issue_jn_regen tmij
             where tmij.d_period_id = mij.d_period_id
               and mij.f_metric_id = tmij.f_metric_id);

    loggerAuto('Updated results in metric_issue_jn.');

    SELECT count(*)
      INTO v_count
      FROM temp_metric_issue_jn_regen tmij
     WHERE NOT EXISTS (select 'x'
              from metric_issue_jn mij
             where mij.f_metric_id = tmij.f_metric_id
               and mij.d_period_id = tmij.d_period_id);

    IF v_count > 0 THEN
      INSERT INTO um.metric_issue_jn
        (d_period_id,
         f_metric_id,
         issue_id,
         date_raised,
         metric_definition_id,
         edge_id,
         node_id,
         issue_status)
        SELECT tmij.d_period_id,
               tmij.f_metric_id,
               tmij.issue_id,
               tmij.date_raised,
               tmij.metric_definition_id,
               tmij.edge_id,
               tmij.node_id,
               tmij.issue_status
          FROM temp_metric_issue_jn_regen tmij
         WHERE NOT EXISTS (select 'x'
                  from metric_issue_jn mij
                 where mij.f_metric_id = tmij.f_metric_id
                   and mij.d_period_id = tmij.d_period_id);

      loggerAuto('Inserted results into metric_issue_jn from regen');
    END IF;
    /*

        -- IF REGEN then MERGE temp tables into concrete table
        MERGE into metric_issue_jn mij
        USING (SELECT * FROM temp_metric_issue_jn_regen) tmij
        ON (mij.f_metric_id = tmij.f_metric_id and mij.d_period_id = tmij.d_period_id)
        WHEN MATCHED THEN
          UPDATE
             SET mij.issue_id    = tmij.issue_id,
                 mij.date_raised = tmij.date_raised
        WHEN NOT MATCHED THEN
          INSERT
            (d_period_id,
             f_metric_id,
             issue_id,
             date_raised,
             metric_definition_id,
             edge_id,
             node_id)
          VALUES
            (tmij.d_period_id,
             tmij.f_metric_id,
             tmij.issue_id,
             tmij.date_raised,
             tmij.metric_definition_id,
             tmij.edge_id,
             tmij.node_id);
    */
    -- IF NOT REGEN then INSERT (append) temp tables into concrete table

    INSERT /*+ NOAPPEND NO_PARALLEL */
    into metric_issue_jn
      select * from temp_metric_issue_jn;

    loggerAuto('Inserted results into metric_issue_jn. ');

    v_issue_count := SQL%ROWCOUNT;

    open close_issue;

    FETCH close_issue BULK COLLECT
      INTO mi_id, dr;

    FOR j IN 1 .. mi_id.COUNT LOOP

      regen_metric_issue_id := mi_id(j);
      issue_date_raised     := dr(j);
      if (regen_metric_issue_id is not null and
         issue_date_raised is not null) then

        -- if this is a regeneration metric, then close any open issues
        -- associated with the original metric

        -- try to close any previous open metric issue
        --              loggerAuto('Okay lets try to close issue: '||regen_metric_issue_id||','||issue_date_raised);
        issueExists := IMM.Issues.closeIssue(regen_metric_issue_id,
                                             forceCloseStateId,
                                             forceCloseResolutionId,
                                             raisedByUserId);
        if issueExists then
          -- add a note
          IMM.Issues.addNote(regen_metric_issue_id,
                             raisedByUserId,
                             metricNoteTypeId,
                             '<b>Issue auto-closed as a result of metric regeneration.</b>',
                             null,
                             null);
        end if;

      end if;
    END LOOP;
    CLOSE close_issue;
    loggerAuto('Closed Issues');
    -- update the ISSUE_LIMIT count
    -- WE DO THIS AS Issues inserted through the metrics
    -- process could result in deadlock if two threads updated
    -- the IMM.issue_limit table and one ran longer than the
    -- session_timeout period
    -- so, we defer updating the ISSUE_LIMIT table until now
    -- the issue limit, could be exceeded, but we have to live
    -- with that for now
    -- ASLO NOTE THAT THIS METHOD WOULD require rework if we
    -- ever use the 'extra_identifier' parameter of the
    -- issue_limit methods
    /*
      IMM.Issues.incrementIssueLimitTable(metricIssueClass,
                                          metricIssueType,
                                          v_issue_count);
    */
    loggerAuto('Completed.');
    return 'Merge complete';

  exception
    -- rethrow a deadlock_detected exception
    -- we want to be able to differentiate between
    -- deadlock_detected exception and any others
    when numeric_error then
      loggerAuto('Exception numeric_value_error (mergeResults): ' ||
                 regen_metric_issue_id || ',' || issue_date_raised || ',' ||
                 DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RAISE;
    when deadlock_detected or no_statement_parsed then
      if ignore_deadlock = 'N' then
        loggerAuto('Exception (mergeResults): ' ||
                   SUBSTR(SQLERRM, 1, 4000));
      end if;
      RAISE deadlock_detected;
      -- record and return any other exception message
    when others then
      loggerAuto('Exception (mergeResults): ' || SUBSTR(SQLERRM, 1, 4000));
      RAISE_APPLICATION_ERROR(-20001,
                              'Exception: ' || SUBSTR(SQLERRM, 1, 4000));
  end;

  /**
  * Core Metric Calculation
  *
  * a_relative indicates whether or not to do last-value comparisons
  * ( true=yes (1), false=no (0) )
  *
  * NB this function should only be called on
  * EITHER node locked rows XOR edge locked rows (of fmo_metric_queue)
  * ie NOT nodes and edge together
  **/
  function coreMatchedForecastMetricCalc(a_operator_id       number,
                                         b_thread_id         number,
                                         job_start_ts        timestamp,
                                         d_metric_version_id number,
                                         a_relative          number,
                                         a_edge_ids          varchar2,
                                         a_node_ids          varchar2,
                                         forecast_metric_id  number,
                                         all_parameters      varchar2,
                                         a_debug             varchar2)
    return varchar2 as
  begin
    -- set globals for logging purposes
    global_operator_id := a_operator_id;
    global_thread_id   := b_thread_id;

    setParameters(all_parameters);

    if a_debug = 'yes' then
      global_debug := 1;
    else
      global_debug := 0;
    end if;

    loggerAuto('coreMatchedForecastMetricCalc');

    return coreMetricCalc(a_operator_id,
                          b_thread_id,
                          cast(job_start_ts as date),
                          d_metric_version_id,
                          0, -- FORECAST metrics can not be 'last value'
                          a_edge_ids,
                          a_node_ids,
                          true, -- matched
                          forecast_metric_id);
  end;

  /**
  * Core Metric Calculation
  *
  * a_relative indicates whether or not to do last-value comparisons
  * ( true=yes (1), false=no (0) )
  *
  * NB this function should only be called on
  * EITHER node locked rows XOR edge locked rows (of fmo_metric_queue)
  * ie NOT nodes and edge together
  **/
  function coreUnMatchForeMetricCalc(a_operator_id       number,
                                     b_thread_id         number,
                                     job_start_ts        timestamp,
                                     d_metric_version_id number,
                                     a_relative          number,
                                     a_edge_ids          varchar2,
                                     a_node_ids          varchar2,
                                     forecast_metric_id  number,
                                     all_parameters      varchar2,
                                     a_debug             varchar2)
    return varchar2 as
  begin
    -- set globals for logging purposes
    global_operator_id := a_operator_id;
    global_thread_id   := b_thread_id;

    setParameters(all_parameters);

    if a_debug = 'yes' then
      global_debug := 1;
    else
      global_debug := 0;
    end if;

    loggerAuto('coreUnMatchedForecastMetricCalc');

    return coreMetricCalc(a_operator_id,
                          b_thread_id,
                          cast(job_start_ts as date),
                          d_metric_version_id,
                          0, -- FORECAST metrics can not be 'last value'
                          a_edge_ids,
                          a_node_ids,
                          false, -- unmatched
                          forecast_metric_id);
  end;

  /**
  * Core Metric Calculation
  *
  * a_relative indicates whether or not to do last-value comparisons
  * ( true=yes (1), false=no (0) )
  *
  * NB this function should only be called on
  * EITHER node locked rows XOR edge locked rows (of fmo_metric_queue)
  * ie NOT nodes and edge together
  **/
  function coreUnMatchedFileMetricCalc(a_operator_id       number,
                                       b_thread_id         number,
                                       job_start_ts        timestamp,
                                       d_metric_version_id number,
                                       a_relative          number,
                                       a_edge_ids          varchar2,
                                       a_node_ids          varchar2,
                                       all_parameters      varchar2,
                                       a_debug             varchar2)
    return varchar2 as
  begin
    -- set globals for logging purposes
    global_operator_id := a_operator_id;
    global_thread_id   := b_thread_id;

    setParameters(all_parameters);

    if a_debug = 'yes' then
      global_debug := 1;
    else
      global_debug := 0;
    end if;

    loggerAuto('coreUnMatchedFileMetricCalc');

    return coreMetricCalc(a_operator_id,
                          b_thread_id,
                          cast(job_start_ts as date),
                          d_metric_version_id,
                          a_relative,
                          a_edge_ids,
                          a_node_ids,
                          false -- matched
                          );
  end;

  function coreMatchedFileMetricCalc(a_operator_id       number,
                                     b_thread_id         number,
                                     job_start_ts        timestamp,
                                     d_metric_version_id number,
                                     a_relative          number,
                                     a_edge_ids          varchar2,
                                     a_node_ids          varchar2,
                                     all_parameters      varchar2,
                                     a_debug             varchar2)
    return varchar2 as
  begin
    -- set globals for logging purposes
    global_operator_id := a_operator_id;
    global_thread_id   := b_thread_id;

    setParameters(all_parameters);

    if a_debug = 'yes' then
      global_debug := 1;
    else
      global_debug := 0;
    end if;

    loggerAuto('coreMatchedFileMetricCalc');

    return coreMetricCalc(a_operator_id,
                          b_thread_id,
                          cast(job_start_ts as date),
                          d_metric_version_id,
                          a_relative,
                          a_edge_ids,
                          a_node_ids,
                          true -- matched
                          );
  end;

  /********
  * Entry point for the Metric Calculation
  * Responsible for running the metric: d_metric_version_id
  * against all edges/nodes flagged in the fmo_metric_queue table.
  * Those rows are flagged by (a_operator_id, a_thread_id)
  *
  * Handles
  * Matched/UnMatched, Edge/Node, relative/absolute,
  * and forecast metrics
  *
  * Responsible for testing if thresholds have been breached, and raising
  * IMM issues if necessary.
  *
  **********/
  function coreMetricCalc(a_operator_id          number,
                          b_thread_id            number,
                          a_metric_creation_date date,
                          d_metric_version_id    number,
                          a_relative             number,
                          a_edge_ids             varchar2,
                          a_node_ids             varchar2,
                          matched_file_metric    boolean,
                          a_forecast_metric_id   number default null)
    return varchar2 as

    the_i_fileset_id       number;
    the_j_fileset_id       number;
    v_fmo_match_history_id number;
    v_fmo_match_checksum   varchar2(200);

    current_threshold_version_id   number;
    current_operator_definition_id number;
    current_operator_order         number;
    current_metric_operator_id     number;

    current_i_min_d_period_id date;
    current_i_max_d_period_id date;
    current_j_min_d_period_id date;
    current_j_max_d_period_id date;

    current_d_period        date;
    current_source_id       number;
    current_source_type_id  number;
    current_edr_type_id     number;
    current_edr_sub_type_id number;

    current_edge_id number;
    current_node_id number;

    current_metric_definition_id number;
    d_metric_mv_id               number;

    current_f_metric_id     number;
    regen_f_metric_id       number;
    regen_metric_issue_id   number;
    issue_date_raised       date;
    issueExists             boolean;
    current_metric_queue_id number;

    the_metric_creation_date date;

    summary_num_metrics          number;
    summary_num_filesets         number;
    summary_num_issues           number;
    summary_num_issue_not_raised number;
    return_msg                   varchar2(200);

    the_metric_return_value metric_return_value;

    the_last_value_data last_value_data;

    the_severity_data severity_data;

    v_non_regen_metric  number;
    
    cursor filesets is
      select i_fileset_id,
             j_fileset_id,
             metric_queue_id,
             edge_id,
             node_id,
             source_id,
             source_type_id,
             edr_type_id,
             edr_sub_type_id,
             i_min_d_period_id,
             i_max_d_period_id,
             j_min_d_period_id,
             j_max_d_period_id,
             f_metric_id,
             d_period_id,
             fmo_match_history_id,
             fmo_match_checksum
        from fmo_metric_queue fsq
       where fsq.operator_id = a_operator_id
         and fsq.thread_id = b_thread_id;

    an_edge_id number;

    cursor edges is
      select distinct edge_id
        from fmo_metric_queue fsq
       where fsq.operator_id = a_operator_id
         and fsq.thread_id = b_thread_id;

    a_node_id number;

    cursor nodes is
      select distinct node_id
        from fmo_metric_queue fsq
       where fsq.operator_id = a_operator_id
         and fsq.thread_id = b_thread_id;

    -- DPP DEBUG --
    --l_metric_count integer := 0;
    -- DPP DEBUG --
  begin
    summary_num_filesets         := 0;
    summary_num_metrics          := 0;
    summary_num_issues           := 0;
    summary_num_issue_not_raised := 0;
    return_msg                   := '';

    -- get current_operator_definition_id
    select mor.metric_operator_id,
           mor.operator_definition_id,
           mor.operator_order
      into current_metric_operator_id,
           current_operator_definition_id,
           current_operator_order
      from fmo_metric_queue fsq, metric_operator_ref mor
     where fsq.operator_id = a_operator_id
       and fsq.metric_operator_id = mor.metric_operator_id
       and rownum = 1;
    loggerDebug('Get Operator Definition Id: ' ||
                current_operator_definition_id);

    -- Switch to get correct metricFunction based on parameters
    loggerDebug('Setting Metric Function...');
    if global_parameters('-custom_sql_metric') = 'yes' then
      setCustomSQLMetricFunction(current_metric_operator_id);
    elsif global_parameters('-meta_metric') = 'yes' then
      setCustomSQLMetricFunction(current_metric_operator_id);
    else
      setGlobalMetricFunction(current_metric_operator_id);
    end if;

    -- debug info
    loggerAuto('coreMetric: fn (start): ' || global_metric_function_id);

    -- get metric_definition_id
    select metric_definition_id
      into current_metric_definition_id
      from metric_version_ref
     where metric_version_id = d_metric_version_id;
    loggerDebug('Get Metric Definition Id: ' ||
                current_metric_definition_id);

    begin
      select description
        into global_operator_desc
        from operator_definition_ref
       where operator_definition_id = current_operator_definition_id;
    exception
      when no_data_found then
        global_operator_desc := 'Undefined';
    end;

    begin
      select mdr.name, mdr.metric_category_id, mcr.category
        into global_metric_definition_name,
             global_metric_category_id,
             global_metric_category_name
        from metric_definition_ref mdr, metric_category_ref mcr
       where mdr.metric_definition_id = current_metric_definition_id
         and mdr.metric_category_id = mcr.metric_category_id;
    exception
      when no_data_found then
        global_metric_definition_name := 'Undefined';
        global_metric_category_id     := -1;
        global_metric_category_name   := 'Undefined';
    end;

    -- set d_metric_mv_id
    d_metric_mv_id := current_metric_definition_id;

    -- load THRESHOLD DATA
    -- either EDGES OR NODES not both
    if a_edge_ids is not null then
      -- by Edge
      open edges;
      while true loop
        fetch edges
          into an_edge_id;

        if edges%notfound then
          close edges;
          exit;
        else
          loadStaticData(an_edge_id, null, current_metric_definition_id);
        end if;
      end loop;
    end if;

    if a_node_ids is not null then
      -- by Node
      open nodes;
      while true loop
        fetch nodes
          into a_node_id;

        if nodes%notfound then
          close nodes;
          exit;
        else
          loadStaticData(null, a_node_id, current_metric_definition_id);
        end if;
      end loop;
    end if;

    -- load Source Data
    loggerDebug('Load Sources');
    loadSources();

    -- debug
    --showGlobalThreshData(); <--- CAREFUL this procedure has not been maintained

    the_metric_creation_date := a_metric_creation_date;

    -- for each i_fileset_id
    loggerDebug('Start Processing Filesets...');
    open filesets;
    while true loop
      fetch filesets
        into the_i_fileset_id,
             the_j_fileset_id,
             current_metric_queue_id,
             current_edge_id,
             current_node_id,
             current_source_id,
             current_source_type_id,
             current_edr_type_id,
             current_edr_sub_type_id,
             current_i_min_d_period_id,
             current_i_max_d_period_id,
             current_j_min_d_period_id,
             current_j_max_d_period_id,
             regen_f_metric_id,
             current_d_period,
             v_fmo_match_history_id,
             v_fmo_match_checksum;

      -- finished
      if filesets%notfound then
        close filesets;

        loggerAuto('coreMetric: fn (end): ' || global_metric_function_id);
        loggerAuto('Summary:- Metrics: ' || summary_num_metrics ||
                   ' (filesets: ' || summary_num_filesets ||
                   '), Issues Raised: ' || summary_num_issues);

        return_msg := 'Summary:- Metrics: ' || summary_num_metrics ||
                      ', Issues Raised: ' || summary_num_issues;
        if (summary_num_issue_not_raised > 0) then
          return_msg := return_msg || ', Issues Not Raised: ' ||
                        summary_num_issue_not_raised;
        end if;

        return return_msg;

      end if;

      summary_num_filesets := summary_num_filesets + 1;

      -- get the d_period corresponding to the (sample) date
      -- if it has not been set in fmo_metric_queue
      if current_d_period is null then
        current_d_period := etl.get_d_period(current_i_max_d_period_id);
      end if;

      -- set current_source_id and current_source_type_id
      if current_source_id is null then
        current_source_id := UNSPECIFIED_SRC_ID;
      end if;
      if current_source_type_id is null OR
         current_source_id != UNSPECIFIED_SRC_ID then
        current_source_type_id := global_source_data_array(current_source_id)
                                  .source_type_id;
      end if;

      -- Check if regen is turned on for this metric
      -- and if the metric already exists  
      BEGIN  
          select sum(1)
          into   v_non_regen_metric
          from   um.f_metric f
          where  f.d_period_id = current_d_period
          and    f.metric_definition_id = current_metric_definition_id
          and    ( f.d_node_id = current_node_id or current_node_id is null )
          and    ( f.d_edge_id = current_edge_id or current_edge_id is null )
          and    not exists ( select 1
                              from   um.node_metric_jn n 
                              where  n.node_id = current_node_id
                              and    n.metric_definition_id = current_metric_definition_id
                              and    n.is_regenerate = 'Y' )
          and    not exists ( select 1
                              from   um.edge_metric_jn e 
                              where  e.edge_id = current_edge_id
                              and    e.metric_definition_id = current_metric_definition_id
                              and    e.is_regenerate = 'Y' );
       EXCEPTION
           when others then
                v_non_regen_metric := 0;
       END;

                   
      -- if not a regen metric and metric already exists then dont re-process, skip to next metric        
      if (v_non_regen_metric > 0 ) then
      
          the_metric_return_value := null;
      
      else
       
          -- GET THRESHOLD VERSION HERE
          current_threshold_version_id := getNewThresholdVersionId(NVL(current_edge_id,
                                                                       current_node_id),
                                                                   current_source_id,
                                                                   current_source_type_id,
                                                                   current_i_max_d_period_id,
                                                                   current_edr_type_id,
                                                                   current_edr_sub_type_id);

          -- CALCULATE the metric!
          -- use fmo_equation to poulate global_fmo_equation details
          --loggerAuto('edrCalcMetricFmoEqn: start');
          the_metric_return_value := edrCalcMetricFmoEqn(the_i_fileset_id,
                                                         current_i_min_d_period_id,
                                                         current_i_max_d_period_id,
                                                         the_j_fileset_id,
                                                         current_j_min_d_period_id,
                                                         current_j_max_d_period_id,
                                                         current_edr_type_id,
                                                         current_edr_sub_type_id);
      end if;

      --loggerAuto('edrCalcMetricFmoEqn: end');

      -- handle nulls
      -- nulls can occur for instance if the current fmo_equation is restricted
      -- on source or source type, but the file matching was not similarly restricted
      -- ignore any calculations that resulted in nulls
      if the_metric_return_value.metric_value is not null then

        -- set edr values if still null:
        if current_edr_type_id is null then
          current_edr_type_id := EDR_TYPE_UNSPECIFIED;
        end if;
        if current_edr_sub_type_id is null then
          current_edr_sub_type_id := EDR_SUB_TYPE_UNSPECIFIED;
        end if;

        -- only do forecast if not a meta (aggregate metric)
        if not global_parameters('-meta_metric') = 'yes' then
          -- get any forecast value and
          -- adjust for forecast / non-forecast metrics
          -- (a case of deciding which value we will use in the threshold comparison)
          forecastAdjustment(the_metric_return_value,
                             a_forecast_metric_id,
                             current_node_id,
                             current_edge_id,
                             current_source_id,
                             current_edr_type_id,
                             current_edr_sub_type_id,
                             current_d_period,
                             current_source_type_id);

        end if;

        -- d_billing_type_id is to be gradually phased out
        --if the_metric_return_value.d_billing_type_id is null then
        --  the_metric_return_value.d_billing_type_id := -1;
        --end if;
        the_metric_return_value.d_billing_type_id := -1;

        -- grab next f_metric_id
        if regen_f_metric_id IS NULL then
          -- grab next f_metric_id
          select seq_f_metric_id.nextval
            into current_f_metric_id
            from dual;
        else
          current_f_metric_id := regen_f_metric_id;
        end if;

        -- DPP
        --loggerAuto('Metric: ' || the_metric_return_value.metric_value);
        --loggerAuto('Raw: ' || the_metric_return_value.raw_value);
        -- DPP

        --insert into f_metric
        if regen_f_metric_id IS NULL then
          insert into temp_f_metric
            (d_period_id,
             f_metric_id,
             d_metric_id,
             d_node_id,
             d_edge_id,
             d_source_id,
             source_type_id,
             d_billing_type_id,
             d_payment_type_id,
             d_call_type_id,
             d_customer_type_id,
             d_service_provider_id,
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
             d_custom_20_list,
             creation_date,
             sample_date,
             threshold_version_id,
             threshold_definition_id,
             metric_operator_id,
             operator_order,
             metric_definition_id,
             edr_type_id,
             edr_sub_type_id,
             i_value,
             j_value,
             raw_value,
             metric,
             comparison,
             is_issue,
             is_comparator,
             forecast_value,
             i_fileset_id,
             j_fileset_id,
             fmo_match_history_id,
             fmo_match_checksum)
          values
            (current_d_period,
             current_f_metric_id,
             d_metric_mv_id,
             current_node_id,
             current_edge_id,
             current_source_id,
             current_source_type_id,
             the_metric_return_value.d_billing_type_id,
             global_fmo_equation.d_payment_type_id,
             global_fmo_equation.d_call_type_id,
             global_fmo_equation.d_customer_type_id,
             global_fmo_equation.d_service_provider_id,
             inlist2varchar(global_fmo_equation.d_custom_01_list),
             inlist2varchar(global_fmo_equation.d_custom_02_list),
             inlist2varchar(global_fmo_equation.d_custom_03_list),
             inlist2varchar(global_fmo_equation.d_custom_04_list),
             inlist2varchar(global_fmo_equation.d_custom_05_list),
             inlist2varchar(global_fmo_equation.d_custom_06_list),
             inlist2varchar(global_fmo_equation.d_custom_07_list),
             inlist2varchar(global_fmo_equation.d_custom_08_list),
             inlist2varchar(global_fmo_equation.d_custom_09_list),
             inlist2varchar(global_fmo_equation.d_custom_10_list),
             inlist2varchar(global_fmo_equation.d_custom_11_list),
             inlist2varchar(global_fmo_equation.d_custom_12_list),
             inlist2varchar(global_fmo_equation.d_custom_13_list),
             inlist2varchar(global_fmo_equation.d_custom_14_list),
             inlist2varchar(global_fmo_equation.d_custom_15_list),
             inlist2varchar(global_fmo_equation.d_custom_16_list),
             inlist2varchar(global_fmo_equation.d_custom_17_list),
             inlist2varchar(global_fmo_equation.d_custom_18_list),
             inlist2varchar(global_fmo_equation.d_custom_19_list),
             inlist2varchar(global_fmo_equation.d_custom_20_list),
             the_metric_creation_date,
             current_i_max_d_period_id,
             current_threshold_version_id,
             global_current_thresh_def_data.active_td_id,
             current_metric_operator_id,
             current_operator_order,
             current_metric_definition_id,
             current_edr_type_id,
             current_edr_sub_type_id,
             the_metric_return_value.i_value,
             the_metric_return_value.j_value,
             the_metric_return_value.raw_value,
             the_metric_return_value.metric_value,
             the_metric_return_value.compare_value,
             'N',
             NVL(global_current_thresh_def_data.tvr_is_comparator, 'Y'),
             the_metric_return_value.forecast_value,
             the_i_fileset_id,
             the_j_fileset_id,
             v_fmo_match_history_id,
             v_fmo_match_checksum);

        else
          -- it's a regen - use regen temp tables
          insert into temp_f_metric_regen
            (d_period_id,
             f_metric_id,
             d_metric_id,
             d_node_id,
             d_edge_id,
             d_source_id,
             source_type_id,
             d_billing_type_id,
             d_payment_type_id,
             d_call_type_id,
             d_customer_type_id,
             d_service_provider_id,
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
             d_custom_20_list,
             creation_date,
             sample_date,
             threshold_version_id,
             threshold_definition_id,
             metric_operator_id,
             operator_order,
             metric_definition_id,
             edr_type_id,
             edr_sub_type_id,
             i_value,
             j_value,
             raw_value,
             metric,
             comparison,
             is_issue,
             is_comparator,
             forecast_value,
             i_fileset_id,
             j_fileset_id,
             fmo_match_history_id,
             fmo_match_checksum)
          values
            (current_d_period,
             current_f_metric_id,
             d_metric_mv_id,
             current_node_id,
             current_edge_id,
             current_source_id,
             current_source_type_id,
             the_metric_return_value.d_billing_type_id,
             global_fmo_equation.d_payment_type_id,
             global_fmo_equation.d_call_type_id,
             global_fmo_equation.d_customer_type_id,
             global_fmo_equation.d_service_provider_id,
             inlist2varchar(global_fmo_equation.d_custom_01_list),
             inlist2varchar(global_fmo_equation.d_custom_02_list),
             inlist2varchar(global_fmo_equation.d_custom_03_list),
             inlist2varchar(global_fmo_equation.d_custom_04_list),
             inlist2varchar(global_fmo_equation.d_custom_05_list),
             inlist2varchar(global_fmo_equation.d_custom_06_list),
             inlist2varchar(global_fmo_equation.d_custom_07_list),
             inlist2varchar(global_fmo_equation.d_custom_08_list),
             inlist2varchar(global_fmo_equation.d_custom_09_list),
             inlist2varchar(global_fmo_equation.d_custom_10_list),
             inlist2varchar(global_fmo_equation.d_custom_11_list),
             inlist2varchar(global_fmo_equation.d_custom_12_list),
             inlist2varchar(global_fmo_equation.d_custom_13_list),
             inlist2varchar(global_fmo_equation.d_custom_14_list),
             inlist2varchar(global_fmo_equation.d_custom_15_list),
             inlist2varchar(global_fmo_equation.d_custom_16_list),
             inlist2varchar(global_fmo_equation.d_custom_17_list),
             inlist2varchar(global_fmo_equation.d_custom_18_list),
             inlist2varchar(global_fmo_equation.d_custom_19_list),
             inlist2varchar(global_fmo_equation.d_custom_20_list),
             the_metric_creation_date,
             current_i_max_d_period_id,
             current_threshold_version_id,
             global_current_thresh_def_data.active_td_id,
             current_metric_operator_id,
             current_operator_order,
             current_metric_definition_id,
             current_edr_type_id,
             current_edr_sub_type_id,
             the_metric_return_value.i_value,
             the_metric_return_value.j_value,
             the_metric_return_value.raw_value,
             the_metric_return_value.metric_value,
             the_metric_return_value.compare_value,
             'N',
             NVL(global_current_thresh_def_data.tvr_is_comparator, 'Y'),
             the_metric_return_value.forecast_value,
             the_i_fileset_id,
             the_j_fileset_id,
             v_fmo_match_history_id,
             v_fmo_match_checksum);

        end if;
        -- increment number of metrics
        summary_num_metrics := summary_num_metrics + 1;

        -- decision on if "last value"
        if a_relative = 1 then
          the_last_value_data.d_period_id          := current_d_period;
          the_last_value_data.node_id              := current_node_id;
          the_last_value_data.edge_id              := current_edge_id;
          the_last_value_data.source_id            := current_source_id;
          the_last_value_data.source_type_id       := current_source_type_id;
          the_last_value_data.metric_operator_id   := current_metric_operator_id;
          the_last_value_data.metric_definition_id := current_metric_definition_id;
          the_last_value_data.operator_order       := current_operator_order;
        else
          the_last_value_data.d_period_id := null;
        end if;

        -- only check thesholds if not a meta (aggregate) metric
        -- this will be done at end
        if not global_parameters('-meta_metric') = 'yes' then

          -- is a threshold breached?
          -- only test if there is something to compare against
          if (current_threshold_version_id is not null) and
             (the_metric_return_value.threshold_value is not null) then

            the_severity_data := raiseIssueIfBreached(current_threshold_version_id,
                                                      the_metric_return_value,
                                                      current_i_max_d_period_id,
                                                      current_d_period,
                                                      current_f_metric_id,
                                                      current_metric_definition_id,
                                                      current_edge_id,
                                                      current_node_id,
                                                      current_source_id,
                                                      current_source_type_id,
                                                      current_edr_type_id,
                                                      current_edr_sub_type_id,
                                                      regen_f_metric_id,
                                                      the_i_fileset_id,
                                                      the_j_fileset_id,
                                                      the_last_value_data);

            -- update f_metric if there was a threshold breach
            if the_severity_data.threshold_breached then

              if regen_f_metric_id is not null then
                update temp_f_metric_regen fmr
                   set is_issue = 'Y', is_comparator = 'N'
                 where fmr.f_metric_id = current_f_metric_id;
              else
                update temp_f_metric fm
                   set is_issue = 'Y', is_comparator = 'N'
                 where fm.f_metric_id = current_f_metric_id;
              end if;

              /*
                if the_severity_data.severity_id is not null then
                  -- increment num_issues
                  summary_num_issues := summary_num_issues + 1;
                end if;
              */
              if (the_severity_data.raise_issue = 'Y') then
                if (the_severity_data.issue_raised = 'N') then
                  summary_num_issue_not_raised := summary_num_issue_not_raised + 1;
                else
                  -- increment num_issues
                  summary_num_issues := summary_num_issues + 1;
                end if;
              end if;

            end if;
          end if;
        end if;
        -- end null test
      end if;
    end loop;

  exception
    -- record and return any exception message
    when others then
      loggerAuto('Exception: ' || SUBSTR(SQLERRM, 1, 4000));
      RAISE_APPLICATION_ERROR(-20001,
                              'Exception: ' || SUBSTR(SQLERRM, 1, 4000));
  end;

  function getMetricVersionFromMetricDef(a_metric_definition_id number,
                                         a_date                 date)
    return number deterministic is
    the_metric_version_id number;
  begin

    select metric_version_id
      into the_metric_version_id
      from metric_version_ref
     where metric_definition_id = a_metric_definition_id
       and valid_from <= a_date
       and valid_to >= a_date
       and status = 'A'
       and valid_from =
           (select max(valid_from)
              from metric_version_ref
             where metric_definition_id = a_metric_definition_id
               and valid_from <= a_date
               and valid_to >= a_date
               and status = 'A');

    return the_metric_version_id;

  end;

  /******************************************************************
  * END
  * Core Metric Calculation Entry:
  *
  * Metric operator entry points
  *******************************************************************/

  /******************************************************************
  * START
  * Actual Metric Function:
  *
  * This section holds the implementations of the specific metric
  * calculation functions, and helper functions
  *
  *******************************************************************/

  /*
  *  Sum (sum of i values)
  */
  function edrCountSumMetric(a_i_fileset_id      number,
                             a_i_min_d_period_id date,
                             a_i_max_d_period_id date,
                             a_edr_type_id       number,
                             a_edr_sub_type_id   number)
    return metric_return_value as

    i_value                 number;
    the_metric              number;
    the_raw_value           number;
    the_metric_return_value metric_return_value;

  begin

    -- get the i and j values
    getEdrCountValue(a_i_fileset_id,
                     a_i_min_d_period_id,
                     a_i_max_d_period_id,

                     global_fmo_equation.source_id,
                     global_fmo_equation.source_type_id,
                     global_fmo_equation.i_d_measure_type_id,

                     a_edr_type_id,
                     a_edr_sub_type_id,

                     i_value);

    -- calculate the metric
    the_metric    := i_value;
    the_raw_value := i_value;

    if global_fmo_equation.adjuster is not null then
      the_metric := the_metric * global_fmo_equation.adjuster;
    end if;

    the_metric_return_value.i_value      := i_value;
    the_metric_return_value.j_value      := null;
    the_metric_return_value.raw_value    := the_raw_value;
    the_metric_return_value.metric_value := the_metric;

    return the_metric_return_value;
  end;

  /*
  *  Minus (i minus j values, gives absolute loss)
  */
  function edrCountMinusMetric(a_i_fileset_id      number,
                               a_i_min_d_period_id date,
                               a_i_max_d_period_id date,
                               a_j_fileset_id      number,
                               a_j_min_d_period_id date,
                               a_j_max_d_period_id date,
                               a_edr_type_id       number,
                               a_edr_sub_type_id   number)
    return metric_return_value as
    i_value       number;
    j_value       number;
    the_metric    number;
    the_raw_value number;

    the_metric_return_value metric_return_value;

  begin
    -- get the i and j values
    getEdrCountValue(a_i_fileset_id,
                     a_i_min_d_period_id,
                     a_i_max_d_period_id,

                     global_fmo_equation.source_id,
                     global_fmo_equation.source_type_id,
                     global_fmo_equation.i_d_measure_type_id,

                     a_edr_type_id,
                     a_edr_sub_type_id,

                     i_value);

    getEdrCountValue(a_j_fileset_id,
                     a_j_min_d_period_id,
                     a_j_max_d_period_id,

                     global_fmo_equation.source_id,
                     global_fmo_equation.source_type_id,
                     global_fmo_equation.j_d_measure_type_id,

                     a_edr_type_id,
                     a_edr_sub_type_id,

                     j_value);

    -- calculate the metric
    the_metric    := j_value - i_value;
    the_raw_value := j_value - i_value;

    if global_fmo_equation.adjuster is not null then
      the_metric := the_metric * global_fmo_equation.adjuster;
    end if;

    the_metric_return_value.i_value      := i_value;
    the_metric_return_value.j_value      := j_value;
    the_metric_return_value.raw_value    := the_raw_value;
    the_metric_return_value.metric_value := the_metric;

    return the_metric_return_value;
  end;

  /*
    Percent (j as a percent of i, gives percentile loss)
  */
  function edrCountPercentMetric(a_i_fileset_id      number,
                                 a_i_min_d_period_id date,
                                 a_i_max_d_period_id date,
                                 a_j_fileset_id      number,
                                 a_j_min_d_period_id date,
                                 a_j_max_d_period_id date,
                                 a_edr_type_id       number,
                                 a_edr_sub_type_id   number)
    return metric_return_value as
    i_value       number;
    j_value       number;
    the_metric    number;
    the_raw_value number;

    the_metric_return_value metric_return_value;

  begin

    -- get the i and j values
    getEdrCountValue(a_i_fileset_id,
                     a_i_min_d_period_id,
                     a_i_max_d_period_id,

                     global_fmo_equation.source_id,
                     global_fmo_equation.source_type_id,
                     global_fmo_equation.i_d_measure_type_id,

                     a_edr_type_id,
                     a_edr_sub_type_id,

                     i_value);

    getEdrCountValue(a_j_fileset_id,
                     a_j_min_d_period_id,
                     a_j_max_d_period_id,

                     global_fmo_equation.source_id,
                     global_fmo_equation.source_type_id,
                     global_fmo_equation.j_d_measure_type_id,

                     a_edr_type_id,
                     a_edr_sub_type_id,

                     j_value);

    -- calculate the metric
    if i_value != 0 then
      the_raw_value := j_value / i_value;
      the_metric    := the_raw_value - 1;
    elsif i_value = 0 then
      the_metric    := 0;
      the_raw_value := 0;
    else
      the_metric    := null;
      the_raw_value := null;
    end if;

    if global_fmo_equation.adjuster is not null then
      the_metric := the_metric * global_fmo_equation.adjuster;
    end if;

    the_metric_return_value.i_value := i_value;
    the_metric_return_value.j_value := j_value;
    if global_switch_to_raw != 'yes' then
      the_metric_return_value.raw_value    := the_raw_value;
      the_metric_return_value.metric_value := the_metric;
    else
      -- if parameter -switch_to_raw
      the_metric_return_value.raw_value    := the_metric;
      the_metric_return_value.metric_value := the_raw_value;
    end if;

    return the_metric_return_value;
  end;

  /*
    Difference (between i and j values, gives absolute difference)
  */
  function edrCountDifferenceMetric(a_i_fileset_id      number,
                                    a_i_min_d_period_id date,
                                    a_i_max_d_period_id date,
                                    a_j_fileset_id      number,
                                    a_j_min_d_period_id date,
                                    a_j_max_d_period_id date,
                                    a_edr_type_id       number,
                                    a_edr_sub_type_id   number)
    return metric_return_value as
    i_value       number;
    j_value       number;
    the_metric    number;
    the_raw_value number;

    the_metric_return_value metric_return_value;

  begin
    -- get the i and j values
    getEdrCountValue(a_i_fileset_id,
                     a_i_min_d_period_id,
                     a_i_max_d_period_id,

                     global_fmo_equation.source_id,
                     global_fmo_equation.source_type_id,
                     global_fmo_equation.i_d_measure_type_id,

                     a_edr_type_id,
                     a_edr_sub_type_id,

                     i_value);

    getEdrCountValue(a_j_fileset_id,
                     a_j_min_d_period_id,
                     a_j_max_d_period_id,

                     global_fmo_equation.source_id,
                     global_fmo_equation.source_type_id,
                     global_fmo_equation.j_d_measure_type_id,

                     a_edr_type_id,
                     a_edr_sub_type_id,

                     j_value);

    -- calculate the metric
    the_metric    := ABS(j_value - i_value);
    the_raw_value := j_value - i_value;

    if global_fmo_equation.adjuster is not null then
      the_metric := the_metric * global_fmo_equation.adjuster;
    end if;

    the_metric_return_value.i_value      := i_value;
    the_metric_return_value.j_value      := j_value;
    the_metric_return_value.raw_value    := the_raw_value;
    the_metric_return_value.metric_value := the_metric;

    return the_metric_return_value;
  end;

  -- EDR VALUE metrics
  /*
    Sum (i values sum)
  */
  function edrValueSumMetric(a_i_fileset_id      number,
                             a_i_min_d_period_id date,
                             a_i_max_d_period_id date,
                             a_edr_type_id       number,
                             a_edr_sub_type_id   number)
    return metric_return_value as
    i_value       number;
    the_metric    number;
    the_raw_value number;

    the_metric_return_value metric_return_value;

  begin
    -- get the i
    getEdrValueValue(a_i_fileset_id,
                     a_i_min_d_period_id,
                     a_i_max_d_period_id,

                     global_fmo_equation.source_id,
                     global_fmo_equation.source_type_id,
                     global_fmo_equation.i_d_measure_type_id,

                     a_edr_type_id,
                     a_edr_sub_type_id,

                     i_value);

    -- calculate the metric
    the_metric    := i_value;
    the_raw_value := i_value;

    if global_fmo_equation.adjuster is not null then
      the_metric := the_metric * global_fmo_equation.adjuster;
    end if;

    the_metric_return_value.i_value      := i_value;
    the_metric_return_value.j_value      := null;
    the_metric_return_value.raw_value    := the_raw_value;
    the_metric_return_value.metric_value := the_metric;

    return the_metric_return_value;
  end;

  /*

    Minus (i minus j values, gives absolute loss)
  */
  function edrValueMinusMetric(a_i_fileset_id      number,
                               a_i_min_d_period_id date,
                               a_i_max_d_period_id date,
                               a_j_fileset_id      number,
                               a_j_min_d_period_id date,
                               a_j_max_d_period_id date,
                               a_edr_type_id       number,
                               a_edr_sub_type_id   number)
    return metric_return_value as
    i_value       number;
    j_value       number;
    the_metric    number;
    the_raw_value number;

    the_metric_return_value metric_return_value;

  begin
    -- get the i and j values
    getEdrValueValue(a_i_fileset_id,
                     a_i_min_d_period_id,
                     a_i_max_d_period_id,

                     global_fmo_equation.source_id,
                     global_fmo_equation.source_type_id,
                     global_fmo_equation.i_d_measure_type_id,

                     a_edr_type_id,
                     a_edr_sub_type_id,

                     i_value);

    getEdrValueValue(a_j_fileset_id,
                     a_j_min_d_period_id,
                     a_j_max_d_period_id,

                     global_fmo_equation.source_id,
                     global_fmo_equation.source_type_id,
                     global_fmo_equation.j_d_measure_type_id,

                     a_edr_type_id,
                     a_edr_sub_type_id,

                     j_value);

    -- calculate the metric
    the_metric    := j_value - i_value;
    the_raw_value := j_value - i_value;

    if global_fmo_equation.adjuster is not null then
      the_metric := the_metric * global_fmo_equation.adjuster;
    end if;

    the_metric_return_value.i_value      := i_value;
    the_metric_return_value.j_value      := j_value;
    the_metric_return_value.raw_value    := the_raw_value;
    the_metric_return_value.metric_value := the_metric;

    return the_metric_return_value;
  end;

  /*
    Percent (j as a percent of i, gives percentile loss)
  */
  function edrValuePercentMetric(a_i_fileset_id      number,
                                 a_i_min_d_period_id date,
                                 a_i_max_d_period_id date,
                                 a_j_fileset_id      number,
                                 a_j_min_d_period_id date,
                                 a_j_max_d_period_id date,
                                 a_edr_type_id       number,
                                 a_edr_sub_type_id   number)
    return metric_return_value as
    i_value       number;
    j_value       number;
    the_metric    number;
    the_raw_value number;

    the_metric_return_value metric_return_value;

  begin
    -- get the i and j values
    getEdrValueValue(a_i_fileset_id,
                     a_i_min_d_period_id,
                     a_i_max_d_period_id,

                     global_fmo_equation.source_id,
                     global_fmo_equation.source_type_id,
                     global_fmo_equation.i_d_measure_type_id,

                     a_edr_type_id,
                     a_edr_sub_type_id,

                     i_value);

    getEdrValueValue(a_j_fileset_id,
                     a_j_min_d_period_id,
                     a_j_max_d_period_id,

                     global_fmo_equation.source_id,
                     global_fmo_equation.source_type_id,
                     global_fmo_equation.j_d_measure_type_id,

                     a_edr_type_id,
                     a_edr_sub_type_id,

                     j_value);

    -- calculate the metric
    if i_value != 0 then
      the_raw_value := j_value / i_value;
      the_metric    := the_raw_value - 1;
    elsif i_value = 0 then
      the_metric    := 0;
      the_raw_value := 0;
    else
      the_metric    := null;
      the_raw_value := null;
    end if;

    if global_fmo_equation.adjuster is not null then
      the_metric := the_metric * global_fmo_equation.adjuster;
    end if;

    the_metric_return_value.i_value := i_value;
    the_metric_return_value.j_value := j_value;
    if global_switch_to_raw != 'yes' then
      the_metric_return_value.raw_value    := the_raw_value;
      the_metric_return_value.metric_value := the_metric;
    else
      -- if parameter -switch_to_raw
      the_metric_return_value.raw_value    := the_metric;
      the_metric_return_value.metric_value := the_raw_value;
    end if;

    return the_metric_return_value;
  end;

  /*
    Difference (between i and j values, gives absolute difference)
  */
  function edrValueDifferenceMetric(a_i_fileset_id      number,
                                    a_i_min_d_period_id date,
                                    a_i_max_d_period_id date,
                                    a_j_fileset_id      number,
                                    a_j_min_d_period_id date,
                                    a_j_max_d_period_id date,
                                    a_edr_type_id       number,
                                    a_edr_sub_type_id   number)
    return metric_return_value as
    i_value       number;
    j_value       number;
    the_metric    number;
    the_raw_value number;

    the_metric_return_value metric_return_value;

  begin
    -- get the i and j values
    getEdrValueValue(a_i_fileset_id,
                     a_i_min_d_period_id,
                     a_i_max_d_period_id,

                     global_fmo_equation.source_id,
                     global_fmo_equation.source_type_id,
                     global_fmo_equation.i_d_measure_type_id,

                     a_edr_type_id,
                     a_edr_sub_type_id,

                     i_value);

    getEdrValueValue(a_j_fileset_id,
                     a_j_min_d_period_id,
                     a_j_max_d_period_id,

                     global_fmo_equation.source_id,
                     global_fmo_equation.source_type_id,
                     global_fmo_equation.j_d_measure_type_id,

                     a_edr_type_id,
                     a_edr_sub_type_id,

                     j_value);

    -- calculate the metric
    the_metric    := ABS(j_value - i_value);
    the_raw_value := j_value - i_value;

    if global_fmo_equation.adjuster is not null then
      the_metric := the_metric * global_fmo_equation.adjuster;
    end if;

    the_metric_return_value.i_value      := i_value;
    the_metric_return_value.j_value      := j_value;
    the_metric_return_value.raw_value    := the_raw_value;
    the_metric_return_value.metric_value := the_metric;

    return the_metric_return_value;
  end;

  -- EDR DURATION metrics
  /*
    Sum (i value sum)
  */

  function edrDurationSumMetric(a_i_fileset_id      number,
                                a_i_min_d_period_id date,
                                a_i_max_d_period_id date,
                                a_edr_type_id       number,
                                a_edr_sub_type_id   number)
    return metric_return_value as
    i_value       number;
    the_metric    number;
    the_raw_value number;

    the_metric_return_value metric_return_value;

  begin
    -- get the i
    getEdrDurationValue(a_i_fileset_id,
                        a_i_min_d_period_id,
                        a_i_max_d_period_id,

                        global_fmo_equation.source_id,
                        global_fmo_equation.source_type_id,
                        global_fmo_equation.i_d_measure_type_id,

                        a_edr_type_id,
                        a_edr_sub_type_id,

                        i_value);

    -- calculate the metric
    the_metric    := i_value;
    the_raw_value := i_value;

    if global_fmo_equation.adjuster is not null then
      the_metric := the_metric * global_fmo_equation.adjuster;
    end if;

    the_metric_return_value.i_value      := i_value;
    the_metric_return_value.j_value      := null;
    the_metric_return_value.raw_value    := the_raw_value;
    the_metric_return_value.metric_value := the_metric;

    return the_metric_return_value;
  end;

  function edrDurationMinusMetric(a_i_fileset_id      number,
                                  a_i_min_d_period_id date,
                                  a_i_max_d_period_id date,
                                  a_j_fileset_id      number,
                                  a_j_min_d_period_id date,
                                  a_j_max_d_period_id date,
                                  a_edr_type_id       number,
                                  a_edr_sub_type_id   number)
    return metric_return_value as
    i_value       number;
    j_value       number;
    the_metric    number;
    the_raw_value number;

    the_metric_return_value metric_return_value;

  begin
    -- get the i and j values
    getEdrDurationValue(a_i_fileset_id,
                        a_i_min_d_period_id,
                        a_i_max_d_period_id,

                        global_fmo_equation.source_id,
                        global_fmo_equation.source_type_id,
                        global_fmo_equation.i_d_measure_type_id,

                        a_edr_type_id,
                        a_edr_sub_type_id,

                        i_value);

    getEdrDurationValue(a_j_fileset_id,
                        a_j_min_d_period_id,
                        a_j_max_d_period_id,

                        global_fmo_equation.source_id,
                        global_fmo_equation.source_type_id,
                        global_fmo_equation.j_d_measure_type_id,

                        a_edr_type_id,
                        a_edr_sub_type_id,

                        j_value);

    -- calculate the metric
    the_metric    := j_value - i_value;
    the_raw_value := j_value - i_value;

    if global_fmo_equation.adjuster is not null then
      the_metric := the_metric * global_fmo_equation.adjuster;
    end if;

    the_metric_return_value.i_value      := i_value;
    the_metric_return_value.j_value      := j_value;
    the_metric_return_value.raw_value    := the_raw_value;
    the_metric_return_value.metric_value := the_metric;

    return the_metric_return_value;
  end;

  /*
    Percent (j as a percent of i, gives percentile loss)
  */
  function edrDurationPercentMetric(a_i_fileset_id      number,
                                    a_i_min_d_period_id date,
                                    a_i_max_d_period_id date,
                                    a_j_fileset_id      number,
                                    a_j_min_d_period_id date,
                                    a_j_max_d_period_id date,
                                    a_edr_type_id       number,
                                    a_edr_sub_type_id   number)
    return metric_return_value as
    i_value       number;
    j_value       number;
    the_metric    number;
    the_raw_value number;

    the_metric_return_value metric_return_value;

  begin
    -- get the i and j values
    getEdrDurationValue(a_i_fileset_id,
                        a_i_min_d_period_id,
                        a_i_max_d_period_id,

                        global_fmo_equation.source_id,
                        global_fmo_equation.source_type_id,
                        global_fmo_equation.i_d_measure_type_id,

                        a_edr_type_id,
                        a_edr_sub_type_id,

                        i_value);

    getEdrDurationValue(a_j_fileset_id,
                        a_j_min_d_period_id,
                        a_j_max_d_period_id,

                        global_fmo_equation.source_id,
                        global_fmo_equation.source_type_id,
                        global_fmo_equation.j_d_measure_type_id,

                        a_edr_type_id,
                        a_edr_sub_type_id,

                        j_value);

    -- calculate the metric
    if i_value != 0 then
      the_raw_value := j_value / i_value;
      the_metric    := the_raw_value - 1;
    elsif i_value = 0 then
      the_metric    := 0;
      the_raw_value := 0;
    else
      the_metric    := null;
      the_raw_value := null;
    end if;

    if global_fmo_equation.adjuster is not null then
      the_metric := the_metric * global_fmo_equation.adjuster;
    end if;

    the_metric_return_value.i_value := i_value;
    the_metric_return_value.j_value := j_value;
    if global_switch_to_raw != 'yes' then
      the_metric_return_value.raw_value    := the_raw_value;
      the_metric_return_value.metric_value := the_metric;
    else
      -- if parameter -switch_to_raw
      the_metric_return_value.raw_value    := the_metric;
      the_metric_return_value.metric_value := the_raw_value;
    end if;

    return the_metric_return_value;
  end;

  /*
    Difference (between i and j values, gives absolute difference)
  */
  function edrDurationDifferenceMetric(a_i_fileset_id      number,
                                       a_i_min_d_period_id date,
                                       a_i_max_d_period_id date,
                                       a_j_fileset_id      number,
                                       a_j_min_d_period_id date,
                                       a_j_max_d_period_id date,
                                       a_edr_type_id       number,
                                       a_edr_sub_type_id   number)
    return metric_return_value as
    i_value       number;
    j_value       number;
    the_metric    number;
    the_raw_value number;

    the_metric_return_value metric_return_value;

  begin
    -- get the i and j values
    getEdrDurationValue(a_i_fileset_id,
                        a_i_min_d_period_id,
                        a_i_max_d_period_id,

                        global_fmo_equation.source_id,
                        global_fmo_equation.source_type_id,
                        global_fmo_equation.i_d_measure_type_id,

                        a_edr_type_id,
                        a_edr_sub_type_id,

                        i_value);

    getEdrDurationValue(a_j_fileset_id,
                        a_j_min_d_period_id,
                        a_j_max_d_period_id,

                        global_fmo_equation.source_id,
                        global_fmo_equation.source_type_id,
                        global_fmo_equation.j_d_measure_type_id,

                        a_edr_type_id,
                        a_edr_sub_type_id,

                        j_value);

    -- calculate the metric
    the_metric    := ABS(j_value - i_value);
    the_raw_value := j_value - i_value;

    if global_fmo_equation.adjuster is not null then
      the_metric := the_metric * global_fmo_equation.adjuster;
    end if;

    the_metric_return_value.i_value      := i_value;
    the_metric_return_value.j_value      := j_value;
    the_metric_return_value.raw_value    := the_raw_value;
    the_metric_return_value.metric_value := the_metric;

    return the_metric_return_value;
  end;

  -- EDR BYTES metrics
  /*
  * Sum (i values sum)
  */

  function edrBytesSumMetric(a_i_fileset_id      number,
                             a_i_min_d_period_id date,
                             a_i_max_d_period_id date,
                             a_edr_type_id       number,
                             a_edr_sub_type_id   number)
    return metric_return_value as
    i_value       number;
    the_metric    number;
    the_raw_value number;

    the_metric_return_value metric_return_value;

  begin
    -- get the i and j values
    getEdrBytesValue(a_i_fileset_id,
                     a_i_min_d_period_id,
                     a_i_max_d_period_id,

                     global_fmo_equation.source_id,
                     global_fmo_equation.source_type_id,
                     global_fmo_equation.i_d_measure_type_id,

                     a_edr_type_id,
                     a_edr_sub_type_id,

                     i_value);

    -- calculate the metric
    the_metric    := i_value;
    the_raw_value := i_value;

    if global_fmo_equation.adjuster is not null then
      the_metric := the_metric * global_fmo_equation.adjuster;
    end if;

    the_metric_return_value.i_value      := i_value;
    the_metric_return_value.j_value      := null;
    the_metric_return_value.raw_value    := the_raw_value;
    the_metric_return_value.metric_value := the_metric;

    return the_metric_return_value;
  end;

  function edrBytesMinusMetric(a_i_fileset_id      number,
                               a_i_min_d_period_id date,
                               a_i_max_d_period_id date,
                               a_j_fileset_id      number,
                               a_j_min_d_period_id date,
                               a_j_max_d_period_id date,
                               a_edr_type_id       number,
                               a_edr_sub_type_id   number)
    return metric_return_value as
    i_value       number;
    j_value       number;
    the_metric    number;
    the_raw_value number;

    the_metric_return_value metric_return_value;

  begin
    -- get the i and j values
    getEdrBytesValue(a_i_fileset_id,
                     a_i_min_d_period_id,
                     a_i_max_d_period_id,

                     global_fmo_equation.source_id,
                     global_fmo_equation.source_type_id,
                     global_fmo_equation.i_d_measure_type_id,

                     a_edr_type_id,
                     a_edr_sub_type_id,

                     i_value);

    getEdrBytesValue(a_j_fileset_id,
                     a_j_min_d_period_id,
                     a_j_max_d_period_id,

                     global_fmo_equation.source_id,
                     global_fmo_equation.source_type_id,
                     global_fmo_equation.j_d_measure_type_id,

                     a_edr_type_id,
                     a_edr_sub_type_id,

                     j_value);

    -- calculate the metric
    the_metric    := j_value - i_value;
    the_raw_value := j_value - i_value;

    if global_fmo_equation.adjuster is not null then
      the_metric := the_metric * global_fmo_equation.adjuster;
    end if;

    the_metric_return_value.i_value      := i_value;
    the_metric_return_value.j_value      := j_value;
    the_metric_return_value.raw_value    := the_raw_value;
    the_metric_return_value.metric_value := the_metric;

    return the_metric_return_value;
  end;

  /*
    Percent (j as a percent of i, gives percentile loss)
  */
  function edrBytesPercentMetric(a_i_fileset_id      number,
                                 a_i_min_d_period_id date,
                                 a_i_max_d_period_id date,
                                 a_j_fileset_id      number,
                                 a_j_min_d_period_id date,
                                 a_j_max_d_period_id date,
                                 a_edr_type_id       number,
                                 a_edr_sub_type_id   number)
    return metric_return_value as
    i_value       number;
    j_value       number;
    the_metric    number;
    the_raw_value number;

    the_metric_return_value metric_return_value;

  begin
    -- get the i and j values
    getEdrBytesValue(a_i_fileset_id,
                     a_i_min_d_period_id,
                     a_i_max_d_period_id,

                     global_fmo_equation.source_id,
                     global_fmo_equation.source_type_id,
                     global_fmo_equation.i_d_measure_type_id,

                     a_edr_type_id,
                     a_edr_sub_type_id,

                     i_value);

    getEdrBytesValue(a_j_fileset_id,
                     a_j_min_d_period_id,
                     a_j_max_d_period_id,

                     global_fmo_equation.source_id,
                     global_fmo_equation.source_type_id,
                     global_fmo_equation.j_d_measure_type_id,

                     a_edr_type_id,
                     a_edr_sub_type_id,

                     j_value);

    -- calculate the metric
    if i_value != 0 then
      the_raw_value := j_value / i_value;
      the_metric    := the_raw_value - 1;
    elsif i_value = 0 then
      the_metric    := 0;
      the_raw_value := 0;
    else
      the_metric    := null;
      the_raw_value := null;
    end if;

    if global_fmo_equation.adjuster is not null then
      the_metric := the_metric * global_fmo_equation.adjuster;
    end if;

    the_metric_return_value.i_value := i_value;
    the_metric_return_value.j_value := j_value;
    if global_switch_to_raw != 'yes' then
      the_metric_return_value.raw_value    := the_raw_value;
      the_metric_return_value.metric_value := the_metric;
    else
      -- if parameter -switch_to_raw
      the_metric_return_value.raw_value    := the_metric;
      the_metric_return_value.metric_value := the_raw_value;
    end if;

    return the_metric_return_value;
  end;

  /*
    Difference (between i and j values, gives absolute difference)
  */
  function edrBytesDifferenceMetric(a_i_fileset_id      number,
                                    a_i_min_d_period_id date,
                                    a_i_max_d_period_id date,
                                    a_j_fileset_id      number,
                                    a_j_min_d_period_id date,
                                    a_j_max_d_period_id date,
                                    a_edr_type_id       number,
                                    a_edr_sub_type_id   number)
    return metric_return_value as
    i_value       number;
    j_value       number;
    the_metric    number;
    the_raw_value number;

    the_metric_return_value metric_return_value;

  begin
    -- get the i and j values
    getEdrBytesValue(a_i_fileset_id,
                     a_i_min_d_period_id,
                     a_i_max_d_period_id,

                     global_fmo_equation.source_id,
                     global_fmo_equation.source_type_id,
                     global_fmo_equation.i_d_measure_type_id,

                     a_edr_type_id,
                     a_edr_sub_type_id,

                     i_value);

    getEdrBytesValue(a_j_fileset_id,
                     a_j_min_d_period_id,
                     a_j_max_d_period_id,

                     global_fmo_equation.source_id,
                     global_fmo_equation.source_type_id,
                     global_fmo_equation.j_d_measure_type_id,

                     a_edr_type_id,
                     a_edr_sub_type_id,

                     j_value);

    -- calculate the metric
    the_metric    := ABS(j_value - i_value);
    the_raw_value := j_value - i_value;

    if global_fmo_equation.adjuster is not null then
      the_metric := the_metric * global_fmo_equation.adjuster;
    end if;

    the_metric_return_value.i_value      := i_value;
    the_metric_return_value.j_value      := j_value;
    the_metric_return_value.raw_value    := the_raw_value;
    the_metric_return_value.metric_value := the_metric;

    return the_metric_return_value;
  end;

  -- calculate all edr_xxx and return edr_count
  procedure getEdrCountValue(a_fileset_id        number,
                             a_min_d_period_id   date,
                             a_max_d_period_id   date,
                             a_d_source_id       number,
                             a_d_source_type_id  number,
                             a_d_measure_type_id number,
                             a_edr_type_id       number,
                             a_edr_sub_type_id   number,
                             a_value             OUT NOCOPY number) is

    count_value    number;
    value_value    number;
    bytes_value    number;
    duration_value number;
  begin

    getEdrXXXValue(a_fileset_id,
                   a_min_d_period_id,
                   a_max_d_period_id,
                   a_d_source_id,
                   a_d_source_type_id,
                   a_d_measure_type_id,
                   a_edr_type_id,
                   a_edr_sub_type_id,
                   count_value,
                   value_value,
                   bytes_value,
                   duration_value);

    a_value := count_value;

  end;

  -- calculate all edr_xxx and return edr_value
  procedure getEdrValueValue(a_fileset_id        number,
                             a_min_d_period_id   date,
                             a_max_d_period_id   date,
                             a_d_source_id       number,
                             a_d_source_type_id  number,
                             a_d_measure_type_id number,
                             a_edr_type_id       number,
                             a_edr_sub_type_id   number,
                             a_value             OUT NOCOPY number) is

    count_value    number;
    value_value    number;
    bytes_value    number;
    duration_value number;
  begin

    getEdrXXXValue(a_fileset_id,
                   a_min_d_period_id,
                   a_max_d_period_id,
                   a_d_source_id,
                   a_d_source_type_id,
                   a_d_measure_type_id,
                   a_edr_type_id,
                   a_edr_sub_type_id,
                   count_value,
                   value_value,
                   bytes_value,
                   duration_value);

    a_value := value_value;

  end;

  -- calculate all edr_xxx and return edr_bytes
  procedure getEdrBytesValue(a_fileset_id        number,
                             a_min_d_period_id   date,
                             a_max_d_period_id   date,
                             a_d_source_id       number,
                             a_d_source_type_id  number,
                             a_d_measure_type_id number,
                             a_edr_type_id       number,
                             a_edr_sub_type_id   number,
                             a_value             OUT NOCOPY number) is

    count_value    number;
    value_value    number;
    bytes_value    number;
    duration_value number;
  begin

    getEdrXXXValue(a_fileset_id,
                   a_min_d_period_id,
                   a_max_d_period_id,
                   a_d_source_id,
                   a_d_source_type_id,
                   a_d_measure_type_id,
                   a_edr_type_id,
                   a_edr_sub_type_id,
                   count_value,
                   value_value,
                   bytes_value,
                   duration_value);

    a_value := bytes_value;

  end;

  -- calculate all edr_xxx and return edr_duration
  procedure getEdrDurationValue(a_fileset_id        number,
                                a_min_d_period_id   date,
                                a_max_d_period_id   date,
                                a_d_source_id       number,
                                a_d_source_type_id  number,
                                a_d_measure_type_id number,
                                a_edr_type_id       number,
                                a_edr_sub_type_id   number,
                                a_value             OUT NOCOPY number) is

    count_value    number;
    value_value    number;
    bytes_value    number;
    duration_value number;
  begin

    getEdrXXXValue(a_fileset_id,
                   a_min_d_period_id,
                   a_max_d_period_id,
                   a_d_source_id,
                   a_d_source_type_id,
                   a_d_measure_type_id,
                   a_edr_type_id,
                   a_edr_sub_type_id,
                   count_value,
                   value_value,
                   bytes_value,
                   duration_value);

    a_value := duration_value;

  end;

  -- calculate all edr_XXX values
  procedure getEdrXXXValue(a_fileset_id        number,
                           a_min_d_period_id   date,
                           a_max_d_period_id   date,
                           a_d_source_id       number,
                           a_d_source_type_id  number,
                           a_d_measure_type_id number,
                           a_edr_type_id       number,
                           a_edr_sub_type_id   number,
                           count_value         OUT NOCOPY number,
                           value_value         OUT NOCOPY number,
                           bytes_value         OUT NOCOPY number,
                           duration_value      OUT NOCOPY number) is

    cursor l_test is
      select distinct log_record_id, d_period_id
        from fmo_fileset f
       where f.fileset_id = a_fileset_id
         and f.d_period_id between a_min_d_period_id and a_max_d_period_id;

    cursor l_test_file is
      select max(l.log_record_id) log_record_id,
             max(l.d_period_id) d_period_id
        from fmo_fileset f, um.log_record l
       where f.fileset_id = a_fileset_id
         and l.log_record_id = f.log_record_id
         and l.d_period_id = f.d_period_id
         and f.d_period_id between a_min_d_period_id and a_max_d_period_id
       group by l.file_name;

    count_total_value    number;
    value_total_value    number;
    bytes_total_value    number;
    duration_total_value number;
    v_count_count        number;
    v_value_count        number;
    v_bytes_count        number;
    v_duration_count     number;
  begin

    count_total_value    := null;
    value_total_value    := null;
    bytes_total_value    := null;
    duration_total_value := null;
    v_count_count        := 0;
    v_value_count        := 0;
    v_bytes_count        := 0;
    v_duration_count     := 0;

    /******
      TODO: find a better solution to teh T-Mobile hack.

      Andrew Maris:
      "T-Mobile still use the distinct_filenames functionality.
      If it is taken away then some of their metrics wont work correctly.
      Will try to explain what it does:

      Some TMU batch files look like the following:

      Date,      In_Filename, Out_Filename, In Record Count, Out Record Count
      1/1/2009,     Afile.txt,       AfileOut1.txt,           10,                     5
      1/1/2009,     Afile.txt,       AfileOut2.txt,           10,                     3
      1/1/2009,     Afile.txt,       AfileOut3.txt,           10,                     2
      1/1/2009,     Afile.txt,       AfileOut4.txt,           10,                     1
      1/1/2009,     Bfile.txt,       BfileOut1.txt,           20,                     5
      1/1/2009,     Bfile.txt,       BfileOut2.txt,           20,                     15

      And TMU require a metric that will sum up the total In record Count. In this example, this result should be 30.
      With the distinct_filename parameter the result will be 30, but without the distinct_filename parameter it will be 80."
    *****/
    IF global_parameters('-distinct_filenames') = 'yes' THEN
      -- Loop over files in fileset to avoid join onto fmo_fileset
      for r_test_file in l_test_file loop

        -- get sum of all edr_xxx fields for this iteration
        select sum(edr_count),
               sum(edr_value),
               sum(edr_bytes),
               sum(edr_duration)
          into count_value, value_value, bytes_value, duration_value

          from f_file ff, d_edr_type_mv edr, f_attribute fa
         where ff.d_period_id = r_test_file.d_period_id
           and fa.f_attribute_id = ff.f_attribute_id
           and ff.log_record_id = r_test_file.log_record_id
           and (a_d_source_id is null OR fa.d_source_id = a_d_source_id)
           and (a_d_source_type_id is null OR EXISTS
                (select source_id
                   from source_ref s
                  where source_type_id = a_d_source_type_id
                    and s.source_id = fa.d_source_id))
           and (a_d_measure_type_id is null OR
               fa.d_measure_type_id = a_d_measure_type_id)

           and fa.d_edr_type_id = edr.d_edr_type_id
           and (a_edr_type_id is null OR edr.edr_type_uid = a_edr_type_id)
           and (a_edr_sub_type_id is null OR
               edr.edr_sub_type_id = a_edr_sub_type_id)
           and (global_fmo_equation.edr_type_id is null OR
               edr.edr_type_uid = global_fmo_equation.edr_type_id)
           and (global_fmo_equation.edr_sub_type_id is null OR
               edr.edr_sub_type_id = global_fmo_equation.edr_sub_type_id)

           and (global_fmo_equation.d_payment_type_id is null OR
               fa.d_payment_type_id =
               global_fmo_equation.d_payment_type_id)
           and (global_fmo_equation.d_call_type_id is null OR
               fa.d_call_type_id = global_fmo_equation.d_call_type_id)
           and (global_fmo_equation.d_customer_type_id is null OR
               fa.d_customer_type_id =
               global_fmo_equation.d_customer_type_id)
           and (global_fmo_equation.d_service_provider_id is null OR
               fa.d_service_provider_id =
               global_fmo_equation.d_service_provider_id)

              -- ugly, but at least it can use indexes
           and (global_fmo_equation.d_custom_01_list is null OR
               fa.d_custom_01_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_01_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_02_list is null OR
               fa.d_custom_02_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_02_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_03_list is null OR
               fa.d_custom_03_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_03_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_04_list is null OR
               fa.d_custom_04_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_04_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_05_list is null OR
               fa.d_custom_05_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_05_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_06_list is null OR
               fa.d_custom_06_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_06_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_07_list is null OR
               fa.d_custom_07_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_07_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_08_list is null OR
               fa.d_custom_08_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_08_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_09_list is null OR
               fa.d_custom_09_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_09_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_10_list is null OR
               fa.d_custom_10_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_10_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_11_list is null OR
               fa.d_custom_11_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_11_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_12_list is null OR
               fa.d_custom_12_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_12_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_13_list is null OR
               fa.d_custom_13_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_13_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_14_list is null OR
               fa.d_custom_14_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_14_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_15_list is null OR
               fa.d_custom_15_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_15_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_16_list is null OR
               fa.d_custom_16_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_16_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_17_list is null OR
               fa.d_custom_17_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_17_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_18_list is null OR
               fa.d_custom_18_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_18_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_19_list is null OR
               fa.d_custom_19_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_19_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_20_list is null OR
               fa.d_custom_20_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_20_list as
                                         inlisttype)
                               from dual)));

        /*
                    and (global_fmo_equation.d_custom_01_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_01_list_csv || ','), (',' || fa.d_custom_01_id || ',')))
                    and (global_fmo_equation.d_custom_02_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_02_list_csv || ','), (',' || fa.d_custom_02_id || ',')))
                    and (global_fmo_equation.d_custom_03_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_03_list_csv || ','), (',' || fa.d_custom_03_id || ',')))
                    and (global_fmo_equation.d_custom_04_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_04_list_csv || ','), (',' || fa.d_custom_04_id || ',')))
                    and (global_fmo_equation.d_custom_05_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_05_list_csv || ','), (',' || fa.d_custom_05_id || ',')))
                    and (global_fmo_equation.d_custom_06_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_06_list_csv || ','), (',' || fa.d_custom_06_id || ',')))
                    and (global_fmo_equation.d_custom_07_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_07_list_csv || ','), (',' || fa.d_custom_07_id || ',')))
                    and (global_fmo_equation.d_custom_08_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_08_list_csv || ','), (',' || fa.d_custom_08_id || ',')))
                    and (global_fmo_equation.d_custom_09_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_09_list_csv || ','), (',' || fa.d_custom_09_id || ',')))
                    and (global_fmo_equation.d_custom_10_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_10_list_csv || ','), (',' || fa.d_custom_10_id || ',')))
                    and (global_fmo_equation.d_custom_11_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_11_list_csv || ','), (',' || fa.d_custom_11_id || ',')))
                    and (global_fmo_equation.d_custom_12_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_12_list_csv || ','), (',' || fa.d_custom_12_id || ',')))
                    and (global_fmo_equation.d_custom_13_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_13_list_csv || ','), (',' || fa.d_custom_13_id || ',')))
                    and (global_fmo_equation.d_custom_14_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_14_list_csv || ','), (',' || fa.d_custom_14_id || ',')))
                    and (global_fmo_equation.d_custom_15_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_15_list_csv || ','), (',' || fa.d_custom_15_id || ',')))
                    and (global_fmo_equation.d_custom_16_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_16_list_csv || ','), (',' || fa.d_custom_16_id || ',')))
                    and (global_fmo_equation.d_custom_17_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_17_list_csv || ','), (',' || fa.d_custom_17_id || ',')))
                    and (global_fmo_equation.d_custom_18_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_18_list_csv || ','), (',' || fa.d_custom_18_id || ',')))
                    and (global_fmo_equation.d_custom_19_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_19_list_csv || ','), (',' || fa.d_custom_19_id || ',')))
                    and (global_fmo_equation.d_custom_20_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_20_list_csv || ','), (',' || fa.d_custom_20_id || ',')));
        */

        -- maintain total counts in case we need to calculate an average
        -- also, do not add nulls as it screws up the sum
        if count_value is not null then
          count_total_value := nvl(count_total_value, 0) + count_value;
          v_count_count     := v_count_count + 1;
        end if;

        if value_value is not null then
          value_total_value := nvl(value_total_value, 0) + value_value;
          v_value_count     := v_value_count + 1;
        end if;

        if bytes_value is not null then
          bytes_total_value := nvl(bytes_total_value, 0) + bytes_value;
          v_bytes_count     := v_bytes_count + 1;
        end if;

        if duration_value is not null then
          duration_total_value := nvl(duration_total_value, 0) +
                                  duration_value;
          v_duration_count     := v_duration_count + 1;
        end if;

      end loop;
    ELSE
      -- Loop over files in fileset to avoid join onto log_record
      for r_test in l_test loop

        -- get sum of all edr_xxx fields for this iteration
        select sum(edr_count),
               sum(edr_value),
               sum(edr_bytes),
               sum(edr_duration)
          into count_value, value_value, bytes_value, duration_value

          from f_file ff, d_edr_type_mv edr, f_attribute fa
         where ff.d_period_id = r_test.d_period_id
           and fa.f_attribute_id = ff.f_attribute_id
           and ff.log_record_id = r_test.log_record_id
           and (a_d_source_id is null OR fa.d_source_id = a_d_source_id)
           and (a_d_source_type_id is null OR EXISTS
                (select source_id
                   from source_ref s
                  where source_type_id = a_d_source_type_id
                    and s.source_id = fa.d_source_id))
           and (a_d_measure_type_id is null OR
               fa.d_measure_type_id = a_d_measure_type_id)

           and fa.d_edr_type_id = edr.d_edr_type_id
           and (a_edr_type_id is null OR edr.edr_type_uid = a_edr_type_id)
           and (a_edr_sub_type_id is null OR
               edr.edr_sub_type_id = a_edr_sub_type_id)
           and (global_fmo_equation.edr_type_id is null OR
               edr.edr_type_uid = global_fmo_equation.edr_type_id)
           and (global_fmo_equation.edr_sub_type_id is null OR
               edr.edr_sub_type_id = global_fmo_equation.edr_sub_type_id)

           and (global_fmo_equation.d_payment_type_id is null OR
               fa.d_payment_type_id =
               global_fmo_equation.d_payment_type_id)
           and (global_fmo_equation.d_call_type_id is null OR
               fa.d_call_type_id = global_fmo_equation.d_call_type_id)
           and (global_fmo_equation.d_customer_type_id is null OR
               fa.d_customer_type_id =
               global_fmo_equation.d_customer_type_id)
           and (global_fmo_equation.d_service_provider_id is null OR
               fa.d_service_provider_id =
               global_fmo_equation.d_service_provider_id)

              -- ugly, but at least it can use indexes
           and (global_fmo_equation.d_custom_01_list is null OR
               fa.d_custom_01_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_01_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_02_list is null OR
               fa.d_custom_02_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_02_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_03_list is null OR
               fa.d_custom_03_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_03_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_04_list is null OR
               fa.d_custom_04_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_04_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_05_list is null OR
               fa.d_custom_05_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_05_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_06_list is null OR
               fa.d_custom_06_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_06_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_07_list is null OR
               fa.d_custom_07_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_07_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_08_list is null OR
               fa.d_custom_08_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_08_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_09_list is null OR
               fa.d_custom_09_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_09_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_10_list is null OR
               fa.d_custom_10_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_10_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_11_list is null OR
               fa.d_custom_11_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_11_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_12_list is null OR
               fa.d_custom_12_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_12_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_13_list is null OR
               fa.d_custom_13_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_13_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_14_list is null OR
               fa.d_custom_14_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_14_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_15_list is null OR
               fa.d_custom_15_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_15_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_16_list is null OR
               fa.d_custom_16_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_16_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_17_list is null OR
               fa.d_custom_17_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_17_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_18_list is null OR
               fa.d_custom_18_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_18_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_19_list is null OR
               fa.d_custom_19_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_19_list as
                                         inlisttype)
                               from dual)))
           and (global_fmo_equation.d_custom_20_list is null OR
               fa.d_custom_20_id IN
               (select *
                   from THE (select cast(global_fmo_equation.d_custom_20_list as
                                         inlisttype)
                               from dual)));

        /*
                    and (global_fmo_equation.d_custom_01_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_01_list_csv || ','), (',' || fa.d_custom_01_id || ',')))
                    and (global_fmo_equation.d_custom_02_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_02_list_csv || ','), (',' || fa.d_custom_02_id || ',')))
                    and (global_fmo_equation.d_custom_03_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_03_list_csv || ','), (',' || fa.d_custom_03_id || ',')))
                    and (global_fmo_equation.d_custom_04_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_04_list_csv || ','), (',' || fa.d_custom_04_id || ',')))
                    and (global_fmo_equation.d_custom_05_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_05_list_csv || ','), (',' || fa.d_custom_05_id || ',')))
                    and (global_fmo_equation.d_custom_06_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_06_list_csv || ','), (',' || fa.d_custom_06_id || ',')))
                    and (global_fmo_equation.d_custom_07_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_07_list_csv || ','), (',' || fa.d_custom_07_id || ',')))
                    and (global_fmo_equation.d_custom_08_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_08_list_csv || ','), (',' || fa.d_custom_08_id || ',')))
                    and (global_fmo_equation.d_custom_09_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_09_list_csv || ','), (',' || fa.d_custom_09_id || ',')))
                    and (global_fmo_equation.d_custom_10_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_10_list_csv || ','), (',' || fa.d_custom_10_id || ',')))
                    and (global_fmo_equation.d_custom_11_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_11_list_csv || ','), (',' || fa.d_custom_11_id || ',')))
                    and (global_fmo_equation.d_custom_12_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_12_list_csv || ','), (',' || fa.d_custom_12_id || ',')))
                    and (global_fmo_equation.d_custom_13_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_13_list_csv || ','), (',' || fa.d_custom_13_id || ',')))
                    and (global_fmo_equation.d_custom_14_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_14_list_csv || ','), (',' || fa.d_custom_14_id || ',')))
                    and (global_fmo_equation.d_custom_15_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_15_list_csv || ','), (',' || fa.d_custom_15_id || ',')))
                    and (global_fmo_equation.d_custom_16_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_16_list_csv || ','), (',' || fa.d_custom_16_id || ',')))
                    and (global_fmo_equation.d_custom_17_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_17_list_csv || ','), (',' || fa.d_custom_17_id || ',')))
                    and (global_fmo_equation.d_custom_18_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_18_list_csv || ','), (',' || fa.d_custom_18_id || ',')))
                    and (global_fmo_equation.d_custom_19_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_19_list_csv || ','), (',' || fa.d_custom_19_id || ',')))
                    and (global_fmo_equation.d_custom_20_list_csv is null or regexp_like((',' || global_fmo_equation.d_custom_20_list_csv || ','), (',' || fa.d_custom_20_id || ',')));
        */

        -- maintain total counts in case we need to calculate an average
        -- also, do not add nulls as it screws up the sum
        if count_value is not null then
          count_total_value := nvl(count_total_value, 0) + count_value;
          v_count_count     := v_count_count + 1;
        end if;

        if value_value is not null then
          value_total_value := nvl(value_total_value, 0) + value_value;
          v_value_count     := v_value_count + 1;
        end if;

        if bytes_value is not null then
          bytes_total_value := nvl(bytes_total_value, 0) + bytes_value;
          v_bytes_count     := v_bytes_count + 1;
        end if;

        if duration_value is not null then
          duration_total_value := nvl(duration_total_value, 0) +
                                  duration_value;
          v_duration_count     := v_duration_count + 1;
        end if;

      end loop;

    END IF;

    -- avg ?
    if global_var_function_id = 'avg' then

      if v_count_count != 0 then
        count_total_value := count_total_value / v_count_count;
      else
        count_total_value := null;
      end if;

      if v_value_count != 0 then
        value_total_value := value_total_value / v_value_count;
      else
        value_total_value := null;
      end if;

      if v_bytes_count != 0 then
        bytes_total_value := bytes_total_value / v_bytes_count;
      else
        bytes_total_value := null;
      end if;

      if v_duration_count != 0 then
        duration_total_value := duration_total_value / v_duration_count;
      else
        duration_total_value := null;
      end if;

    end if;

    -- return all edr_xxx total values
    count_value    := count_total_value;
    value_value    := value_total_value;
    bytes_value    := bytes_total_value;
    duration_value := duration_total_value;

  end;

  function edrCalcMetricFmoEqn(a_i_fileset_id      number,
                               a_i_min_d_period_id date,
                               a_i_max_d_period_id date,
                               a_j_fileset_id      number,
                               a_j_min_d_period_id date,
                               a_j_max_d_period_id date,
                               a_edr_type_id       number,
                               a_edr_sub_type_id   number)
    return metric_return_value as
  begin

    --switch on the required metric calculation function
    case global_metric_function_id
      when 'edrCountMinusMetric' then
        return edrCountMinusMetric(a_i_fileset_id,
                                   a_i_min_d_period_id,
                                   a_i_max_d_period_id,
                                   a_j_fileset_id,
                                   a_j_min_d_period_id,
                                   a_j_max_d_period_id,
                                   a_edr_type_id,
                                   a_edr_sub_type_id);

      when 'edrCountSumMetric' then
        return edrCountSumMetric(a_i_fileset_id,
                                 a_i_min_d_period_id,
                                 a_i_max_d_period_id,
                                 a_edr_type_id,
                                 a_edr_sub_type_id);

      when 'edrCountPercentMetric' then
        return edrCountPercentMetric(a_i_fileset_id,
                                     a_i_min_d_period_id,
                                     a_i_max_d_period_id,
                                     a_j_fileset_id,
                                     a_j_min_d_period_id,
                                     a_j_max_d_period_id,
                                     a_edr_type_id,
                                     a_edr_sub_type_id);

      when 'edrCountDifferenceMetric' then
        return edrCountDifferenceMetric(a_i_fileset_id,
                                        a_i_min_d_period_id,
                                        a_i_max_d_period_id,
                                        a_j_fileset_id,
                                        a_j_min_d_period_id,
                                        a_j_max_d_period_id,
                                        a_edr_type_id,
                                        a_edr_sub_type_id);

      when 'edrValueMinusMetric' then
        return edrValueMinusMetric(a_i_fileset_id,
                                   a_i_min_d_period_id,
                                   a_i_max_d_period_id,
                                   a_j_fileset_id,
                                   a_j_min_d_period_id,
                                   a_j_max_d_period_id,
                                   a_edr_type_id,
                                   a_edr_sub_type_id);

      when 'edrValueSumMetric' then
        return edrValueSumMetric(a_i_fileset_id,
                                 a_i_min_d_period_id,
                                 a_i_max_d_period_id,
                                 a_edr_type_id,
                                 a_edr_sub_type_id);

      when 'edrValuePercentMetric' then
        return edrValuePercentMetric(a_i_fileset_id,
                                     a_i_min_d_period_id,
                                     a_i_max_d_period_id,
                                     a_j_fileset_id,
                                     a_j_min_d_period_id,
                                     a_j_max_d_period_id,
                                     a_edr_type_id,
                                     a_edr_sub_type_id);

      when 'edrValueDifferenceMetric' then
        return edrValueDifferenceMetric(a_i_fileset_id,
                                        a_i_min_d_period_id,
                                        a_i_max_d_period_id,
                                        a_j_fileset_id,
                                        a_j_min_d_period_id,
                                        a_j_max_d_period_id,
                                        a_edr_type_id,
                                        a_edr_sub_type_id);

      when 'edrBytesMinusMetric' then
        return edrBytesMinusMetric(a_i_fileset_id,
                                   a_i_min_d_period_id,
                                   a_i_max_d_period_id,
                                   a_j_fileset_id,
                                   a_j_min_d_period_id,
                                   a_j_max_d_period_id,
                                   a_edr_type_id,
                                   a_edr_sub_type_id);

      when 'edrBytesSumMetric' then
        return edrBytesSumMetric(a_i_fileset_id,
                                 a_i_min_d_period_id,
                                 a_i_max_d_period_id,
                                 a_edr_type_id,
                                 a_edr_sub_type_id);

      when 'edrBytesPercentMetric' then
        return edrBytesPercentMetric(a_i_fileset_id,
                                     a_i_min_d_period_id,
                                     a_i_max_d_period_id,
                                     a_j_fileset_id,
                                     a_j_min_d_period_id,
                                     a_j_max_d_period_id,
                                     a_edr_type_id,
                                     a_edr_sub_type_id);

      when 'edrBytesDifferenceMetric' then
        return edrBytesDifferenceMetric(a_i_fileset_id,
                                        a_i_min_d_period_id,
                                        a_i_max_d_period_id,
                                        a_j_fileset_id,
                                        a_j_min_d_period_id,
                                        a_j_max_d_period_id,
                                        a_edr_type_id,
                                        a_edr_sub_type_id);

      when 'edrDurationMinusMetric' then
        return edrDurationMinusMetric(a_i_fileset_id,
                                      a_i_min_d_period_id,
                                      a_i_max_d_period_id,
                                      a_j_fileset_id,
                                      a_j_min_d_period_id,
                                      a_j_max_d_period_id,
                                      a_edr_type_id,
                                      a_edr_sub_type_id);

      when 'edrDurationSumMetric' then
        return edrDurationSumMetric(a_i_fileset_id,
                                    a_i_min_d_period_id,
                                    a_i_max_d_period_id,
                                    a_edr_type_id,
                                    a_edr_sub_type_id);

      when 'edrDurationPercentMetric' then
        return edrDurationPercentMetric(a_i_fileset_id,
                                        a_i_min_d_period_id,
                                        a_i_max_d_period_id,
                                        a_j_fileset_id,
                                        a_j_min_d_period_id,
                                        a_j_max_d_period_id,
                                        a_edr_type_id,
                                        a_edr_sub_type_id);

      when 'edrDurationDifferenceMetric' then
        return edrDurationDifferenceMetric(a_i_fileset_id,
                                           a_i_min_d_period_id,
                                           a_i_max_d_period_id,
                                           a_j_fileset_id,
                                           a_j_min_d_period_id,
                                           a_j_max_d_period_id,
                                           a_edr_type_id,
                                           a_edr_sub_type_id);

      when 'edrCustomSQLMetric' then
        return edrCustomSQLMetric(a_i_fileset_id,
                                  a_i_min_d_period_id,
                                  a_i_max_d_period_id,
                                  a_j_fileset_id,
                                  a_j_min_d_period_id,
                                  a_j_max_d_period_id);

      else
        return null;

    end case;
  end;

  ---------------------------------------------------------------
  --
  -- An initialisation procedure
  -- Called once to determine which metric calculation function
  -- is to be used
  --
  ---------------------------------------------------------------
  procedure setGlobalMetricFunction(a_metric_operator_id number) is
    fmo_equation_exception exception;
  begin

    --read from fmo_equation
    select metric_operator_id,
           field_type,
           operator,
           adjuster,
           source_id,
           source_type_id,
           edr_type_id,
           edr_sub_type_id,
           i_d_measure_type_id,
           j_d_measure_type_id,

           d_payment_type_id,
           d_call_type_id,
           d_customer_type_id,
           d_service_provider_id,

           -- hmm, metrics still use inList types
           in_list(d_custom_01_list),
           in_list(d_custom_02_list),
           in_list(d_custom_03_list),
           in_list(d_custom_04_list),
           in_list(d_custom_05_list),
           in_list(d_custom_06_list),
           in_list(d_custom_07_list),
           in_list(d_custom_08_list),
           in_list(d_custom_09_list),
           in_list(d_custom_10_list),
           in_list(d_custom_11_list),
           in_list(d_custom_12_list),
           in_list(d_custom_13_list),
           in_list(d_custom_14_list),
           in_list(d_custom_15_list),
           in_list(d_custom_16_list),
           in_list(d_custom_17_list),
           in_list(d_custom_18_list),
           in_list(d_custom_19_list),
           in_list(d_custom_20_list),

           -- keep until decide on which approach is best
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

      into global_fmo_equation
      from fmo_equation
     where metric_operator_id = a_metric_operator_id;

    case global_fmo_equation.field_type
      when 'B' then
        case global_fmo_equation.operator
          when 'Sum' then
            global_metric_function_id := 'edrBytesSumMetric';
          when 'Minus' then
            global_metric_function_id := 'edrBytesMinusMetric';
          when 'Percent' then
            global_metric_function_id := 'edrBytesPercentMetric';
          when 'Difference' then
            global_metric_function_id := 'edrBytesDifferenceMetric';
          else
            raise fmo_equation_exception;
        end case;
      when 'C' then
        case global_fmo_equation.operator
          when 'Sum' then
            global_metric_function_id := 'edrCountSumMetric';
          when 'Minus' then
            global_metric_function_id := 'edrCountMinusMetric';
          when 'Percent' then
            global_metric_function_id := 'edrCountPercentMetric';
          when 'Difference' then
            global_metric_function_id := 'edrCountDifferenceMetric';
          else
            raise fmo_equation_exception;
        end case;
      when 'D' then
        case global_fmo_equation.operator
          when 'Sum' then
            global_metric_function_id := 'edrDurationSumMetric';
          when 'Minus' then
            global_metric_function_id := 'edrDurationMinusMetric';
          when 'Percent' then
            global_metric_function_id := 'edrDurationPercentMetric';
          when 'Difference' then
            global_metric_function_id := 'edrDurationDifferenceMetric';
          else
            raise fmo_equation_exception;
        end case;
      when 'V' then
        case global_fmo_equation.operator
          when 'Sum' then
            global_metric_function_id := 'edrValueSumMetric';
          when 'Minus' then
            global_metric_function_id := 'edrValueMinusMetric';
          when 'Percent' then
            global_metric_function_id := 'edrValuePercentMetric';
          when 'Difference' then
            global_metric_function_id := 'edrValueDifferenceMetric';
          else
            raise fmo_equation_exception;
        end case;

      else
        raise fmo_equation_exception;

    end case;

    if global_parameters('-switch_to_raw') = 'yes' then
      global_switch_to_raw := 'yes';
    else
      global_switch_to_raw := 'no';
    end if;

  exception
    -- record and return any exception message
    when others then
      loggerAuto('setGlobalMetricFunction: problem with fmoEquation for this metric operator: ' ||
                 a_metric_operator_id);
      loggerAuto('Exception: ' || SUBSTR(SQLERRM, 1, 4000));

      -- re-throw any exception
      raise;
  end;

  /******************************************************************
  * END
  * Actual Metric Function:
  *
  * This section holds the implementations of the specific metric
  * calculation functions, and helper functions
  *
  *******************************************************************/

  /******************************************************************
  * START
  * Utilities:
  *
  *******************************************************************/

  ----------------------------------------------------------------
  -- OPERATOR DB LOG
  --
  -- loggerAuto will force commit of the messages
  -- messages will not be lost on rollback (ie if opreator fails)
  ----------------------------------------------------------------
  procedure loggerAuto(msg varchar2) is
    pragma autonomous_transaction;
  begin
    -- make autonomous so logging doesn't get rolled back
    insert into operator_log
      (operator_log_id, operator_id, thread_id, log, log_date)
    values
      (seq_operator_log_id.nextval,
       global_operator_id,
       global_thread_id,
       msg,
       sysdate);

    commit;
  end;

  procedure forceMsg(jobId integer, msg varchar) is
  begin
    begin
      utils.table_utils.PutMessage('um.filesetReconciliation',
                                   msg,
                                   jobId,
                                   'Y');
      commit;
    end;
  end;

  ----------------------------------------------------------------
  -- Use this procedure for debug message
  --
  -- Output controlled by the operator/job parameter
  -- "-debug yes"
  --
  ----------------------------------------------------------------
  procedure loggerDebug(msg varchar2) is
  begin
    if global_debug = 1 then
      loggerAuto(msg);
    end if;
  end;

  procedure loggerDebugWithTest(msg varchar2, okay boolean) is
  begin
    if global_debug = 1 and okay then
      loggerAuto(msg);
    end if;
  end;

  /***
  * This is just for debug purposes...
  *
  * AND IS PROBABLY OUT-OF-DATE AND LIKELY TO FALL OVER IF USED
  ****/
  procedure showGlobalThreshData is
    the_threshold_date_data      threshold_date_data;
    the_thresh_date_array        threshold_date_array;
    the_threshold_day_data       threshold_day_data;
    the_thresh_day_array         threshold_day_array;
    the_threshold_def_data       threshold_def_data;
    the_threshold_seq_data_array threshold_seq_data_array;
    the_threshold_sev_data       threshold_sev_data;
    the_threshold_sev_data_array threshold_sev_data_array;

    the_source_ids      source_id_array;
    the_source_type_ids source_type_id_array;

    e_row   pls_integer;
    l_row   pls_integer;
    counter pls_integer;
  begin

    e_row := global_thresh_data_by_id.FIRST;
    while (e_row is not null) loop
      the_threshold_seq_data_array := global_thresh_data_by_id(e_row);
      loggerDebug('XXX EDGE/NODE (Thresholds): ' || e_row);

      l_row := the_threshold_seq_data_array.FIRST;
      while (l_row is not null) loop
        loggerDebug('XXX Thresh Ver: ' || l_row);

        the_threshold_def_data := the_threshold_seq_data_array(l_row);

        -- tv_data
        loggerDebug('TV Desc: ' || the_threshold_def_data.tvr_description);
        loggerDebug('Is Comparator: ' ||
                    the_threshold_def_data.tvr_is_comparator);

        -- test days
        the_thresh_day_array := the_threshold_def_data.day_data;

        if the_thresh_day_array is not null then
          loggerDebug('EdgeId: ' || the_threshold_def_data.edge_id);
          loggerDebug('NodeId: ' || the_threshold_def_data.node_id);
          loggerDebug('DAYS');

          counter := the_thresh_day_array.FIRST;
          while (counter is not null) loop
            the_threshold_day_data := the_thresh_day_array(counter);
            loggerDebug('DAY verId: ' ||
                        the_threshold_day_data.thresh_version_id);
            loggerDebug('DAY day: ' || the_threshold_day_data.t_day);
            loggerDebug('DAY from: ' || the_threshold_day_data.from_time);
            loggerDebug('DAY to: ' || the_threshold_day_data.to_time);
            counter := the_thresh_day_array.NEXT(counter);
          end loop;
        end if;

        -- test dates
        the_thresh_date_array := the_threshold_def_data.date_data;

        if the_thresh_date_array is not null then
          loggerDebug('EdgeId: ' || the_threshold_def_data.edge_id);
          loggerDebug('NodeId: ' || the_threshold_def_data.node_id);
          loggerDebug('DATES');

          counter := the_thresh_date_array.FIRST;
          while (counter is not null) loop
            the_threshold_date_data := the_thresh_date_array(counter);
            loggerDebug('DATE verId: ' ||
                        the_threshold_date_data.thresh_version_id);
            loggerDebug('DATE from: ' ||
                        to_char(the_threshold_date_data.from_date,
                                'YYYYMMDD HH24:MI:SS'));
            loggerDebug('DATE to: ' ||
                        to_char(the_threshold_date_data.to_date,
                                'YYYYMMDD HH24:MI:SS'));
            counter := the_thresh_date_array.NEXT(counter);
          end loop;
        end if;

        -- sources
        the_source_ids := the_threshold_def_data.source_ids;
        if the_source_ids is not null then
          counter := the_source_ids.FIRST;
          while (counter is not null) loop
            the_threshold_sev_data := the_threshold_sev_data_array(counter);
            loggerDebug('Source id: ' || the_source_ids(counter));
            counter := the_threshold_sev_data_array.NEXT(counter);
          end loop;
        end if;

        -- sources types
        the_source_type_ids := the_threshold_def_data.source_type_ids;
        if the_source_type_ids is not null then
          counter := the_source_type_ids.FIRST;
          while (counter is not null) loop
            the_threshold_sev_data := the_threshold_sev_data_array(counter);
            loggerDebug('Source Type id: ' || the_source_type_ids(counter));
            counter := the_threshold_sev_data_array.NEXT(counter);
          end loop;
        end if;

        -- tv_data
        the_threshold_sev_data_array := the_threshold_def_data.severity_data;
        if the_threshold_sev_data_array is not null then
          loggerDebug('SEVERITIES');
          counter := the_threshold_sev_data_array.FIRST;
          while (counter is not null) loop
            the_threshold_sev_data := the_threshold_sev_data_array(counter);
            loggerDebug('severity_id: ' ||
                        the_threshold_sev_data.severity_id);
            loggerDebug('value: ' || the_threshold_sev_data.value);
            loggerDebug('operator: ' || the_threshold_sev_data.operator);
            loggerDebug('etc...');
            counter := the_threshold_sev_data_array.NEXT(counter);
          end loop;
        end if;

        l_row := the_threshold_seq_data_array.NEXT(l_row);
      end loop;

      e_row := global_thresh_data_by_id.NEXT(l_row);
    end loop;

  exception
    when others then
      loggerDebug('Exception: ' || SUBSTR(SQLERRM, 1, 4000));
  end;

  function getActiveOperatorId(metric_def_id NUMBER) return NUMBER as
    id NUMBER;
  begin

    select metric_operator_id
      into id
      from (
        select t1.metric_operator_id
          from um.metric_version_ref t, um.metric_operator_ref t1
         where t.metric_version_id = t1.metric_version_id
           and t.valid_from <= sysdate
           and t.valid_to >= sysdate
           and t.metric_definition_id = metric_def_id
           and t.status = 'A'
         order by t.valid_from desc)
     where rownum < 2;

    return id;
  end;

  /******************************************************************
  * END
  * Utilities:
  *
  *******************************************************************/

  /*****
  * Converts a csv string like "123,456,789"
  * into a collection of numbers, thus suitable to be used
  * in an IN CLAUSE
  *
  * If p_string is null, then return null
  *****/
  function in_list(p_string in varchar2) return inListType as
    l_data   inListType := inListType();
    l_string long default p_string || ',';
    l_n      number;
  begin

    if p_string is null then
      return null;
    end if;

    loop
      exit when l_string is null;
      l_data.extend;
      l_n := instr(l_string, ',');
      l_data(l_data.count) := substr(l_string, 1, l_n - 1);
      l_string := substr(l_string, l_n + 1);
    end loop;
    return l_data;
  end;

  /******************************
  * Converts an inListType into a csv string like "123,456,789"
  ******************************/
  function inlist2varchar(p_in_list in inListType) return varchar2 as
    l_str varchar2(4000);
  begin

    if p_in_list is null then
      return null;
    end if;

    if p_in_list.count > 0 then
      l_str := p_in_list(p_in_list.first);
      for i in (p_in_list.first + 1) .. p_in_list.last loop
        l_str := l_str || ',' || p_in_list(i);
      end loop;
    end if;

    return l_str;
  end;

  /*
    Set Parameters.

    unpack parameters into global associative array (global_parameters)
    for use later on.

  */
  procedure setParameters(all_parameters varchar2) is

    idx    number;
    pkey   varchar2(200);
    pvalue varchar2(4000);
    params varchar2(10000);
  begin
    loggerAuto('Operator Parameters: ' ||
               replace(all_parameters, ':_:', '  '));
    idx    := 0;
    params := all_parameters;

    global_parameters.delete;

    loop
      idx := instr(params, ':_:');

      if (nvl(idx, 0) > 0) then
        pkey   := lower(substr(params, 1, idx - 1));
        params := substr(params, idx + 3);

        idx := instr(params, ':_:');

        if (nvl(idx, 0) = 0) then
          pvalue := lower(params);
        else
          pvalue := lower(substr(params, 1, idx - 1));
        end if;

        params := substr(params, idx + 3);
        global_parameters(pkey) := pvalue;
      else
        exit;
      end if;
    end loop;

    -- set core parameters to default value if no
    -- value exists, this is to avoid no_data_found exceptions

    /* forecast_type is percent (default)  or absolute */
    if not global_parameters.exists('-forecast_type') then
      global_parameters('-forecast_type') := 'percent';
    end if;

    if not global_parameters.exists('-meta_metric') then
      global_parameters('-meta_metric') := 'no';
    end if;

    if not global_parameters.exists('-function') then
      global_parameters('-function') := 'sum';
    end if;
    global_var_function_id := global_parameters('-function');

    if not global_parameters.exists('-long_metric') then
      global_parameters('-long_metric') := 'no';
    end if;

    if not global_parameters.exists('-custom_sql_metric') then
      global_parameters('-custom_sql_metric') := 'no';
    end if;

    if not global_parameters.exists('-edr_group') then
      global_parameters('-edr_group') := 'no';
    end if;

    if not global_parameters.exists('-switch_to_raw') then
      global_parameters('-switch_to_raw') := 'no';
      global_switch_to_raw := 'no';
    end if;

    if not global_parameters.exists('-distinct_filenames') then
      global_parameters('-distinct_filenames') := 'no';
    end if;

  exception
    when others then
      loggerAuto('setParameters Exception: ' || SUBSTR(SQLERRM, 1, 4000));
      RAISE_APPLICATION_ERROR(-20001,
                              'Exception: ' || SUBSTR(SQLERRM, 1, 4000));
  end;

  ---------------------------------------------------------------
  --
  -- An initialisation procedure for custom metrics
  -- Called once to retrieve custom sqls and substitute
  -- any parameters
  --
  ---------------------------------------------------------------

  procedure setCustomSQLMetricFunction(a_metric_operator number) is

    l_jvalue_sql   varchar2(4000);
    l_ivalue_sql   varchar2(4000);
    l_metric_sql   varchar2(4000);
    l_rawvalue_sql varchar2(4000);

    idx  number;
    idx2 number;

    temp varchar2(200);
  begin

    -- reset FMO equation object as custom metrics do not use this table
    global_fmo_equation := null;

    global_metric_function_id := 'edrCustomSQLMetric';

    select nvl(s.sql, ' ')
      into l_ivalue_sql
      from um.metric_operator_sql_jn m, um.sql_ref s
     where m.sql_id = s.sql_id
       and m.sql_order = 1
       and m.metric_operator_id = a_metric_operator;

    select nvl(s.sql, ' ')
      into l_jvalue_sql
      from um.metric_operator_sql_jn m, um.sql_ref s
     where m.sql_id = s.sql_id
       and m.sql_order = 2
       and m.metric_operator_id = a_metric_operator;

    select nvl(s.sql, ' ')
      into l_metric_sql
      from um.metric_operator_sql_jn m, um.sql_ref s
     where m.sql_id = s.sql_id
       and m.sql_order = 3
       and m.metric_operator_id = a_metric_operator;

    select nvl(s.sql, ' ')
      into l_rawvalue_sql
      from um.metric_operator_sql_jn m, um.sql_ref s
     where m.sql_id = s.sql_id
       and m.sql_order = 4
       and m.metric_operator_id = a_metric_operator;

    -- I value : Substitute any [variable] with values from the parameters
    begin
      loop
        idx := instr(l_ivalue_sql, '[');
        if (nvl(idx, 0) > 0) then
          idx2 := instr(l_ivalue_sql, ']');

          temp := substr(l_ivalue_sql, idx + 1, idx2 - idx - 1);

          begin
            if global_parameters('-' || temp) is not null then
              l_ivalue_sql := replace(l_ivalue_sql,
                                      '[' || temp || ']',
                                      global_parameters('-' || temp));
            end if;
          exception
            when no_data_found then
              l_ivalue_sql := replace(l_ivalue_sql,
                                      '[' || temp || ']',
                                      null);
              loggerDebug('missing paramter for I value custom sql');
          end;
        else
          exit;
        end if;

      end loop;
    exception
      when others then
        loggerAuto('setCustomSQLMetricFunction - I value SQL interpretation Exception: ' ||
                   SUBSTR(SQLERRM, 1, 4000));
        RAISE_APPLICATION_ERROR(-20001,
                                'Exception: ' || SUBSTR(SQLERRM, 1, 4000));
    end;

    -- J value : Substitute any [variable] with values from the parameters
    begin
      loop
        idx := instr(l_jvalue_sql, '[');
        if (nvl(idx, 0) > 0) then
          idx2 := instr(l_jvalue_sql, ']');

          temp := substr(l_jvalue_sql, idx + 1, idx2 - idx - 1);

          begin
            if global_parameters('-' || temp) is not null then
              l_jvalue_sql := replace(l_jvalue_sql,
                                      '[' || temp || ']',
                                      global_parameters('-' || temp));
            end if;
          exception
            when no_data_found then
              l_jvalue_sql := replace(l_jvalue_sql,
                                      '[' || temp || ']',
                                      null);
              loggerDebug('missing paramter for j value custom sql');
          end;
        else
          exit;
        end if;

      end loop;
    exception
      when others then
        loggerAuto('setCustomSQLMetricFunction - J value SQL interpretation Exception: ' ||
                   SUBSTR(SQLERRM, 1, 4000));
        RAISE_APPLICATION_ERROR(-20001,
                                'Exception: ' || SUBSTR(SQLERRM, 1, 4000));
    end;

    -- Metric value : Substitute any [variable] with values from the parameters
    begin

      loop
        idx := instr(l_metric_sql, '[');
        if (nvl(idx, 0) > 0) then
          idx2 := instr(l_metric_sql, ']');

          temp := substr(l_metric_sql, idx + 1, idx2 - idx - 1);

          begin
            if global_parameters('-' || temp) is not null then
              l_metric_sql := replace(l_metric_sql,
                                      '[' || temp || ']',
                                      global_parameters('-' || temp));
            end if;
          exception
            when no_data_found then
              l_metric_sql := replace(l_metric_sql,
                                      '[' || temp || ']',
                                      null);
              loggerDebug('missing paramter for metric custom sql');
          end;
        else
          exit;
        end if;

      end loop;
    exception
      when others then
        loggerAuto('setCustomSQLMetricFunction - Metric SQL interpretation Exception: ' ||
                   SUBSTR(SQLERRM, 1, 4000));
        RAISE_APPLICATION_ERROR(-20001,
                                'Exception: ' || SUBSTR(SQLERRM, 1, 4000));
    end;

    -- Raw value : Substitute any [variable] with values from the parameters
    begin
      loop
        idx := instr(l_rawvalue_sql, '[');
        if (nvl(idx, 0) > 0) then
          idx2 := instr(l_rawvalue_sql, ']');

          temp := substr(l_rawvalue_sql, idx + 1, idx2 - idx - 1);

          begin
            if global_parameters('-' || temp) is not null then
              l_rawvalue_sql := replace(l_rawvalue_sql,
                                        '[' || temp || ']',
                                        global_parameters('-' || temp));
            end if;
          exception
            when no_data_found then
              l_rawvalue_sql := replace(l_rawvalue_sql,
                                        '[' || temp || ']',
                                        null);
              loggerDebug('missing paramter for raw value custom sql');
          end;
        else
          exit;
        end if;

      end loop;
    exception
      when others then
        loggerAuto('setCustomSQLMetricFunction - raw value SQL interpretation Exception: ' ||
                   SUBSTR(SQLERRM, 1, 4000));
        RAISE_APPLICATION_ERROR(-20001,
                                'Exception: ' || SUBSTR(SQLERRM, 1, 4000));
    end;

    global_custom_sqls.i_value_sql   := replace(l_ivalue_sql, ';');
    global_custom_sqls.j_value_sql   := replace(l_jvalue_sql, ';');
    global_custom_sqls.metric_sql    := replace(l_metric_sql, ';');
    global_custom_sqls.raw_value_sql := replace(l_rawvalue_sql, ';');

  exception
    when others then
      loggerAuto('setCustomSQLMetricFunction Exception: ' ||
                 SUBSTR(SQLERRM, 1, 4000));
      RAISE_APPLICATION_ERROR(-20001,
                              'Exception: ' || SUBSTR(SQLERRM, 1, 4000));
  end;

  /*
       Logic for custom metrics
       SQL's in um.metric_operator_sql_jn are executed in order:
             1. i value
             2. j value
             3. metric value
             4. raw value

       Each expects arguments in a particular order.

  */
  function edrCustomSQLMetric(a_i_fileset_id      number,
                              a_i_min_d_period_id date,
                              a_i_max_d_period_id date,
                              a_j_fileset_id      number,
                              a_j_min_d_period_id date,
                              a_j_max_d_period_id date)
    return metric_return_value as

    i_value       number;
    j_value       number;
    edr_value     number;
    the_metric    number;
    the_raw_value number;

    the_metric_return_value metric_return_value;

    type rc is ref cursor;
    l_rc rc;

    cursor Itest is
      select distinct log_record_id, d_period_id
        from fmo_fileset f
       where f.fileset_id = a_i_fileset_id
         and f.d_period_id between a_i_min_d_period_id and
             a_i_max_d_period_id;

    cursor Jtest is
      select distinct log_record_id, d_period_id
        from fmo_fileset f
       where f.fileset_id = a_j_fileset_id
         and f.d_period_id between a_j_min_d_period_id and
             a_j_max_d_period_id;

    I_total_value number;
    J_total_value number;
    I_count       number;
    J_count       number;

  begin

    I_count := 0;
    J_count := 0;

    for r_Itest in Itest loop

      if global_parameters('-edr_group') = 'edrtype' or
         global_parameters('-edr_group') = 'edrsubtype' or
         global_parameters('-edr_group') = 'edrtypesubtype' then
        -- Get I value and Edr type Id
        open l_rc for global_custom_sqls.i_value_sql
          using r_Itest.d_period_id, r_Itest.Log_Record_Id;
        fetch l_rc
          into i_value, edr_value;
        close l_rc;
      else
        -- Get I value
        open l_rc for global_custom_sqls.i_value_sql
          using r_Itest.d_period_id, r_Itest.Log_Record_Id;
        fetch l_rc
          into i_value;
        close l_rc;

        the_metric_return_value.d_edr_type_id := null;
      end if;

      if i_value is not null then
        I_total_value := nvl(I_total_value, 0) + i_value;
        I_count       := I_count + 1;
      end if;

      if edr_value is not null then
        the_metric_return_value.d_edr_type_id := edr_value;
      end if;

    end loop;

    for r_Jtest in Jtest loop

      -- Get J value
      open l_rc for global_custom_sqls.j_value_sql
        using r_Jtest.d_period_id, r_Jtest.Log_Record_Id;
      fetch l_rc
        into j_value;
      close l_rc;

      if j_value is not null then
        J_total_value := nvl(J_total_value, 0) + j_value;
        J_count       := J_count + 1;
      end if;

    end loop;

    if global_var_function_id = 'avg' then
      if I_count != 0 then
        I_total_value := I_total_value / I_count;
      else
        I_total_value := null;
      end if;
      if J_count != 0 then
        J_total_value := J_total_value / J_count;
      else
        J_total_value := null;
      end if;

    end if;

    i_value := I_total_value;
    j_value := J_total_value;

    -- Get Metric Value
    open l_rc for global_custom_sqls.metric_sql
      using j_value, i_value;
    fetch l_rc
      into the_metric;
    close l_rc;

    -- get the raw value
    open l_rc for global_custom_sqls.raw_value_sql
      using the_metric;
    fetch l_rc
      into the_raw_value;
    close l_rc;

    -- end if;

    the_metric_return_value.i_value      := i_value;
    the_metric_return_value.j_value      := j_value;
    the_metric_return_value.raw_value    := the_raw_value;
    the_metric_return_value.metric_value := the_metric;

    the_metric_return_value.d_billing_type_id := -1;

    return the_metric_return_value;

  exception
    when others then
      loggerAuto('edrCustomSQLMetric - error executing custom sqls: ' ||
                 SUBSTR(SQLERRM, 1, 4000));
  end;

end metrics;
/

exit
