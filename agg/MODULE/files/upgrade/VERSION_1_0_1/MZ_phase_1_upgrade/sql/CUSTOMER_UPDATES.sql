
create table customer.stg_agg_data_ds70
(
  CURRENTDIR    VARCHAR2(200),
  EDRFILENAME   VARCHAR2(100),
  NEID          VARCHAR2(100),
  UMIDENTIFIER  VARCHAR2(50),
  USAGETYPE     VARCHAR2(10),
  TIMESLOT      DATE,
  SERVICETYPE   VARCHAR2(100),
  EVENTCOUNT    INTEGER,
  SUMDURATION   INTEGER,
  SUMBYTES      INTEGER,
  SUMVALUE      INTEGER,
  LOG_RECORD_ID INTEGER
 ,PROCESSDATE DATE
)
tablespace customer_data;


--

create table customer.stg_agg_data_ds71
(
  CURRENTDIR      VARCHAR2(200),
  EDRFILENAME   VARCHAR2(100),
  NEID          VARCHAR2(100),
  UMIDENTIFIER  VARCHAR2(50),
  USAGETYPE     VARCHAR2(10),
  TIMESLOT      DATE,
  SERVICETYPE   VARCHAR2(100),
  EVENTCOUNT    INTEGER,
  SUMDURATION   INTEGER,
  SUMBYTES      INTEGER,
  SUMVALUE      INTEGER,
  LOG_RECORD_ID INTEGER
 ,PROCESSDATE DATE
)
tablespace customer_data;


--

create table customer.stg_agg_data_ds72
(
  CURRENTDIR      VARCHAR2(200),
  EDRFILENAME   VARCHAR2(100),
  NEID          VARCHAR2(100),
  UMIDENTIFIER  VARCHAR2(50),
  USAGETYPE     VARCHAR2(10),
  TIMESLOT      DATE,
  SERVICETYPE   VARCHAR2(100),
  EVENTCOUNT    INTEGER,
  SUMDURATION   INTEGER,
  SUMBYTES      INTEGER,
  SUMVALUE      INTEGER,
  LOG_RECORD_ID INTEGER
 ,PROCESSDATE DATE
)
tablespace customer_data;

grant insert, update, references, select on customer.stg_agg_data_ds70 to gdl;
grant insert, update, references, select on customer.stg_agg_data_ds71 to gdl;
grant insert, update, references, select on customer.stg_agg_data_ds72 to gdl;



insert into customer.data_feed_frequency_ref (NODE, ALARM_PERIOD_TYPE, EXPECTED_FILES_PER_PERIOD, ALARM_THRESHOLD, LATENCY)
values ('DS70', 'day', 25, 0.1, 1);

insert into customer.data_feed_frequency_ref (NODE, ALARM_PERIOD_TYPE, EXPECTED_FILES_PER_PERIOD, ALARM_THRESHOLD, LATENCY)
values ('DS71', 'day', 25, 0.1, 1);

insert into customer.data_feed_frequency_ref (NODE, ALARM_PERIOD_TYPE, EXPECTED_FILES_PER_PERIOD, ALARM_THRESHOLD, LATENCY)
values ('DS72', 'day', 25, 0.1, 1);

commit;



exit;

