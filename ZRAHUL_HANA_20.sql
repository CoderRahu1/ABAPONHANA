---------------------------------------------------------------
-- TOPIC - 1) INTERNAL TABLE WITH CURSOR, 2) PASSING OUTPUT FROM ARRAYS TO INTERNAL TABLE, 3) UNNEST FUNCTION IN SQL.

---------------------------------------------------------------



CREATE PROCEDURE CursorWithLoop(IN MyCat varchar(20),
out etab table(product_id varchar(40), price decimal(10,2))
)
default schema saphanadb
as begin

declare allProd varchar(40) array;
declare allPrice decimal(10,2) array;
--declare a cursor
declare cursor c1(icat varchar(20)) for select product_id, price from snwd_pd 
                where category = :icat;

--loop to fetch data dynamically
for wa as c1(MyCat) do
 allProd[c1::rowcount] = wa.product_id;
 allPrice[c1::rowcount] = wa.price;
end for;

etab = unnest(:allProd, :allPrice) as (product_id, price);
end;


---------------------------------------------------------------
-- OUTPUT - NOW WE GET DATA IN THE FORM OF TABLE FROM ARRAY.


