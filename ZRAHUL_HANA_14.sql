
-- TOPIC - 1) SOLVING THE REQUIREMENT TO CREATE A EMPLOYEE TABLE WITH EMPID AS INTEGER AND EMPNAME AS VARCHAR(40) AND USING FOR LOOP TO FILL THE CREATED TABLE,
--         2) SOLVE BY CREATING STORED PROCEDURE.



------------------------------------------------------------------------------------

CREATE PROCEDURE CREATEANDFILL(IN X INTEGER)
AS BEGIN

-- DECLARING VARIBLE I FOR USING IN THE FOR LOOP.
DECLARE I INTEGER;

-- CREATING COLUMN NAME FOR THE TABLE
CREATE COLUMN TABLE EMP(EMPID INTEGER, EMPNAME VARCHAR(40), PRIMARY KEY(EMPID));

-- USING FOR LOOP FOR LOOPING THE RECORDS IN THE TABLE.

FOR I IN 1..:X DO
	INSERT INTO EMP VALUES (:I, 'EMPLOYEE' || :I); -- DOING CONCATENATE EMPNAME WITH EMPID.
END FOR;


	
	

END;
