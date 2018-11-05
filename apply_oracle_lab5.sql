-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lib/cleanup_oracle.sql
@/home/student/Data/cit225/oracle/lib2/create/create_oracle_store2.sql
@/home/student/Data/cit225/oracle/lib2/preseed/preseed_oracle_store.sql
@/home/student/Data/cit225/oracle/lib2/seed/seeding.sql
 
SPOOL apply_oracle_lab5.txt
 
------1a-------------------------------------------------------------------
SELECT   member_id
,        contact_id
FROM     member INNER JOIN contact 
USING(member_id);
------1b--------------------------------------------------------------------
SELECT   m.member_id,
         c.contact_id
FROM     member m, contact c
WHERE    m.member_id = c.member_id;
 -----1c--------------------------------------------------------------------
SELECT   contact_id
,        address_id
FROM     contact INNER JOIN address
USING(contact_id);
------1d--------------------------------------------------------------------
SELECT   c.contact_id,
         a.address_id
FROM     contact c, address a
WHERE    c.contact_id = a.contact_id;
------1e--------------------------------------------------------------------
SELECT   address_id
,        street_address_id
FROM     address INNER JOIN street_address
USING(address_id);
------1f--------------------------------------------------------------------
SELECT   ad.address_id,
         st.street_address_id
FROM     address ad, street_address st
WHERE    ad.address_id = st.address_id;
------1g----------------------------------------------------------------------
SELECT   contact_id
,        telephone_id
FROM     contact INNER JOIN telephone
USING(contact_id);
------1h----------------------------------------------------------------------
SELECT   c.contact_id,
         t.telephone_id
FROM     contact c, telephone t
WHERE    c.contact_id = t.contact_id;
------2a------------------------------------------------------------------------
SELECT   c.contact_id
,        s.system_user_id
FROM     contact c INNER JOIN system_user s
ON       c.created_by = s.system_user_id;
------2b--------------------------------------------------------------------------
SELECT   con.contact_id
,        sys.system_user_id
FROM     contact con, system_user sys
WHERE    con.created_by = sys.system_user_id;
------2c------------------------------------------------------------------------
SELECT   c.contact_id
,        s.system_user_id
FROM     contact c INNER JOIN system_user s
ON       c.last_updated_by = s.system_user_id;
------2d----------------------------------------------------------------------------
SELECT   con.contact_id
,        sys.system_user_id
FROM     contact con, system_user sys
WHERE    con.last_updated_by = sys.system_user_id;
------3a-----------------------------------------------------------------------------
COL system_user_id  FORMAT 999999  HEADING "System|User|ID #|--------|Table #1"
COL created_by      FORMAT 999999  HEADING "Created|By|ID #|--------|Table #1"
COL system_user_pk  FORMAT 999999  HEADING "System|User|ID #|--------|Table #2"

SELECT   su1.system_user_id
,        su2.created_by
,        su3.system_user_id AS system_user_pk
FROM     system_user su1 INNER JOIN system_user su2
ON       su1.system_user_id = su2.system_user_id
INNER JOIN system_user su3
ON su2.created_by = su3.system_user_id;
------3b--------------------------------------------------------------------------------
COL system_user_id   FORMAT 999999  HEADING "System|User|ID #|--------|Table #1"
COL last_updated_by  FORMAT 999999  HEADING "Last|Updated|By|ID #|--------|Table #1"
COL system_user_pk   FORMAT 999999  HEADING "System|User|ID #|--------|Table #2"

SELECT   su1.system_user_id
,        su2.last_updated_by
,        su3.system_user_id AS system_user_pk
FROM     system_user su1 INNER JOIN system_user su2
ON       su1.system_user_id = su2.system_user_id
INNER JOIN system_user su3
ON su2.last_updated_by = su3.system_user_id;
------3c-------------------------------------------------------------------------------
COL system_user_id             FORMAT 999999  HEADING "System|User|ID #|--------|Table #1"
COL system_user_name           FORMAT A8      HEADING "System|User|Name|--------|Table #1"
COL created_by                 FORMAT 999999  HEADING "System|User|ID #|--------|Table #2"
COL created_by_user_name       FORMAT A8      HEADING "System|User|Name|--------|Table #2"
COL last_updated_by            FORMAT 999999  HEADING "System|User|ID #|--------|Table #3"
COL last_updated_by_user_name     FORMAT A8      HEADING "System|User|Name|--------|Table #3"

SELECT su1.system_user_id
,      su1.system_user_name
,      su2.system_user_id AS created_by
,      su2.system_user_name AS created_by_user_name
,      su3.system_user_id AS last_updated_by
,      su3.system_user_name AS last_updated_by_user_name
FROM   system_user su1 INNER JOIN system_user su2
ON     su1.created_by = su2.system_user_id
INNER JOIN system_user su3
ON     su1.last_updated_by = su3.system_user_id;       
--------4--------------------------------------------------------------------------------
COL rental             FORMAT 999999  HEADING "Rental|Table|--------|Rental|ID#"
COL rental_rental      FORMAT 999999  HEADING "Rental|Item|Table|--------|Rental|ID#"
COL rental_item        FORMAT 999999  HEADING "Rental|Item|Table|--------|Item|ID#"
COL item               FORMAT 999999  HEADING "Item|Table|--------|Item|ID#"

SELECT r1.rental_id AS rental
,      ri.rental_id AS rental_rental
,      ri.item_id AS rental_item
,      i3.item_id AS item
FROM   rental r1 INNER JOIN rental_item ri
ON     r1.rental_id = ri.rental_id
INNER JOIN item i3
ON     ri.item_id = i3.item_id;   
ALTER TABLE rental DROP CONSTRAINT NN_RENTAL_3;
---------------------------------------------------------------------------------------
/* Conditionally drop non-equijoin sample tables. */
BEGIN
  FOR i IN (SELECT   object_name
            ,        object_type
            FROM     user_objects
            WHERE    object_name IN ('DEPARTMENT','DEPARTMENT_S'
                                  ,'EMPLOYEE','EMPLOYEE_S'
                                  ,'SALARY','SALARY_S')
            ORDER BY object_type) LOOP
    IF i.object_type = 'TABLE' THEN
      EXECUTE IMMEDIATE 'DROP '||i.object_type||' '||i.object_name||' CASCADE CONSTRAINTS';
    ELSIF i.object_type = 'SEQUENCE' THEN
      EXECUTE IMMEDIATE 'DROP '||i.object_type||' '||i.object_name;
    END IF;
  END LOOP;
END;
/
 
/* Create department table. */
CREATE TABLE department
( department_id    NUMBER  CONSTRAINT department_pk PRIMARY KEY
, department_name  VARCHAR2(20));
 
/* Create a department_s sequence. */
CREATE SEQUENCE department_s;
 
/* Create a salary table. */
CREATE TABLE salary
( salary_id             NUMBER  CONSTRAINT salary_pk   PRIMARY KEY
, effective_start_date  DATE    CONSTRAINT salary_nn1  NOT NULL
, effective_end_date    DATE
, salary                NUMBER  CONSTRAINT salary_nn2  NOT NULL);
 
/* Create a salary_s sequence. */
CREATE SEQUENCE salary_s;
 
/* Create an employee table. */
CREATE TABLE employee
( employee_id    NUMBER        CONSTRAINT employee_pk  PRIMARY KEY
, department_id  NUMBER        CONSTRAINT employee_nn1 NOT NULL
, salary_id      NUMBER        CONSTRAINT employee_nn2 NOT NULL
, first_name     VARCHAR2(20)  CONSTRAINT employee_nn3 NOT NULL
, last_name      VARCHAR2(20)  CONSTRAINT employee_nn4 NOT NULL
, CONSTRAINT employee_fk FOREIGN KEY(employee_id) REFERENCES employee(employee_id));
 
/* Create an employee_s sequence. */
CREATE SEQUENCE employee_s;
 
 
/* Create an anonymous program to insert data. */
SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
  /* Declare a collection of strings. */
  TYPE xname IS TABLE OF VARCHAR2(20);
 
  /* Declare a collection of numbers. */
  TYPE xsalary IS TABLE OF NUMBER;
 
  /* Local variable generated by a random foreign key. */
  lv_department_id  NUMBER;
  lv_salary_id      NUMBER;
 
  /* A collection of first names. */
  lv_first XNAME := xname('Ann','Abbey','Amanda','Archie','Antonio','Arnold'
                         ,'Barbara','Basil','Bernie','Beth','Brian','Bryce'
                         ,'Carl','Carrie','Charlie','Christine','Corneilus','Crystal'
                         ,'Dana','Darlene','Darren','Dave','Davi','Deidre'
                         ,'Eamonn','Eberhard','Ecaterina','Ebony','Elana','Eric'
                         ,'Fabian','Faith','Fernando','Farris','Fiana','Francesca'
                         ,'Gabe','Gayle','Geoffrey','Gertrude','Grayson','Guy'
                         ,'Harry','Harriet','Henry','Henrica','Herman','Hesper'
                         ,'Ian','Ida','Iggy','Iliana','Imogene','Issac'
                         ,'Jan','Jack','Jennifer','Jerry','Julian','June'
                         ,'Kacey','Karen','Kaitlyn','Keith','Kevin','Kyle'
                         ,'Laney','Lawrence','Leanne','Liam','Lois','Lynne'
                         ,'Marcel','Marcia','Mark','Meagan','Mina','Michael'
                         ,'Nancy','Naomi','Narcissa','Nasim','Nathaniel','Neal'
                         ,'Obadiah','Odelia','Ohanna','Olaf','Olive','Oscar'
                         ,'Paige','Palmer','Paris','Pascal','Patricia','Peter'
                         ,'Qadir','Qasim','Quaid','Quant','Quince','Quinn'
                         ,'Rachelle','Rafael','Raj','Randy','Ramona','Raven'
                         ,'Savina','Sadie','Sally','Samuel','Saul','Santino'
                         ,'Tabitha','Tami','Tanner','Thomas','Timothy','Tina'
                         ,'Ugo','Ululani','Umberto','Una','Urbi','Ursula'
                         ,'Val','Valerie','Valiant','Vanessa','Vaughn','Verna'
                         ,'Wade','Wagner','Walden','Wanda','Wendy','Wilhelmina'
                         ,'Xander','Xavier','Xena','Xerxes','Xia','Xylon'
                         ,'Yana','Yancy','Yasmina','Yasmine','Yepa','Yeva'
                         ,'Zacarias','Zach','Zahara','Zander','Zane');
 
  /* A collection of last names. */
  lv_last  XNAME := xname('Abernathy','Anderson','Baker','Barney'
                         ,'Christensen','Cafferty','Davis','Donaldson'
                         ,'Eckhart','Eidelman','Fern','Finkel','Frank','Frankel','Fromm'
                         ,'Garfield','Geary','Harvey','Hamilton','Harwood'
                         ,'Ibarguen','Imbezi','Lindblom','Lynstrom'
                         ,'Martel','McKay','McLellen','Nagata','Noonan','Nunes'
                         ,'O''Brien','Oakey','Patterson','Petersen','Pratel','Preston'
                         ,'Qian','Queen','Ricafort','Richards','Roberts','Robertson'
                         ,'Sampson','Simon','Tabacchi','Travis','Trevor','Tower'
                         ,'Ubel','Urie','Vassen','Vanderbosch'
                         ,'Wacha','Walcott','West','Worley','Xian','Xiang'
                         ,'Yackley','Yaguchi','Zarbarsky','Zambelli');
 
  /* A collection of department names. */
  lv_dept  XNAME := xname('Accounting','Operations','Sales','Factory','Manufacturing');
 
  /* A colleciton of possible salaries. */
  lv_salary  XSALARY := xsalary( 36000, 42000, 48000, 52000, 64000 );
 
  /* Define a local function. */
  FUNCTION random_foreign_key RETURN INTEGER IS
    /* Declare a return variable. */
    lv_return_value  NUMBER;
  BEGIN
    /* Select a random number between 1 and 5 and assign it to a local variable. */
    SELECT CASE
             WHEN num = 0 THEN 5 ELSE num
           END AS random_key
    INTO   lv_return_value
    FROM   (SELECT ROUND(dbms_random.VALUE(1,1000)/100/2,0) num FROM dual) il;
 
    /* Return the random number. */
    RETURN lv_return_value;
  END random_foreign_key;
 
BEGIN
  /* Insert departments. */
  FOR i IN 1..lv_dept.LAST LOOP
    INSERT INTO department
    ( department_id
    , department_name )
    VALUES
    ( department_s.NEXTVAL
    , lv_dept(i));
  END LOOP;
 
  /* Insert salary. */
  FOR i IN 1..lv_salary.LAST LOOP
    INSERT INTO salary
    ( salary_id
    , effective_start_date
    , salary )
    VALUES
    ( salary_s.NEXTVAL
    , TRUNC(SYSDATE) - 30
    , lv_salary(i));
  END LOOP;
 
  /* Insert random employees. */
  FOR i IN 1..lv_first.LAST LOOP
    FOR j IN 1..lv_last.LAST LOOP
      /* Assign a random values to a local variable. */
      lv_department_id := random_foreign_key;
      lv_salary_id := random_foreign_key;
 
      /* Insert values into the employee table. */
      INSERT INTO employee
      ( employee_id
      , department_id
      , salary_id
      , first_name
      , last_name )
      VALUES
      ( employee_s.NEXTVAL
      , lv_department_id
      , lv_salary_id
      , lv_first(i)
      , lv_last(j));   
    END LOOP;
  END LOOP;
 
  /* Commit the writes. */
  COMMIT;  
END;
/
------------------------------------------------------------------------------------------
SELECT   d.department_name
,        ROUND(AVG(s.salary),0) AS salary
FROM     employee e INNER JOIN department d
ON       e.department_id = d.department_id INNER JOIN salary s
ON       e.salary_id = s.salary_id
GROUP BY d.department_name
ORDER BY d.department_name;
-------------------------------------------------------------------------------------------
/* Conditionally drop the table. */
BEGIN
  FOR i IN (SELECT table_name
            FROM   user_tables
            WHERE  table_name = 'MOCK_CALENDAR') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE '||i.table_name||' CASCADE CONSTRAINTS';
  END LOOP;
END;
/
 
/* Create a mock_calendar table. */
CREATE TABLE mock_calendar
( short_month  VARCHAR2(3)
, long_month   VARCHAR2(9)
, start_date   DATE
, end_date     DATE );
 
/* Seed the table with 10 years of data. */
DECLARE
  /* Create local collection data types. */
  TYPE smonth IS TABLE OF VARCHAR2(3);
  TYPE lmonth IS TABLE OF VARCHAR2(9);
 
  /* Declare month arrays. */
  short_month SMONTH := smonth('JAN','FEB','MAR','APR','MAY','JUN'
                              ,'JUL','AUG','SEP','OCT','NOV','DEC');
  long_month  LMONTH := lmonth('January','February','March','April','May','June'
                              ,'July','August','September','October','November','December');
 
  /* Declare base dates. */
  start_date DATE := '01-JAN-15';
  end_date   DATE := '31-JAN-15';
 
  /* Declare years. */
  years      NUMBER := 4;
 
BEGIN
 
  /* Loop through years and months. */
  FOR i IN 1..years LOOP
    FOR j IN 1..short_month.COUNT LOOP
      INSERT INTO mock_calendar VALUES
      ( short_month(j)
      , long_month(j)
      , ADD_MONTHS(start_date,(j-1)+(12*(i-1)))
      , ADD_MONTHS(end_date,(j-1)+(12*(i-1))));
    END LOOP;
  END LOOP;
 
  /* Commit the records. */
  COMMIT;
END;
/
----------------------------------------------------------------------------------------
/* Set output parameters. */
SET PAGESIZE 16
 
/* Format column output. */
COL short_month FORMAT A5 HEADING "Short|Month"
COL long_month  FORMAT A9 HEADING "Long|Month"
COL start_date  FORMAT A9 HEADING "Start|Date"
COL end_date    FORMAT A9 HEADING "End|Date" 
 
/* Query the results from the table. */
SELECT * FROM mock_calendar;
--------------------------------------------------------------------------

SELECT   d.department_name
,        ROUND(AVG(s.salary),0) AS salary
FROM     employee e INNER JOIN department d
ON       e.department_id = d.department_id INNER JOIN salary s
ON       e.salary_id = s.salary_id
WHERE    NVL(s.effective_end_date, TRUNC(SYSDATE)) BETWEEN TRUNC(SYSDATE-60) AND TRUNC(SYSDATE)
GROUP BY d.department_name
ORDER BY d.department_name;

SPOOL OFF

