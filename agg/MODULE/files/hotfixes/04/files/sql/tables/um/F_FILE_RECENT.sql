REM ----------------------------------------------
REM Cartesian Limited
REM Table: F_FILE_RECENT
REM ----------------------------------------------

CREATE TABLE F_FILE_RECENT
(        
         D_PERIOD_ID             DATE NOT NULL,
         F_FILE_RECENT_ID               INTEGER,
         SAMPLE_DATE             DATE NOT NULL,
         LOG_RECORD_ID           INTEGER,
         F_ATTRIBUTE_ID          INTEGER NOT NULL,
         EDR_COUNT               INTEGER,
         EDR_VALUE               NUMBER,
         EDR_DURATION            NUMBER,
         EDR_BYTES               INTEGER
)
  TABLESPACE UM_DWH_USG_DATA
  pctfree 10
  nologging compress;


REM ----------------------------------------------
REM Creating primary keys on F_FILE_RECENT
REM ----------------------------------------------

ALTER TABLE F_FILE_RECENT
  ADD CONSTRAINT F_FILE_RECENT_PK PRIMARY KEY (F_FILE_RECENT_ID,D_PERIOD_ID)
  USING INDEX 
  TABLESPACE UM_DWH_USG_IDX 
  pctfree 10
  compress 1;

REM ----------------------------------------------
REM The linesbelow change the index into a global index
REM and are commented out for now.
REM ----------------------------------------------
REM alter table F_FILE_RECENT disable primary key;
REM alter table F_FILE_RECENT enable novalidate primary key;


REM ----------------------------------------------
REM Creating foreign keys for F_FILE_RECENT
REM ----------------------------------------------

REM ALTER TABLE F_FILE_RECENT
REM  ADD CONSTRAINT F_FILE_RECENT_01_FK FOREIGN KEY (F_ATTRIBUTE_ID)
REM  REFERENCES F_ATTRIBUTE(F_ATTRIBUTE_ID)
REM  NOVALIDATE;
  
  
REM ----------------------------------------------
REM Creating indexes on F_FILE_RECENT
REM ----------------------------------------------

create index F_FILE_RECENT_01_IDX on F_FILE_RECENT (D_PERIOD_ID, LOG_RECORD_ID)
  TABLESPACE UM_DWH_USG_IDX
  nologging compress 1;

create bitmap index F_FILE_RECENT_PERIOD_ID_IDX on F_FILE_RECENT (D_PERIOD_ID)
  TABLESPACE UM_DWH_USG_IDX
  pctfree 10
  nologging ;

create bitmap index F_FILE_RECENT_ATTRIBUTE_ID_IDX on F_FILE_RECENT (F_ATTRIBUTE_ID)
  TABLESPACE UM_DWH_USG_IDX
  pctfree 10
  nologging ;

REM ----------------------------------------------
REM Creating Materialised View Log for F_FILE_RECENT
REM ----------------------------------------------

create materialized view log
on UM.F_FILE_RECENT
tablespace UM_MVL_DATA
with rowid (
         D_PERIOD_ID,
         F_FILE_RECENT_ID,
         SAMPLE_DATE,         
         LOG_RECORD_ID,
         F_ATTRIBUTE_ID, 
         EDR_COUNT,
         EDR_VALUE,
         EDR_DURATION,
         EDR_BYTES
     ),
     sequence
including new values;

exit;
