REM ----------------------------------------------
REM Cartesian Limited
REM Table: LOG_RECORD
REM ----------------------------------------------
--DROP table log_record cascade constraints ;
CREATE TABLE LOG_RECORD
(        
         D_PERIOD_ID             DATE,
         LOG_RECORD_ID           INTEGER,
         SAMPLE_DATE             DATE    NOT NULL,           
         BATCH_ID                INTEGER,
         NODE_ID                 INTEGER,
         SOURCE_ID               INTEGER,
         FILE_TYPE               VARCHAR2(1),
         PROCESS_DATE            DATE,
         CREATION_DATE           DATE,
         RECORD_NO               INTEGER,
         RECORD_CHECKSUM         VARCHAR2(32),
         IS_RE_PRESENTED         VARCHAR2(1),
         IS_MISSING_PREDECESSOR  VARCHAR2(1),
         IS_MISSING_SUCCESSOR    VARCHAR2(1),
         FILE_NAME               VARCHAR2(100),
         OUT_FILE_NAME           VARCHAR2(100)
)
  TABLESPACE UM_DWH_USG_DATA
  pctfree 10
  nologging compress
  ;

REM ----------------------------------------------
REM Creating primary keys on LOG_RECORD
REM ----------------------------------------------

ALTER TABLE LOG_RECORD
  ADD CONSTRAINT LOG_RECORD_PK PRIMARY KEY (D_PERIOD_ID,LOG_RECORD_ID)
  USING INDEX TABLESPACE UM_DWH_USG_IDX compress 1 ;
 
REM ----------------------------------------------
REM The linesbelow change the index into a global index
REM and are commented out for now.
REM ----------------------------------------------  
REM ALTER TABLE LOG_RECORD disable primary key;
REM ALTER TABLE LOG_RECORD enable novalidate primary key;

REM ----------------------------------------------
REM Creating foreign keys for LOG_RECORD
REM ----------------------------------------------

ALTER TABLE LOG_RECORD
  ADD CONSTRAINT LOG_RECORD_01_FK FOREIGN KEY (BATCH_ID)
  REFERENCES JOBS.BATCH(BATCH_ID)
  DISABLE NOVALIDATE;

ALTER TABLE LOG_RECORD
  MODIFY CONSTRAINT LOG_RECORD_01_FK RELY;

ALTER TABLE LOG_RECORD
  ADD CONSTRAINT LOG_RECORD_02_FK FOREIGN KEY (NODE_ID)
  REFERENCES DGF.NODE_REF(NODE_ID)
  DISABLE NOVALIDATE;

ALTER TABLE LOG_RECORD
  MODIFY CONSTRAINT LOG_RECORD_02_FK RELY;

ALTER TABLE LOG_RECORD
  ADD CONSTRAINT LOG_RECORD_03_FK FOREIGN KEY (SOURCE_ID)
  REFERENCES UM.SOURCE_REF(SOURCE_ID)
  DISABLE NOVALIDATE;

ALTER TABLE LOG_RECORD
  MODIFY CONSTRAINT LOG_RECORD_03_FK RELY;

REM ----------------------------------------------
REM this replaces original pk on LOG_RECORD, unique constraint
REM not allowed without partition key - but that caused
REM probs for RELATED_FILE and RECORD_ISSUE_JOIN
REM this index doesnt solve that but might be useful 
REM ----------------------------------------------

REM CREATE INDEX LOG_RECORD_01_IDX ON LOG_RECORD(LOG_RECORD_ID) 
REM  
REM  TABLESPACE UM_DWH_USG_IDX
REM  pctfree &5
REM  nologging
REM  storage
REM  ( initial &3
REM    next    &4
REM  );


REM ----------------------------------------------
REM Creating additional indexes on LOG_RECORD
REM ----------------------------------------------

CREATE INDEX LOG_RECORD_02_IDX ON LOG_RECORD(BATCH_ID) 
  TABLESPACE UM_DWH_USG_IDX
  nologging compress 1 ;

CREATE INDEX LOG_RECORD_03_IDX ON LOG_RECORD(NODE_ID) 
  TABLESPACE UM_DWH_USG_IDX
  nologging compress 1 ;

CREATE INDEX LOG_RECORD_04_IDX ON LOG_RECORD(SOURCE_ID)
  TABLESPACE UM_DWH_USG_IDX
  nologging compress 1 ;

CREATE INDEX LOG_RECORD_05_IDX ON LOG_RECORD(SAMPLE_DATE) 
  TABLESPACE UM_DWH_USG_IDX
  nologging compress 1 ;

CREATE INDEX LOG_RECORD_06_IDX ON LOG_RECORD(RECORD_CHECKSUM)
  TABLESPACE UM_DWH_USG_IDX
  nologging ;

CREATE INDEX LOG_RECORD_07_IDX ON LOG_RECORD(IS_MISSING_PREDECESSOR)
  TABLESPACE UM_DWH_USG_IDX
  nologging compress 1 ;

CREATE INDEX LOG_RECORD_08_IDX ON LOG_RECORD(IS_MISSING_SUCCESSOR)
  TABLESPACE UM_DWH_USG_IDX
  nologging compress 1  ;

CREATE INDEX LOG_RECORD_09_IDX ON LOG_RECORD(D_PERIOD_ID) 
  TABLESPACE UM_DWH_USG_IDX
  nologging compress 1 ;
  
CREATE INDEX LOG_RECORD_10_IDX ON LOG_RECORD(FILE_NAME, LOG_RECORD_ID) 
  TABLESPACE UM_DWH_USG_IDX
  nologging compress 1 ;
  
REM -------------------------------------------------
REM Creating column check constraint(s) on LOG_RECORD
REM -------------------------------------------------

ALTER TABLE LOG_RECORD
  ADD CONSTRAINT IS_RE_PRESENTED_01_CK CHECK (IS_RE_PRESENTED IN ('Y','N'))
  novalidate;

ALTER TABLE LOG_RECORD
  ADD CONSTRAINT IS_MISSING_PREDECESSOR_01_CK CHECK (IS_MISSING_PREDECESSOR IN ('Y','N'))
  novalidate;

ALTER TABLE LOG_RECORD
  ADD CONSTRAINT IS_MISSING_SUCCESSOR_01_CK CHECK (IS_MISSING_SUCCESSOR IN ('Y','N'))
  novalidate;

exit;
