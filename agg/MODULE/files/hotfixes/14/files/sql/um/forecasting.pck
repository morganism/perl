create or replace package FORECASTING is

    function getForecast(forecast_metric_id integer, node_id integer, edge_id integer, source_id integer, edr_type_id integer, edr_sub_type_id integer, d_period_id date, source_type_id integer)
  	return number RESULT_CACHE;

    function getForecastAndConfidence(forecast_metric_id integer, node_id integer, edge_id integer, source_id integer, edr_type_id integer, edr_sub_type_id integer, d_period_id date)
    return varchar2;

    procedure setGlobalTimeVariables(local_d_period_id date);

    procedure setGlobalForecastVariables(local_forecast_metric_id integer, local_node_id integer, local_edge_id integer, local_source_id integer, local_edr_type_id integer, local_edr_sub_type_id integer, local_d_period_id date, local_source_type_id integer);

    function getGlobalForecastVariablesSql(edge_or_node varchar2, local_forecast_metric_id integer, local_source_id integer, local_edr_type_id integer, local_edr_sub_type_id integer, local_d_period_id date, local_source_type_id integer)
    return varchar2;

    function getForecastValue
  	return number;

    function getConfidenceValue
  	return number;

    function linearRegressionValue
  	return number;

    function movingAverageValue
  	return number;

    ---------------------------------------------------------------------
    -- Gets the forecasted value that was calculated earlier
    ---------------------------------------------------------------------
    function getSavedForecastValue(
      a_edge_id integer, 
      a_node_id integer,
      a_metric_defn_id integer,
      a_source_type_id integer,
      a_source_id integer,
      a_edr_type_id integer,
      a_edr_sub_type_id integer,
      a_current_date date)
    return number;
    
    ---------------------------------------------------------------------
    -- Gets the adjusted threshold value
    -- a_grouping_fn => 'MIN' or 'MAX'
    -- returns NULL if no threshold exists or no forecast to compare with
    ---------------------------------------------------------------------
    function getAdjustedThresholdValue(
      a_edge_id integer, 
      a_node_id integer,
      a_metric_defn_id integer,
      a_source_id integer,
      a_source_type_id integer,
      a_current_date date,
      a_edr_type_id integer,
      a_edr_sub_type_id integer,
      a_severity_id integer,
      a_grouping_fn varchar2)
    return number;
    
    ---------------------------------------------------------------------
    -- Gets the threshold version id that will be used
    -- (includes first threshold sequence that applies) 
    -- a_grouping_fn => 'MIN' or 'MAX'
    -- returns NULL if no threshold exists or no forecast to compare with
    ---------------------------------------------------------------------
    function getThresholdVersionId(
      a_edge_id integer, 
      a_node_id integer,
      a_metric_defn_id integer,
      a_source_type_id integer,
      a_source_id integer,
      a_edr_type_id integer,
      a_edr_sub_type_id integer,
      a_current_date date)
    return number;

    ---------------------------------------------------------------------
    -- Returns the threshold limit for the given forecast value
    -- a_grouping_fn => 'MIN' or 'MAX'
    -- a_is_relative_operator => 'Y' or anything else
    ---------------------------------------------------------------------
    function getThresholdLimit(
      a_severity_id integer,
      a_grouping_fn varchar2,
      a_threshold_version_id integer,
      a_forecast_value number,
      a_is_relative_operator varchar2)
    return number;
    
end FORECASTING;
/
create or replace package body FORECASTING is

    ------------------------------
    -- The nasty global variables
    -- make my life much easier
    ------------------------------
    global_x number;
    global_day integer;
    global_hour integer;

    global_forecast_id integer;
    global_forecast_model varchar2(500);

    EDR_TYPE_UNSPECIFIED constant number := -1;
    EDR_SUB_TYPE_UNSPECIFIED constant number := -1;

    ---------------------------------------------------------------------
    -- Returns the forecast value for a node or edge (not both!)
    -- Source_id is mandatory 0 = all
    ---------------------------------------------------------------------
    function getForecast(forecast_metric_id integer, node_id integer, edge_id integer, source_id integer, edr_type_id integer, edr_sub_type_id integer, d_period_id date, source_type_id integer)
    return number RESULT_CACHE relies_on (um.forecast_model_values)
    as
        returnValue number;

    begin
        -- Set some global variables
        setGlobalTimeVariables(d_period_id);
        setGlobalForecastVariables(forecast_metric_id, node_id, edge_id, source_id, edr_type_id, edr_sub_type_id, d_period_id, source_type_id);

        -- Get the forecast value
        returnValue := getForecastValue;

        return(returnValue);

    exception
        when no_data_found then
        return null;
  	end;

    ---------------------------------------------------------------------
    -- Returns a string of the forecast and confidence values for a
    -- node or edge (not both!) in the form
    -- 1.4923094859435,0.873409836327
    -- Source_id is mandatory 0 = all
    ---------------------------------------------------------------------
    function getForecastAndConfidence(forecast_metric_id integer, node_id integer, edge_id integer, source_id integer, edr_type_id integer, edr_sub_type_id integer, d_period_id date)
    return varchar2
  	as
        forecast number;
        confidence number;
        returnValue varchar2(80);
        v_source_type_id number := 0; -- Default to all source_types, as screen which uses this function cannot be filtered by source_type
  	begin
  	    -- Set some global variables
        setGlobalTimeVariables(d_period_id);
        setGlobalForecastVariables(forecast_metric_id, node_id, edge_id, source_id, edr_type_id, edr_sub_type_id, d_period_id, v_source_type_id);

        -- Get the forecast and confidence values
        forecast := getForecastValue;
        confidence := getConfidenceValue;

        returnValue := forecast || '#' || confidence;
        return(returnValue);

    exception
        when no_data_found then
        return null;
    end;


    ---------------------------------------------------------------------
    -- Set the global time variables
    ---------------------------------------------------------------------
    procedure setGlobalTimeVariables(local_d_period_id date)
    is

    begin
--        select 86400 * ( (d_period_id) - (to_date('01-01-1970', 'DD-MM-YYYY')) ), week_day, substr(hour,9,2)
--        into global_x, global_day, global_hour
--        from um.d_period um_dp
--        where um_dp.d_period_id = local_d_period_id;

        -- Set time info we need
        select
          trunc(86400 * (local_d_period_id - to_date('01-01-1970', 'DD-MM-YYYY'))),
          mod(to_char(local_d_period_id,'D'), 7),
          to_char(local_d_period_id,'HH24')
        into global_x, global_day, global_hour
        from dual;
    end;


    ---------------------------------------------------------------------
    -- Set the global forecast variables when its a forecast
    ---------------------------------------------------------------------
    procedure setGlobalForecastVariables(local_forecast_metric_id integer, local_node_id integer, local_edge_id integer, local_source_id integer, local_edr_type_id integer, local_edr_sub_type_id integer, local_d_period_id date, local_source_type_id integer)
    is
        sql_string varchar2(4000);

    begin


        -- Set the forcast id and model
        if local_node_id is not null
        then
              sql_string := getGlobalForecastVariablesSql(
               ' and f.node_id = ' || local_node_id,
               local_forecast_metric_id,
               local_source_id,
               local_edr_type_id,
               local_edr_sub_type_id,
               local_d_period_id,
               local_source_type_id
               );
            --v_node_or_edge := local_node_id;
      elsif local_edge_id is not null
        then
            sql_string := getGlobalForecastVariablesSql(
               ' and f.edge_id = ' || local_edge_id,
               local_forecast_metric_id,
               local_source_id,
               local_edr_type_id,
               local_edr_sub_type_id,
               local_d_period_id,
               local_source_type_id
               );
            --v_node_or_edge := local_edge_id;
        end if;

        execute immediate sql_string into global_forecast_id, global_forecast_model;

    end;

    ---------------------------------------------------------------------
    -- Returns the forecast variable SQL
    ---------------------------------------------------------------------
    function getGlobalForecastVariablesSql(
             edge_or_node varchar2,
             local_forecast_metric_id integer,
             local_source_id integer,
             local_edr_type_id integer,
             local_edr_sub_type_id integer,
             local_d_period_id date,
             local_source_type_id integer
             )
    return varchar2
    as
        returnValue varchar2(4000);

    begin
        -- get the latest forecast fitting the definition
        returnValue :=
            'select t1.forecast_id,
                    t1.forecast_model
            from (
            select f.valid_from,
                   f.creation_date,
                   f.forecast_id,
                   f.forecast_model
              from um.forecast f, forecast_metric_jn fmj
              where fmj.forecast_metric_id = ' || local_forecast_metric_id || '
              and f.metric_definition_id = fmj.metric_definition_id
              and f.forecast_definition_id = fmj.forecast_definition_id
              and f.valid_from <= ''' || local_d_period_id || '''
              and f.valid_to >= ''' || local_d_period_id || '''
              and f.forecast_type = ''METRIC'' '
              || edge_or_node;

        if local_source_id is null then
           returnValue := returnValue || ' and f.source_id is null ';
        elsif local_source_id != 0 then
           returnValue := returnValue || ' and f.source_id = ' || local_source_id;
        end if;

        if local_edr_type_id is null then
          returnValue := returnValue || ' and f.edr_type_id is null ' ;
        elsif local_edr_type_id != 0 then
          returnValue := returnValue || ' and f.edr_type_id = ' || local_edr_type_id ;
        end if;

        if local_edr_sub_type_id is null then
          returnValue := returnValue || ' and f.edr_sub_type_id is null ';
        elsif local_edr_sub_type_id != 0 then
          returnValue := returnValue || ' and f.edr_sub_type_id = ' || local_edr_sub_type_id;
        end if;

        if local_source_type_id is null then
           returnValue := returnValue || ' and f.source_type_id is null ';
        elsif local_source_type_id != 0 then
           returnValue := returnValue || ' and f.source_type_id = ' || local_source_type_id;
        end if;

        if local_edr_type_id != EDR_TYPE_UNSPECIFIED or local_edr_sub_type_id != EDR_SUB_TYPE_UNSPECIFIED then
              returnValue := returnValue || ' and 1 = 1 ';
        end if;

        returnValue := returnValue ||
            ' order by f.valid_from desc, f.creation_date desc
            ) t1
             where rownum = 1';

        return(returnValue);
    end;


    ---------------------------------------------------------------------
    -- Returns the forecast value in the form
    ---------------------------------------------------------------------
    function getForecastValue
    return number
    as
        returnValue number;

    begin
        -- Now get the return value
        if global_forecast_model = 'um.forecasting.LinearRegressionModel'
        then
            returnValue := linearRegressionValue;
        elsif global_forecast_model = 'um.forecasting.MovingAverageModel'
        then
            returnValue := movingAverageValue;
        end if;

        return(round(returnValue,4));
    end;


    ---------------------------------------------------------------------
    -- Gets the confidence values for a particular forecast
    ---------------------------------------------------------------------
    function getConfidenceValue
    return number
    as
        returnValue number;

    begin
        -- Get the v and growth values
        select value into returnValue
        from um.forecast_model_values um_fmv
        where um_fmv.forecast_id = global_forecast_id
        and um_fmv.weekday = global_day
        and um_fmv.hour = global_hour
        and um_fmv.parameter = 'CONFIDENCE';

        return(round(returnValue,4));
    end;


    ---------------------------------------------------------------------
    -- Calculates the linear regression value
    ---------------------------------------------------------------------
    function linearRegressionValue
    return number
    as
        m number;
        c number;
        growth number;
        returnValue number;

    begin
        -- Get the m, c and growth values
        select value into m
        from um.forecast_model_values um_fmv
        where um_fmv.forecast_id = global_forecast_id
        and um_fmv.weekday = global_day
        and um_fmv.hour = global_hour
        and um_fmv.parameter = 'GRADIENT';

        select value into c
        from um.forecast_model_values um_fmv
        where um_fmv.forecast_id = global_forecast_id
        and um_fmv.weekday = global_day
        and um_fmv.hour = global_hour
        and um_fmv.parameter = 'Y_INTERCEPT';

        select value into growth
        from um.forecast_model_values um_fmv
        where um_fmv.forecast_id = global_forecast_id
        and um_fmv.weekday = global_day
        and um_fmv.hour = global_hour
        and um_fmv.parameter = 'GROWTH_FACTOR';

        -- calculate the y value
        returnValue := (m * growth * global_x) + c;

        return(round(returnValue,4));
    end;


    ---------------------------------------------------------------------
    -- Calculates the moving average value
    ---------------------------------------------------------------------
    function movingAverageValue
    return number
    as
        v number;
        growth number;
        returnValue number;

    begin
        -- Get the v and growth values
        select value into v
        from um.forecast_model_values um_fmv
        where um_fmv.forecast_id = global_forecast_id
        and um_fmv.weekday = global_day
        and um_fmv.hour = global_hour
        and um_fmv.parameter = 'VALUE';

        select value into growth
        from um.forecast_model_values um_fmv
        where um_fmv.forecast_id = global_forecast_id
        and um_fmv.weekday = global_day
        and um_fmv.hour = global_hour
        and um_fmv.parameter = 'GROWTH_FACTOR';

        -- calculate the y value
        returnValue := growth * v;

        return(round(returnValue,4));
    end;

    ---------------------------------------------------------------------
    -- Gets the forecasted value that was calculated earlier
    -- This function should be the same as getForecastAndConfidence
    ---------------------------------------------------------------------
    function getSavedForecastValue(
      a_edge_id integer, 
      a_node_id integer,
      a_metric_defn_id integer,
      a_source_type_id integer,
      a_source_id integer,
      a_edr_type_id integer,
      a_edr_sub_type_id integer,
      a_current_date date)
    return number
    as
      v_result number;
   
    begin
      
      select fmv.value 
        into v_result
        from um.forecast_model_values fmv 
        join um.d_day dd on fmv.weekday = dd.week_day
       where dd.d_day_id = trunc(a_current_date)
         and fmv.hour = to_number(to_char(a_current_date, 'hh24'))
         and fmv.parameter = 'VALUE'
         and fmv.forecast_id in (
               select max(f.forecast_id) -- get the most recent saved value
                 from um.forecast_definition_ref fdr 
                 left outer join um.forecast f 
                       on fdr.forecast_definition_id = f.forecast_definition_id 
                      and f.forecast_type = fdr.forecast_type
                      and f.metric_definition_id = a_metric_defn_id
                      and nvl(f.edge_id, -1) = nvl(a_edge_id, -1)
                      and nvl(f.node_id, -1) = nvl(a_node_id, -1)
                      and nvl(f.source_id, -1) = nvl(a_source_id, -1)
                      and nvl(f.source_type_id, -1) = nvl(a_source_type_id, -1)
                      and nvl(f.edr_type_id, -1) = nvl(a_edr_type_id, -1)
                      and nvl(f.edr_sub_type_id, -1) = nvl(a_edr_sub_type_id, -1)
                      and a_current_date between f.valid_from and f.valid_to
                where fdr.forecast_type = 'F');

      return v_result;

    exception
      when no_data_found then
        return null;
    end;

    ---------------------------------------------------------------------
    -- Gets the adjusted threshold value
    -- a_grouping_fn => 'MIN' or 'MAX'
    -- returns NULL if no threshold exists or no forecast to compare with
    ---------------------------------------------------------------------
    function getAdjustedThresholdValue(
      a_edge_id integer, 
      a_node_id integer,
      a_metric_defn_id integer,
      a_source_id integer,
      a_source_type_id integer,
      a_current_date date,
      a_edr_type_id integer,
      a_edr_sub_type_id integer,
      a_severity_id integer,
      a_grouping_fn varchar2)
    return number
    as
      v_threshold_ver_id integer;
      v_forecast_value number;
      v_result number;
      
      cursor c_threshold_limits(p_threshold_id integer) is
      select tdr.type threshold_type,
             max(case when tsr.severity_id = a_severity_id and tsr.operator in ('>', '>=', '=') then tsr.value else null end) max_threshold,
             min(case when tsr.severity_id = a_severity_id and tsr.operator in ('<', '<=', '=') then tsr.value else null end) min_threshold
        from imm.threshold_version_ref tvr 
        join imm.threshold_definition_ref tdr on tvr.threshold_definition_id = tdr.threshold_definition_id
        left outer join imm.threshold_severity_ref tsr on tsr.threshold_version_id = tvr.threshold_version_id
       where tvr.status = 'A'
         and tvr.threshold_version_id = p_threshold_id
       group by tdr.type;      
   
    begin
      
      metrics.loadStaticData(a_edge_id, a_node_id, a_metric_defn_id);
      v_threshold_ver_id := metrics.getNewThresholdVersionId(
          nvl(a_edge_id, a_node_id),
          a_source_id, 
          a_source_type_id, 
          a_current_date, 
          a_edr_type_id, 
          a_edr_sub_type_id);
          
      v_forecast_value := getSavedForecastValue(
          a_edge_id, a_node_id, a_metric_defn_id, a_source_type_id, a_source_id, 
          a_edr_type_id, a_edr_sub_type_id, a_current_date);
      
      for r_threshold_limits in c_threshold_limits(v_threshold_ver_id) loop
        if r_threshold_limits.threshold_type = 'Percentage' then
          select (1 + decode(upper(a_grouping_fn), 
                      'MAX', r_threshold_limits.max_threshold,
                      'MIN', r_threshold_limits.min_threshold, null)) * v_forecast_value
            into v_result
            from dual;

        elsif r_threshold_limits.threshold_type = 'Absolute' then
          select decode(upper(a_grouping_fn), 
                      'MAX', v_forecast_value + r_threshold_limits.max_threshold,
                      'MIN', v_forecast_value - r_threshold_limits.min_threshold, null)
            into v_result
            from dual;
        end if;
      end loop;

      return v_result;

  end;

    ---------------------------------------------------------------------
    -- Gets the threshold version id that will be used
    -- (includes first threshold sequence that applies) 
    -- a_grouping_fn => 'MIN' or 'MAX'
    -- returns NULL if no threshold exists or no forecast to compare with
    ---------------------------------------------------------------------
    function getThresholdVersionId(
      a_edge_id integer, 
      a_node_id integer,
      a_metric_defn_id integer,
      a_source_type_id integer,
      a_source_id integer,
      a_edr_type_id integer,
      a_edr_sub_type_id integer,
      a_current_date date)
    return number
    as
    begin
      
      metrics.loadStaticData(a_edge_id, a_node_id, a_metric_defn_id);
      return metrics.getNewThresholdVersionId(
          nvl(a_edge_id, a_node_id),
          a_source_id, 
          a_source_type_id, 
          a_current_date, 
          a_edr_type_id, 
          a_edr_sub_type_id);

    end;
    
    ---------------------------------------------------------------------
    -- Returns the threshold limit for the given forecast value
    -- a_grouping_fn => 'MIN' or 'MAX'
    -- a_is_relative_operator => 'Y' or anything else
    ---------------------------------------------------------------------
    function getThresholdLimit(
      a_severity_id integer,
      a_grouping_fn varchar2,
      a_threshold_version_id integer,
      a_forecast_value number,
      a_is_relative_operator varchar2)
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

      if a_threshold_version_id is null or a_forecast_value is null then
        return null;
      end if;

      for r_threshold_limits in c_threshold_limits loop
        
        -- absolute operator; forecast value is not used
        if a_is_relative_operator <> 'Y' then
          select decode(upper(a_grouping_fn),
                      'MAX', r_threshold_limits.max_threshold,
                      'MIN', r_threshold_limits.min_threshold, null)
            into v_result
            from dual;
          
        elsif r_threshold_limits.threshold_type = 'Absolute' then
          select decode(upper(a_grouping_fn),
                      'MAX', a_forecast_value + r_threshold_limits.max_threshold,
                      'MIN', a_forecast_value - r_threshold_limits.min_threshold, null)
            into v_result
            from dual;

        elsif r_threshold_limits.threshold_type = 'Percentage' then
          select (1 + decode(upper(a_grouping_fn),
                      'MAX', r_threshold_limits.max_threshold,
                      'MIN', r_threshold_limits.min_threshold, null)) * a_forecast_value
            into v_result
            from dual;

        end if;
      end loop;

      return v_result;

    end;

end FORECASTING;
/

exit;
