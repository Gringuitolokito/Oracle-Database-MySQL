--This calls Lab #9, Lab #9 calls Lab #8, Lab #8 calls Lab #7, Lab #7 calls Lab #6,---
--Lab #6 calls Lab #5, and Lab #5 calls both the Creation and Seed script files.------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--Call lab 9 in order to run lab 11---------------------------------------------------
@../lab9/apply_oracle_lab9.sql
 -------------------------------------------------------------------------------------
--Create text file--------------------------------------------------------------------
--------------------------------------------------------------------------------------
SPOOL apply_oracle_lab11.txt
--------------------------------------------------------------------------------------
SET PAGESIZE 99
SET linesize 999
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--Step 1
--------------------------------------------------------------------------------------
MERGE INTO rental target
USING ( 
SELECT 		DISTINCT 
		r.rental_id		AS RENTAL_ID
,		c.contact_id		AS CUSTOMER_ID
,		tu.check_out_date	AS CHECK_OUT_DATE
,		tu.return_date		AS RETURN_DATE
, 		1			AS CREATED_BY
, 		TRUNC(SYSDATE)		AS CREATION_DATE
, 		1			AS LAST_UPDATED_BY
, 		TRUNC(SYSDATE)		AS LAST_UPDATE_DATE
FROM		member m INNER JOIN contact c
ON		m.member_id = c.member_id INNER JOIN transaction_upload tu
ON		m.account_number = tu.account_number
AND		c.first_name = tu.first_name
AND		NVL(c.middle_name, 'x') = NVL(tu.middle_name, 'x')
AND		c.last_name = tu.last_name 
AND		tu.account_number = m.account_number LEFT JOIN rental r
ON		c.contact_id = r.customer_id		
AND		TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
AND		TRUNC(tu.return_date) = TRUNC(r.return_date)
 ) source
ON (target.rental_id = source.rental_id)
WHEN MATCHED THEN
UPDATE SET last_updated_by = SOURCE.last_updated_by
,          last_update_date = SOURCE.last_update_date
WHEN NOT MATCHED THEN
INSERT VALUES
( rental_s1.nextval
, source.customer_id
, source.check_out_date
, source.return_date
, source.created_by
, source.creation_date
, source.last_updated_by
, source.last_update_date);
-----------------------------------------------------------------------------------------------
--Verify Step 1
-----------------------------------------------------------------------------------------------
SELECT   TO_CHAR(COUNT(*),'99,999') AS "Rental After Merge"
FROM     rental;
-----------------------------------------------------------------------------------------------
--Step 2
-----------------------------------------------------------------------------------------------
-- Incorporate the query developed in Lab #10 into a MERGE statement into the RENTAL_ITEM table.
------------------------------------------------------------------------------------------------
MERGE INTO rental_item target
USING ( 
SELECT rental_item_id
,r.rental_id
,tu.item_id
,TRUNC(r.return_date) - TRUNC(r.check_out_date)	AS rental_item_price
,cl.common_lookup_id AS rental_item_type
,1 AS created_by
,TRUNC(SYSDATE)	AS creation_date
,1 AS last_updated_by
,TRUNC(SYSDATE)	AS last_update_date
FROM member m INNER JOIN contact c
ON m.member_id = c.member_id INNER JOIN transaction_upload tu
ON m.account_number = tu.account_number
AND c.first_name = tu.first_name
AND NVL(c.middle_name, 'x') = NVL(tu.middle_name, 'x')
AND c.last_name = tu.last_name 
AND tu.account_number = m.account_number LEFT JOIN rental r
ON c.contact_id = r.customer_id		
AND TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
AND TRUNC(tu.return_date) = TRUNC(r.return_date) INNER JOIN common_lookup cl
ON cl.common_lookup_table = 'RENTAL_ITEM'
AND cl.common_lookup_column = 'RENTAL_ITEM_TYPE'
AND cl.common_lookup_type = tu.rental_item_type LEFT JOIN rental_item ri
ON r.rental_id = ri.rental_id
) source
ON (target.rental_item_id = source.rental_item_id)
WHEN MATCHED THEN
UPDATE SET last_updated_by = SOURCE.last_updated_by
,last_update_date = SOURCE.last_update_date
WHEN NOT MATCHED THEN
INSERT VALUES
(rental_item_s1.nextval
,source.rental_id
,source.item_id
,source.created_by
,source.creation_date
,source.last_updated_by
,source.last_update_date
,source.rental_item_type
,source.rental_item_price);
----------------------------------------------------------------------------------------------
--Verify Step 2
----------------------------------------------------------------------------------------------
SELECT   TO_CHAR(COUNT(*),'99,999') AS "Rental Item After Merge"
FROM     rental_item;
-----------------------------------------------------------------------------------------------
--Step 3
-----------------------------------------------------------------------------------------------
-- Incorporate the query developed in Lab #10 into a MERGE statement into the TRANSACTION table.
------------------------------------------------------------------------------------------------
MERGE INTO transaction target
USING ( 
SELECT t.transaction_id
,tu.payment_account_number AS transaction_account
,cl1.common_lookup_id AS transaction_type
,tu.transaction_date
,(SUM(tu.transaction_amount) / 1.06) AS transaction_amount
,r.rental_id
,cl2.common_lookup_id AS payment_method_type
,m.credit_card_number AS payment_account_number
,1 AS created_by
,TRUNC(SYSDATE) AS creation_date
,1 AS last_updated_by
,TRUNC(SYSDATE)	AS last_update_date
FROM member m INNER JOIN contact c
ON m.member_id = c.member_id INNER JOIN transaction_upload tu
ON m.account_number = tu.account_number
AND c.first_name = tu.first_name
AND NVL(c.middle_name, 'x') = NVL(tu.middle_name, 'x')
AND c.last_name = tu.last_name INNER JOIN rental r
ON c.contact_id = r.customer_id		
AND TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
AND TRUNC(tu.return_date) = TRUNC(r.return_date) INNER JOIN common_lookup cl1
ON cl1.common_lookup_table = 'TRANSACTION'
AND cl1.common_lookup_column = 'TRANSACTION_TYPE'
AND cl1.common_lookup_type = tu.transaction_type INNER JOIN common_lookup cl2
ON cl2.common_lookup_table = 'TRANSACTION'
AND cl2.common_lookup_column = 'PAYMENT_METHOD_TYPE'
AND cl2.common_lookup_type = tu.payment_method_type LEFT JOIN transaction t
ON t.rental_id = r.rental_id
AND t.transaction_type = cl1.common_lookup_id
AND t.transaction_date = tu.transaction_date
AND t.payment_method_type = cl2.common_lookup_id
AND t.payment_account_number = m.credit_card_number 
AND t.transaction_account = tu.payment_account_number
GROUP BY t.transaction_id
,tu.payment_account_number
,cl1.common_lookup_id
,tu.transaction_date
,r.rental_id
,cl2.common_lookup_id
,m.credit_card_number
,1
,TRUNC(SYSDATE)
,1
,TRUNC(SYSDATE)
) source
ON (target.transaction_id = source.transaction_id)
WHEN MATCHED THEN
UPDATE SET last_updated_by = SOURCE.last_updated_by
,last_update_date = SOURCE.last_update_date
WHEN NOT MATCHED THEN
INSERT VALUES
(transaction_s1.NEXTVAL
,source.transaction_account
,source.transaction_type
,source.transaction_date
,source.transaction_amount
,source.rental_id
,source.payment_method_type
,source.payment_account_number
,source.created_by
,source.creation_date
,source.last_updated_by
,source.last_update_date);
----------------------------------------------------------------
--Verify step 3
----------------------------------------------------------------
SELECT TO_CHAR(COUNT(*),'99,999') AS "Transaction After Merge"
FROM transaction;
----------------------------------------------------------------
--Step 4
----------------------------------------------------------------
CREATE OR REPLACE PROCEDURE upload_transaction IS 
BEGIN
  -- Set save point for an all or nothing transaction.
  SAVEPOINT starting_point;
 
  -- Merge into RENTAL table.
  MERGE INTO rental target
	USING ( 
	SELECT 		DISTINCT 
			r.rental_id		AS RENTAL_ID
	,		c.contact_id		AS CUSTOMER_ID
	,		tu.check_out_date	AS CHECK_OUT_DATE
	,		tu.return_date		AS RETURN_DATE
	, 		1			AS CREATED_BY
	, 		TRUNC(SYSDATE)		AS CREATION_DATE
	, 		1			AS LAST_UPDATED_BY
	, 		TRUNC(SYSDATE)		AS LAST_UPDATE_DATE
	FROM		member m INNER JOIN contact c
	ON		m.member_id = c.member_id INNER JOIN transaction_upload tu
	ON		m.account_number = tu.account_number
	AND		c.first_name = tu.first_name
	AND		NVL(c.middle_name, 'x') = NVL(tu.middle_name, 'x')
	AND		c.last_name = tu.last_name 
	AND		tu.account_number = m.account_number LEFT JOIN rental r
	ON		c.contact_id = r.customer_id		
	AND		TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
	AND		TRUNC(tu.return_date) = TRUNC(r.return_date)
 	) source
	ON (target.rental_id = source.rental_id)
	WHEN MATCHED THEN
	UPDATE SET last_updated_by = SOURCE.last_updated_by
	,          last_update_date = SOURCE.last_update_date
	WHEN NOT MATCHED THEN
	INSERT VALUES
	( rental_s1.nextval
	, source.customer_id
	, source.check_out_date
	, source.return_date
	, source.created_by
	, source.creation_date
	, source.last_updated_by
	, source.last_update_date);
--------------------------------
-- Merge into RENTAL_ITEM table.
MERGE INTO rental_item target
USING ( 
SELECT rental_item_id
,r.rental_id
,tu.item_id
,TRUNC(r.return_date) - TRUNC(r.check_out_date) AS rental_item_price
,cl.common_lookup_id AS rental_item_type
,1 AS created_by
,TRUNC(SYSDATE) AS creation_date
,1 AS last_updated_by
,TRUNC(SYSDATE) AS last_update_date
FROM member m INNER JOIN contact c
ON m.member_id = c.member_id INNER JOIN transaction_upload tu
ON m.account_number = tu.account_number
AND c.first_name = tu.first_name
AND NVL(c.middle_name, 'x') = NVL(tu.middle_name, 'x')
AND c.last_name = tu.last_name 
AND tu.account_number = m.account_number LEFT JOIN rental r
ON c.contact_id = r.customer_id		
AND TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
AND TRUNC(tu.return_date) = TRUNC(r.return_date) INNER JOIN common_lookup cl
ON cl.common_lookup_table = 'RENTAL_ITEM'
AND cl.common_lookup_column = 'RENTAL_ITEM_TYPE'
AND cl.common_lookup_type = tu.rental_item_type LEFT JOIN rental_item ri
ON r.rental_id = ri.rental_id
) source
ON (target.rental_item_id = source.rental_item_id)
WHEN MATCHED THEN
UPDATE SET last_updated_by = SOURCE.last_updated_by
,last_update_date = SOURCE.last_update_date
WHEN NOT MATCHED THEN
INSERT VALUES
(rental_item_s1.nextval
,source.rental_id
,source.item_id
,source.created_by
,source.creation_date
,source.last_updated_by
,source.last_update_date
,source.rental_item_type
,source.rental_item_price);
--------------------------------
-- Merge into TRANSACTION table.
MERGE INTO transaction target
USING ( 
SELECT t.transaction_id
,tu.payment_account_number AS transaction_account
,cl1.common_lookup_id AS transaction_type
,tu.transaction_date
,(SUM(tu.transaction_amount) / 1.06) AS transaction_amount
,r.rental_id
,cl2.common_lookup_id AS payment_method_type
,m.credit_card_number AS payment_account_number
,1 AS created_by
,TRUNC(SYSDATE) AS creation_date
,1 AS last_updated_by
,TRUNC(SYSDATE) AS last_update_date
	FROM		member m INNER JOIN contact c
	ON		m.member_id = c.member_id INNER JOIN transaction_upload tu
	ON		m.account_number = tu.account_number
	AND		c.first_name = tu.first_name
	AND		NVL(c.middle_name, 'x') = NVL(tu.middle_name, 'x')
	AND		c.last_name = tu.last_name INNER JOIN rental r
	ON		c.contact_id = r.customer_id		
	AND		TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
	AND		TRUNC(tu.return_date) = TRUNC(r.return_date) INNER JOIN common_lookup cl1
	ON		cl1.common_lookup_table = 'TRANSACTION'
	AND		cl1.common_lookup_column = 'TRANSACTION_TYPE'
	AND		cl1.common_lookup_type = tu.transaction_type INNER JOIN common_lookup cl2
	ON		cl2.common_lookup_table = 'TRANSACTION'
	AND		cl2.common_lookup_column = 'PAYMENT_METHOD_TYPE'
	AND		cl2.common_lookup_type	= tu.payment_method_type LEFT JOIN transaction t
	ON		t.rental_id = r.rental_id
	AND		t.transaction_type = cl1.common_lookup_id
	AND		t.transaction_date = tu.transaction_date
	AND		t.payment_method_type = cl2.common_lookup_id
	AND		t.payment_account_number = m.credit_card_number 
	AND		t.transaction_account = tu.payment_account_number
	GROUP BY	t.transaction_id
		,	tu.payment_account_number
		,	cl1.common_lookup_id
		,	tu.transaction_date
		,	r.rental_id
		,	cl2.common_lookup_id
		,	m.credit_card_number
		,	1
		,	TRUNC(SYSDATE)
		,	1
		,	TRUNC(SYSDATE)
	) source
	ON (target.transaction_id = source.transaction_id)
	WHEN MATCHED THEN
	UPDATE SET last_updated_by = SOURCE.last_updated_by
	,          last_update_date = SOURCE.last_update_date
	WHEN NOT MATCHED THEN
	INSERT VALUES
	( transaction_s1.NEXTVAL
	, source.transaction_account
	, source.transaction_type
	, source.transaction_date
	, source.transaction_amount
	, source.rental_id
	, source.payment_method_type
	, source.payment_account_number
	, source.created_by
	, source.creation_date
	, source.last_updated_by
	, source.last_update_date);
 
  -- Save the changes.
  COMMIT;
 
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK TO starting_point;
    RETURN;
END;
/
--------------------------------------------------------------------------
--Execute procedure
--------------------------------------------------------------------------
EXECUTE upload_transaction;
--------------------------------------------------------------------------
--Query the results from procedure
--------------------------------------------------------------------------
COLUMN rental_count      FORMAT 99,999 HEADING "Rental|Count"
COLUMN rental_item_count FORMAT 99,999 HEADING "Rental|Item|Count"
COLUMN transaction_count FORMAT 99,999 HEADING "Transaction|Count"
 
SELECT il1.rental_count
,il2.rental_item_count
,il3.transaction_count
FROM (SELECT COUNT(*) AS rental_count FROM rental) il1 CROSS JOIN
     (SELECT COUNT(*) AS rental_item_count FROM rental_item) il2 CROSS JOIN
     (SELECT COUNT(*) AS transaction_count FROM TRANSACTION) il3;
-------------------------------------------------------------------------
--Re-run the upload_transaction procedure.
-------------------------------------------------------------------------
EXECUTE upload_transaction;
-------------------------------------------------------------------------
--Query the results from procedure
-------------------------------------------------------------------------
COLUMN rental_count      FORMAT 99,999 HEADING "Rental|Count"
COLUMN rental_item_count FORMAT 99,999 HEADING "Rental|Item|Count"
COLUMN transaction_count FORMAT 99,999 HEADING "Transaction|Count"
 
SELECT   il1.rental_count
,        il2.rental_item_count
,        il3.transaction_count
FROM    (SELECT COUNT(*) AS rental_count FROM rental) il1 CROSS JOIN
        (SELECT COUNT(*) AS rental_item_count FROM rental_item) il2 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM TRANSACTION) il3;
-------------------------------------------------------------------------
--Step 5
-------------------------------------------------------------------------
-- Create a query that prints the following aggregated data set.
SELECT  st.month 
,st.base    	AS "BASE_REVENUE"
,st.perc110  	AS "10_PLUS"
,st.perc120  	AS "20_PLUS"
,st.perc10  	AS "10_PLUS_LESS_BASE"
,st.perc20  	AS "20_PLUS_LESS_BASE"
FROM   	(SELECT 	CONCAT(TO_CHAR(t.transaction_date, 'MON'), CONCAT('-', EXTRACT(YEAR FROM t.transaction_date))) AS month
,TO_CHAR(SUM(t.transaction_amount) , '$9,999,999.00') AS base
,TO_CHAR(SUM(t.transaction_amount) * 1.1, '$9,999,999.00') AS perc110
,TO_CHAR(SUM(t.transaction_amount) * 1.2, '$9,999,999.00') AS perc120
,TO_CHAR(SUM(t.transaction_amount) * 0.1, '$9,999,999.00') AS perc10
,TO_CHAR(SUM(t.transaction_amount) * 0.2, '$9,999,999.00') AS perc20
,EXTRACT(MONTH FROM t.transaction_date) AS sort
	       FROM transaction t
	       WHERE EXTRACT(YEAR FROM t.transaction_date) = 2009
	       GROUP BY CONCAT(TO_CHAR(t.transaction_date, 'MON'), CONCAT('-', EXTRACT(YEAR FROM t.transaction_date)))
,EXTRACT(MONTH FROM t.transaction_date)) st
ORDER BY st.sort;


SPOOL OFF
