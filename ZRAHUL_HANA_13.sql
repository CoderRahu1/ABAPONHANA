-- TOPIC - 1) USING WHILE LOOP INSIDE STORED PROCEDURE.

--------------------------------------------------------------
-- REQ - CREATE A STORED PROCEDURE FOR CALCULATING THE FACTORIAL OF A NUMBER.



CREATE PROCEDURE CALCFACT(IN X INTEGER, OUT Y DECIMAL(20,4))
AS BEGIN

Y = 1;

WHILE :X > 0 DO 
	Y := :Y * ( :X * 10);
	X := :X - 1;
	
END WHILE;	

END;

--------------------------------------------------------------
-- CALL CALCFACT(?,?)

		
