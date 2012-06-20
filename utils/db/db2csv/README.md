<pre>
 db2csv Version: : 1.36 

 USAGE:

  db2csv [ARGUMENTS]

 ARGUMENTS: 
   UNARY

    -h, --help                  Display this usage screen.
    -V, --version               Display version information.
        --create-table-sql      Generate the SQL to create the tables.
        --create-table-xml      Generate the XML to create the tables.
        --column-header         First row in output file is the column names.
    -D, --debug                 Debug mode
        --mru                   Turn ON use of Most Recently Used functionality for remembering defaults
        --nomru                 Turn OFF use of Most Recently Used functionality for remembering defaults
        --nodump                Do not dump the tables. HINT: Use with --create-table-sql
        --preserve-nl           Do not replace \n with \\n (as required by SQL*Loader)
    -q, --quiet                 Be quiet. Use default for all options.
    -Q, --very-quiet            Be very quiet. Same as quiet but no output.
    -v, --views                 Include views in list of tables to dump.
   BINARY
    -d, --dir                   PATH              Specify output directory.
        --delimiter             CHAR              Specify delimiter.
        --date-format           STRING            Specify date format stringt.
    -C, --create-control-files  [APPEND|TRUNCATE] Generate sqlldr control files for each table that is dumped.
                                                  Optionall specify APPEND or TRUNCATE, default TRUNCATE.
    -c, --ctrl-file-path        PATH              Specify PATH to ctrl files. *see note below
    -e, --enclose               CHAR              Specify ENCLOSE character.
        --extension             STRING            Specify output filename extension.
        --prefix                STRING            Specify output filename prefix.
        --exclude-column        [TABLE.]COLUMN    Exclude COLUMN from the dump, and control file creation
                                                  OK to specify multiple --exclude-column arguments.
                                                  TABLE is optional will restrict exclusion to the named table.
                                                  N.B. The syntax is TABLE<DOT>COLUMN, or COLUMN.
    -f, --file                  CHAR              Specify filename containing SQL to execute instead of table or view.
        --long-read-len         INT               Specify largest length of LONG types (bytes).
    -m, --max-rows              INT               Specify the maximum number of rows per output file.
        --nls-lang              STRING            Set the NLS_LANG environmental variable. Example: FRENCH_BELGIUM.WE8MSWIN1252
    -n, --out-file-name         CHAR              Specify name of output filename.
    -o, --oracle-sid            ORACLE_SID        Specify ORACLE SID.
    -p, --password              PASS              Specify password.
    -s, --schema                SCHEMA            Specify schema to dump, same as user.
    -t, --table                 TABLE             Specify table to dump (OK 2 specify multiple -t args). Use __ALL__ to dump all tables in schema.
    -T, --table-file            FILE              Specify file containing list of tables.
    -u, --user                  USER              Specify user to dump, same as schema.
    -z, --zip                   [NUMBER]          Output to a gzip stream, optionally supply compression level (1-9).

    -Z, --zip-cmd               COMMAND           Specify command to use for compression.

 NOTES:
    Example to dump a table to /tmp using compression, suitable from cron

    db2csv -z -Q -d /tmp -o DB01 -s HUMRES -p s3cr3t -t EMPLOYEE_DETAILS


    --create-table-sql
         Use this option to query DBMS_METADATA to generate the SQL to create the table.
    --ctrl-file-path PATH
         Set this to search directories under PATH for ctrl files matching
         the name of the table being dumped [EMPLOYEE_DETAILS.ctrl when dumping EMPLOYEE_DETAILS].
         The ctrl file will be used to dump data in a format suitable to be loaded in by that ctrl file.
         Example DATE fields will be dumped in the format specified instead of Oracle's default.

    -enclose CHAR
         This will override the default character: ".
         If ctrl files are not being parsed skip to (3):
            1) check field level for 'ENCLOSE BY' statement, always enclose this field
            2) next check for commas, fields with commas will be enclosed by the OPTIONALLY ENCLOSED BY character
            3) if for some reason OPTIONALLY ENCLOSED BY has not been specified use --enclose CHAR (defaults to: ")

</pre>
