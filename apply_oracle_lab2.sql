-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lib/cleanup_oracle.sql
@/home/student/Data/cit225/oracle/lib2/create/create_oracle_store2.sql
@/home/student/Data/cit225/oracle/lab2/integration.sql
-- ... insert calls to other files with code here, like ...
 
@@system_user_lab.sql

SPOOL apply_oracle_lab2.txt
 
-- ... insert your code here ...
 
SPOOL OFF
