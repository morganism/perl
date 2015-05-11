update olap_ref set mdx='select Crossjoin({[Period]}, {[Measures]}) ON COLUMNS, {[EDR Type]} ON ROWS from [FILE_VIEW]' where olap_ref_id=35001;
update olap_ref set mdx='select Crossjoin([Period].[All Periods].Children, {[Measures].[EDRs]}) ON COLUMNS, Hierarchize({([Source by Type.Source by Type].[All Source by Types], [EDR Type].[All EDR Types], [Measure Type].[All Measure Types])}) ON ROWS from [FILE_VIEW]' where olap_ref_id=35002;

exit;
