-----------------------------------------------------------------------------
-- TOPICS - 1) TO DO OPERATIONS ON INTERNAL TABLE SIMILAR TO ABAP REPORT, 2) EXPLICIT INTERNAL TABLE, 3) RECORD_COUNT FUNCTION.

-----------------------------------------------------------------------------
-- REQUIREMENT - CREATE LOGIC TO EVALUATE 18% GST ON EACH PRODUCT OF TYPE NOTEBOOKS, 12% OF TYPE MICE, 8% ON OTHERS.

-----------------------------------------------------------------------------


CREATE PROCEDURE ITABOPR
-- EXPLICIT INTERNAL TABLE.
(out etab table(product_id varchar(40),CATEGORY,price decimal(10,2)),CATEGORY VARCHAR(80), MRP DECIMAL(10,2)  -- MRP IS FINAL PRICE AFTER DISCOUNT
)
default schema saphanadb
 as begin
 	DECLARE LV_MRP DECIMAL(10,2);
 	
	-- IMPLICIT INTERNAL TABLE.
	LT_PRODUCTS = SELECT PRODUCT_ID, PRICE FROM SNWD_PD;
	-- NOW LOOP THROUGH ABOVE LT_PRODUCTS TO CALCULATE.

	DECLARE COUNTER,I INTEGER;
	
	COUNTER := RECORD_COUNT(:LT_PRODUCTS);
	
	-- NOW STARTING THE LOOP.
	FOR I IN 1..COUNTER DO
		IF LT_PRODUCTS.CATEGORY[I] = 'NOTEBOOKS' THEN
			LV_MRP := :LT_PRODUCTS.PRICE[I] * 118/100;
		ELSEIF :LT_PRODUCTS.CATEGORY[I] = 'MICE' THEN
			LV_MRP := :LT_PRODUCTS.PRICE[I] * 112/100;		
		ELSE
			LV_MRP := :LT_PRODUCTS.PRICE[I] * 103/100;
		END IF;
		ETAB.INSERT((	:LT_PRODUCTS.PRODUCT_ID[I],
						:LT_PRODUCTS.PRICE[I],
						:LT_PRODUCTS.CATEGORY[I],
						:LV_MRP
						), :I);
	
	END FOR;
	
	
	



end;


-----------------------------------------------------------------------------
-- O/P - SHOWS THE MRP ACCORDING TO THE DISCOUNT RATES APPLIED.



