create or replace package customer.FORECASTING is

  function getForecast(forecast_metric_id integer,
                       node_id            integer,
                       edge_id            integer, --never used
                       source_id          integer,
                       edr_type_id        integer,
                       edr_sub_type_id    integer,
                       d_period_id        date,
                       source_type_id     integer) return number;

  procedure setGlobalTimeVariables(local_d_period_id date);

  function getForecastValue(local_forecast_metric_id integer,
                            local_node_id            integer,
                            local_source_id          integer,
                            local_edr_type_id        integer,
                            local_edr_sub_type_id    integer,
                            local_d_period_id        date,
                            local_source_type_id     integer) return number;

end FORECASTING;
/
create or replace package body customer.FORECASTING is

    ------------------------------
    -- The nasty global variables
    -- make my life much easier
    ------------------------------
    global_x number;
    global_day integer;
    global_hour integer;

    ---------------------------------------------------------------------
    -- Returns the forecast value for a node
    -- Source_id is mandatory 
    -- 0 = all for source, source type, edr type and edr sub type
    ---------------------------------------------------------------------
    function getForecast(forecast_metric_id integer, node_id integer, edge_id integer, source_id integer, edr_type_id integer, 
                                            edr_sub_type_id integer, d_period_id date, source_type_id integer)
    return number
    as
        returnValue number;

    begin
        -- Set some global variables
        setGlobalTimeVariables(d_period_id);

        -- Get the forecast value
        returnValue := getForecastValue(forecast_metric_id, node_id, source_id, edr_type_id, edr_sub_type_id, d_period_id, source_type_id);

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
        -- Set time info we need
        select
          trunc(86400 * (local_d_period_id - to_date('01-01-1970', 'DD-MM-YYYY'))),
          mod(to_char(local_d_period_id,'D'), 7),
          to_char(local_d_period_id,'HH24')
        into global_x, global_day, global_hour
        from dual;
    end;

    -------------------------------------------------------------------------
    -- Get the forecast value for the given parameters. 
    -- This function returns an aggregate amount if multiple forecasts exist 
    -- at a level that is outside the specified parameters. e.g. if source is 
    -- not specified and the node has multiple sources, it will return the 
    -- aggregate of all the forecasts (which have to be run per source). If 
    -- multiple forecasts exist for each of the parameters, e.g. two forecasts 
    -- have been run on node 100000, metric 100000, source 100015, only the 
    -- most recent will be retrieved.
    -------------------------------------------------------------------------
    function getForecastValue(local_forecast_metric_id integer,
                              local_node_id integer,
                              local_source_id integer,
                              local_edr_type_id integer,
                              local_edr_sub_type_id integer,
                              local_d_period_id date,
                              local_source_type_id integer)
    return number
    as
           returnValue number;
           sqlString   varchar2(2000);

    begin

        sqlString :=
          'with fcasts as
           ( -- Get our relevant forecasts
            select forecast_id from (
              select f.forecast_id, row_number() over(partition by f.source_id, edr_type_id order by f.forecast_id desc) rn
                from um.forecast f, um.forecast_metric_jn fmj
               where f.metric_definition_id = fmj.metric_definition_id 
                and f.forecast_definition_id = fmj.forecast_definition_id
                and fmj.forecast_metric_id = ' || local_forecast_metric_id || '
                and f.forecast_type = ''METRIC''
                and f.valid_from <= ''' || local_d_period_id || '''
                and f.valid_to >= ''' || local_d_period_id || '''
                and f.node_id = ' || local_node_id ;

        /*optional*/        
        if local_source_id is not null and local_source_id != 0 then
           sqlString := sqlString || ' and f.source_id = ' || local_source_id;
        end if;

        if local_edr_type_id is not null and local_edr_type_id != 0 then
          sqlString := sqlString || ' and f.edr_type_id = ' || local_edr_type_id ;
        end if;

        if local_edr_sub_type_id is not null and local_edr_sub_type_id != 0 then
          sqlString := sqlString || ' and f.edr_sub_type_id = ' || local_edr_sub_type_id;
        end if;

        if local_source_type_id is not null and local_source_type_id != 0 then
           sqlString := sqlString || ' and f.source_type_id = ' || local_source_type_id;
        end if;
        
        sqlString := sqlString || ') where rn = 1), ';

        sqlString := sqlString ||
        'm_values as
           ( -- Get our relevant forecast values)
            select f.*
              from um.forecast_model_values f, fcasts
             where f.forecast_id = fcasts.forecast_id)
          select sum(result) result
            from ( -- Pivot the model_values so we can perform the arithmetic operation between value and growth factor
                  select max(decode(ff.parameter, ''VALUE'', ff.value)) *
                          max(decode(ff.parameter, ''GROWTH_FACTOR'', ff.value)) result
                    from (select *
                             from m_values m
                            where m.weekday = ' || global_day || '
                              and m.hour = ' || global_hour || ') ff
                   group by ff.forecast_id)';

        execute immediate sqlString into returnValue;

        return(round(returnValue,4));

    end;

end FORECASTING;
/

exit;

