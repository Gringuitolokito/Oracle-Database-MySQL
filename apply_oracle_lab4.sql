-- ------------------------------------------------------------------
--  Program Name:   seeding.sql
--  Lab Assignment: N/A
--  Program Author: Michael McLaughlin
--  Creation Date:  30-Jan-2018
-- ------------------------------------------------------------------
--  Change Log:
-- ------------------------------------------------------------------
--  Change Date    Change Reason
-- -------------  ---------------------------------------------------
--  
-- ------------------------------------------------------------------
--  This seeds data in the video store model.
--   - Inserts the data in the rental table for 5 records and
--     then inserts 9 dependent records in a non-sequential 
--     order.
--   - A non-sequential order requires that you use subqueries
--     to discover the foreign key values for the inserts.
-- ------------------------------------------------------------------

@/home/student/Data/cit225/oracle/lab3/apply_oracle_lab3.sql
@/home/student/Data/cit225/oracle/lib2/seed/seeding.sql

@@group_account1_lab.sql
@@group_account2_lab.sql
@@group_account3_lab.sql
@@item_inserts_lab.sql
@@create_insert_contacts_lab.sql
@@individual_accounts_lab.sql
@@update_members_lab.sql
@@rental_inserts_lab.sql
@@create_view_lab.sql

SPOOL apply_oracle_lab4.txt

-- ------------------------------------------------------------------
--   Query to verify seven rows of chained inserts to the five
--   dependent tables.
-- ------------------------------------------------------------------
--    1. MEMBER
--    2. CONTACT
--    3. ADDRESS
--    4. STREET_ADDRESS
--    5. TELEPHONE
-- ------------------------------------------------------------------

INSERT INTO member_lab
( member_lab_id
, member_type
, account_number
, credit_card_number
, credit_card_type
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( member_lab_s1.nextval                               -- member_id
, NULL                                            -- member_type
,'B293-71445'                                     -- account_number
,'1111-2222-3333-4444'                            -- credit_card_number
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'MEMBER_LAB'
  AND      common_lookup_type = 'DISCOVER_CARD')  -- credit_card_type
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

-- ------------------------------------------------------------------
--  Insert first contact in a group account user.
-- ------------------------------------------------------------------
INSERT INTO contact_lab
( contact_lab_id
, member_lab_id
, contact_type
, first_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( contact_lab_s1.nextval                              -- contact_id
, member_lab_s1.currval                               -- member_id
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'CONTACT_LAB'
  AND      common_lookup_type = 'CUSTOMER')       -- contact_type
,'Randi'                                          -- first_name
,'Winn'                                           -- last_name
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

INSERT INTO address_lab
( address_lab_id
, contact_lab_id
, address_type
, city
, state_province
, postal_code
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( address_lab_s1.nextval                              -- address_id
, contact_lab_s1.currval                              -- contact_id
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'HOME')           -- address_type
,'San Jose'                                       -- city
,'CA'                                             -- state_province
,'95192'                                          -- postal_code
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

INSERT INTO street_address_lab
( street_address_lab_id
, address_lab_id
, street_address
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
( street_address_lab_s1.nextval                       -- street_address_id
, address_lab_s1.currval                              -- address_id
,'10 El Camino Real'                              -- street_address
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

INSERT INTO telephone_lab
( telephone_lab_id
, contact_lab_id
, address_lab_id
, telephone_type
, country_code
, area_code
, telephone_number
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
( telephone_lab_s1.nextval                            -- telephone_id
, address_lab_s1.currval                              -- address_id
, contact_lab_s1.currval                              -- contact_id
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'MULTIPLE'
  AND      common_lookup_type = 'HOME')           -- telephone_type
,'001'                                            -- country_code
,'408'                                            -- area_code
,'111-1111'                                       -- telephone_number
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

-- ------------------------------------------------------------------
--  Insert second contact in a group account user.
-- ------------------------------------------------------------------
INSERT INTO contact_lab
( contact_lab_id
, member_lab_id
, contact_type
, first_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( contact_lab_s1.nextval                              -- contact_id
, member_lab_s1.currval                               -- member_id
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'CONTACT_LAB'
  AND      common_lookup_type = 'CUSTOMER')       -- contact_type
,'Brian'                                          -- first_name
,'Winn'                                           -- last_name
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);


INSERT INTO address_lab
( address_lab_id
, contact_lab_id
, address_type
, city
, state_province
, postal_code
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( address_lab_s1.nextval                              -- address_id
, contact_lab_s1.currval                              -- contact_id
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'HOME')           -- address_type
,'San Jose'                                       -- city
,'CA'                                             -- state_province
,'95192'                                          -- postal_code
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

INSERT INTO street_address_lab
( street_address_lab_id
, address_lab_id
, street_address
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
( street_address_lab_s1.nextval                       -- street_address_id
, address_lab_s1.currval                              -- address_id
,'10 El Camino Real'                              -- street_address
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

INSERT INTO telephone_lab
( telephone_lab_id
, contact_lab_id
, address_lab_id
, telephone_type
, country_code
, area_code
, telephone_number
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
( telephone_lab_s1.nextval                            -- telephone_id
, address_lab_s1.currval                              -- address_id
, contact_lab_s1.currval                              -- contact_id
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'MULTIPLE'
  AND      common_lookup_type = 'HOME')           -- telephone_type
,'001'                                            -- country_code
,'408'                                            -- area_code
,'111-1111'                                       -- telephone_number
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);


INSERT INTO member_lab
( member_lab_id
, member_type
, account_number
, credit_card_number
, credit_card_type
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( member_lab_s1.nextval                               -- member_id
, NULL                                            -- member_type
,'B293-71446'                                     -- account_number
,'2222-3333-4444-5555'                            -- credit_card_number
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'MEMBER_LAB'
  AND      common_lookup_type = 'DISCOVER_CARD')  -- credit_card_type
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

-- ------------------------------------------------------------------
--  Insert first contact in a group account user.
-- ------------------------------------------------------------------
INSERT INTO contact_lab
( contact_lab_id
, member_lab_id
, contact_type
, first_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( contact_lab_s1.nextval                              -- contact_id
, member_lab_s1.currval                               -- member_id
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'CONTACT_LAB'
  AND      common_lookup_type = 'CUSTOMER')       -- contact_type
,'Oscar'                                          -- first_name
,'Vizquel'                                        -- last_name
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

INSERT INTO address_lab
( address_lab_id
, contact_lab_id
, address_type
, city
, state_province
, postal_code
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( address_lab_s1.nextval                              -- address_id
, contact_lab_s1.currval                              -- contact_id
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'HOME')           -- address_type
,'San Jose'                                       -- city
,'CA'                                             -- state_province
,'95192'                                          -- postal_code
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

INSERT INTO street_address_lab
( street_address_lab_id
, address_lab_id
, street_address
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
( street_address_lab_s1.nextval                       -- street_address_id
, address_lab_s1.currval                              -- address_id
,'12 El Camino Real'                              -- street_address
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

INSERT INTO telephone_lab
( telephone_lab_id
, contact_lab_id
, address_lab_id
, telephone_type
, country_code
, area_code
, telephone_number
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
( telephone_lab_s1.nextval                            -- telephone_id
, address_lab_s1.currval                              -- address_id
, contact_lab_s1.currval                              -- contact_id
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'MULTIPLE'
  AND      common_lookup_type = 'HOME')           -- telephone_type
,'USA'                                            -- country_code
,'408'                                            -- area_code
,'222-2222'                                       -- telephone_number
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

-- ------------------------------------------------------------------
--  Insert second contact in a group account user.
-- ------------------------------------------------------------------
INSERT INTO contact_lab
( contact_lab_id
, member_lab_id
, contact_type
, first_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( contact_lab_s1.nextval                              -- contact_id
, member_lab_s1.currval                               -- member_id
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'CONTACT_LAB'
  AND      common_lookup_type = 'CUSTOMER')       -- contact_type
,'Doreen'                                         -- first_name
,'Vizquel'                                        -- last_name
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);


INSERT INTO address_lab
( address_lab_id
, contact_lab_id
, address_type
, city
, state_province
, postal_code
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( address_lab_s1.nextval                              -- address_id
, contact_lab_s1.currval                              -- contact_id
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'HOME')           -- address_type
,'San Jose'                                       -- city
,'CA'                                             -- state_province
,'95192'                                          -- postal_code
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

INSERT INTO street_address_lab
( street_address_lab_id
, address_lab_id
, street_address
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
( street_address_lab_s1.nextval                       -- street_address_id
, address_lab_s1.currval                              -- address_id
,'12 El Camino Real'                              -- street_address
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

INSERT INTO telephone_lab
( telephone_lab_id
, contact_lab_id
, address_lab_id
, telephone_type
, country_code
, area_code
, telephone_number
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
( telephone_lab_s1.nextval                            -- telephone_id
, address_lab_s1.currval                              -- address_id
, contact_lab_s1.currval                              -- contact_id
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'MULTIPLE'
  AND      common_lookup_type = 'HOME')           -- telephone_type
,'USA'                                            -- country_code
,'408'                                            -- area_code
,'222-2222'                                       -- telephone_number
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);


INSERT INTO member_lab
( member_lab_id
, member_type
, account_number
, credit_card_number
, credit_card_type
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( member_lab_s1.nextval                               -- member_id
, NULL                                            -- member_type
,'B293-71447'                                     -- account_number
,'3333-4444-5555-6666'                            -- credit_card_number
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'MEMBER_LAB'
  AND      common_lookup_type = 'DISCOVER_CARD')  -- credit_card_type
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

-- ------------------------------------------------------------------
--  Insert first contact in a group account user.
-- ------------------------------------------------------------------
INSERT INTO contact_lab
( contact_lab_id
, member_lab_id
, contact_type
, first_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( contact_lab_s1.nextval                              -- contact_id
, member_lab_s1.currval                               -- member_id
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'CONTACT_LAB'
  AND      common_lookup_type = 'CUSTOMER')       -- contact_type
,'Meaghan'                                        -- first_name
,'Sweeney'                                        -- last_name
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

INSERT INTO address_lab
( address_lab_id
, contact_lab_id
, address_type
, city
, state_province
, postal_code
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( address_lab_s1.nextval                              -- address_id
, contact_lab_s1.currval                              -- contact_id
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'HOME')           -- address_type
,'San Jose'                                       -- city
,'CA'                                             -- state_province
,'95192'                                          -- postal_code
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

INSERT INTO street_address_lab
( street_address_lab_id
, address_lab_id
, street_address
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
( street_address_lab_s1.nextval                       -- street_address_id
, address_lab_s1.currval                              -- address_id
,'14 El Camino Real'                              -- street_address
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

INSERT INTO telephone_lab
( telephone_lab_id
, contact_lab_id
, address_lab_id
, telephone_type
, country_code
, area_code
, telephone_number
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
( telephone_lab_s1.nextval                            -- telephone_id
, address_lab_s1.currval                              -- address_id
, contact_lab_s1.currval                              -- contact_id
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'MULTIPLE'
  AND      common_lookup_type = 'HOME')           -- telephone_type
,'USA'                                            -- country_code
,'408'                                            -- area_code
,'333-3333'                                       -- telephone_number
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

-- ------------------------------------------------------------------
--  Insert second contact in a group account user.
-- ------------------------------------------------------------------
INSERT INTO contact_lab
( contact_lab_id
, member_lab_id
, contact_type
, first_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( contact_lab_s1.nextval                              -- contact_id
, member_lab_s1.currval                               -- member_id
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'CONTACT_LAB'
  AND      common_lookup_type = 'CUSTOMER')       -- contact_type
,'Matthew'                                         -- first_name
,'Sweeney'                                        -- last_name
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);


INSERT INTO address_lab
( address_lab_id
, contact_lab_id
, address_type
, city
, state_province
, postal_code
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( address_lab_s1.nextval                              -- address_id
, contact_lab_s1.currval                              -- contact_id
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'HOME')           -- address_type
,'San Jose'                                       -- city
,'CA'                                             -- state_province
,'95192'                                          -- postal_code
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

INSERT INTO street_address_lab
( street_address_lab_id
, address_lab_id
, street_address
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
( street_address_lab_s1.nextval                       -- street_address_id
, address_lab_s1.currval                              -- address_id
,'14 El Camino Real'                              -- street_address
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

INSERT INTO telephone_lab
( telephone_lab_id
, contact_lab_id
, address_lab_id
, telephone_type
, country_code
, area_code
, telephone_number
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
( telephone_lab_s1.nextval                            -- telephone_id
, address_lab_s1.currval                              -- address_id
, contact_lab_s1.currval                              -- contact_id
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'MULTIPLE'
  AND      common_lookup_type = 'HOME')           -- telephone_type
,'USA'                                            -- country_code
,'408'                                            -- area_code
,'333-3333'                                       -- telephone_number
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

-- ------------------------------------------------------------------
--  Insert third contact in a group account user.
-- ------------------------------------------------------------------
INSERT INTO contact_lab
( contact_lab_id
, member_lab_id
, contact_type
, first_name
, middle_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( contact_lab_s1.nextval                              -- contact_id
, member_lab_s1.currval                               -- member_id
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'CONTACT_LAB'
  AND      common_lookup_type = 'CUSTOMER')       -- contact_type
,'Ian'                                            -- first_name
,'M'                                              -- middle_name
,'Sweeney'                                        -- last_name
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);


INSERT INTO address_lab
( address_lab_id
, contact_lab_id
, address_type
, city
, state_province
, postal_code
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( address_lab_s1.nextval                              -- address_id
, contact_lab_s1.currval                              -- contact_id
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'HOME')           -- address_type
,'San Jose'                                       -- city
,'CA'                                             -- state_province
,'95192'                                          -- postal_code
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

INSERT INTO street_address_lab
( street_address_lab_id
, address_lab_id
, street_address
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
( street_address_lab_s1.nextval                       -- street_address_id
, address_lab_s1.currval                              -- address_id
,'14 El Camino Real'                              -- street_address
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

INSERT INTO telephone_lab
( telephone_lab_id
, contact_lab_id
, address_lab_id
, telephone_type
, country_code
, area_code
, telephone_number
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
( telephone_lab_s1.nextval                            -- telephone_id
, address_lab_s1.currval                              -- address_id
, contact_lab_s1.currval                              -- contact_id
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'MULTIPLE'
  AND      common_lookup_type = 'HOME')           -- telephone_type
,'USA'                                            -- country_code
,'408'                                            -- area_code
,'333-3333'                                       -- telephone_number
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

COL account_number  FORMAT A10  HEADING "Account|Number"
COL full_name       FORMAT A16  HEADING "Name|(Last, First MI)"
COL city            FORMAT A12  HEADING "City"
COL state_province  FORMAT A10  HEADING "State"
COL telephone       FORMAT A18  HEADING "Telephone"
SELECT   m.account_number
,        c.last_name || ', ' || c.first_name
||       CASE
           WHEN c.middle_name IS NOT NULL THEN ' ' || c.middle_name
         END AS full_name
,        a.city
,        a.state_province
,        t.country_code || '-(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM     member_lab m INNER JOIN contact_lab c ON m.member_lab_id = c.member_lab_id INNER JOIN
         address_lab a ON c.contact_lab_id = a.contact_lab_id INNER JOIN
         street_address sa ON a.address_lab_id = sa.address_id INNER JOIN
         telephone t ON c.contact_lab_id = t.contact_id AND a.address_lab_id = t.address_id
WHERE    c.last_name = 'Vizquel';

COL member_lab_id       FORMAT 9999 HEADING "Acct|ID #"
COL account_number  FORMAT A10  HEADING "Account|Number"
COL full_name       FORMAT A16  HEADING "Name|(Last, First MI)"
COL city            FORMAT A12  HEADING "City"
COL state_province  FORMAT A10  HEADING "State"
COL telephone       FORMAT A18  HEADING "Telephone"
SELECT   m.member_lab_id
,        m.account_number
,        c.last_name || ', ' || c.first_name
||       CASE
           WHEN c.middle_name IS NOT NULL THEN ' ' || SUBSTR(c.middle_name,1,1)
         END AS full_name
,        a.city
,        a.state_province
,        t.country_code || '-(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM     member_lab m INNER JOIN contact_lab c ON m.member_lab_id = c.member_lab_id INNER JOIN
         address_lab a ON c.contact_lab_id = a.contact_lab_id INNER JOIN
         street_address sa ON a.address_lab_id = sa.address_id INNER JOIN
         telephone t ON c.contact_lab_id = t.contact_id AND a.address_lab_id = t.address_id
WHERE    last_name IN ('Sweeney','Vizquel','Winn');

-- ------------------------------------------------------------------
--  Display the 21 inserts into the item table.
-- ------------------------------------------------------------------


INSERT INTO item_lab
( item_lab_id
, item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( item_lab_s1.nextval
,'9736-05640-4'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'ITEM_LAB'
  AND      common_lookup_type = 'DVD_WIDE_SCREEN')
,'The Hunt for Red October'
,'Special Collector''s Edition'
,'PG'
,'02-MAR-90'
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO item_lab 
( item_lab_id
, item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( item_lab_s1.nextval
,'24543-02392'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'ITEM_LAB'
  AND      common_lookup_type = 'DVD_WIDE_SCREEN')
,'Star Wars I'
,'Phantom Menace'
,'PG'
,'04-MAY-99'
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO item_lab 
( item_lab_id
, item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( item_lab_s1.nextval
,'24543-5615'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'ITEM_LAB'
  AND      common_lookup_type = 'DVD_FULL_SCREEN')
,'Star Wars II'
,'Attack of the Clones'
,'PG'
,'16-MAY-02'
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO item_lab 
( item_lab_id
, item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( item_lab_s1.nextval
,'24543-05539'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'ITEM_LAB'
  AND      common_lookup_type = 'DVD_WIDE_SCREEN')
,'Star Wars II'
,'Attack of the Clones'
,'PG'
,'16-MAY-02'
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO item_lab
( item_lab_id
, item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( item_lab_s1.nextval
,'24543-20309'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'ITEM_LAB'
  AND      common_lookup_type = 'DVD_WIDE_SCREEN')
,'Star Wars III'
,'Revenge of the Sith'
,'PG13'
,'19-MAY-05'
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO item_lab
( item_lab_id
, item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( item_lab_s1.nextval
,'86936-70380'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'ITEM_LAB'
  AND      common_lookup_type = 'DVD_WIDE_SCREEN')
,'The Chronicles of Narnia'
,'The Lion, the Witch and the Wardrobe','PG'
,'16-MAY-02'
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO item_lab
( item_lab_id
, item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( item_lab_s1.nextval
,'91493-06475'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'ITEM_LAB'
  AND      common_lookup_type = 'XBOX')
,'RoboCop'
,''
,'Mature'
,'24-JUL-03'
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO item_lab
( item_lab_id
, item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( item_lab_s1.nextval
,'93155-11810'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'ITEM_LAB'
  AND      common_lookup_type = 'XBOX')
,'Pirates of the Caribbean'
,''
,'Teen'
,'30-JUN-03'
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO item_lab
( item_lab_id
, item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( item_lab_s1.nextval
,'12725-00173'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'ITEM_LAB'
  AND      common_lookup_type = 'XBOX')
,'The Chronicles of Narnia'
,'The Lion, the Witch and the Wardrobe'
,'Everyone'
,'30-JUN-03'
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO item_lab
( item_lab_id
, item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( item_lab_s1.nextval
,'45496-96128'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'ITEM_LAB'
  AND      common_lookup_type = 'NINTENDO_GAMECUBE')
,'MarioKart'
,'Double Dash'
,'Everyone'
,'17-NOV-03'
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO item_lab
( item_lab_id
, item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( item_lab_s1.nextval
,'08888-32214'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'ITEM_LAB'
  AND      common_lookup_type = 'PLAYSTATION2')
,'Splinter Cell'
,'Chaos Theory'
,'Teen'
,'08-APR-03'
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO item_lab
( item_lab_id
, item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( item_lab_s1.nextval
,'14633-14821'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'ITEM_LAB'
  AND      common_lookup_type = 'PLAYSTATION2')
,'Need for Speed'
,'Most Wanted'
,'Everyone'
,'15-NOV-04'
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO item_lab
( item_lab_id
, item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( item_lab_s1.nextval
,'10425-29944'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'ITEM_LAB'
  AND      common_lookup_type = 'XBOX')
,'The DaVinci Code'
,''
,'Teen'
,'19-MAY-06'
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO item_lab
( item_lab_id
, item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( item_lab_s1.nextval
,'52919-52057'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'ITEM_LAB'
  AND      common_lookup_type = 'XBOX')
,'Cars'
,''
,'Everyone'
,'28-APR-06'
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO item_lab
( item_lab_id
, item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( item_lab_s1.nextval
,'9689-80547-3'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'ITEM_LAB'
  AND      common_lookup_type = 'BLU-RAY')
,'Beau Geste'
,''
,'PG'
,'01-MAR-92'
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO item_lab
( item_lab_id
, item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( item_lab_s1.nextval
,'53939-64103'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'ITEM_LAB'
  AND      common_lookup_type = 'BLU-RAY')
,'I Remember Mama'
,''
,'NR'
,'05-JAN-98'
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO item_lab
( item_lab_id
, item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( item_lab_s1.nextval
,'24543-01292'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'ITEM_LAB'
  AND      common_lookup_type = 'BLU-RAY')
,'Tora! Tora! Tora!'
,'The Attack on Pearl Harbor'
,'G'
,'02-NOV-99'
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO item_lab
( item_lab_id
, item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( item_lab_s1.nextval
,'43396-60047'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'ITEM_LAB'
  AND      common_lookup_type = 'BLU-RAY')
,'A Man for All Seasons'
,''
,'G'
,'28-JUN-94'
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO item_lab
( item_lab_id
, item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( item_lab_s1.nextval
,'43396-70603'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'ITEM_LAB'
  AND      common_lookup_type = 'BLU-RAY')
,'Hook'
,''
,'PG'
,'11-DEC-91'
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO item_lab
( item_lab_id
, item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( item_lab_s1.nextval
,'85391-13213'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'ITEM_LAB'
  AND      common_lookup_type = 'BLU-RAY')
,'Around the World in 80 Days'
,''
,'G'
,'04-DEC-92'
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO item_lab
( item_lab_id
, item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( item_lab_s1.nextval
,'85391-10843'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'ITEM_LAB'
  AND      common_lookup_type = 'BLU-RAY')
,'Camelot'
,''
,'G'
,'15-MAY-98'
, 1001
, SYSDATE
, 1001
, SYSDATE);


SET PAGESIZE 99
COL item_labid                FORMAT 9999  HEADING "Item|ID #"
COL common__lookup_meaning  FORMAT A20  HEADING "Item Description"
COL item_title             FORMAT A30  HEADING "Item Title"
COL item_release_date      FORMAT A11  HEADING "Item|Release|Date"
SELECT   i.item_lab_id
,        cl.common_lookup_meaning
,        i.item_title
,        i.item_release_date
FROM     item_lab i INNER JOIN common_lookup cl ON i.item_type = cl.common_lookup_id;


-- Transaction Management Example.
CREATE OR REPLACE PROCEDURE contact_insert
( pv_member_type         VARCHAR2
, pv_account_number      VARCHAR2
, pv_credit_card_number  VARCHAR2
, pv_credit_card_type    VARCHAR2
, pv_first_name          VARCHAR2
, pv_middle_name         VARCHAR2 := ''
, pv_last_name           VARCHAR2
, pv_contact_type        VARCHAR2
, pv_address_type        VARCHAR2
, pv_city                VARCHAR2
, pv_state_province      VARCHAR2
, pv_postal_code         VARCHAR2
, pv_street_address      VARCHAR2
, pv_telephone_type      VARCHAR2
, pv_country_code        VARCHAR2
, pv_area_code           VARCHAR2
, pv_telephone_number    VARCHAR2
, pv_created_by          NUMBER   := 1001
, pv_creation_date       DATE     := SYSDATE
, pv_last_updated_by     NUMBER   := 1001
, pv_last_update_date    DATE     := SYSDATE) IS

BEGIN
 
  /* Create a SAVEPOINT as a starting point. */
  SAVEPOINT starting_point;

  /* Insert into the member_lab table. */
  INSERT INTO member_lab
  ( member_lab_id
  , member_type
  , account_number
  , credit_card_number
  , credit_card_type
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ( member_lab_s1.NEXTVAL
  ,(SELECT   common_lookup_lab_id
    FROM     common_lookup_lab
    WHERE    common_lookup_context = 'MEMBER_LAB'
    AND      common_lookup_type = pv_member_type)
  , pv_account_number
  , pv_credit_card_number
  ,(SELECT   common_lookup_lab_id
    FROM     common_lookup_lab
    WHERE    common_lookup_context = 'MEMBER_LAB'
    AND      common_lookup_type = pv_credit_card_type)
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date );

  /* Insert into the contact_lab table. */
  INSERT INTO contact_lab
  VALUES
  ( contact_lab_s1.NEXTVAL
  , member_lab_s1.CURRVAL
  ,(SELECT   common_lookup_lab_id
    FROM     common_lookup_lab
    WHERE    common_lookup_context = 'CONTACT_LAB'
    AND      common_lookup_type = pv_contact_type)
  , pv_first_name
  , pv_middle_name
  , pv_last_name
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date );  

  /* Insert into the address_lab table. */
  INSERT INTO address_lab
  VALUES
  ( address_lab_s1.NEXTVAL
  , contact_lab_s1.CURRVAL
  ,(SELECT   common_lookup_lab_id
    FROM     common_lookup_lab
    WHERE    common_lookup_context = 'MULTIPLE'
    AND      common_lookup_type = pv_address_type)
  , pv_city
  , pv_state_province
  , pv_postal_code
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date );  

  /* Insert into the street_address_lab table. */
  INSERT INTO street_address_lab
  VALUES
  ( street_address_lab_s1.NEXTVAL
  , address_lab_s1.CURRVAL
  , pv_street_address
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date );  

  /* Insert into the telephone_lab table. */
  INSERT INTO telephone_lab
  VALUES
  ( telephone_lab_s1.NEXTVAL                              -- TELEPHONE_ID
  , contact_lab_s1.CURRVAL                                -- CONTACT_ID
  , address_lab_s1.CURRVAL                                -- ADDRESS_ID
  ,(SELECT   common_lookup_lab_id                         -- ADDRESS_TYPE
    FROM     common_lookup_lab
    WHERE    common_lookup_context = 'MULTIPLE'
    AND      common_lookup_type = pv_telephone_type)
  , pv_country_code                                   -- COUNTRY_CODE
  , pv_area_code                                      -- AREA_CODE
  , pv_telephone_number                               -- TELEPHONE_NUMBER
  , pv_created_by                                     -- CREATED_BY
  , pv_creation_date                                  -- CREATION_DATE
  , pv_last_updated_by                                -- LAST_UPDATED_BY
  , pv_last_update_date);                             -- LAST_UPDATE_DATE

  /* Commit the series of inserts. */
  COMMIT;
EXCEPTION 
  WHEN OTHERS THEN
    ROLLBACK TO starting_point;
    RETURN;
END contact_insert;
/

-- ------------------------------------------------------------------
--   Query to verify five individual rows of chained inserts through
--   a procedure into the five dependent tables.
-- ------------------------------------------------------------------

BEGIN
  /* Call the contact_insert procedure. */
  contact_insert(
      pv_member_type => 'INDIVIDUAL'
    , pv_account_number => 'R11-514-34'
    , pv_credit_card_number => '1111-1111-1111-1111'
    , pv_credit_card_type => 'VISA_CARD'
    , pv_first_name => 'Goeffrey'
    , pv_middle_name => 'Ward'
    , pv_last_name => 'Clinton'
    , pv_contact_type => 'CUSTOMER'
    , pv_address_type => 'HOME'
    , pv_city => 'Provo'
    , pv_state_province => 'Utah'
    , pv_postal_code => '84606'
    , pv_street_address => '118 South 9th East'
    , pv_telephone_type => 'HOME'
    , pv_country_code => '001'
    , pv_area_code => '801'
    , pv_telephone_number => '423-1234' );
END;
/

-- Insert second contact.
BEGIN
  /* Call athe contact_insert procedure. */
  contact_insert(
      pv_member_type => 'INDIVIDUAL'
    , pv_account_number => 'R11-514-35'
    , pv_credit_card_number => '1111-2222-1111-1111'
    , pv_credit_card_type => 'VISA_CARD'
    , pv_first_name => 'Wendy'
    , pv_last_name => 'Moss'
    , pv_contact_type => 'CUSTOMER'
    , pv_address_type => 'HOME'
    , pv_city => 'Provo'
    , pv_state_province => 'Utah'
    , pv_postal_code => '84606'
    , pv_street_address => '1218 South 10th East'
    , pv_telephone_type => 'HOME'
    , pv_country_code => '001'
    , pv_area_code => '801'
    , pv_telephone_number => '423-1235' );
END;
/

-- Insert third contact.
BEGIN
  /* Call the contact_insert procedure. */
  contact_insert(
      pv_member_type => 'INDIVIDUAL'
    , pv_account_number => 'R11-514-36'
    , pv_credit_card_number => '1111-1111-2222-1111'
    , pv_credit_card_type => 'VISA_CARD'
    , pv_first_name => 'Simon'
    , pv_middle_name => 'Jonah'
    , pv_last_name => 'Gretelz'
    , pv_contact_type => 'CUSTOMER'
    , pv_address_type => 'HOME'
    , pv_city => 'Provo'
    , pv_state_province => 'Utah'
    , pv_postal_code => '84606'
    , pv_street_address => '2118 South 7th East'
    , pv_telephone_type => 'HOME'
    , pv_country_code => '001'
    , pv_area_code => '801'
    , pv_telephone_number => '423-1236' );
END;
/

-- Insert fourth contact.
BEGIN
  /* Call the contact_insert procedure. */
  contact_insert(
      pv_member_type => 'INDIVIDUAL'
    , pv_account_number => 'R11-514-37'
    , pv_credit_card_number => '3333-1111-1111-2222'
    , pv_credit_card_type => 'VISA_CARD'
    , pv_first_name => 'Elizabeth'
    , pv_middle_name => 'Jane'
    , pv_last_name => 'Royal'
    , pv_contact_type => 'CUSTOMER'
    , pv_address_type => 'HOME'
    , pv_city => 'Provo'
    , pv_state_province => 'Utah'
    , pv_postal_code => '84606'
    , pv_street_address => '2228 South 14th East'
    , pv_telephone_type => 'HOME'
    , pv_country_code => '001'
    , pv_area_code => '801'
    , pv_telephone_number => '423-1237' );
END;
/

-- Insert fifth contact.
BEGIN
  /* Call the contact_insert procedure. */
  contact_insert(
      pv_member_type => 'INDIVIDUAL'
    , pv_account_number => 'R11-514-38'
    , pv_credit_card_number => '1111-1111-3333-1111'
    , pv_credit_card_type => 'VISA_CARD'
    , pv_first_name => 'Brian'
    , pv_middle_name => 'Nathan'
    , pv_last_name => 'Smith'
    , pv_contact_type => 'CUSTOMER'
    , pv_address_type => 'HOME'
    , pv_city => 'Spanish Fork'
    , pv_state_province => 'Utah'
    , pv_postal_code => '84606'
    , pv_street_address => '333 North 2nd East'
    , pv_telephone_type => 'HOME'
    , pv_country_code => '001'
    , pv_area_code => '801'
    , pv_telephone_number => '423-1238' );
END;
/



COL account_number  FORMAT A10  HEADING "Account|Number"
COL full_name       FORMAT A20  HEADING "Name|(Last, First MI)"
COL city            FORMAT A12  HEADING "City"
COL state_province  FORMAT A10  HEADING "State"
COL telephone       FORMAT A18  HEADING "Telephone"
SELECT   m.account_number
,        c.last_name || ', ' || c.first_name
||       CASE
           WHEN c.middle_name IS NOT NULL THEN ' ' || SUBSTR(c.middle_name,1,1)
         END AS full_name
,        a.city
,        a.state_province
,        t.country_code || '-(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM     member_lab m INNER JOIN contact_lab c ON m.member_lab_id = c.member_lab_id INNER JOIN
         address_lab a ON c.contact_lab_id = a.contact_lab_id INNER JOIN
         street_address sa ON a.address_lab_id = sa.address_id INNER JOIN
         telephone t ON c.contact_lab_id = t.contact_id AND a.address_lab_id = t.address_id
WHERE    m.member_type = (SELECT common_lookup_lab_id
                          FROM   common_lookup_lab
                          WHERE  common_lookup_context = 'MEMBER_LAB'
                          AND    common_lookup_type = 'INDIVIDUAL');




-- Update all MEMBER_TYPE values based on number of dependent CONTACT rows.
UPDATE member_lab m
SET    member_type =
        (SELECT   common_lookup_lab_id
         FROM     common_lookup_lab
         WHERE    common_lookup_context = 'MEMBER_LAB'
         AND      common_lookup_type =
                   (SELECT  dt.member_type
                    FROM   (SELECT   c.member_lab_id
                            ,        CASE
                                       WHEN COUNT(c.member_lab_id) > 1 THEN 'GROUP'
                                       ELSE 'INDIVIDUAL'
                                     END AS member_type
                            FROM     contact_lab c
                            GROUP BY c.member_lab_id) dt
                    WHERE    dt.member_lab_id = m.member_lab_id));

-- Modify the MEMBER table to add a NOT NULL constraint to the MEMBER_TYPE column.
ALTER TABLE member_lab
  MODIFY (member_type  NUMBER  CONSTRAINT nn_member_lab_1  NOT NULL);

-- Use SQL*Plus report formatting commands.
COLUMN member_lab_id          FORMAT 999999 HEADING "MEMBER|ID"
COLUMN members            FORMAT 999999 HEADING "MEMBER|QTY #"
COLUMN member_type        FORMAT 999999 HEADING "MEMBER|TYPE|ID #"
COLUMN common_lookup_lab_id   FORMAT 999999 HEADING "MEMBER|LOOKUP|ID #"
COLUMN common_lookup_type FORMAT A12    HEADING "COMMON|LOOKUP|TYPE"
SELECT   m.member_lab_id
,        COUNT(contact_lab_id) AS MEMBERS
,        m.member_type
,        cl.common_lookup_lab_id
,        cl.common_lookup_type
FROM     member_lab m INNER JOIN contact_lab c
ON       m.member_lab_id = c.member_lab_id INNER JOIN common_lookup_lab cl
ON       m.member_type = cl.common_lookup_lab_id
GROUP BY m.member_lab_id
,        m.member_type
,        cl.common_lookup_lab_id
,        cl.common_lookup_type
ORDER BY m.member_lab_id;

-- Commit changes.
COMMIT;

-- ------------------------------------------------------------------
--   Query to verify nine rental agreements, some with one and some
--   with more than one rental item.
-- ------------------------------------------------------------------


-- ------------------------------------------------------------------
-- Insert 5 records in the RENTAL table.
-- ------------------------------------------------------------------

INSERT INTO rental_lab
( rental_lab_id
, customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( rental_lab_s1.nextval
,(SELECT   contact_lab_id
  FROM     contact_lab
  WHERE    last_name = 'Vizquel'
  AND      first_name = 'Oscar')
, TRUNC(SYSDATE)
, TRUNC(SYSDATE) + 5
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO rental_lab
( rental_lab_id
, customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( rental_lab_s1.nextval
,(SELECT   contact_lab_id
  FROM     contact_lab
  WHERE    last_name = 'Vizquel'
  AND      first_name = 'Doreen')
, TRUNC(SYSDATE)
, TRUNC(SYSDATE) + 5
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO rental_lab
( rental_lab_id
, customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( rental_lab_s1.nextval
,(SELECT   contact_lab_id
  FROM     contact_lab
  WHERE    last_name = 'Sweeney'
  AND      first_name = 'Meaghan')
, TRUNC(SYSDATE)
, TRUNC(SYSDATE) + 5
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO rental_lab
( rental_lab_id
, customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( rental_lab_s1.nextval
,(SELECT   contact_lab_id
  FROM     contact_lab
  WHERE    last_name = 'Sweeney'
  AND      first_name = 'Ian')
, TRUNC(SYSDATE)
, TRUNC(SYSDATE) + 5
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO rental_lab
( rental_lab_id
, customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( rental_lab_s1.nextval
,(SELECT   contact_lab_id
  FROM     contact_lab
  WHERE    last_name = 'Winn'
  AND      first_name = 'Brian')
, TRUNC(SYSDATE)
, TRUNC(SYSDATE) + 5
, 1001
, SYSDATE
, 1001
, SYSDATE);

-- ------------------------------------------------------------------
-- Insert 9 records in the RENTAL_ITEM table.
-- ------------------------------------------------------------------

INSERT INTO rental_item_lab
( rental_item_lab_id
, rental_lab_id
, item_lab_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_lab_s1.nextval
,(SELECT   r.rental_lab_id
  FROM     rental_lab r
  ,        contact_lab c
  WHERE    r.customer_id = c.contact_lab_id
  AND      c.last_name = 'Vizquel'
  AND      c.first_name = 'Oscar')
,(SELECT   i.item_lab_id
  FROM     item_lab i
  ,        common_lookup_lab cl
  WHERE    i.item_title = 'Star Wars I'
  AND      i.item_subtitle = 'Phantom Menace'
  AND      i.item_type = cl.common_lookup_lab_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO rental_item_lab
( rental_item_lab_id
, rental_lab_id
, item_lab_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_lab_s1.nextval
,(SELECT   r.rental_lab_id
  FROM     rental_lab r inner join contact_lab c
  ON       r.customer_id = c.contact_lab_id
  WHERE    c.last_name = 'Vizquel'
  AND      c.first_name = 'Oscar')
,(SELECT   d.item_lab_id
  FROM     item_lab d join common_lookup_lab cl
  ON       d.item_title = 'Star Wars II'
  WHERE    d.item_subtitle = 'Attack of the Clones'
  AND      d.item_type = cl.common_lookup_lab_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO rental_item_lab
( rental_item_lab_id
, rental_lab_id
, item_lab_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_lab_s1.nextval
,(SELECT   r.rental_lab_id
  FROM     rental_lab r
  ,        contact_lab c
  WHERE    r.customer_id = c.contact_lab_id
  AND      c.last_name = 'Vizquel'
  AND      c.first_name = 'Oscar')
,(SELECT   d.item_lab_id
  FROM     item_lab d
  ,        common_lookup_lab cl
  WHERE    d.item_title = 'Star Wars III'
  AND      d.item_subtitle = 'Revenge of the Sith'
  AND      d.item_type = cl.common_lookup_lab_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO rental_item_lab
( rental_item_lab_id
, rental_lab_id
, item_lab_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_lab_s1.nextval
,(SELECT   r.rental_lab_id
  FROM     rental_lab r
  ,        contact_lab c
  WHERE    r.customer_id = c.contact_lab_id
  AND      c.last_name = 'Vizquel'
  AND      c.first_name = 'Doreen')
,(SELECT   d.item_lab_id
  FROM     item_lab d
  ,        common_lookup_lab cl
  WHERE    d.item_title = 'I Remember Mama'
  AND      d.item_subtitle IS NULL
  AND      d.item_type = cl.common_lookup_lab_id
  AND      cl.common_lookup_type = 'BLU-RAY')
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO rental_item_lab
( rental_item_lab_id
, rental_lab_id
, item_lab_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_lab_s1.nextval
,(SELECT   r.rental_lab_id
  FROM     rental_lab r
  ,        contact_lab c
  WHERE    r.customer_id = c.contact_lab_id
  AND      c.last_name = 'Vizquel'
  AND      c.first_name = 'Doreen')
,(SELECT   d.item_lab_id
  FROM     item_lab d
  ,        common_lookup_lab cl
  WHERE    d.item_title = 'Camelot'
  AND      d.item_subtitle IS NULL
  AND      d.item_type = cl.common_lookup_lab_id
  AND      cl.common_lookup_type = 'BLU-RAY')
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO rental_item_lab
( rental_item_lab_id
, rental_lab_id
, item_lab_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_lab_s1.nextval
,(SELECT   r.rental_lab_id
  FROM     rental_lab r
  ,        contact_lab c
  WHERE    r.customer_id = c.contact_lab_id
  AND      c.last_name = 'Sweeney'
  AND      c.first_name = 'Meaghan')
,(SELECT   d.item_lab_id
  FROM     item_lab d
  ,        common_lookup_lab cl
  WHERE    d.item_title = 'Hook'
  AND      d.item_subtitle IS NULL
  AND      d.item_type = cl.common_lookup_lab_id
  AND      cl.common_lookup_type = 'BLU-RAY')
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO rental_item_lab
( rental_item_lab_id
, rental_lab_id
, item_lab_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_lab_s1.nextval
,(SELECT   r.rental_lab_id
  FROM     rental_lab r
  ,        contact_lab c
  WHERE    r.customer_id = c.contact_lab_id
  AND      c.last_name = 'Sweeney'
  AND      c.first_name = 'Ian')
,(SELECT   d.item_lab_id
  FROM     item_lab d
  ,        common_lookup_lab cl
  WHERE    d.item_title = 'Cars'
  AND      d.item_subtitle IS NULL
  AND      d.item_type = cl.common_lookup_lab_id
  AND      cl.common_lookup_type = 'XBOX')
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO rental_item_lab
( rental_item_lab_id
, rental_lab_id
, item_lab_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_lab_s1.nextval
,(SELECT   r.rental_lab_id
  FROM     rental_lab r
  ,        contact_lab c
  WHERE    r.customer_id = c.contact_lab_id
  AND      c.last_name = 'Winn'
  AND      c.first_name = 'Brian')
,(SELECT   d.item_lab_id
  FROM     item_lab d
  ,        common_lookup_lab cl
  WHERE    d.item_title = 'RoboCop'
  AND      d.item_subtitle IS NULL
  AND      d.item_type = cl.common_lookup_lab_id
  AND      cl.common_lookup_type = 'XBOX')
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO rental_item_lab
( rental_item_lab_id
, rental_lab_id
, item_lab_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_lab_s1.nextval
,(SELECT   r.rental_lab_id
  FROM     rental_lab r
  ,        contact_lab c
  WHERE    r.customer_id = c.contact_lab_id
  AND      c.last_name = 'Winn'
  AND      c.first_name = 'Brian')
,(SELECT   d.item_lab_id
  FROM     item_lab d
  ,        common_lookup_lab cl
  WHERE    d.item_title = 'The Hunt for Red October'
  AND      d.item_subtitle = 'Special Collector''s Edition'
  AND      d.item_type = cl.common_lookup_lab_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 1001
, SYSDATE
, 1001
, SYSDATE);



COL member_lab_id       FORMAT 9999 HEADING "Member|ID #"
COL account_number  FORMAT A10  HEADING "Account|Number"
COL full_name       FORMAT A20  HEADING "Name|(Last, First MI)"
COL rental_lab_id       FORMAT 9999 HEADING "Rent|ID #"
COL rental_item_lab_id  FORMAT 9999 HEADING "Rent|Item|ID #"
COL item_title      FORMAT A26  HEADING "Item Title"
SELECT   m.member_lab_id
,        m.account_number
,        c.last_name || ', ' || c.first_name
||       CASE
           WHEN c.middle_name IS NOT NULL THEN ' ' || SUBSTR(c.middle_name,1,1)
         END AS full_name
,        r.rental_lab_id
,        ri.rental_item_lab_id
,        i.item_title
FROM     member_lab m INNER JOIN contact_lab c ON m.member_lab_id = c.member_lab_id INNER JOIN
         rental_lab r ON c.contact_lab_id = r.customer_id INNER JOIN
         rental_item_lab ri ON r.rental_lab_id = ri.rental_lab_id INNER JOIN
         item_lab i ON ri.item_lab_id = i.item_lab_id
ORDER BY r.rental_lab_id;


-- --------------------------------------------------------
--  Step #1
--  --------
--   Display the rows in the member and contact tables.
-- --------------------------------------------------------

COL member_lab_id           FORMAT 9999  HEADING "Member|ID #"
COL members             FORMAT 9999  HEADING "Member|#"
COL common_lookup_type  FORMAT A12   HEADING "Common|Lookup Type"
SELECT   m.member_lab_id
,        COUNT(contact_lab_id) AS MEMBERS
,        cl.common_lookup_type
FROM     member_lab m INNER JOIN contact_lab c
ON       m.member_lab_id = c.member_lab_id INNER JOIN common_lookup_lab cl
ON       m.member_type = cl.common_lookup_lab_id
GROUP BY m.member_lab_id
,        m.member_type
,        cl.common_lookup_lab_id
,        cl.common_lookup_type
ORDER BY m.member_lab_id;

-- --------------------------------------------------------
--  Step #2
--  --------
--   Create a view .
-- --------------------------------------------------------
CREATE OR REPLACE VIEW current_rental AS
  SELECT   m.account_number
  ,        c.last_name || ', ' || c.first_name
  ||       CASE
             WHEN c.middle_name IS NOT NULL THEN ' ' || SUBSTR(c.middle_name,1,1)
           END AS full_name
  ,        i.item_title AS title
  ,        i.item_subtitle AS subtitle
  ,        SUBSTR(cl.common_lookup_meaning,1,3) AS product
  ,        r.check_out_date
  ,        r.return_date
  FROM     member_lab m INNER JOIN contact_lab c ON m.member_lab_id = c.member_lab_id INNER JOIN
           rental_lab r ON c.contact_lab_id = r.customer_id INNER JOIN
           rental_item_lab ri ON r.rental_lab_id = ri.rental_lab_id INNER JOIN
           item_lab i ON ri.item_lab_id = i.item_lab_id INNER JOIN
           common_lookup_lab cl ON i.item_lab_id = cl.common_lookup_lab_id
  ORDER BY 1, 2, 3;

-- --------------------------------------------------------
--  Step #3
--  --------
--   Display the content of a view .
-- --------------------------------------------------------
COL full_name      FORMAT A24
COL title          FORMAT A30
COL subtitlei      FORMAT A4
COL product        FORMAT A7
COL check_out_date FORMAT A11
COL return_date    FORMAT A11
SELECT   cr.full_name
,        cr.title
,        cr.check_out_date
,        cr.return_date
FROM     current_rental cr;

-- ------------------------------------------------------------------
--  Close log file.
-- ------------------------------------------------------------------ 

SPOOL OFF

