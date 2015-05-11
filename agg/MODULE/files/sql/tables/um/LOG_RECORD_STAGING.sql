REM ----------------------------------------------
REM Cartesian Limited
REM Table: LOG_RECORD_STAGING
REM ----------------------------------------------

CREATE TABLE LOG_RECORD_STAGING
(        
         JOB_ID                  INTEGER NOT NULL,
         BATCH_ID                INTEGER NOT NULL,
         SAMPLE_DATE             DATE    NOT NULL,
         LOG_RECORD_ID           INTEGER NOT NULL,
         NODE_ID                 INTEGER NOT NULL,
         SOURCE_ID               INTEGER NOT NULL,
         FILE_TYPE               VARCHAR2(1) NOT NULL,
         PROCESS_DATE            DATE,
         CREATION_DATE           DATE,
         RECORD_NO               INTEGER,
         RECORD_CHECKSUM         VARCHAR2(32),
         IS_MISSING_PREDECESSOR  VARCHAR2(1) NOT NULL,
         IS_MISSING_SUCCESSOR    VARCHAR2(1) NOT NULL,
         FILE_NAME               VARCHAR2(100) NOT NULL,
         OUT_FILE_NAME           VARCHAR2(100),
         IS_RELOAD               VARCHAR2(1),
         IS_DELTA                VARCHAR2(1)
)
TABLESPACE UM_DWH_USG_DATA;

REM ----------------------------------------------
REM Creating additional indexes on LOG_RECORD_STAGING
REM ----------------------------------------------

CREATE INDEX LOG_RECORD_STAGING_01_IDX ON LOG_RECORD_STAGING(LOG_RECORD_ID) 
  TABLESPACE UM_DWH_USG_IDX
  nologging;

CREATE INDEX LOG_RECORD_STAGING_02_IDX ON LOG_RECORD_STAGING(SAMPLE_DATE) 
  TABLESPACE UM_DWH_USG_IDX
  nologging;

CREATE INDEX LOG_RECORD_STAGING_03_IDX ON LOG_RECORD_STAGING(BATCH_ID)
  TABLESPACE UM_DWH_USG_IDX
  nologging;

create index LOG_RECORD_STAGING_04_IDX on LOG_RECORD_STAGING (IS_RELOAD)
  tablespace UM_DWH_USG_IDX
  nologging;

create index LOG_RECORD_STAGING_05_IDX on LOG_RECORD_STAGING (IS_DELTA)
  tablespace UM_DWH_USG_IDX
  nologging;

create index LOG_RECORD_STAGING_06_IDX on LOG_RECORD_STAGING (FILE_NAME)
  tablespace UM_DWH_USG_IDX
  nologging;

exit;
