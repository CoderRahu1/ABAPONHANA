---------------------------------------------------------------------------------------------------------------
-- TOPICS - 1) TABLE UDF(USER DEFINED FUNCTION WITH ONLY ONE RETURN PARAMETER)

---------------------------------------------------------------------------------------------------------------

-- REQUIREMENT - TO GET THE LIST OF ALL SUPPLIERS.

---------------------------------------------------------------------------------------------------------------

CREATE FUNCTION GETSUPPLIERS()
RETURNS TABLE (SUPPLIER_ID VARCHAR(20),
			   SUPPLIER_NAME VARCHAR(80),
			   CITY VARCHAR(40),
			   COUNTRY VARCHAR(40)
)

DEFAULT SCHEMA SAPHANADB

AS BEGIN

	RETURN SELECT BP_ID AS SUPPLIER_ID, COMPANY_NAME AS SUPPLIER_NAME,
		   ADDR.CITY , ADDR.COUNTRY
		   FROM SNWD_BPA AS BPA INNER JOIN SNWD_AD AS ADDR
		   ON BPA.ADDRESS_GUID = ADDR.NODE_KEY
		   WHERE
		   BPA.BP_ROLE = '02';                               -- SUPPLIERS ARE ALWAYS HAVIG BUSINESS ROLE.

		   
		    
	
END;	
---------------------------------------------------------------------------------------------------------------
-- TO RUN ABOVE CODE 

-- SELECT * FROM GETSUPPLIERS()
---------------------------------------------------------------------------------------------------------------
-- O/P - LIST OF ALL SUPPLIERS.
