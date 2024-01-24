





-- TOPIC - 1) HANDLING OVERALL EXCEPTIONS USING SQLEXCEPTION




------------------------------------------------------------------------------------

CREATE PROCEDURE CREATEANDFILL(IN X INTEGER)
AS BEGIN

-- DECLARING VARIBLE I FOR USING IN THE FOR LOOP.
DECLARE I INTEGER;

----------------------------------------------------------------------------------------------------------------------------------------------
-- HANDLING TABLE RECREATION ERROR.
-- GENERIC HANDLER CODE FOR ANY KIND OF ERROR.

DECLARE EXIT HANDLER FOR SQL_EXCEPTION;

SELECT 'INTERNAL ERROR OCCURED. CONTACT DEVELOPER OR BASIS TEAM' AS ERROR,
		::SQL_ERROR_CODE AS ERR_CODE,
		::SQL_ERROR_MESSAGE AS ER_MSG FROM DUMMY;                  -- PROVIDING MESSAGE TO USERS
----------------------------------------------------------------------------------------------------------------------------------------------
-- CREATING COLUMN NAME FOR THE TABLE
CREATE COLUMN TABLE EMP(EMPID INTEGER, EMPNAME VARCHAR(40), PRIMARY KEY(EMPID));

-- USING FOR LOOP FOR LOOPING THE RECORDS IN THE TABLE.

FOR I IN 1..:X DO
	INSERT INTO EMP VALUES (:I, 'EMPLOYEE' || :I); -- DOING CONCATENATE EMPNAME WITH EMPID.
END FOR;


	
	

END;
