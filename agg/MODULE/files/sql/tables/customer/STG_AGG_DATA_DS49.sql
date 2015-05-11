create table customer.stg_agg_data_ds49
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
  SUMBYTES      NUMBER,
  SUMVALUE      NUMBER,
  LOG_RECORD_ID INTEGER
 ,PROCESSDATE DATE
)
tablespace customer_data;

exit;