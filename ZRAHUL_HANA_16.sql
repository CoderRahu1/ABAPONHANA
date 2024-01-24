
-- TOPIC - USING OF ARRAYS IN STORED PROCEDURES


-------------------------------------------------------------------------

CREATE PROCEDURE SIMPLEARRAY(OUT RES VARCHAR(40))
AS BEGIN

DECLARE FRUITS VARCHAR(40) ARRAY := ARRAY('APPLE', 'BANANA', 'CHERRY');

DECLARE IDX TINYINT ARRAY := ARRAY(3,1,2);

RES := :FRUITS[:IDX[2]];

END;


---------------------------------------------------------------------------
-- OUTPUT - APPLE.
