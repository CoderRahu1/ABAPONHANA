-- TOPIC - 1) PRACTICAL REQUIRMENT FOR STORED PROCEDURE.

----------------------------------------------------------

--  REQ- TO CALCULATE EVEN OR ODD NUMBER ( SO PASS A INTEGER AND IN THE OUTPUT WE SHOULD GET A TEXT).






CREATE PROCEDURE EVENODD(IN X INTEGER, OUT RES VARCHAR(10))
AS BEGIN

IF (MOD(X,2) = 0) THEN
	RES = 'EVEN';
ELSE 
	RES = 'ODD';

END IF;

END;
