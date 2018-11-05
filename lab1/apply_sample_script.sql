-- Run the unit test scripts.
@/home/student/Data/cit225/oracle/lab1/create_sample_tables.sql
@/home/student/Data/cit225/oracle/lab1/add_data_in_tables.sql
 
 
-- Put any program logic specific to the integration script.  
SPOOL apply_sample_lab.txt
 
-- Insert your SQL statements here ... 
-- start with the validation scripts ...
 
SPOOL OFF
 
-- ------------------------------------------------------------------
--  This is necessary to avoid a resource busy error. You can
--  inadvertently create a resource busy error when testing in two
--  concurrent SQL*Plus sessions unless you provide an explicit
--  COMMIT; statement. 
-- ------------------------------------------------------------------
COMMIT;
