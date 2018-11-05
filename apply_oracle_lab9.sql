@/home/student/Data/cit225/oracle/lab8/apply_oracle_lab8.sql

SPOOL apply_oracle_lab9.txt

--Step 1a-----------------
--Create transaction table
--------------------------
CREATE TABLE transaction
( transaction_id        NUMBER          CONSTRAINT pk_transaction_01    PRIMARY KEY
, transaction_account   VARCHAR2(15)    CONSTRAINT nn_transaction_01    NOT NULL
, transaction_type      NUMBER          CONSTRAINT nn_transaction_02    NOT NULL
, transaction_date      DATE            CONSTRAINT nn_transaction_03    NOT NULL
, transaction_amount    NUMBER          CONSTRAINT nn_transaction_04    NOT NULL
, rental_id             NUMBER          CONSTRAINT nn_transaction_05    NOT NULL
, payment_method_type   NUMBER          CONSTRAINT nn_transaction_06    NOT NULL
, payment_account_number VARCHAR2(19)   CONSTRAINT nn_transaction_07    NOT NULL
, created_by            NUMBER          CONSTRAINT nn_transaction_08    NOT NULL
, creation_date         DATE            CONSTRAINT nn_transaction_09    NOT NULL
, last_updated_by       NUMBER          CONSTRAINT nn_transaction_10    NOT NULL
, last_update_date      DATE            CONSTRAINT nn_transaction_11    NOT NULL
, CONSTRAINT fk_transaction_01 FOREIGN KEY (transaction_type) REFERENCES common_lookup(common_lookup_id)
, CONSTRAINT fk_transaction_02 FOREIGN KEY (rental_id) REFERENCES rental(rental_id)
, CONSTRAINT fk_transaction_03 FOREIGN KEY (payment_method_type) REFERENCES common_lookup(common_lookup_id)
, CONSTRAINT fk_transaction_04 FOREIGN KEY (created_by) REFERENCES system_user(system_user_id)
, CONSTRAINT fk_transaction_05 FOREIGN KEY (last_updated_by) REFERENCES system_user(system_user_id));

CREATE SEQUENCE transaction_s1;
--Step 1a verification--------------------------------------------
--The following query veries that the table was created correctly
-----------------------------------------------------------------
COLUMN table_name   FORMAT A14  HEADING "Table Name"
COLUMN column_id    FORMAT 9999 HEADING "Column ID"
COLUMN column_name  FORMAT A22  HEADING "Column Name"
COLUMN nullable     FORMAT A8   HEADING "Nullable"
COLUMN data_type    FORMAT A12  HEADING "Data Type"
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'TRANSACTION'
ORDER BY 2;
--Step 1b----------------------------
--Create the NATURAL_KEY unique index
-------------------------------------
CREATE UNIQUE INDEX natural_key ON transaction(rental_id, transaction_type, transaction_date, payment_method_type, payment_account_number, transaction_account);
--Step 1b verification----------------
--Verifies index was created correctly
--------------------------------------
COLUMN table_name       FORMAT A12  HEADING "Table Name"
COLUMN index_name       FORMAT A16  HEADING "Index Name"
COLUMN uniqueness       FORMAT A8   HEADING "Unique"
COLUMN column_position  FORMAT 9999 HEADING "Column Position"
COLUMN column_name      FORMAT A24  HEADING "Column Name"
SELECT   i.table_name
,        i.index_name
,        i.uniqueness
,        ic.column_position
,        ic.column_name
FROM     user_indexes i INNER JOIN user_ind_columns ic
ON       i.index_name = ic.index_name
WHERE    i.table_name = 'TRANSACTION'
AND      i.uniqueness = 'UNIQUE'
AND      i.index_name = 'NATURAL_KEY';
--Step 2a----------------------------------------------------------------------------------------
--Insert two TRANSACTION_TYPE rows and four PAYMENT_METHOD_TYPE rows into the COMMON_LOOKUP table.
-------------------------------------------------------------------------------------------------
INSERT INTO common_lookup
( common_lookup_id, common_lookup_type, common_lookup_meaning
, created_by, creation_date, last_updated_by, last_update_date
, common_lookup_table, common_lookup_column, common_lookup_code)
VALUES
( common_lookup_s1.NEXTVAL, 'DEBIT', 'Debit'
, 1, SYSDATE, 1, SYSDATE
, 'TRANSACTION', 'TRANSACTION_TYPE', 'CR');

INSERT INTO common_lookup
( common_lookup_id, common_lookup_type, common_lookup_meaning
, created_by, creation_date, last_updated_by, last_update_date
, common_lookup_table, common_lookup_column, common_lookup_code)
VALUES
( common_lookup_s1.NEXTVAL, 'CREDIT', 'Credit'
, 1, SYSDATE, 1, SYSDATE
, 'TRANSACTION', 'TRANSACTION_TYPE', 'DR');

INSERT INTO common_lookup
( common_lookup_id, common_lookup_type, common_lookup_meaning
, created_by, creation_date, last_updated_by, last_update_date
, common_lookup_table, common_lookup_column, common_lookup_code)
VALUES
( common_lookup_s1.NEXTVAL, 'DISCOVER_CARD', 'Discover Card'
, 1, SYSDATE, 1, SYSDATE
, 'TRANSACTION', 'PAYMENT_METHOD_TYPE', '');

INSERT INTO common_lookup
( common_lookup_id, common_lookup_type, common_lookup_meaning
, created_by, creation_date, last_updated_by, last_update_date
, common_lookup_table, common_lookup_column, common_lookup_code)
VALUES
( common_lookup_s1.NEXTVAL, 'VISA_CARD', 'Visa Card'
, 1, SYSDATE, 1, SYSDATE
, 'TRANSACTION', 'PAYMENT_METHOD_TYPE', '');

INSERT INTO common_lookup
( common_lookup_id, common_lookup_type, common_lookup_meaning
, created_by, creation_date, last_updated_by, last_update_date
, common_lookup_table, common_lookup_column, common_lookup_code)
VALUES
( common_lookup_s1.NEXTVAL, 'MASTER_CARD', 'Master Card'
, 1, SYSDATE, 1, SYSDATE
, 'TRANSACTION', 'PAYMENT_METHOD_TYPE', '');

INSERT INTO common_lookup
( common_lookup_id, common_lookup_type, common_lookup_meaning
, created_by, creation_date, last_updated_by, last_update_date
, common_lookup_table, common_lookup_column, common_lookup_code)
VALUES
( common_lookup_s1.NEXTVAL, 'CASH', 'Cash'
, 1, SYSDATE, 1, SYSDATE
, 'TRANSACTION', 'PAYMENT_METHOD_TYPE', '');
--Step 2a verification---------------------
--Verifies the rows were inserted correctly
-------------------------------------------
COLUMN common_lookup_table  FORMAT A20 HEADING "COMMON_LOOKUP_TABLE"
COLUMN common_lookup_column FORMAT A20 HEADING "COMMON_LOOKUP_COLUMN"
COLUMN common_lookup_type   FORMAT A20 HEADING "COMMON_LOOKUP_TYPE"
SELECT   common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
WHERE    common_lookup_table = 'TRANSACTION'
AND      common_lookup_column IN ('TRANSACTION_TYPE','PAYMENT_METHOD_TYPE')
ORDER BY 1, 2, 3 DESC;

--Step 3a-----------------------------------------------
--Create the AIRPORT table and the AIRPORT_S1 sequences.
--------------------------------------------------------
CREATE TABLE airport
( airport_id            NUMBER          CONSTRAINT pk_airport_01        PRIMARY KEY
, airport_code          VARCHAR2(3)     CONSTRAINT nn_airport_01        NOT NULL
, airport_city          VARCHAR2(30)    CONSTRAINT nn_airport_02        NOT NULL
, city                  VARCHAR2(30)    CONSTRAINT nn_airport_03        NOT NULL
, state_province        VARCHAR2(30)    CONSTRAINT nn_airport_04        NOT NULL
, created_by            NUMBER          CONSTRAINT nn_airport_05        NOT NULL
, creation_date         DATE            CONSTRAINT nn_airport_06        NOT NULL
, last_updated_by       NUMBER          CONSTRAINT nn_airport_07        NOT NULL
, last_update_date      DATE            CONSTRAINT nn_airport_08        NOT NULL
, CONSTRAINT fk_airport_01 FOREIGN KEY (created_by) REFERENCES system_user(system_user_id)
, CONSTRAINT fk_airport_02 FOREIGN KEY (last_updated_by) REFERENCES system_user(system_user_id));

CREATE SEQUENCE airport_s1;
--Step 3a verification---------------------------------
--Verifies that the airport table was created correctly
-------------------------------------------------------
COLUMN table_name   FORMAT A14  HEADING "Table Name"
COLUMN column_id    FORMAT 9999 HEADING "Column ID"
COLUMN column_name  FORMAT A22  HEADING "Column Name"
COLUMN nullable     FORMAT A8   HEADING "Nullable"
COLUMN data_type    FORMAT A12  HEADING "Data Type"
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'AIRPORT'
ORDER BY 2;
--Step 3b-----------------------------------------------------------------
--Create unique natural key (named NK_AIRPORT) index for the AIRPORT table
--------------------------------------------------------------------------
CREATE UNIQUE INDEX nk_airport ON airport(airport_code, airport_city, city, state_province);
--Step 3b verification---------------------------
--Verifies the unique index was created correctly
-------------------------------------------------
COLUMN table_name       FORMAT A12  HEADING "Table Name"
COLUMN index_name       FORMAT A16  HEADING "Index Name"
COLUMN uniqueness       FORMAT A8   HEADING "Unique"
COLUMN column_position  FORMAT 9999 HEADING "Column Position"
COLUMN column_name      FORMAT A24  HEADING "Column Name"
SELECT   i.table_name
,        i.index_name
,        i.uniqueness
,        ic.column_position
,        ic.column_name
FROM     user_indexes i INNER JOIN user_ind_columns ic
ON       i.index_name = ic.index_name
WHERE    i.table_name = 'AIRPORT'
AND      i.uniqueness = 'UNIQUE'
AND      i.index_name = 'NK_AIRPORT';
--Step 3c------------------------------------------------------------
--seed the AIRPORT table with at these cities------------------------
--Airport Code	Airport City	      City	       State Province
--LAX	        Los Angeles	      Los Angeles      California
--SLC	        Salt Lake City	      Provo            Utah
--SLC	        Salt Lake City	      Spanish Fork     Utah
--SFO	        San Francisco	      San Francsico    California
--SJC	        San Jose	      San Jose	       California
--SJC	        San Jose	      San Carlos       California
---------------------------------------------------------------------
INSERT INTO airport
( airport_id, airport_code, airport_city, city, state_province 
, created_by , creation_date, last_updated_by, last_update_date)
VALUES
( airport_s1.NEXTVAL, 'LAX', 'Los Angeles', 'Los Angeles', 'California'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO airport
( airport_id, airport_code, airport_city, city, state_province 
, created_by , creation_date, last_updated_by, last_update_date)
VALUES
( airport_s1.NEXTVAL, 'SLC', 'Salt Lake City', 'Provo', 'Utah'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO airport
( airport_id, airport_code, airport_city, city, state_province 
, created_by , creation_date, last_updated_by, last_update_date)
VALUES
( airport_s1.NEXTVAL, 'SLC', 'Salt Lake City', 'Spanish Fork', 'Utah'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO airport
( airport_id, airport_code, airport_city, city, state_province 
, created_by , creation_date, last_updated_by, last_update_date)
VALUES
( airport_s1.NEXTVAL, 'SFO', 'San Francisco', 'San Francisco', 'California'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO airport
( airport_id, airport_code, airport_city, city, state_province 
, created_by , creation_date, last_updated_by, last_update_date)
VALUES
( airport_s1.NEXTVAL, 'SJC', 'San Jose', 'San Jose', 'California'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO airport
( airport_id, airport_code, airport_city, city, state_province 
, created_by , creation_date, last_updated_by, last_update_date)
VALUES
( airport_s1.NEXTVAL, 'SJC', 'San Jose', 'San Carlos', 'California'
, 1, SYSDATE, 1, SYSDATE);
--Step 3c verification---------------------------
--Verifies that the inerts were done correctly---
-------------------------------------------------
COLUMN code           FORMAT A4  HEADING "Code"
COLUMN airport_city   FORMAT A14 HEADING "Airport City"
COLUMN city           FORMAT A14 HEADING "City"
COLUMN state_province FORMAT A10 HEADING "State or|Province"
SELECT   airport_code AS code
,        airport_city
,        city
,        state_province
FROM     airport;
--Step 3d---------------------------------------------------
--Create the ACCOUNT_LIST table and ACCOUNT_LIST_S1 sequence.
------------------------------------------------------------
CREATE TABLE account_list
( account_list_id       NUMBER          CONSTRAINT pk_accnt_list_01 PRIMARY KEY
, account_number        VARCHAR2(10)    CONSTRAINT nn_accnt_list_01 NOT NULL
, consumed_date         DATE
, consumed_by           NUMBER          
, created_by            NUMBER          CONSTRAINT nn_accnt_list_02 NOT NULL
, creation_date         DATE            CONSTRAINT nn_accnt_list_03 NOT NULL
, last_updated_by       NUMBER          CONSTRAINT nn_accnt_list_04 NOT NULL
, last_update_date      DATE            CONSTRAINT nn_accnt_list_05 NOT NULL
, CONSTRAINT fk_accnt_list_01 FOREIGN KEY (consumed_by) REFERENCES system_user(system_user_id)
, CONSTRAINT fk_accnt_list_02 FOREIGN KEY (created_by) REFERENCES system_user(system_user_id)
, CONSTRAINT fk_accnt_list_03 FOREIGN KEY (last_updated_by) REFERENCES system_user(system_user_id));

CREATE SEQUENCE account_list_s1;
--Step 3d verification---------------------------
--Verifies that the table was created correctly--
-------------------------------------------------
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'ACCOUNT_LIST'
ORDER BY 2;
--Step 3e-----------------------------
--Create or replace seeding procedure.
--------------------------------------
CREATE OR REPLACE PROCEDURE seed_account_list IS
  /* Declare variable to capture table, and column. */
  lv_table_name   VARCHAR2(90);
  lv_column_name  VARCHAR2(30);

  /* Declare an exception variable and PRAGMA map. */
  not_null_column  EXCEPTION;
  PRAGMA EXCEPTION_INIT(not_null_column,-1400);

BEGIN
  /* Set savepoint. */
  SAVEPOINT all_or_none;

  FOR i IN (SELECT DISTINCT airport_code FROM airport) LOOP
    FOR j IN 1..50 LOOP

      INSERT INTO account_list
      VALUES
      ( account_list_s1.NEXTVAL
      , i.airport_code||'-'||LPAD(j,6,'0')
      , null
      , null
      , 1
      , SYSDATE
      , 1
      , SYSDATE);
    END LOOP;
  END LOOP;

  /* Commit the writes as a group. */
  COMMIT;

EXCEPTION
  WHEN not_null_column THEN
    /* Capture the table and column name that triggered the error. */
    lv_table_name := (TRIM(BOTH '"' FROM RTRIM(REGEXP_SUBSTR(SQLERRM,'".*\."',REGEXP_INSTR(SQLERRM,'\.',1,1)),'."')));
    lv_column_name := (TRIM(BOTH '"' FROM REGEXP_SUBSTR(SQLERRM,'".*"',REGEXP_INSTR(SQLERRM,'\.',1,2))));

    /* This undoes all DML statements to this point in the procedure. */
    ROLLBACK TO SAVEPOINT all_or_none;
    RAISE_APPLICATION_ERROR(
       -20001
      ,'Remove the NOT NULL contraint from the '||lv_column_name||' column in'||CHR(10)||' the '||lv_table_name||' table.');
  WHEN OTHERS THEN
    /* This undoes all DML statements to this point in the procedure. */
    ROLLBACK TO SAVEPOINT all_or_none;
END;
/
-------------------------------
--Calls procedure created above
-------------------------------
EXECUTE seed_account_list();
-------------------------------------------------------------
--The following query to verifies the completion of this step
-------------------------------------------------------------
COLUMN object_name FORMAT A18
COLUMN object_type FORMAT A12
SELECT   object_name
,        object_type
FROM     user_objects
WHERE    object_name = 'SEED_ACCOUNT_LIST';
-------------------------------------------------------------
--Calls the SEED_ACCOUNT_LIST procedure to populate the table
-------------------------------------------------------------
COLUMN airport FORMAT A7
SELECT   SUBSTR(account_number,1,3) AS "Airport"
,        COUNT(*) AS "# Accounts"
FROM     account_list
WHERE    consumed_date IS NULL
GROUP BY SUBSTR(account_number,1,3)
ORDER BY 1;
--Step 3f---------------------------------------------------------------------------------------
--The following UPDATE statement changes US Postal Services abbreviations to the full state name
------------------------------------------------------------------------------------------------
UPDATE address
SET    state_province = 'California'
WHERE  state_province = 'CA';

UPDATE address
SET    state_province = 'Utah'
WHERE  state_province = 'UT';
--Step 3g------------------------------------------------------------------------
--Consume values from the ACCOUNT_LIST table and update the ACCOUNT_NUMBER column 
--of the MEMBER table with correct values from the ACCOUNT_LIST table------------
---------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE update_member_account IS

  /* Declare a local variable. */
  lv_account_number VARCHAR2(10);

  /* Declare a SQL cursor fabricated from local variables. */  
  CURSOR member_cursor IS
    SELECT   DISTINCT
             m.member_id
    ,        a.city
    ,        a.state_province
    FROM     member m INNER JOIN contact c
    ON       m.member_id = c.member_id INNER JOIN address a
    ON       c.contact_id = a.contact_id
    ORDER BY m.member_id;

BEGIN
   
/* Set savepoint. */  
  SAVEPOINT all_or_none;
  
/* Open a local cursor. */  
  FOR i IN member_cursor LOOP
  
/* Secure a unique account number as they're consumed from the list. */
      SELECT al.account_number
      INTO   lv_account_number
      FROM   account_list al INNER JOIN airport ap
      ON     SUBSTR(al.account_number,1,3) = ap.airport_code
      WHERE  ap.city = i.city
      AND    ap.state_province = i.state_province
      AND    consumed_by IS NULL
      AND    consumed_date IS NULL
      AND    ROWNUM < 2;

      /* Update a member with a unique account number linked to their nearest airport. */
      UPDATE member
      SET    account_number = lv_account_number
      WHERE  member_id = i.member_id;

      /* Mark consumed the last used account number. */      
      UPDATE account_list
      SET    consumed_by = 1002
      ,      consumed_date = SYSDATE
      WHERE  account_number = lv_account_number;
      
  END LOOP;

/* Commit the writes as a group. */
  COMMIT;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    dbms_output.put_line('You have an error in your AIRPORT table inserts.');

/* This undoes all DML statements to this point in the procedure. */
    ROLLBACK TO SAVEPOINT all_or_none;
  WHEN OTHERS THEN
/* This undoes all DML statements to this point in the procedure. */
    ROLLBACK TO SAVEPOINT all_or_none;
END;
/
--Step 3g verification--------------------------------------------
--The following query verifies the completion of procedure created
------------------------------------------------------------------
COLUMN object_name FORMAT A22
COLUMN object_type FORMAT A12
SELECT   object_name
,        object_type
FROM     user_objects
WHERE    object_name = 'UPDATE_MEMBER_ACCOUNT';
-----------------
--Calls Procedure
-----------------
EXECUTE update_member_account();
----------------------------------------------------------------------------------------------
--Update the MEMBER table by calling the UPDATE_MEMBER_ACCOUNT procedure to populate the table.
---------------------------------------------------------------------------------------------- 
-- Format the SQL statement display.----------------------------------------------------------
COLUMN member_id      FORMAT 999999 HEADING "Member|ID #"
COLUMN last_name      FORMAT A7     HEADING "Last|Name"
COLUMN account_number FORMAT A10    HEADING "Account|Number"
COLUMN acity          FORMAT A12    HEADING "Address City"
COLUMN apcode         FORMAT A8     HEADING "Airport|State or|Province"
COLUMN alcode         FORMAT A8     HEADING "Airport|Code"
 
-- Query distinct members and addresses.
SELECT   DISTINCT
         m.member_id
,        c.last_name
,        m.account_number
,        a.city AS acity
,        ap.state_province AS apstate
,        SUBSTR(al.account_number,1,3) AS alcode
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN address a
ON       c.contact_id = a.contact_id INNER JOIN airport ap
ON       a.city = ap.city
AND      a.state_province = ap.state_province INNER JOIN account_list al
ON       ap.airport_code = SUBSTR(al.account_number,1,3)
ORDER BY 1;
--The above query should display the MEMBER table with the updated rows.--
--------------------------------------------------------------------------
--------------------------------------------------------------------------
--
--Step 4------------------
--Create transaction table
--------------------------
  CREATE TABLE "STUDENT"."TRANSACTION_UPLOAD"
   (    "ACCOUNT_NUMBER" VARCHAR2(10),
        "FIRST_NAME" VARCHAR2(20),
        "MIDDLE_NAME" VARCHAR2(20),
        "LAST_NAME" VARCHAR2(20),
        "CHECK_OUT_DATE" DATE,
        "RETURN_DATE" DATE,
        "RENTAL_ITEM_TYPE" VARCHAR2(12),
        "TRANSACTION_TYPE" VARCHAR2(14),
        "TRANSACTION_AMOUNT" NUMBER,
        "TRANSACTION_DATE" DATE,
        "ITEM_ID" NUMBER,
        "PAYMENT_METHOD_TYPE" VARCHAR2(14),
        "PAYMENT_ACCOUNT_NUMBER" VARCHAR2(19)
   )
   ORGANIZATION EXTERNAL
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "UPLOAD"
      ACCESS PARAMETERS
      ( RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
      BADFILE     'UPLOAD':'transaction_upload.bad'
      DISCARDFILE 'UPLOAD':'transaction_upload.dis'
      LOGFILE     'UPLOAD':'transaction_upload.log'
      FIELDS TERMINATED BY ','
      OPTIONALLY ENCLOSED BY "'"
      MISSING FIELD VALUES ARE NULL     )
      LOCATION
       ( 'transaction_upload.csv')
    )
   REJECT LIMIT UNLIMITED;

SELECT   COUNT(*) AS "External Rows"
FROM     transaction_upload;
--'
SPOOL OFF
