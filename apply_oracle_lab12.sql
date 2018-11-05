-- This calls Lab #11, Lab #11 calls Lab #10, Lab #10 calls Lab #9, Lab #9 calls Lab #8, Lab #8 calls Lab #7, Lab #7 calls Lab #6, Lab #6 calls Lab #5, and Lab #5 calls both the Creation and Seed script files.
@../lab11/apply_oracle_lab11.sql

SET LINES 9999
SET PAGESIZE 9000
SET LINESIZE 32700
SET TRIMSPOOL ON

SPOOL apply_oracle_lab12.txt

-- Step 1 CREATE CALENDAR TABLE
CREATE TABLE CALENDAR
(CALENDAR_ID            NUMBER
,CALENDAR_NAME          VARCHAR2(10) CONSTRAINT NN_CAL_NAME NOT NULL
,CALENDAR_SHORT_NAME    VARCHAR2(3)  CONSTRAINT NN_CAL_SHOR NOT NULL
,START_DATE             DATE         CONSTRAINT NN_START_DA NOT NULL
,END_DATE               DATE         CONSTRAINT NN_END_DATE NOT NULL
,CREATED_BY             NUMBER       CONSTRAINT NN_CAL_CB   NOT NULL
,CREATION_DATE          DATE         CONSTRAINT NN_CAL_CD   NOT NULL
,LAST_UPDATED_BY        NUMBER       CONSTRAINT NN_CAL_LUB  NOT NULL
,LAST_UPDATE_DATE       DATE         CONSTRAINT NN_CAL_LUD  NOT NULL
,CONSTRAINT PK_CALENDAR_ID PRIMARY KEY (CALENDAR_ID)
,CONSTRAINT FK_CAL_CB      FOREIGN KEY (CREATED_BY) REFERENCES SYSTEM_USER(SYSTEM_USER_ID)
,CONSTRAINT FK_CAL_LUB     FOREIGN KEY (LAST_UPDATED_BY) REFERENCES SYSTEM_USER(SYSTEM_USER_ID));

-- Create calendar sequence.
CREATE SEQUENCE CALENDAR_S1 START WITH 1;
 
-- Step 2 Seed the calendar table with the following data.
INSERT INTO CALENDAR
VALUES (CALENDAR_S1.NEXTVAL
,'January'
,'JAN'
,'01-JAN-2009'
,'31-JAN-2009'
,1
,SYSDATE
,1
,SYSDATE);
INSERT INTO CALENDAR
VALUES (CALENDAR_S1.NEXTVAL
,'February'
,'FEB'
,'01-FEB-2009'
,'28-FEB-2009'
,1
,SYSDATE
,1
,SYSDATE);
INSERT INTO CALENDAR
VALUES (CALENDAR_S1.NEXTVAL
,'March'
,'MAR'
,'01-MAR-2009'
,'31-MAR-2009'
,1
,SYSDATE
,1
,SYSDATE);
INSERT INTO CALENDAR
VALUES (CALENDAR_S1.NEXTVAL
,'April'
,'APR'
,'01-APR-2009'
,'30-APR-2009'
,1
,SYSDATE
,1
,SYSDATE);
INSERT INTO CALENDAR
VALUES (CALENDAR_S1.NEXTVAL
,'May'
,'MAY'
,'01-JAN-2009'
,'31-JAN-2009'
,1
,SYSDATE
,1
,SYSDATE);
INSERT INTO CALENDAR
VALUES (CALENDAR_S1.NEXTVAL
,'June'
,'JUN'
,'01-JUN-2009'
,'30-JUN-2009'
,1
,SYSDATE
,1
,SYSDATE);
INSERT INTO CALENDAR
VALUES (CALENDAR_S1.NEXTVAL
,'July'
,'JUL'
,'01-JUL-2009'
,'31-JUL-2009'
,1
,SYSDATE
,1
,SYSDATE);
INSERT INTO CALENDAR
VALUES (CALENDAR_S1.NEXTVAL
,'August'
,'AUG'
,'01-AUG-2009'
,'31-AUG-2009'
,1
,SYSDATE
,1
,SYSDATE);
INSERT INTO CALENDAR
VALUES (CALENDAR_S1.NEXTVAL
,'September'
,'SEP'
,'01-SEP-2009'
,'30-SEP-2009'
,1
,SYSDATE
,1
,SYSDATE);
INSERT INTO CALENDAR
VALUES (CALENDAR_S1.NEXTVAL
,'October'
,'OCT'
,'01-OCT-2009'
,'31-OCT-2009'
,1
,SYSDATE
,1
,SYSDATE);
INSERT INTO CALENDAR
VALUES (CALENDAR_S1.NEXTVAL
,'November'
,'NOV'
,'01-NOV-2009'
,'30-NOV-2009'
,1
,SYSDATE
,1
,SYSDATE);
INSERT INTO CALENDAR
VALUES (CALENDAR_S1.NEXTVAL
,'December'
,'DEC'
,'01-DEC-2009'
,'31-DEC-2009'
,1
,SYSDATE
,1
,SYSDATE);
 
-- Step 3  Create the TRANSACTION_REVERSAL
CREATE TABLE TRANSACTION_REVERSAL
(TRANSACTION_ID                 NUMBER
,TRANSACTION_ACCOUNT            VARCHAR2(15)
,TRANSACTION_TYPE               NUMBER
,TRANSACTION_DATE               DATE
,TRANSACTION_AMOUNT             FLOAT
,RENTAL_ID                      NUMBER
,PAYMENT_METHOD_TYPE            NUMBER
,PAYMENT_ACCOUNT_NUMBER         VARCHAR2(19)
,CREATED_BY                     NUMBER
,CREATION_DATE                  DATE
,LAST_UPDATED_BY                NUMBER
,LAST_UPDATE_DATE               DATE)
 ORGANIZATION EXTERNAL
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "UPLOAD"
      ACCESS PARAMETERS
      ( RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
      BADFILE     'UPLOAD':'transaction_upload2.bad'
      DISCARDFILE 'UPLOAD':'transaction_upload2.dis'
      LOGFILE     'UPLOAD':'transaction_upload2.log'
      FIELDS TERMINATED BY ','
      OPTIONALLY ENCLOSED BY "'"
      MISSING FIELD VALUES ARE NULL)
      LOCATION('transaction_upload2.csv'))
   REJECT LIMIT UNLIMITED;
-- '
 
SET LONG 200000
SELECT   DBMS_METADATA.get_ddl('TABLE','TRANSACTION_REVERSAL') AS "Table Description"
FROM     dual;
SELECT   COUNT(*) AS "External Rows"
FROM     transaction_reversal;


 
-- Set a local variable of a character large object (CLOB).
VARIABLE ddl_text CLOB
 
--Step 3 Seed transaction table from transaction_reversal.
INSERT INTO transaction
(SELECT transaction_s1.NEXTVAL
,	transaction_account
,       (SELECT common_lookup_id
                FROM common_lookup
               WHERE common_lookup_table = 'TRANSACTION'
                AND common_lookup_column =  'TRANSACTION_TYPE'
                AND common_lookup_type =   'CREDIT')
,	transaction_date
,	transaction_amount / 1.06
,	rental_id
,	payment_method_type
,	payment_account_number
,	1001
,	SYSDATE
, 	1001
,	SYSDATE
 FROM   transaction_reversal);

-- Head of output
COLUMN "Debit Transactions"  FORMAT A20
COLUMN "Credit Transactions" FORMAT A20
COLUMN "All Transactions"    FORMAT A20
 
-- Check current contents of the model.
SELECT 'SELECT record counts' AS "Statement" FROM dual;
SELECT   LPAD(TO_CHAR(c1.transaction_count,'99,999'),19,' ') AS "Debit Transactions"
,        LPAD(TO_CHAR(c2.transaction_count,'99,999'),19,' ') AS "Credit Transactions"
,        LPAD(TO_CHAR(c3.transaction_count,'99,999'),19,' ') AS "All Transactions"
FROM    (SELECT COUNT(*) AS transaction_count FROM transaction WHERE transaction_account = '111-111-111-111') c1 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM transaction WHERE transaction_account = '222-222-222-222') c2 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM transaction) c3;

-- Step 4
-- Create the following transformation report by a CROSS JOIN between the TRANSACTION and CALENDAR tables.
COLUMN Transaction FORMAT A15
COLUMN January   FORMAT A10
COLUMN February  FORMAT A10
COLUMN March     FORMAT A10
COLUMN F1Q       FORMAT A10
COLUMN April     FORMAT A10
COLUMN May       FORMAT A10
COLUMN June      FORMAT A10
COLUMN F2Q       FORMAT A10
COLUMN July      FORMAT A10
COLUMN August    FORMAT A10
COLUMN September FORMAT A10
COLUMN F3Q       FORMAT A10
COLUMN October   FORMAT A10
COLUMN November  FORMAT A10
COLUMN December  FORMAT A10
COLUMN F4Q       FORMAT A10
COLUMN YTD       FORMAT A12

SELECT	transaction_account 	
,	january   			
, 	february  		
,	march 	  		
, 	f1q       		
,	april	  		
, 	may 	  		
, 	june	  		
, 	july	  		
,	f2q			
, 	august    		
, 	september 		
,	f3q			
,	october   		
, 	november   		
, 	december  		
,       f4q 	  		
,       ytd	  		
FROM (
SELECT 	CASE 
		WHEN t.transaction_account = '111-111-111-111' 
		THEN 'Debit'
		WHEN t.transaction_account = '222-222-222-222' 
		THEN 'Credit'
	END AS "TRANSACTION_ACCOUNT"
,	CASE
           	WHEN t.transaction_account = '111-111-111-111' 
		THEN 1
           	WHEN t.transaction_account = '222-222-222-222' 
		THEN 2
        END AS "SORTKEY"
,	LPAD(TO_CHAR
        (SUM(CASE
		WHEN EXTRACT(MONTH FROM transaction_date) = 1 
		AND EXTRACT(YEAR FROM transaction_date) = 2009 
	     THEN
             	CASE
                	WHEN cl.common_lookup_type = 'DEBIT'
                   	THEN t.transaction_amount
                   	ELSE t.transaction_amount * -1
                END
             END),'99,999.00'),10,' ') AS "JANUARY"
,	LPAD(TO_CHAR
        (SUM(CASE
		WHEN EXTRACT(MONTH FROM transaction_date) = 2 
		AND EXTRACT(YEAR FROM transaction_date) = 2009 
	     THEN
             	CASE
                	WHEN cl.common_lookup_type = 'DEBIT'
                   	THEN t.transaction_amount
                   	ELSE t.transaction_amount * -1
                END
             END),'99,999.00'),10,' ') AS "FEBRUARY"
,	LPAD(TO_CHAR
        (SUM(CASE
		WHEN EXTRACT(MONTH FROM transaction_date) = 3 
		AND EXTRACT(YEAR FROM transaction_date) = 2009 
	     THEN
             	CASE
                	WHEN cl.common_lookup_type = 'DEBIT'
                   	THEN t.transaction_amount
                   	ELSE t.transaction_amount * -1
                END
             END),'99,999.00'),10,' ') AS "MARCH"
,	LPAD(TO_CHAR
        (SUM(CASE
		WHEN EXTRACT(MONTH FROM transaction_date) IN (1, 2, 3) 
		AND EXTRACT(YEAR FROM transaction_date) = 2009 
	     THEN
             	CASE
                	WHEN cl.common_lookup_type = 'DEBIT'
                   	THEN t.transaction_amount
                   	ELSE t.transaction_amount * -1
                END
             END),'99,999.00'),10,' ') AS "F1Q"
,	LPAD(TO_CHAR
        (SUM(CASE
		WHEN EXTRACT(MONTH FROM transaction_date) = 4 
		AND EXTRACT(YEAR FROM transaction_date) = 2009 
	     THEN
             	CASE
                	WHEN cl.common_lookup_type = 'DEBIT'
                   	THEN t.transaction_amount
                   	ELSE t.transaction_amount * -1
                END
             END),'99,999.00'),10,' ') AS "APRIL"
,	LPAD(TO_CHAR
        (SUM(CASE
		WHEN EXTRACT(MONTH FROM transaction_date) = 5 
		AND EXTRACT(YEAR FROM transaction_date) = 2009 
	     THEN
             	CASE
                	WHEN cl.common_lookup_type = 'DEBIT'
                   	THEN t.transaction_amount
                   	ELSE t.transaction_amount * -1
                END
             END),'99,999.00'),10,' ') AS "MAY"
,	LPAD(TO_CHAR
        (SUM(CASE
		WHEN EXTRACT(MONTH FROM transaction_date) = 6 
		AND EXTRACT(YEAR FROM transaction_date) = 2009 
	     THEN
             	CASE
                	WHEN cl.common_lookup_type = 'DEBIT'
                   	THEN t.transaction_amount
                   	ELSE t.transaction_amount * -1
                END
             END),'99,999.00'),10,' ') AS "JUNE"
,	LPAD(TO_CHAR
        (SUM(CASE
		WHEN EXTRACT(MONTH FROM transaction_date) IN (4, 5, 6) 
		AND EXTRACT(YEAR FROM transaction_date) = 2009 
	     THEN
             	CASE
                	WHEN cl.common_lookup_type = 'DEBIT'
                   	THEN t.transaction_amount
                   	ELSE t.transaction_amount * -1
                END
             END),'99,999.00'),10,' ') AS "F2Q"
,	LPAD(TO_CHAR
        (SUM(CASE
		WHEN EXTRACT(MONTH FROM transaction_date) = 7 
		AND EXTRACT(YEAR FROM transaction_date) = 2009 
	     THEN
             	CASE
                	WHEN cl.common_lookup_type = 'DEBIT'
                   	THEN t.transaction_amount
                   	ELSE t.transaction_amount * -1
                END
             END),'99,999.00'),10,' ') AS "JULY"
,	LPAD(TO_CHAR
        (SUM(CASE
		WHEN EXTRACT(MONTH FROM transaction_date) = 8 
		AND EXTRACT(YEAR FROM transaction_date) = 2009 
	     THEN
             	CASE
                	WHEN cl.common_lookup_type = 'DEBIT'
                   	THEN t.transaction_amount
                   	ELSE t.transaction_amount * -1
                END
             END),'99,999.00'),10,' ') AS "AUGUST"
,	LPAD(TO_CHAR
        (SUM(CASE
		WHEN EXTRACT(MONTH FROM transaction_date) = 9 
		AND EXTRACT(YEAR FROM transaction_date) = 2009 
	     THEN
             	CASE
                	WHEN cl.common_lookup_type = 'DEBIT'
                   	THEN t.transaction_amount
                   	ELSE t.transaction_amount * -1
                END
             END),'99,999.00'),10,' ') AS "SEPTEMBER"
,	LPAD(TO_CHAR
        (SUM(CASE
		WHEN EXTRACT(MONTH FROM transaction_date) IN (7, 8, 9)
		AND EXTRACT(YEAR FROM transaction_date) = 2009 
	     THEN
             	CASE
                	WHEN cl.common_lookup_type = 'DEBIT'
                   	THEN t.transaction_amount
                   	ELSE t.transaction_amount * -1
                END
             END),'99,999.00'),10,' ') AS "F3Q"
,	LPAD(TO_CHAR
        (SUM(CASE
		WHEN EXTRACT(MONTH FROM transaction_date) = 10
		AND EXTRACT(YEAR FROM transaction_date) = 2009 
	     THEN
             	CASE
                	WHEN cl.common_lookup_type = 'DEBIT'
                   	THEN t.transaction_amount
                   	ELSE t.transaction_amount * -1
                END
             END),'99,999.00'),10,' ') AS "OCTOBER"
,	LPAD(TO_CHAR
        (SUM(CASE
		WHEN EXTRACT(MONTH FROM transaction_date) = 11
		AND EXTRACT(YEAR FROM transaction_date) = 2009 
	     THEN
             	CASE
                	WHEN cl.common_lookup_type = 'DEBIT'
                   	THEN t.transaction_amount
                   	ELSE t.transaction_amount * -1
                END
             END),'99,999.00'),10,' ') AS "NOVEMBER"
,	LPAD(TO_CHAR
        (SUM(CASE
		WHEN EXTRACT(MONTH FROM transaction_date) = 12 
		AND EXTRACT(YEAR FROM transaction_date) = 2009 
	     THEN
             	CASE
                	WHEN cl.common_lookup_type = 'DEBIT'
                   	THEN t.transaction_amount
                   	ELSE t.transaction_amount * -1
                END
             END),'99,999.00'),10,' ') AS "DECEMBER"
,	LPAD(TO_CHAR
        (SUM(CASE
		WHEN EXTRACT(MONTH FROM transaction_date) IN (10, 11, 12)
		AND EXTRACT(YEAR FROM transaction_date) = 2009 
	     THEN
             	CASE
                	WHEN cl.common_lookup_type = 'DEBIT'
                   	THEN t.transaction_amount
                   	ELSE t.transaction_amount * -1
                END
             END),'99,999.00'),10,' ') AS "F4Q"
,	LPAD(TO_CHAR
        (SUM(CASE
		WHEN EXTRACT(MONTH FROM transaction_date) IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
		AND EXTRACT(YEAR FROM transaction_date) = 2009 
	     THEN
             	CASE
                	WHEN cl.common_lookup_type = 'DEBIT'
                   	THEN t.transaction_amount
                   	ELSE t.transaction_amount * -1
                END
             END),'99,999.00'),10,' ') AS "YTD"
FROM	transaction t INNER JOIN common_lookup cl
ON      t.transaction_type = cl.common_lookup_id 
WHERE   cl.common_lookup_table = 'TRANSACTION'
AND     cl.common_lookup_column = 'TRANSACTION_TYPE' 
GROUP BY CASE
		WHEN t.transaction_account = '111-111-111-111' 
		THEN 'Debit'
           	WHEN t.transaction_account = '222-222-222-222' 
		THEN 'Credit'
         END
,        CASE
           	WHEN t.transaction_account = '111-111-111-111' 
		THEN 1
           	WHEN t.transaction_account = '222-222-222-222' 
		THEN 2
         END
UNION ALL
SELECT    'TOTAL' AS "TRANSACTION_ACCOUNT"
, 3 AS "sortkey"
,	LPAD(TO_CHAR
        (SUM(CASE
		WHEN EXTRACT(MONTH FROM transaction_date) = 1 
		AND EXTRACT(YEAR FROM transaction_date) = 2009 
	     THEN
             	CASE
                	WHEN cl.common_lookup_type = 'DEBIT'
                   	THEN t.transaction_amount
                   	ELSE t.transaction_amount * -1
                END
             END),'99,999.00'),10,' ') AS "JANUARY"
,	LPAD(TO_CHAR
        (SUM(CASE
		WHEN EXTRACT(MONTH FROM transaction_date) = 2 
		AND EXTRACT(YEAR FROM transaction_date) = 2009 
	     THEN
             	CASE
                	WHEN cl.common_lookup_type = 'DEBIT'
                   	THEN t.transaction_amount
                   	ELSE t.transaction_amount * -1
                END
             END),'99,999.00'),10,' ') AS "FEBRUARY"
,	LPAD(TO_CHAR
        (SUM(CASE
		WHEN EXTRACT(MONTH FROM transaction_date) = 3 
		AND EXTRACT(YEAR FROM transaction_date) = 2009 
	     THEN
             	CASE
                	WHEN cl.common_lookup_type = 'DEBIT'
                   	THEN t.transaction_amount
                   	ELSE t.transaction_amount * -1
                END
             END),'99,999.00'),10,' ') AS "MARCH"
,	LPAD(TO_CHAR
        (SUM(CASE
		WHEN EXTRACT(MONTH FROM transaction_date) IN (1, 2, 3) 
		AND EXTRACT(YEAR FROM transaction_date) = 2009 
	     THEN
             	CASE
                	WHEN cl.common_lookup_type = 'DEBIT'
                   	THEN t.transaction_amount
                   	ELSE t.transaction_amount * -1
                END
             END),'99,999.00'),10,' ') AS "F1Q"
,	LPAD(TO_CHAR
        (SUM(CASE
		WHEN EXTRACT(MONTH FROM transaction_date) = 4 
		AND EXTRACT(YEAR FROM transaction_date) = 2009 
	     THEN
             	CASE
                	WHEN cl.common_lookup_type = 'DEBIT'
                   	THEN t.transaction_amount
                   	ELSE t.transaction_amount * -1
                END
             END),'99,999.00'),10,' ') AS "APRIL"
,	LPAD(TO_CHAR
        (SUM(CASE
		WHEN EXTRACT(MONTH FROM transaction_date) = 5 
		AND EXTRACT(YEAR FROM transaction_date) = 2009 
	     THEN
             	CASE
                	WHEN cl.common_lookup_type = 'DEBIT'
                   	THEN t.transaction_amount
                   	ELSE t.transaction_amount * -1
                END
             END),'99,999.00'),10,' ') AS "MAY"
,	LPAD(TO_CHAR
        (SUM(CASE
		WHEN EXTRACT(MONTH FROM transaction_date) = 6 
		AND EXTRACT(YEAR FROM transaction_date) = 2009 
	     THEN
             	CASE
                	WHEN cl.common_lookup_type = 'DEBIT'
                   	THEN t.transaction_amount
                   	ELSE t.transaction_amount * -1
                END
             END),'99,999.00'),10,' ') AS "JUNE"
,	LPAD(TO_CHAR
        (SUM(CASE
		WHEN EXTRACT(MONTH FROM transaction_date) IN (4, 5, 6) 
		AND EXTRACT(YEAR FROM transaction_date) = 2009 
	     THEN
             	CASE
                	WHEN cl.common_lookup_type = 'DEBIT'
                   	THEN t.transaction_amount
                   	ELSE t.transaction_amount * -1
                END
             END),'99,999.00'),10,' ') AS "F2Q"
,	LPAD(TO_CHAR
        (SUM(CASE
		WHEN EXTRACT(MONTH FROM transaction_date) = 7 
		AND EXTRACT(YEAR FROM transaction_date) = 2009 
	     THEN
             	CASE
                	WHEN cl.common_lookup_type = 'DEBIT'
                   	THEN t.transaction_amount
                   	ELSE t.transaction_amount * -1
                END
             END),'99,999.00'),10,' ') AS "JULY"
,	LPAD(TO_CHAR
        (SUM(CASE
		WHEN EXTRACT(MONTH FROM transaction_date) = 8 
		AND EXTRACT(YEAR FROM transaction_date) = 2009 
	     THEN
             	CASE
                	WHEN cl.common_lookup_type = 'DEBIT'
                   	THEN t.transaction_amount
                   	ELSE t.transaction_amount * -1
                END
             END),'99,999.00'),10,' ') AS "AUGUST"
,	LPAD(TO_CHAR
        (SUM(CASE
		WHEN EXTRACT(MONTH FROM transaction_date) = 9 
		AND EXTRACT(YEAR FROM transaction_date) = 2009 
	     THEN
             	CASE
                	WHEN cl.common_lookup_type = 'DEBIT'
                   	THEN t.transaction_amount
                   	ELSE t.transaction_amount * -1
                END
             END),'99,999.00'),10,' ') AS "SEPTEMBER"
,	LPAD(TO_CHAR
        (SUM(CASE
		WHEN EXTRACT(MONTH FROM transaction_date) IN (7, 8, 9)
		AND EXTRACT(YEAR FROM transaction_date) = 2009 
	     THEN
             	CASE
                	WHEN cl.common_lookup_type = 'DEBIT'
                   	THEN t.transaction_amount
                   	ELSE t.transaction_amount * -1
                END
             END),'99,999.00'),10,' ') AS "F3Q"
,	LPAD(TO_CHAR
        (SUM(CASE
		WHEN EXTRACT(MONTH FROM transaction_date) = 10
		AND EXTRACT(YEAR FROM transaction_date) = 2009 
	     THEN
             	CASE
                	WHEN cl.common_lookup_type = 'DEBIT'
                   	THEN t.transaction_amount
                   	ELSE t.transaction_amount * -1
                END
             END),'99,999.00'),10,' ') AS "OCTOBER"
,	LPAD(TO_CHAR
        (SUM(CASE
		WHEN EXTRACT(MONTH FROM transaction_date) = 11
		AND EXTRACT(YEAR FROM transaction_date) = 2009 
	     THEN
             	CASE
                	WHEN cl.common_lookup_type = 'DEBIT'
                   	THEN t.transaction_amount
                   	ELSE t.transaction_amount * -1
                END
             END),'99,999.00'),10,' ') AS "NOVEMBER"
,	LPAD(TO_CHAR
        (SUM(CASE
		WHEN EXTRACT(MONTH FROM transaction_date) = 12 
		AND EXTRACT(YEAR FROM transaction_date) = 2009 
	     THEN
             	CASE
                	WHEN cl.common_lookup_type = 'DEBIT'
                   	THEN t.transaction_amount
                   	ELSE t.transaction_amount * -1
                END
             END),'99,999.00'),10,' ') AS "DECEMBER"
,	LPAD(TO_CHAR
        (SUM(CASE
		WHEN EXTRACT(MONTH FROM transaction_date) IN (10, 11, 12)
		AND EXTRACT(YEAR FROM transaction_date) = 2009 
	     THEN
             	CASE
                	WHEN cl.common_lookup_type = 'DEBIT'
                   	THEN t.transaction_amount
                   	ELSE t.transaction_amount * -1
                END
             END),'99,999.00'),10,' ') AS "F4Q"
,	LPAD(TO_CHAR
        (SUM(CASE
		WHEN EXTRACT(MONTH FROM transaction_date) IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
		AND EXTRACT(YEAR FROM transaction_date) = 2009 
	     THEN
             	CASE
                	WHEN cl.common_lookup_type = 'DEBIT'
                   	THEN t.transaction_amount
                   	ELSE t.transaction_amount * -1
                END
             END),'99,999.00'),10,' ') AS "YTD"
FROM	transaction t INNER JOIN common_lookup cl
ON      t.transaction_type = cl.common_lookup_id 
WHERE   cl.common_lookup_table = 'TRANSACTION'
AND     cl.common_lookup_column = 'TRANSACTION_TYPE' 
ORDER BY 2);

SPOOL OFF
