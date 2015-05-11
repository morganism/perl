alter table um.AGG_F_FILE set interval (NUMTODSINTERVAL(1, 'DAY')) ; 
alter table um.AGG_F_FILE set store in (UM_DWH_USG_DATA);

alter table um.AGG_F_MREC set interval (NUMTODSINTERVAL(1, 'DAY')) ; 
alter table um.AGG_F_MREC set store in (UM_DWH_USG_DATA);

alter table um.AGG_F_MREC_CHART set interval (NUMTODSINTERVAL(1, 'DAY')) ; 
alter table um.AGG_F_MREC_CHART set store in (UM_DWH_MTR_DATA);

alter table um.FMO_FILESET set interval (NUMTODSINTERVAL(1, 'DAY')) ; 
alter table um.FMO_FILESET set store in (UM_DWH_USG_DATA);

alter table um.F_FILE set interval (NUMTODSINTERVAL(1, 'DAY')) ; 
alter table um.F_FILE set store in (UM_DWH_USG_DATA);

alter table um.F_METRIC set interval (NUMTODSINTERVAL(1, 'DAY')) ; 
alter table um.F_METRIC set store in (UM_DWH_MTR_DATA);

alter table um.F_MREC set interval (NUMTODSINTERVAL(1, 'DAY')) ; 
alter table um.F_MREC set store in (UM_DWH_MTR_DATA);

alter table um.LOG_CHECKSUM set interval (NUMTODSINTERVAL(1, 'DAY')) ; 
alter table um.LOG_CHECKSUM set store in (UM_DWH_USG_DATA);

alter table um.LOG_RECORD set interval (NUMTODSINTERVAL(1, 'DAY')) ; 
alter table um.LOG_RECORD set store in (UM_DWH_USG_DATA);

alter table um.METRIC_ISSUE_JN set interval (NUMTODSINTERVAL(1, 'DAY')) ; 
alter table um.METRIC_ISSUE_JN set store in (UM_DWH_MTR_DATA);

alter table um.MREC set interval (NUMTODSINTERVAL(1, 'DAY')) ; 
alter table um.MREC set store in (UM_DWH_MTR_DATA);

alter table um.MREC_FILESET set interval (NUMTODSINTERVAL(1, 'DAY')) ; 
alter table um.MREC_FILESET set store in (UM_DWH_MTR_DATA);

alter table um.MREC_FORECAST_VALUES set interval (NUMTODSINTERVAL(1, 'DAY')) ; 
alter table um.MREC_FORECAST_VALUES set store in (UM_DWH_MTR_DATA);

alter table um.MREC_ISSUE_JN set interval (NUMTODSINTERVAL(1, 'DAY')) ; 
alter table um.MREC_ISSUE_JN set store in (UM_DWH_MTR_DATA);

alter table um.MV_F_FILE set interval (NUMTODSINTERVAL(1, 'DAY')) ; 
alter table um.MV_F_FILE set store in (UM_MV_DATA);

alter table um.MV_F_MREC_FILE set interval (NUMTODSINTERVAL(1, 'DAY')) ; 
alter table um.MV_F_MREC_FILE set store in (UM_MV_DATA);

alter table um.MV_F_MREC_TIME set interval (NUMTODSINTERVAL(1, 'DAY')) ; 
alter table um.MV_F_MREC_TIME set store in (UM_MV_DATA);

alter table um.RECORD_ISSUE_JN set interval (NUMTODSINTERVAL(1, 'DAY')) ; 
alter table um.RECORD_ISSUE_JN set store in (UM_DWH_USG_DATA);

alter table um.RELATED_FILE set interval (NUMTODSINTERVAL(1, 'DAY')) ; 
alter table um.RELATED_FILE set store in (UM_DWH_USG_DATA);

exit;
