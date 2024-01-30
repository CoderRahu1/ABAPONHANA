---------------------------------------------------------------

-- TOPICS - 1) UDF(USER DEFINED FUNCTION), 2) SCALAR UDF.

--------------------------------------------------------------
-- CODE- 
CREATE FUNCTION AREAOFCIRCLE(RADIUS INTEGER)
RETURNS AREA DECIMAL(10,2)
AS BEGIN

	AREA = 3.14 * RADIUS * RADIUS;
	
END;

--------------------------------------------------------------
-- FOR CALLING A FUNCTION WE USE SELECT QUERY
-- SYNTAX - SELECT AREAOFCIRCLE(2) FROM DUMMY;
--------------------------------------------------------------

-- O/P AREA OF CIRCLE IS 12.56.

--------------------------------------------------------------
