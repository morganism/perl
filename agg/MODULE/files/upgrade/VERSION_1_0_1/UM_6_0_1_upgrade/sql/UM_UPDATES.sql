

create bitmap index D_MREC_LINE_MV_BX_07 on D_MREC_LINE_MV (MREC_DEFINITION_ID, MREC_LINE_TYPE, MREC_TYPE, MREC_LINE_NAME, D_MREC_LINE_ID)
 	  	   tablespace UM_MV_IDX
 	  	   parallel
 	  	   pctfree 10
 	  	   nologging;

commit;
exit;
