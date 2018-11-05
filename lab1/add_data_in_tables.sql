/* Set the save point like a book mark sets a page number. If any part
   of the transaction fails, you return to this point by rolling back
   the parts that did complete. */
SAVEPOINT starting_place;
 
/* Insert into grandma table. */
INSERT INTO grandma
( grandma_id
, grandma_house
, grandma_name )
VALUES
( grandma_seq.NEXTVAL
,'Yellow'
,'Hazel');
 
/* Insert into tweetie_bird table. */
INSERT INTO tweetie_bird
( tweetie_bird_id 
, tweetie_bird_name
, grandma_id )
VALUES
( tweetie_bird_seq.NEXTVAL
,'Henry'
, grandma_seq.CURRVAL );
 
/* Query the joined results of the insert into two tables. */
COL grandma_house      FORMAT A14  HEADING "Grandma|House"
COL grandma_name       FORMAT A14  HEADING "Grandma|Name"
COL tweetie_bird_name  FORMAT A14  HEADING "Tweetie Bird|Name"
SELECT grandma_house
,      grandma_name
,      tweetie_bird_name
FROM   grandma g JOIN tweetie_bird tb ON g.grandma_id = tb.grandma_id;
