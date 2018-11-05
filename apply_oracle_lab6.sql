-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab5/apply_oracle_lab5.sql
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--open log file-----------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
SPOOL apply_oracle_lab6.txt
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Change the RENTAL_ITEM table by adding the RENTAL_ITEM_TYPE and RENTAL_ITEM_PRICE columns.
--------------------------------------------------------------------------------------------------
ALTER TABLE  rental_item
        ADD (rental_item_type NUMBER)
        ADD (rental_item_price NUMBER)
        ADD CONSTRAINT fk_rental_item_5 FOREIGN KEY(rental_item_type) REFERENCES common_lookup(common_lookup_id);
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Validate----------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
SET NULL ''
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
WHERE    table_name = 'RENTAL_ITEM'
ORDER BY 2;
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
-- Conditionally drop price table.----------------------------------------------------------------
--------------------------------------------------------------------------------------------------
BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'price') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE price CASCADE CONSTRAINTS';
  END LOOP;
END;
/
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Create the PRICE table one qualification using check constraint YN_PRICE------------------------
--------------------------------------------------------------------------------------------------
CREATE TABLE price
(  price_id           NUMBER        CONSTRAINT nn_price_1 NOT NULL
,  item_id            NUMBER        CONSTRAINT nn_price_2 NOT NULL
,  price_type         NUMBER
,  active_flag        VARCHAR2(1)   CONSTRAINT nn_price_3 NOT NULL
,  start_date         DATE          CONSTRAINT nn_price_4 NOT NULL
,  end_date           DATE
,  amount             NUMBER        CONSTRAINT nn_price_5 NOT NULL
,  created_by         NUMBER        CONSTRAINT nn_price_6 NOT NULL
,  creation_date      DATE          CONSTRAINT nn_price_7 NOT NULL
,  last_updated_by    NUMBER        CONSTRAINT nn_price_8 NOT NULL
,  last_update_date   DATE          CONSTRAINT nn_price_9 NOT NULL
,  CONSTRAINT         pk_price_1    PRIMARY KEY(price_id)
,  CONSTRAINT         fk_price_1    FOREIGN KEY(item_id) REFERENCES item(item_id)
,  CONSTRAINT         fk_price_2    FOREIGN KEY(price_type) REFERENCES common_lookup(common_lookup_id)
,  CONSTRAINT         fk_price_3    FOREIGN KEY(created_by) REFERENCES system_user(system_user_id)
,  CONSTRAINT         fk_price_4    FOREIGN KEY(last_updated_by) REFERENCES system_user(system_user_id)
,  CONSTRAINT         yn_price      CHECK (active_flag IN ('Y','N'))
);
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Validate----------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
SET NULL ''
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
WHERE    table_name = 'PRICE'
ORDER BY 2;
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Step 2 Constraint Validation--------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
COLUMN constraint_name   FORMAT A16
COLUMN search_condition  FORMAT A30
SELECT   uc.constraint_name
,        uc.search_condition
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
ON       uc.table_name = ucc.table_name
AND      uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = UPPER('price')
AND      ucc.column_name = UPPER('active_flag')
AND      uc.constraint_name = UPPER('yn_price')
AND      uc.constraint_type = 'C';
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Change the name of ITEM_RELEASE_DATE to RELEASE_DATE in ITEM table.-----------------------------
--------------------------------------------------------------------------------------------------
ALTER TABLE    item
  RENAME COLUMN  item_release_date TO release_date;
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Validate step 3a--------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
SET NULL ''
COLUMN TABLE_NAME   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   TABLE_NAME
,        column_id
,        column_name
,        CASE
           WHEN NULLABLE = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS NULLABLE
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    TABLE_NAME = 'ITEM'
ORDER BY 2;
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Step 3b Insert three new DVD releases into the ITEM table Using (TRUNC(SYSDATE) - 1)------------
--------------------------------------------------------------------------------------------------
INSERT INTO item
VALUES
(item_s1.nextval
,'43396-25467'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Tron'
,''
,'PG'
,(TRUNC(SYSDATE) - 1)
, 1
, SYSDATE
, 1
, SYSDATE
);

INSERT INTO item
VALUES
(item_s1.nextval
,'45496-253365'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Ender''s game'
,''
,'PG-13'
,(TRUNC(SYSDATE) - 1)
, 1
, SYSDATE
, 1
, SYSDATE
);

INSERT INTO item
VALUES
(item_s1.nextval
,'65477-423345'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Elysium'
,''
,'R'
,(TRUNC(SYSDATE) - 1)
, 1
, SYSDATE
, 1
, SYSDATE
);
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Validate----------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
SELECT   i.item_title
,        SYSDATE AS today
,        i.release_date
FROM     item i
WHERE   (SYSDATE - i.release_date) < 31;
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
-- Step 3c Insert a new row in the MEMBER table, and three new rows in the CONTACT, ADDRESS, STREET_ADDRESS, and TELEPHONE tables.
-- Rememer to check the seed_oracle_store_sql script's logic----------------------------------------------------------------------
-- .NEXTVAL for primary key, and .CURRVAL for foregign key.-----------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
-- Insert a new MEMBER row for the Potter family.

INSERT INTO member
VALUES
( member_s1.NEXTVAL
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_type = 'CUSTOMER')
, 'R11-514-39'
, '1111-1111-3333-1112'
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_context = 'MEMBER'
   AND common_lookup_type = 'VISA_CARD')
, 1
, SYSDATE
, 1
, SYSDATE);
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Insert a new CONTACT row for Harry Potter.
INSERT INTO contact
VALUES
( contact_s1.NEXTVAL
, member_s1.CURRVAL
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_context = 'CONTACT'
   AND common_lookup_type = 'CUSTOMER')
   , 'Harry'
   , ''
   , 'Potter'
   , 1
   , SYSDATE
   , 1
   , SYSDATE);
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Insert a new ADDRESS row for Harry Potter.
INSERT INTO address
VALUES
( address_s1.NEXTVAL
, contact_s1.CURRVAL
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_type = 'HOME')
, 'Provo'
, 'Utah'
, '83440'
, 1
, SYSDATE
, 1
, SYSDATE);
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
-- Insert a new STREET_ADDRESS row for Harry Potter.
INSERT INTO street_address
VALUES
( street_address_s1.NEXTVAL
, address_s1.CURRVAL
, '112 SE Westerland St'
, 1
, SYSDATE
, 1
, SYSDATE)
;
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Insert a new TELEPHONE row for Harry Potter.
INSERT INTO telephone
VALUES
( telephone_s1.NEXTVAL
, contact_s1.CURRVAL
, address_s1.CURRVAL
, (SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
, 'USA'
, '84604'
, '333-3333'
, 1, SYSDATE, 1, SYSDATE);

--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
-- Insert a new CONTACT row for Ginny Potter.
INSERT INTO contact
VALUES
( contact_s1.NEXTVAL
, member_s1.CURRVAL
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_context = 'CONTACT'
   AND common_lookup_type = 'CUSTOMER')
   , 'Ginny'
   , ''
   , 'Potter'
   , 1
   , SYSDATE
   , 1
   , SYSDATE);
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Insert a new ADDRESS row for Ginny Potter.
INSERT INTO address
VALUES
( address_s1.NEXTVAL
, contact_s1.CURRVAL
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_type = 'HOME')
, 'Provo'
, 'Utah'
, '83440'
, 1
, SYSDATE
, 1
, SYSDATE);
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Insert a new STREET_ADDRESS row for Ginny Potter.
INSERT INTO street_address
VALUES
( street_address_s1.NEXTVAL
, address_s1.CURRVAL
,'112 SE Westerland St'
, 1
, SYSDATE
, 1
, SYSDATE)
;
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
-- Insert a new TELEPHONE row for Ginny Potter.
INSERT INTO telephone
VALUES
( telephone_s1.NEXTVAL
, contact_s1.CURRVAL
, address_s1.CURRVAL
, (SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
, 'USA'
, '208'
, '111-111'
, 1, SYSDATE, 1, SYSDATE);

--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
---Insert a new CONTACT row for Lily Potter.
INSERT INTO contact
VALUES
( contact_s1.NEXTVAL
, member_s1.CURRVAL
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_context = 'CONTACT'
   AND common_lookup_type = 'CUSTOMER')
   , 'Lily'
   , 'Luna'
   , 'Potter'
   , 1
   , SYSDATE
   , 1
   , SYSDATE);
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
-- Insert a new ADDRESS row for Lily Potter.
INSERT INTO address
VALUES
( address_s1.NEXTVAL
, contact_s1.CURRVAL
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_type = 'HOME')
, 'Provo'
, 'Utah'
, '83440'
, 1
, SYSDATE
, 1
, SYSDATE);
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
-- Insert a new STREET_ADDRESS row for lily Potter.
INSERT INTO street_address
VALUES
( street_address_s1.NEXTVAL
, address_s1.CURRVAL
, '112 SE Westerland St'
, 1
, SYSDATE
, 1
, SYSDATE)
;
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
-- Insert a new TELEPHONE row for Lily Potter.
INSERT INTO telephone
VALUES
( telephone_s1.NEXTVAL
, contact_s1.CURRVAL
, address_s1.CURRVAL
, (SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
, 'USA'
, '208'
, '123-4555'
, 1, SYSDATE, 1, SYSDATE);
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Validate----------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
COLUMN full_name FORMAT A20
COLUMN city      FORMAT A10
COLUMN state     FORMAT A10
SELECT   c.last_name || ', ' || c.first_name AS full_name
,        a.city
,        a.state_province AS state
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN address a
ON       c.contact_id = a.contact_id INNER JOIN street_address sa
ON       a.address_id = sa.address_id INNER JOIN telephone t
ON       c.contact_id = t.contact_id
WHERE    c.last_name = 'Potter';
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Insert three new rows in the RENTAL and four new rows in the RENTAL_ITEM tables
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Insert Harry's rental
INSERT INTO rental
VALUES
( rental_s1.nextval
,(SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Potter'
  AND      first_name = 'Harry')
, SYSDATE
, (SYSDATE +1)
, 1
, SYSDATE
, 1
, SYSDATE);
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Insert Harry's rental item.
INSERT INTO rental_item
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Potter'
  AND      c.first_name = 'Harry')
,(SELECT   i.item_id
  FROM     item i
  ,        common_lookup cl
  WHERE    i.item_title = 'The Chronicles of Narnia'
  AND      i.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 1
, SYSDATE
, 1
, SYSDATE
, ''
, '')
;
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Insert Harry's rental item.
INSERT INTO rental_item
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Potter'
  AND      c.first_name = 'Harry')
,(SELECT   i.item_id
  FROM     item i
  ,        common_lookup cl
  WHERE    i.item_title = 'Ender''s game'
  AND      i.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 1
, SYSDATE
, 1
, SYSDATE
, ''
, '')
;
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Insert Ginny's rental
INSERT INTO rental
VALUES
( rental_s1.nextval
,(SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Potter'
  AND      first_name = 'Ginny')
, SYSDATE
, (SYSDATE +3)
, 1
, SYSDATE
, 1
, SYSDATE);
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Insert Ginny's rental item
INSERT INTO rental_item
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Potter'
  AND      c.first_name = 'Ginny')
,(SELECT   i.item_id
  FROM     item i
  ,        common_lookup cl
  WHERE    i.item_title = 'Tron'
  AND      i.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 1
, SYSDATE
, 1
, SYSDATE
, ''
, '')
;
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Insert Lily's rental
INSERT INTO rental
VALUES
( rental_s1.nextval
,(SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Potter'
  AND      first_name = 'Lily')
, SYSDATE
, (SYSDATE +5)
, 1
, SYSDATE
, 1
, SYSDATE);
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Insert Lily's rental item
INSERT INTO rental_item
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Potter'
  AND      c.first_name = 'Lily')
,(SELECT   i.item_id
  FROM     item i
  ,        common_lookup cl
  WHERE    i.item_title = 'Elysium'
  AND      i.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 1
, SYSDATE
, 1
, SYSDATE
, ''
, '')
;
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Validate----------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
COLUMN full_name   FORMAT A18
COLUMN rental_id   FORMAT 9999
COLUMN rental_days FORMAT A14
COLUMN rentals     FORMAT 9999
COLUMN items       FORMAT 9999
SELECT   c.last_name||', '||c.first_name||' '||c.middle_name AS full_name
,        r.rental_id
,       (r.return_date - r.check_out_date) || '-DAY RENTAL' AS rental_days
,        COUNT(DISTINCT r.rental_id) AS rentals
,        COUNT(ri.rental_item_id) AS items
FROM     rental r INNER JOIN rental_item ri
ON       r.rental_id = ri.rental_id INNER JOIN contact c
ON       r.customer_id = c.contact_id
WHERE   (SYSDATE - r.check_out_date) < 15
AND      c.last_name = 'Potter'
GROUP BY c.last_name||', '||c.first_name||' '||c.middle_name
,        r.rental_id
,       (r.return_date - r.check_out_date) || '-DAY RENTAL'
ORDER BY 2;
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Modify the design of the COMMON_LOOKUP table.---------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Drop the COMMON_LOOKUP_N1 and COMMON_LOOKUP_U2 indexes.
DROP INDEX COMMON_LOOKUP_N1;
DROP INDEX COMMON_LOOKUP_U2;
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Validation--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
COLUMN table_name FORMAT A14
COLUMN index_name FORMAT A20
SELECT   table_name
,        index_name
FROM     user_indexes
WHERE    table_name = 'COMMON_LOOKUP';
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Add three new columns to the COMMON_LOOKUP table.
ALTER TABLE common_lookup
ADD        (common_lookup_table VARCHAR2(30))
ADD        (common_lookup_column VARCHAR2(30))
ADD        (common_lookup_code VARCHAR2(30));
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Validate the addition of these columns
SET NULL ''
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
WHERE    table_name = 'COMMON_LOOKUP'
ORDER BY 2;
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Migrate data and populate (or seed) new columns with existing data.

UPDATE common_lookup
SET common_lookup_table = common_lookup_context
WHERE common_lookup_context !='MULTIPLE';

UPDATE common_lookup
SET common_lookup_table = 'ADDRESS'
WHERE common_lookup_context = 'MULTIPLE';

UPDATE common_lookup
SET common_lookup_column = CONCAT(common_lookup_context, '_TYPE')
WHERE common_lookup_table = 'MEMBER'
AND (common_lookup_type = 'INDIVIDUAL'
OR common_lookup_type = 'GROUP');

UPDATE common_lookup
SET common_lookup_column = 'CREDIT_CARD_TYPE'
WHERE common_lookup_type = 'VISA_CARD'
OR common_lookup_type = 'MASTER_CARD'
OR common_lookup_type = 'DISCOVER_CARD';

UPDATE common_lookup
SET common_lookup_column = 'ADDRESS_TYPE'
WHERE common_lookup_context = 'MULTIPLE';

UPDATE common_lookup
SET common_lookup_column = CONCAT(common_lookup_context, '_TYPE')
WHERE common_lookup_context != 'MEMBER'
OR common_lookup_type != 'MULTIPLE'
AND common_lookup_column != 'CREDIT_CARD_TYPE';

COLUMN common_lookup_context  FORMAT A14  HEADING "Common|Lookup Context"
COLUMN common_lookup_table    FORMAT A12  HEADING "Common|Lookup Table"
COLUMN common_lookup_column   FORMAT A18  HEADING "Common|Lookup Column"
COLUMN common_lookup_type     FORMAT A18  HEADING "Common|Lookup Type"
SELECT   common_lookup_context
,        common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
ORDER BY 1, 2, 3;
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Add 2 new rows to common_lookup table to support.
INSERT INTO common_lookup
SELECT common_lookup_s1.nextval,
       common_lookup_context,
       common_lookup_type,
       common_lookup_meaning,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       common_lookup_table,
       'NULL',
       common_lookup_code
FROM   common_lookup
WHERE  common_lookup_id = '1008';

INSERT INTO common_lookup
SELECT common_lookup_s1.nextval,
       common_lookup_context,
       common_lookup_type,
       common_lookup_meaning,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       common_lookup_table,
       'NULL',
       common_lookup_code
FROM   common_lookup
WHERE  common_lookup_id = '1009';
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Update the 4 remaining rows that have 'ADDRESS' in common_lookup_table
--------------------------------------------------------------------------------------------------
UPDATE common_lookup
SET common_lookup_table = 'TELEPHONE', common_lookup_column = 'TELEPHONE_TYPE'
WHERE common_lookup_column = 'NULL';

UPDATE common_lookup
SET common_lookup_column = 'ADDRESS_TYPE'
WHERE common_lookup_column = 'MULTIPLE_TYPE';
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Verification completion of the re-structuring of the COMMON_LOOKUP table.
--------------------------------------------------------------------------------------------------
SET NULL ''
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
WHERE    table_name = 'COMMON_LOOKUP'
ORDER BY 2;
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Validate the data that was inserted into the new structure
--------------------------------------------------------------------------------------------------
COLUMN common_lookup_table  FORMAT A20
COLUMN common_lookup_column FORMAT A20
COLUMN common_lookup_type   FORMAT A20
SELECT   common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
ORDER BY 1, 2, 3;
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Update foreign keys from telephone table in common_lookup table
--------------------------------------------------------------------------------------------------
UPDATE telephone t
SET t.telephone_type = (SELECT cl.common_lookup_id
                        FROM   common_lookup cl
                        WHERE  cl.common_lookup_column = 'TELEPHONE_TYPE'
                        AND    cl.common_lookup_type = 'WORK');

UPDATE telephone t
SET t.telephone_type = (SELECT cl.common_lookup_id
                        FROM   common_lookup cl
                        WHERE  cl.common_lookup_column = 'TELEPHONE_TYPE'
                        AND    cl.common_lookup_type = 'HOME');

--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Remove obsolete columns, apply not null constraints, and create a new unique index for the natural key of the COMMON_LOOKUP table.
ALTER TABLE common_lookup
DROP column common_lookup_context;

ALTER TABLE common_lookup
MODIFY      common_lookup_table VARCHAR2(30) NOT NULL;

ALTER TABLE common_lookup
MODIFY      common_lookup_column VARCHAR2(30) NOT NULL;
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Validate changes to common_lookup table.
SET NULL ''
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
WHERE    table_name = 'COMMON_LOOKUP'
ORDER BY 2;

--names NOT NULL constraints with the following query-----

COLUMN constraint_name   FORMAT A22  HEADING "Constraint Name"
COLUMN search_condition  FORMAT A36  HEADING "Search Condition" 
COLUMN constraint_type   FORMAT A10  HEADING "Constraint|Type"
SELECT   uc.constraint_name
,        uc.search_condition
,        uc.constraint_type
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
ON       uc.table_name = ucc.table_name
AND      uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = UPPER('common_lookup')
AND      uc.constraint_type IN (UPPER('c'),UPPER('p'))
ORDER BY uc.constraint_type DESC
,        uc.constraint_name;

--Create a unique index across the COMMON_LOOKUP_TABLE, COMMON_LOOKUP_COLUMN, and COMMON_LOOKUP_TYPE columns
CREATE INDEX common_lookup_u1
ON           common_lookup (common_lookup_table, common_lookup_column, common_lookup_type);

--Validate indexes
COLUMN sequence_name   FORMAT A22 HEADING "Sequence Name"
COLUMN column_position FORMAT 999 HEADING "Column|Position"
COLUMN column_name     FORMAT A22 HEADING "Column|Name"
SELECT   UI.index_name
,        uic.column_position
,        uic.column_name
FROM     user_indexes UI INNER JOIN user_ind_columns uic
ON       UI.index_name = uic.index_name
AND      UI.table_name = uic.table_name
WHERE    UI.table_name = UPPER('common_lookup')
ORDER BY UI.index_name
,        uic.column_position;

--Validation new common_lookup table, foreign keys and private keys
COLUMN common_lookup_table  FORMAT A14 HEADING "Common|Lookup Table"
COLUMN common_lookup_column FORMAT A14 HEADING "Common|Lookup Column"
COLUMN common_lookup_type   FORMAT A8  HEADING "Common|Lookup|Type"
COLUMN count_dependent      FORMAT 999 HEADING "Count of|Foreign|Keys"
COLUMN count_lookup         FORMAT 999 HEADING "Count of|Primary|Keys"
SELECT   cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
,        COUNT(a.address_id) AS count_dependent
,        COUNT(DISTINCT cl.common_lookup_table) AS count_lookup
FROM     address a RIGHT JOIN common_lookup cl
ON       a.address_type = cl.common_lookup_id
WHERE    cl.common_lookup_table = 'ADDRESS'
AND      cl.common_lookup_column = 'ADDRESS_TYPE'
AND      cl.common_lookup_type IN ('HOME','WORK')
GROUP BY cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
UNION
SELECT   cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
,        COUNT(t.telephone_id) AS count_dependent
,        COUNT(DISTINCT cl.common_lookup_table) AS count_lookup
FROM     telephone t RIGHT JOIN common_lookup cl
ON       t.telephone_type = cl.common_lookup_id
WHERE    cl.common_lookup_table = 'TELEPHONE'
AND      cl.common_lookup_column = 'TELEPHONE_TYPE'
AND      cl.common_lookup_type IN ('HOME','WORK')
GROUP BY cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type;

--close log file
SPOOL OFF
