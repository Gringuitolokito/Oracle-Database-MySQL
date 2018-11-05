/* Conditionally drop the GRANDMA and TWEETIE_BIRD tables, and
   the GRANDMA_SEQ and TWEETIE_BIRD sequences. */
BEGIN
  FOR i IN (SELECT   object_name
            ,        object_type
            FROM     user_objects
            WHERE    object_name IN ('GRANDMA','GRANDMA_SEQ'
                                    ,'TWEETIE_BIRD','TWEETIE_BIRD_SEQ')
            ORDER BY object_type ) LOOP
    IF i.object_type = 'TABLE' THEN
      EXECUTE IMMEDIATE 'DROP TABLE '||i.object_name||' CASCADE CONSTRAINTS';
    ELSE
      EXECUTE IMMEDIATE 'DROP SEQUENCE '||i.object_name;
    END IF;
  END LOOP;
END;
/
 
/* Create the grandma table:
    - A natural key of grandma_house and grandma_name columns.
    - A surrogate and primary key column that uses the table name 
      plus _ID suffix.
    - A primary key constraint on the surrogate key column.
    - A uq_grandma unique index across the two natural key columns.
*/
CREATE TABLE GRANDMA
( grandma_id     NUMBER       CONSTRAINT pk_grandma    PRIMARY KEY
, grandma_house  VARCHAR2(30) CONSTRAINT nn_grandma_1  NOT NULL
, grandma_name   VARCHAR2(30) CONSTRAINT nn_grandma_2  NOT NULL
, CONSTRAINT uq_grandma       UNIQUE (grandma_house, grandma_name));
 
/* Create the grandma_seq sequence. */
CREATE SEQUENCE grandma_seq;
 
/* Create the tweetie_bird table with:
    - A natural key of tweetie_bird_house and tweetie_bird columns.
    - A surrogate and primary key column that uses the table name
    - plus an _ID suffix.
    - A primary key constraint on the surrogate key column.
    - A foreign key constraint on the grandma_id column of the grandma table.
    - A uq_tweetie_bird unique index across the two natural key columns.
*/
CREATE TABLE TWEETIE_BIRD
( tweetie_bird_id    NUMBER        CONSTRAINT tweetie_bird_nn1 NOT NULL
, tweetie_bird_name  VARCHAR2(30)  CONSTRAINT tweetie_bird_nn2 NOT NULL
, grandma_id         NUMBER        CONSTRAINT tweetie_bird_nn3 NOT NULL
, CONSTRAINT pk_tweetie_bird       PRIMARY KEY (tweetie_bird_id)
, CONSTRAINT fk_tweetie_bird       FOREIGN KEY (grandma_id)
  REFERENCES GRANDMA (GRANDMA_ID)
, CONSTRAINT uq_tweetie_bird       UNIQUE (tweetie_bird_name));
 
/* Create the tweetie_bird_seq sequence. */
CREATE SEQUENCE tweetie_bird_seq;
 
/* Verify that you successfully created the two tables by querying the
   data dictionary. The data dictionary stores information about all
   structures, like tables and constraints, that you create in any
   database. */
SELECT   table_name
FROM     user_tables
WHERE    table_name IN ('GRANDMA','TWEETIE_BIRD')
ORDER BY table_name;
