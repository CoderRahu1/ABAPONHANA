------------------------------------------------------------
-- TOPICS - 1) CREATE INTERNAL TABLE AND INSERT RECORDS INTO THE INTERNAL TABLE.

------------------------------------------------------------


CREATE PROCEDURE BASICITAB(out etab table(product_id varchar(40), price decimal(10,2))
)
default schema saphanadb
as begin

:ETAB.INSERT(('HT-2020'), 500, 1);
:ETAB.INSERT(('HT-2021'), 850, 2);
:ETAB.INSERT(('HT-2022'), 950, 3);


end;

------------------------------------------------------------

--  O/P - CREATES INTERNAL TABLE WITH 3 RECORDS.










