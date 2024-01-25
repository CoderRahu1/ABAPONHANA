-- TOPICS- 1) USING CURSOR IN SAP SCRIPT.

-----------------------------------------------------
-- THEORY - 
-- CURSOR - CURSORS IN HANA ARE USED TO READ DATA FROM A STORED QUERY(A CURSOR IS ASSIGNED TO A QUERY).
-- TWO WAYS OF CURSOR - 1) PARAMETERIZED, 2) NON-PARAMETERIZED.

------------------------------------------------------
-- REQ - CREATE A SIMPLE CURSOR TO READ PRODUCT ID WITH THE HELP OF CURSOR.
------------------------------------------------------

CREATE PROCEDURE SIMPLECURSOR(OUT PROD1 VARCHAR(40)), OUT PROD2 VARCHAR(40))

DEFAULT SCHEMA SAPHANADB
AS BEGIN

-- DECLARE A CURSOR.
DECLARE CURSOR C1 FOR SELECT PRODUCT_ID FROM SNWD_PD
