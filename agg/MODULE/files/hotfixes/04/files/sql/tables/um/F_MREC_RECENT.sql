REM ----------------------------------------------
REM Cartesian Limited
REM Table: F_MREC_RECENT
REM ----------------------------------------------

CREATE TABLE F_MREC_RECENT
(        
         D_PERIOD_ID             DATE NOT NULL,
         F_MREC_RECENT_ID               INTEGER,
         F_FILE_ID               INTEGER,
         F_ATTRIBUTE_ID          INTEGER,
         MREC_ID                 INTEGER NOT NULL,
         MREC_SET                NUMBER(1) NOT NULL,
         D_MREC_LINE_ID          INTEGER NOT NULL,
         D_EDGE_ID               INTEGER,
         MREC_TYPE               VARCHAR2(1) NOT NULL,
         MEASURE_TYPE            VARCHAR2(1) NOT NULL,
         MREC                    NUMBER
)
  TABLESPACE UM_DWH_MTR_DATA
  pctfree 10
  nologging;

REM ----------------------------------------------
REM Creating primary keys on F_MREC_RECENT
REM ----------------------------------------------

ALTER TABLE F_MREC_RECENT
  ADD CONSTRAINT F_MREC_RECENT_PK PRIMARY KEY (D_PERIOD_ID,F_MREC_RECENT_ID)
  USING INDEX TABLESPACE UM_DWH_MTR_IDX;

REM ----------------------------------------------
REM The lines below change the index into a global index
REM and are commented out for now.
REM ----------------------------------------------
REM alter table F_MREC_RECENT disable primary key;
REM alter table F_MREC_RECENT enable novalidate primary key;

REM -------------------------------------------------
REM Creating column check constraint(s) on F_MREC_RECENT
REM -------------------------------------------------

ALTER TABLE F_MREC_RECENT
  ADD CONSTRAINT F_MREC_RECENT_01_CK CHECK (MREC_SET IN (-1,0,1));

ALTER TABLE F_MREC_RECENT
  MODIFY CONSTRAINT F_MREC_RECENT_01_CK RELY;

ALTER TABLE F_MREC_RECENT
  DISABLE NOVALIDATE CONSTRAINT F_MREC_RECENT_01_CK;

ALTER TABLE F_MREC_RECENT
  ADD CONSTRAINT F_MREC_RECENT_02_CK CHECK (MREC_TYPE IN ('T', 'F'));

ALTER TABLE F_MREC_RECENT
  MODIFY CONSTRAINT F_MREC_RECENT_02_CK RELY;

ALTER TABLE F_MREC_RECENT
  DISABLE NOVALIDATE CONSTRAINT F_MREC_RECENT_02_CK;

ALTER TABLE F_MREC_RECENT
  ADD CONSTRAINT F_MREC_RECENT_03_CK CHECK (MEASURE_TYPE IN ( 'C' , 'B' , 'V' , 'D' ));

ALTER TABLE F_MREC_RECENT
  MODIFY CONSTRAINT F_MREC_RECENT_03_CK RELY;

REM ----------------------------------------------
REM Creating indexes on F_MREC_RECENT
REM ----------------------------------------------

create bitmap index F_MREC_RECENT_D_PERIOD_ID_IDX on F_MREC_RECENT (D_PERIOD_ID)
  TABLESPACE UM_DWH_MTR_IDX
  pctfree 10
  nologging;

create index F_MREC_RECENT_F_MREC_RECENT_ID_IDX on F_MREC_RECENT (F_MREC_RECENT_ID) 
  tablespace UM_DWH_MTR_IDX
  pctfree 10
  nologging;

create index F_MREC_RECENT_F_FILE_ID_IDX on F_MREC_RECENT (F_FILE_ID) 
  tablespace UM_DWH_MTR_IDX
  pctfree 10
  nologging

create bitmap index F_MREC_RECENT_F_ATTRIBUTE_ID_IDX on F_MREC_RECENT (F_ATTRIBUTE_ID) 
  tablespace UM_DWH_MTR_IDX
  pctfree 10
  nologging;

create index F_MREC_RECENT_MREC_ID_IDX on F_MREC_RECENT (MREC_ID) 
  tablespace UM_DWH_MTR_IDX
  pctfree 10
  nologging;

create bitmap index F_MREC_RECENT_D_MREC_LINE_ID_IDX on F_MREC_RECENT (D_MREC_LINE_ID) 
  tablespace UM_DWH_MTR_IDX
  pctfree 10
  nologging;

create bitmap index F_MREC_RECENT_D_EDGE_ID_IDX on F_MREC_RECENT (D_EDGE_ID) 
  tablespace UM_DWH_MTR_IDX
  pctfree 10
  nologging;

create bitmap index F_MREC_RECENT_MREC_TYPE_IDX on F_MREC_RECENT (MREC_TYPE)
  tablespace UM_DWH_MTR_IDX
  pctfree 10
  nologging;

create index F_MREC_RECENT_01_IDX on F_MREC_RECENT (MREC_SET, D_PERIOD_ID, MREC_ID, D_MREC_LINE_ID, F_MREC_RECENT_ID, MREC) 
  tablespace um_dwh_mtr_idx
  compress 1;

  
REM ----------------------------------------------
REM Creating Materialised View Log for F_MREC_RECENT
REM ----------------------------------------------

create materialized view log 
on UM.F_MREC_RECENT 
tablespace UM_MVL_DATA 
with rowid (
         D_PERIOD_ID,
         F_MREC_RECENT_ID,
         F_FILE_ID,
         F_ATTRIBUTE_ID,
         MREC_ID,
         MREC_SET,         
         D_MREC_LINE_ID,
         D_EDGE_ID,
         MREC_TYPE,
         MREC),
     sequence
including new values;

exit;
