CREATE OR REPLACE PACKAGE um.olap_utils IS

    PROCEDURE update_f_file_snapshot;
    PROCEDURE update_f_mrec_snapshot;

END olap_utils;
/
CREATE OR REPLACE PACKAGE BODY um.olap_utils IS
    PROCEDURE update_f_file_snapshot IS
        vNow date := trunc(sysdate);
        vRecentMonths INTEGER := 1;
    BEGIN
        begin
            execute immediate 'trunc um.f_file_recent';
        exception
          when others then
            null;
        end;
        execute immediate 'insert into um.f_file_recent
            select * from um.f_file ff
                where ff.d_period_id >= add_months(to_date(''' || to_char(vNow, 'DD/MM/YYYY') || ''',''DD/MM/YYYY''), 0 - ' || vRecentMonths || ')';
    END update_f_file_snapshot;

    PROCEDURE update_f_mrec_snapshot IS
        vNow date := trunc(sysdate);
        vRecentMonths INTEGER := 1;
    BEGIN
        begin
            execute immediate 'trunc um.f_mrec_recent';
        exception
          when others then
            null;
        end;
        execute immediate 'insert into um.f_mrec_recent
            select * from um.f_mrec ff
                where ff.d_period_id >= add_months(to_date(''' || to_char(vNow, 'DD/MM/YYYY') || ''',''DD/MM/YYYY''), 0 - ' || vRecentMonths || ')';
    END update_f_mrec_snapshot;

END olap_utils;
/
show errors;
/

exit
