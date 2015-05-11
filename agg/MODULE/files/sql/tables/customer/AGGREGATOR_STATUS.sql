create table AGGREGATOR_STATUS
(
  node                      VARCHAR2(20),
  type                      VARCHAR2(10),
  process_date              VARCHAR2(150),
  file_name                 VARCHAR2(100),
  expected_files_per_period VARCHAR2(15),
  alarm_threshold           NUMBER,
  period0                   NUMBER,
  period1                   NUMBER,
  period2                   NUMBER,
  period3                   NUMBER,
  period0_status            VARCHAR2(4),
  period1_status            VARCHAR2(4),
  period2_status            VARCHAR2(4),
  period3_status            VARCHAR2(4)
)
tablespace customer_data
/

exit;
