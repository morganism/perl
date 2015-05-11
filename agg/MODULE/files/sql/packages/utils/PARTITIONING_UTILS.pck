create or replace package partitioning_utils AUTHID CURRENT_USER is

    -- Author  : CARTESIAN Limited
    -- Created : 30/01/2010
    -- Purpose : Utility package for creating partitions

    -- Public method declarations

    /**
    * This is a wrapper for the addPartitionsToSchema using months rather than a date range
    * This method will attempt to add partitions in the range SYSDATE to SYSDATE + months
    */
    procedure addDateRangePartitionsToSchema(
        pJobId         in pls_integer,
        pSchema        in varchar2,
        pMonths        in number,
        pPartitionType in varchar2 default 'D');

    /**
    * This procedure will partition all tables within a given schema between the given dates
    * If the start date is null then the first partition will be created directly after the most recent partition
    * The end date must be defined
    */
    procedure addDateRangePartitionsToSchema (
        pJobId         in pls_integer,
        pSchema        in varchar2,
        pStartDate     in varchar2 default null,
        pEndDate       in varchar2,
        pPartitionType in varchar2 default 'D');

    /**
    * This procedure will partition the given table between the specified dates
    * If the start date is null then the first partition will be created directly after the most recent partition
    * The end date must be defined
    */
    procedure addDateRangePartitionsToTable(
        pJobId         in pls_integer,
        pSchema        in varchar2,
        pTable         in varchar2,
        pStartDate     in varchar2 default null,
        pEndDate       in varchar2,
        pPartitionType in varchar2 default 'D');


    /**
    * This procedure will partition all table in a given schema to ensure that there are enough
    * partitions to provide the required buffer
    */
    procedure addNumRangePartitionsToSchema (
        pJobId         in pls_integer,
        pSchema        in varchar2,
        pBuffer        in varchar2);

    /**
    * This procedure will partition the given table to ensure that there are enough
    * partitions to provide the required buffer
    */
    procedure addNumRangePartitionsToTable(
        pJobId         in pls_integer,
        pSchema        in varchar2,
        pTable         in varchar2,
        pBuffer        in varchar2);


end partitioning_utils;
/
create or replace package body partitioning_utils is

    ----------------------------------------------------------------------------------------------
    -- Private variable definitions
    ----------------------------------------------------------------------------------------------

    NUMBER_RANGE_PARTITION_SIZE integer := 100000;  -- If you feel the need to change this please stick to multiples of 1000!!!!

    vModuleName   varchar2(100); -- output for debugging
    vParmList     varchar2(200); -- parameter list used for debugging


    ----------------------------------------------------------------------------------------------
    -- Method bodies
    ----------------------------------------------------------------------------------------------

    /**
    * This is a wrapper for the addPartitionsToSchema using months rather than a date range
    * This method will attempt to add partitions in the range SYSDATE to SYSDATE + months
    */
    procedure addDateRangePartitionsToSchema(
        pJobId         in pls_integer,
        pSchema        in varchar2,
        pMonths        in number,
        pPartitionType in varchar2 default 'D')
    is
        vStartDate varchar2(8);
        vEndDate   varchar2(8);
    begin
        -- log the call to utils.messages
        vModuleName := 'partitioning_utils.addFuturePartitionsToSchema';
        vParmlist   := 'pSchema: ' || pSchema || ',pMonths: ' || pMonths || ',pPartitionType: ' || pPartitionType;
        utils.logging_utils.putMessage(vModuleName, vModuleName || chr(10) || vParmList, pJobId, 'Y');

        vStartDate := TO_CHAR(sysdate, 'yyyymmdd');
        vEndDate   := TO_CHAR(add_months(sysdate, pMonths), 'yyyymmdd');

        addDateRangePartitionsToSchema(pJobId, pSchema, vStartDate, vEndDate, pPartitionType);
    end;


    /**
    * This procedure will partition all tables within a given schema between the given dates
    * If the start date is null then the first partition will be created directly after the most recent partition
    * The end date must be defined
    */
    procedure addDateRangePartitionsToSchema (
        pJobId         in pls_integer,
        pSchema        in varchar2,
        pStartDate     in varchar2 default null,
        pEndDate       in varchar2,
        pPartitionType in varchar2 default 'D')
    is
        TYPE tPartTabs is TABLE of all_tables.table_name%type;
        vPartTabs tPartTabs; -- table of partitioned table names

        is_interval number;
        
    begin
        -- log the call to utils.messages
        vModuleName := 'partitioning_utils.addPartitionsToSchema';
        vParmlist   := 'pSchema: ' || pSchema || ',pStartDate: ' || pStartDate || ',pEndDate: ' || pEndDate || ',pPartitionType: ' || pPartitionType;
        utils.logging_utils.putMessage(vModuleName, vModuleName || chr(10) || vParmList, pJobId, 'Y');

        -- get a list of all range partitioned tables in the specified schema
        -- we assume that they are all date range partitions, if not this method is not for you
        select t.table_name bulk collect
        into vPartTabs
        from all_tables t, all_part_tables t1
        where t.owner = pSchema
        and t.table_name = t1.table_name
        and t1.partitioning_type = 'RANGE' ;

        -- iterate through these tables
        FOR cPartTabs IN 1 .. vPartTabs.COUNT loop
          
            begin 
              select regexp_instr(DBMS_METADATA.GET_DDL('TABLE',upper(vPartTabs(cPartTabs))),'PARTITION BY.*INTERVAL')
              into   is_interval
              from   dual;
            exception 
                 when others then
                   is_interval := 0;      
            end;
              
            if is_interval = 0 then 
               addDateRangePartitionsToTable(pJobId, pSchema, vPartTabs(cPartTabs), pStartDate, pEndDate, pPartitionType);
            else 
               utils.logging_utils.putMessage(vModuleName, 'Not adding partitions to ' || vPartTabs(cPartTabs) || ' as it has Interval partitioning.', pJobId, 'Y');       
            end if;
        
            
        end loop;

        exception
            when others then
              utils.logging_utils.putMessage(vModuleName, sqlerrm, pJobId, 'Y');
              RAISE_APPLICATION_ERROR(-20003, 'Job Id:' || pJobId || ' Module ' || vModuleName || ' error:' || sqlerrm);
    end;

    /**
    * This procedure will partition the given table between the specified dates
    * If the start date is null then the first partition will be created directly after the most recent partition
    * The end date must be defined
    */
    procedure addDateRangePartitionsToTable(
        pJobId         in pls_integer,
        pSchema        in varchar2,
        pTable         in varchar2,
        pStartDate     in varchar2 default null,
        pEndDate       in varchar2,
        pPartitionType in varchar2 default 'D')
    is
        vNextPartition date;
        vTempDate      date;
        vTempEndDate   date;
        vStmt varchar2(2000);
        vLastPartname all_tab_partitions.partition_name%type;
        vTableSpace   all_tab_partitions.tablespace_name%type;
    begin
        -- log the call to utils.messages
        vModuleName := 'partitioning_utils.addDateRangePartitionsToTable';
        vParmlist   := 'pSchema: ' || pSchema || 'pTable: ' || pTable || ',pStartDate: ' || pStartDate || ',pEndDate: ' || pEndDate || ',pPartitionType: ' || pPartitionType;
        utils.logging_utils.putMessage(vModuleName, vModuleName || chr(10) || vParmList, pJobId, 'Y');

        -- get the last current partition of the table
        select partition_name, tablespace_name
        into vLastPartName, vTablespace
        from all_tab_partitions
        where partition_position = (
            select max(partition_position)
            from all_tab_partitions
            where table_owner = pSchema
            and table_name = pTable
        )
        and table_owner = pSchema
        and table_name = pTable;

        --If tablespace is null then this is most likly and IOT table, if it isn't then this needs fixing!!
        if vTablespace is null
        then
            select distinct ds.tablespace_name
            into vTablespace
            from all_constraints ac
            inner join user_segments ds
                    on ac.constraint_name = ds.segment_name
--                   and ac.owner = ds.owner
            where ac.owner = pSchema
            and ac.table_name = pTable
            and ac.constraint_type = 'P';
        end if;

        -- check if there are partitions other than the initial P??000000 partition
        if substr(vLastPartName, length(vLastPartName) - 5) like '000000' then
            if pStartDate is null then
                -- if pStartDate is not set use sysdate
                vTempDate := sysdate;
            else
                -- otherwise use pStartDate
                vTempDate := TO_DATE(pStartDate, 'yyyymmdd');
            end if;
        else
            -- there exist partitions other than the initial parition
            -- parse out the last partition date
            if upper(pPartitionType) like 'D' then
                -- in this case the vLastPartName would be in the form P20061201
                -- NOTE: we add one day
                vNextPartition := TO_DATE(substr(vLastPartName, length(vLastPartName) - 7), 'yyyymmdd') + 1;
            else
                -- upper(pPartFormat) like 'M' in this case the vLastPartName would be in the form P200612
                -- NOTE: we add one month
                vNextPartition := add_months(TO_DATE(substr(vLastPartName, length(vLastPartName) - 5), 'yyyymm'), 1);
            end if;

            -- check to see if the start date has been set, and that it is after
            -- the last current partition
            if pStartDate is null or
                TO_DATE(pStartDate, 'yyyymmdd') < vNextPartition then
                vTempDate := vNextPartition;
            else
                vTempDate := TO_DATE(pStartDate, 'yyyymmdd');
            end if;
        end if;

        -- check that the end date is later than the last current partition,
        -- and that it is also later than the start date
        vTempEndDate := TO_DATE(pEndDate, 'yyyymmdd');

        -- iterate through the dates, appending sql which adds the partition
        while vTempDate <= vTempEndDate loop
            if upper(pPartitionType) like 'D' then
                -- daily partitions
                vStmt := 'ALTER TABLE ' || pSchema || '.' || pTable ||
                         ' ADD PARTITION P' || TO_CHAR(vTempDate, 'yyyymmdd') ||
                         ' VALUES LESS THAN (TO_DATE(''' ||
                         TO_CHAR(vTempDate + 1, 'yyyymmdd') ||
                         ''',''YYYYMMDD'')) TABLESPACE ' || vtablespace;
                -- increment the tempDateIndex by 1 day
                vTempDate := vTempDate + 1;
            else
                -- monthly partitions
                vStmt := 'ALTER TABLE ' || pSchema || '.' || pTable ||
                         ' ADD PARTITION P' || TO_CHAR(vTempDate, 'yyyymm') ||
                         ' VALUES LESS THAN (TO_DATE(''' ||
                         TO_CHAR(add_months(vTempDate, 1), 'yyyymm') ||
                         ''',''YYYYMM'')) TABLESPACE ' || vtablespace;
                -- increment the tempDateIndex by 1 month
                vTempDate := add_months(vTempDate, 1);
            end if;

            -- and log a message
            utils.logging_utils.putMessage(vModuleName, '-- executing: ' || vStmt, pJobId, 'Y');

            -- execute the sql
            execute immediate vStmt;

        end loop;
    end;


    /**
    * This procedure will partition all tables within a given schema between the given dates
    * If the start date is null then the first partition will be created directly after the most recent partition
    * The end date must be defined
    */
    procedure addNumRangePartitionsToSchema (
        pJobId         in pls_integer,
        pSchema        in varchar2,
        pBuffer        in varchar2)
    is
        TYPE tPartTabs is TABLE of all_tables.table_name%type;
        vPartTabs tPartTabs; -- table of partitioned table names
    begin
        -- log the call to utils.messages
        vModuleName := 'partitioning_utils.addPartitionsToSchema';
        vParmlist   := 'pSchema: ' || pSchema || ',pBuffer: ' || pBuffer;
        utils.logging_utils.putMessage(vModuleName, vModuleName || chr(10) || vParmList, pJobId, 'Y');

        -- get a list of all range partitioned tables in the specified schema
        -- we assume that they are all number range partitions, if not this method is not for you
        select t.table_name bulk collect
        into vPartTabs
        from all_tables t, all_part_tables t1
        where t.owner = pSchema
        and t.table_name = t1.table_name
        and t.iot_name is null
        and t1.partitioning_type = 'RANGE';

        -- iterate through these tables
        FOR cPartTabs IN 1 ..  vPartTabs.COUNT loop
            addNumRangePartitionsToTable(pJobId, pSchema, vPartTabs(cPartTabs), pBuffer);
        end loop;

        exception
            when others then
              utils.logging_utils.putMessage(vModuleName, sqlerrm, pJobId, 'Y');
              RAISE_APPLICATION_ERROR(-20003, 'Job Id:' || pJobId || ' Module ' || vModuleName || ' error:' || sqlerrm);
    end;

    /**
    * This procedure will partition the given table between the specified dates
    * If the start date is null then the first partition will be created directly after the most recent partition
    * The end date must be defined
    */
    procedure addNumRangePartitionsToTable(
        pJobId         in pls_integer,
        pSchema        in varchar2,
        pTable         in varchar2,
        pBuffer        in varchar2)
    is
        vNewPartitionValue integer;
        vNewPartitionCount integer;
        vCurrentPartition integer;
        vEmptyPartitions integer;
        vSpareCapacity integer;
        vCounter integer;

        vNewPartitionName varchar2(30);
        vStmt varchar2(2000);

        vLastPartname all_tab_partitions.partition_name%type;
        vTableSpace   all_tab_partitions.tablespace_name%type;
    begin
        -- log the call to utils.messages
        vModuleName := 'partitioning_utils.addNumRangePartitionsToTable';
        vParmlist := 'pSchema: ' || pSchema || ',pTable: ' || pTable || ',pBuffer: ' || pBuffer;
        utils.logging_utils.putMessage(vModuleName, vModuleName || chr(10) || vParmList, pJobId, 'Y');

        -- Find out our current capacity
        select count(*)
        into vEmptyPartitions
        from all_tab_partitions
        where table_owner = pSchema
        and table_name = pTable
        and nvl(num_rows,0) = 0;

        vSpareCapacity := vEmptyPartitions * (NUMBER_RANGE_PARTITION_SIZE);
        if vSpareCapacity < pBuffer
        then
            --We need more partitions!
            --Get the last current partition of the table
            select partition_name, tablespace_name
            into vLastPartName, vTablespace
            from all_tab_partitions
            where partition_position = (
                select max(partition_position)
                from all_tab_partitions
                where table_owner = pSchema
                and table_name = pTable
            )
            and table_owner = pSchema
            and table_name = pTable;

            --If tablespace is null then this is most likely an IOT table, if it isn't then this needs fixing!!
            if vTablespace is null
            then
                select distinct ds.tablespace_name
                into vTablespace
                from all_constraints ac
                inner join user_segments ds
                        on ac.constraint_name = ds.segment_name
--                       and ac.owner = ds.owner
                where ac.owner = pSchema
                and ac.table_name = pTable
                and ac.constraint_type = 'P';
            end if;

            -- Number range partition names are of the form P100k
            vCurrentPartition := substr(vLastPartName, 2, length(vLastPartName)-2) * 1000;
            vNewPartitionCount := (pBuffer - vSpareCapacity)/NUMBER_RANGE_PARTITION_SIZE;
            utils.logging_utils.putMessage(vModuleName, 'Creating ' || vNewPartitionCount || ' new partitions', pJobId, 'Y');

            vCounter := 0;
            while vCounter < vNewPartitionCount loop
                --Decrement partition count
                vCounter := vCounter + 1;

                --Create SQL
                vNewPartitionValue := (vCurrentPartition + (vCounter * NUMBER_RANGE_PARTITION_SIZE))/1000;
                vNewPartitionName := 'P' || vNewPartitionValue || 'k';
                vStmt := 'ALTER TABLE ' || pSchema || '.' || pTable ||
                         ' ADD PARTITION ' || vNewPartitionName ||
                         ' VALUES LESS THAN (' || ((vCounter * NUMBER_RANGE_PARTITION_SIZE) + vCurrentPartition) || ')' ||
                         ' TABLESPACE ' || vtablespace;

                -- and log a message
                utils.logging_utils.putMessage(vModuleName, 'executing: ' || vStmt, pJobId, 'Y');

                -- execute the sql
                execute immediate vStmt;

            end loop;
        end if;
    end;
end partitioning_utils;
/

exit;
