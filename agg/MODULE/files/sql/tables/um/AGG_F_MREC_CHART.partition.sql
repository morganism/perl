REM ----------------------------------------------
REM Cartesian Limited
REM Table: AGG_F_MREC_CHART
REM ----------------------------------------------

CREATE TABLE UM.AGG_F_MREC_CHART
(
  D_PERIOD_ID    DATE NOT NULL,
  D_MREC_LINE_ID INTEGER NOT NULL,
  D_EDGE_ID      INTEGER,
  D_NODE_ID      INTEGER,  
  MEASURE_TYPE   VARCHAR2(1),
  MREC           NUMBER,
  F_MREC_COUNT   NUMBER,
  F_MREC_PMARKER NUMBER NOT NULL,
  MREC_PERC	 NUMBER,
  IS_COMPARATOR  VARCHAR2(1),
  FORECAST	 NUMBER,
  FORECAST_PERC  NUMBER,
  MREC_PERC_PLUS NUMBER,
  FORECAST_PERC_PLUS NUMBER,
  FREC		 NUMBER,	
  FREC_PERC	 NUMBER
)
SEGMENT CREATION IMMEDIATE TABLESPACE UM_DWH_USG_DATA COMPRESS NOLOGGING
PARTITION BY RANGE ("D_PERIOD_ID")
INTERVAL(NUMTODSINTERVAL(1, 'DAY'))
(PARTITION "2012-01-01 00:00:00" VALUES LESS THAN (TO_DATE
('2012-01-01 00', 'YYYY-MM-DD hh24', 'NLS_CALENDAR=GREGORIAN')));

----------------------------------------------
--- Creating foreign keys for AGG_F_MREC_CHART
----------------------------------------------

ALTER TABLE UM.AGG_F_MREC_CHART
  ADD CONSTRAINT AGG_F_MREC_CHART_01_FK FOREIGN KEY (D_PERIOD_ID)
  REFERENCES UM.D_PERIOD(D_PERIOD_ID);

ALTER TABLE UM.AGG_F_MREC_CHART
  MODIFY CONSTRAINT AGG_F_MREC_CHART_01_FK RELY;

ALTER TABLE UM.AGG_F_MREC_CHART
  DISABLE NOVALIDATE CONSTRAINT AGG_F_MREC_CHART_01_FK;


----------------------------------------------
--- Creating indexes for AGG_F_MREC_CHART
----------------------------------------------

CREATE bitmap INDEX AMRECCHART_LINE_IDX ON UM.AGG_F_MREC_CHART(D_MREC_LINE_ID)
  TABLESPACE UM_DWH_USG_IDX
  local;

CREATE bitmap INDEX AMRECCHART_DAY_IDX ON UM.AGG_F_MREC_CHART(D_PERIOD_ID)
  TABLESPACE UM_DWH_USG_IDX
  local;

CREATE bitmap INDEX AMRECCHART_MREC_IDX ON UM.AGG_F_MREC_CHART(D_EDGE_ID)
  TABLESPACE UM_DWH_USG_IDX
  local;

create bitmap index AMRECCHART_NODE_IDX on UM.AGG_F_MREC_CHART (D_NODE_ID)
  tablespace UM_DWH_USG_IDX
  local;

create bitmap index AMRECCHART_PMARKER_IDX on UM.AGG_F_MREC_CHART (F_MREC_PMARKER)
  tablespace UM_DWH_USG_IDX
  local;

REM ----------------------------------------------
REM Creating Materialised View Log for AGG_F_MREC_CHART
REM ----------------------------------------------

create materialized view log
on UM.AGG_F_MREC_CHART
tablespace UM_MVL_DATA
with rowid (
  D_PERIOD_ID,
  D_MREC_LINE_ID,
  D_EDGE_ID,  
  D_NODE_ID,  
  MREC,
  F_MREC_COUNT,
  F_MREC_PMARKER),
  sequence
including new values;

EXIT;
