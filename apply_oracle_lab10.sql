-- This calls Lab #9, Lab #9 calls Lab #8, Lab #8 calls Lab #7, Lab #7 calls Lab #6, Lab #6 calls Lab #5, and Lab #5 calls both the Creation and Seed script files.
@../lab9/apply_oracle_lab9.sql
 
SPOOL apply_oracle_lab10.txt
----------------------------------------------
SET PAGESIZE 99
----------------------------------------------
-- Step1 SELECT contact_id from contact table.
----------------------------------------------
SELECT   DISTINCT c.contact_id
FROM     member m INNER JOIN transaction_upload tu
ON       m.account_number = tu.account_number INNER JOIN contact c
ON       m.member_id = c.member_id
WHERE    c.first_name = tu.first_name
AND      NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
AND      c.last_name = tu.last_name
ORDER BY c.contact_id;
-----------------
--Step 1a Verify.
-----------------
SELECT   COUNT(*)
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id;
-------------------------------------------------------------------------------------
-- Step 1b Check the join condition between the CONTACT and TRANSACTION_UPLOAD tables.
-------------------------------------------------------------------------------------- 
-- It should return 11,520 rows.
--------------------------------------------------------------------------------------
SELECT   COUNT(*)
FROM     contact c INNER JOIN transaction_upload tu
ON       c.first_name = tu.first_name
AND      NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
AND      c.last_name = tu.last_name;
-----------------------------------------------------------------------
-- Step 1c Check the join condition between both the MEMBER and CONTACT 
-- tables and the join of those two tables with TRANSACTION_UPLOAD table. 
-- This should return 11,520 rows.-------------------------------------
SELECT   COUNT(*)
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN transaction_upload tu
ON       c.first_name = tu.first_name
AND      NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
AND      c.last_name = tu.last_name
AND      m.account_number = tu.account_number;
--------------------------------
-- Step 1 First SELECT statement
--------------------------------
SET NULL '<Null>'
COLUMN rental_id        FORMAT 99999 HEADING "Rental|ID #"
COLUMN customer         FORMAT 99999 HEADING "Customer|ID #"
COLUMN check_out_date   FORMAT A9   HEADING "Check Out|Date"
COLUMN return_date      FORMAT A10  HEADING "Return|Date"
COLUMN created_by       FORMAT 99999 HEADING "Created|By"
COLUMN creation_date    FORMAT A10  HEADING "Creation|Date"
COLUMN last_updated_by  FORMAT 99999 HEADING "Last|Update|By"
COLUMN last_update_date FORMAT A10  HEADING "Last|Updated"
SELECT DISTINCT
   	r.rental_id AS rental_id
, 	c.contact_id AS customer_id
,	tu.check_out_date AS check_out_date
,	tu.return_date AS return_date
,       3 AS created_by
,       TRUNC(sysdate) AS creation_date
,       3 AS last_updated_by
,       TRUNC(sysdate) AS last_update_date
FROM  	member m INNER JOIN contact c
ON	m.member_id = c.member_id INNER JOIN transaction_upload tu
ON	c.first_name = tu.first_name
AND	NVL(c.middle_name, 'x') = NVL(tu.middle_name, 'x')
AND	c.last_name = tu.last_name
AND	tu.account_number = m.account_number LEFT JOIN rental r
ON	c.contact_id = r.customer_id
AND	tu.check_out_date = r.check_out_date
AND	tu.return_date = r.return_date;
---------------------------------------
-- Step 1 First SELECT statement verify.
---------------------------------------
SELECT   COUNT(*) AS "Rental before count"
FROM     rental;
-----------------------------------
-- Step 1 Inserts into rental table.
-----------------------------------
INSERT INTO rental
( rental_id
, customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
SELECT
  rental_s1.NEXTVAL
, alt.contact_id
, alt.check_out_date
, alt.return_date
, 1, SYSDATE, 1, SYSDATE
FROM    (SELECT DISTINCT
   	r.rental_id
, 	c.contact_id
,	tu.check_out_date
,	tu.return_date
FROM  	member m INNER JOIN contact c
ON	m.member_id = c.member_id INNER JOIN transaction_upload tu
ON	c.first_name = tu.first_name
AND	NVL(c.middle_name, 'x') = NVL(tu.middle_name, 'x')
AND	c.last_name = tu.last_name
AND	tu.account_number = m.account_number LEFT JOIN rental r
ON	c.contact_id = r.customer_id
AND	tu.check_out_date = r.check_out_date
AND	tu.return_date = r.return_date) alt;
-------------------------------------------------------------------
-- Step 1, Verification after inserting the records from the query,
-- You re-query a count from the rental table.---------------------
-------------------------------------------------------------------
SELECT   COUNT(*) AS "Rental after count"
FROM     rental;
 --------------------------------------
 -- Step 2, the second SELECT statement.
---------------------------------------
SET NULL '<Null>'
COLUMN rental_item_id     FORMAT 99999 HEADING "Rental|Item ID #"
COLUMN rental_id          FORMAT 99999 HEADING "Rental|ID #"
COLUMN item_id            FORMAT 99999 HEADING "Item|ID #"
COLUMN rental_item_price  FORMAT 99999 HEADING "Rental|Item|Price"
COLUMN rental_item_type   FORMAT 99999 HEADING "Rental|Item|Type"
SELECT   COUNT(*)
FROM    (SELECT   ri.rental_item_id
         ,        r.rental_id
         ,        tu.item_id
         ,        r.return_date - r.check_out_date AS rental_item_price
         ,        cl.common_lookup_id AS rental_item_type
         ,        3 AS created_by
         ,        TRUNC(SYSDATE) AS creation_date
         ,        3 AS last_updated_by
         ,        TRUNC(SYSDATE) AS last_update_date
         FROM     member m INNER JOIN contact c
         ON       m.member_id = c.member_id INNER JOIN transaction_upload tu
         ON       c.first_name = tu.first_name
         AND      NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
         AND      c.last_name = tu.last_name
         AND      tu.account_number = m.account_number LEFT JOIN rental r
         ON       c.contact_id = r.customer_id
         AND      TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
         AND      TRUNC(tu.return_date) = TRUNC(r.return_date) INNER JOIN common_lookup cl
         ON       cl.common_lookup_table = 'RENTAL_ITEM'
         AND      cl.common_lookup_column = 'RENTAL_ITEM_TYPE'
         AND      cl.common_lookup_type = tu.rental_item_type  LEFT JOIN rental_item ri
         ON       r.rental_id = ri.rental_id);

SELECT   COUNT(*) AS "Rental Item Before Count"
FROM     rental_item;

INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date
, rental_item_type
, rental_item_price)
SELECT rental_item_s1.NEXTVAL, r.rental_id, tu.item_id, 1, SYSDATE, 1, SYSDATE, cl.common_lookup_id AS rental_item_type, tu.transaction_amount
FROM member m
INNER JOIN contact c
ON c.member_id = m.member_id
INNER JOIN transaction_upload tu
ON((tu.account_number = m.account_number)
AND (tu.first_name = c.first_name)
AND (NVL(tu.middle_name, 'x') = NVL(c.middle_name, 'x'))
AND (tu.last_name = c.last_name))
LEFT JOIN rental r 
ON (r.check_out_date = tu.check_out_date)
AND (r.return_date = tu.return_date)
AND (c.contact_id = r.customer_id)
INNER JOIN common_lookup cl
ON ((tu.rental_item_type = cl.common_lookup_type)
AND (cl.common_lookup_column = 'RENTAL_ITEM_TYPE'))
LEFT JOIN rental_item ri
ON ((ri.rental_id = r.rental_id)
AND (ri.item_id = tu.item_id));

SELECT   COUNT(*) AS "Rental Item After Count"
FROM     rental_item;

-------------------------------
-- Step3 Third SELECT statement.
-------------------------------
SELECT COUNT(*)
FROM (
SELECT
  transaction_id
, tu.payment_account_number AS payment_account_number
, cl1.common_lookup_id AS transaction_type
, tu.transaction_date AS transaction_date
, sum(tu.transaction_amount)/1.06 AS transaction_amount
, r.rental_id
, cl2.common_lookup_id AS payment_method_type
, m.credit_card_number AS payment_account_number
FROM member m INNER JOIN contact c
ON m.member_id = c.member_id INNER JOIN transaction_upload tu
ON tu.account_number = m.account_number
AND tu.first_name = c.first_name
AND NVL(tu.middle_name, 'x') = NVL(c.middle_name, 'x')
AND tu.last_name = c.last_name INNER JOIN rental r
ON c.contact_id = r.customer_id
AND tu.check_out_date = r.check_out_date
AND tu.return_date = r.return_date INNER JOIN common_lookup cl1
ON cl1.common_lookup_table = 'TRANSACTION'
AND cl1.common_lookup_column = 'TRANSACTION_TYPE'
AND cl1.common_lookup_type = tu.transaction_type
INNER JOIN common_lookup cl2
ON cl2.common_lookup_table = 'TRANSACTION'
AND cl2.common_lookup_column = 'PAYMENT_METHOD_TYPE'
AND cl2.common_lookup_type = tu.payment_method_type 
LEFT JOIN transaction t
ON t.transaction_account = tu.payment_account_number
AND t.transaction_type = cl1.common_lookup_id
AND t.transaction_date = tu.transaction_date
AND t.transaction_amount = tu.transaction_amount
AND t.payment_method_type = cl2.common_lookup_id
AND t.payment_account_number = m.credit_card_number
GROUP BY
(t.transaction_id
, tu.payment_account_number
, cl1.common_lookup_id
, tu.transaction_date
, r.rental_id
, cl2.common_lookup_id
, m.credit_card_number));

INSERT INTO transaction
SELECT transaction_s1.NEXTVAL
, ni.transaction_account
, ni.transaction_type
, ni.transaction_date
, ni.transaction_amount
, ni.rental_id
, ni.payment_method_type
, ni.payment_account_number
, 1, SYSDATE, 1, SYSDATE
FROM
(SELECT
  transaction_id
, tu.payment_account_number AS transaction_account
, cl1.common_lookup_id AS transaction_type
, tu.transaction_date AS transaction_date
, sum(tu.transaction_amount)/1.06 AS transaction_amount
, r.rental_id
, cl2.common_lookup_id AS payment_method_type
, m.credit_card_number AS payment_account_number
FROM member m INNER JOIN contact c
ON m.member_id = c.member_id INNER JOIN transaction_upload tu
ON tu.account_number = m.account_number
AND tu.first_name = c.first_name
AND NVL(tu.middle_name, 'x') = NVL(c.middle_name, 'x')
AND tu.last_name = c.last_name INNER JOIN rental r
ON c.contact_id = r.customer_id
AND tu.check_out_date = r.check_out_date
AND tu.return_date = r.return_date INNER JOIN common_lookup cl1
ON cl1.common_lookup_table = 'TRANSACTION'
AND cl1.common_lookup_column = 'TRANSACTION_TYPE'
AND cl1.common_lookup_type = tu.transaction_type
INNER JOIN common_lookup cl2
ON cl2.common_lookup_table = 'TRANSACTION'
AND cl2.common_lookup_column = 'PAYMENT_METHOD_TYPE'
AND cl2.common_lookup_type = tu.payment_method_type 
LEFT JOIN transaction t
ON t.transaction_account = tu.payment_account_number
AND t.transaction_type = cl1.common_lookup_id
AND t.transaction_date = tu.transaction_date
AND t.transaction_amount = tu.transaction_amount
AND t.payment_method_type = cl2.common_lookup_id
AND t.payment_account_number = m.credit_card_number
GROUP BY
(t.transaction_id
, tu.payment_account_number
, cl1.common_lookup_id
, tu.transaction_date
, r.rental_id
, cl2.common_lookup_id
, m.credit_card_number)) ni;

COMMIT;
SPOOL OFF


