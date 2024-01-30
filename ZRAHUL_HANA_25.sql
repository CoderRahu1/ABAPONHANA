-----------------------------------------------------------------------------------------------------------------------------------------
-- TOPIC - 1) COMPLETE OIA SENARIO USING SQL SCRIPT AND HAVING LOWEST PROCESSING TIME OF 747 MICRO SECONDS.


-----------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE GETOIA(
OUT ETAB TABLE( BP_ID VARCHAR(40),
			    COMPANY_NAME VARCHAR(80),
			    OPEN_DAYS BIGINT,
			    GROSS_AMOUNT DECIMAL(15,2),
			    CURRENCY_CODE VARCHAR(4),
			    TAGGING VARCHAR(1)
			    
			   )
)

DEFAULT SCHEMA SAPHANADB

-- DECLARING VARIABLES TO STORE DATA.
DECLARE LV_TODAY DATE;
DECLARE LV_MAX_DAYS BIGINT;
DECLARE LV_GROSS_AMOUNT DECIMAL(10,2);
DECLARE LV_CURRENCY VARCHAR(4);
DECLARE LV_CLIENT VARCHAR(3);



AS BEGIN

-----------------------------------------------------------------------------------------------------------------------------------------

-- STEP 1: READ THE CUSTOMIZING,  ALSO READING THE CLIENT VALUE.

SELECT MANDT, MAX_OPEN_DAYS, MAX_AMOUNT, CURRENY_CODE,
CURRENT_DATE INTO LV_CLIENT, LV_MAX_DAYS, LV_GROSS_AMOUNT,
LV_CURRENCY, LV_TODAY                           -- WE CAN CREATE MUTIPLE PARAMS AND STORE VALUES 
FROM ZDP_CUST WHERE USRID = (SELECT UCASE(SESSION_CONTEXT('APPLICATIONUSER')) FROM DUMMY );

-----------------------------------------------------------------------------------------------------------------------------------------

-- STEP 2 : CALCULATING OPENDAYS AND CONVERTING TIME STAMPS
-- FIRST QUERY FOR CALCULATING DAYS DIFFERENCE
LT_DAYS = SELECT SECONDS_BETWEEN(																 -- THIS IS FINAL RESULT Z
			 TO_TIMESTAMP(LEFT(HEAD.CHANGED_AT,14),'YYYYMMDDHHMISS'),                        -- X VALUE
			 TO_TIMESTAMP(LOCALTOUTC(NOW(), 'CET')))                                        -- Y VALUE AND CET(CENTRAL EUROPEAN TIME)
			 / ( 24 * 60 * 60 ) 
			 AS OPEN_DAYS,                                                                   -- FIRST COLUMM
			 BP_ID FROM SNWD_BPA AS BPA INNER JOIN
			 SNWD_SO_INV_HEAD AS HEAD ON													 -- SPECIFYING JOIN CONDITION
			 BPA.NODE_KEY = HEAD.BUYER_GUID
			 WHERE HEAD.PAYMENT_STATUS = '';
			 
			 -- NOTE - CAN FIRE SELECT ON INTERNAL TABLE LT_DAYS.

-- NOW CALCULATING AVERAGE DAYS 

LT_AVG_DATS = SELECT AVG(OPEN_DAYS) AS OPEN_DAYS, BP_ID FROM :LT_DAYS GROUP BY BP_ID;
-----------------------------------------------------------------------------------------------------------------------------------------
-- STEP 3 : CALCULATE THE TOTAL GROSS_AMOUNT PENDING IN COMMON CURRENCY.
-- GETTING TOTAL PAYMENT STATUS.

LT_ALL_AMOUNT = SELECT BP_ID, SUM(ITEM.GROSS_AMOUNT) AS GROSS_AMOUNT,
				ITEM.CURRENCY_CODE FROM SNWD_SO_INV_ITEM AS ITEM INNER JOIN
				SNWD_SO_INV_HEAD AS HEAD ON
				ITEM.PARENT_KEY = HEAD.NODE_KEY
				INNER JOIN SNWD_BPA AS BPA ON
				BPA.NODE_KEY = HEAD.BUYER_GUID
				WHERE HEAD.PAYMENT_STATUS = ''
				GROUP BY BP_ID,ITEM.CURRENCY_CODE;                              -- WE ARE GOING TO GET TOTAL AMOUNT FOR CURRENCY CODE.


-- CURRENCY CONVERSION

LT_CONV_AMOUNT = CE_CONVERSION(:LT_ALL_AMOUNT, [
					FAMILY = 'CURRENCY',
					METHOD = 'ERP',
					SCHEMA = 'SAPHANADB',
					CLIENT = :LV_CLIENT,
					ERROR_HANDLING = 'KEEP_UNCOVERTED',
					STEPS = 'SHIFT,CONVERT,SHIFT_BACK',
					SOURCE_UNIT_COLUMN = 'CURRENCY_CODE',
					TARGET_UNIT = :LV_CURRENCY,                                 -- TARGET CURRENCY SET BY NEED (ZDP_CUST) CUSTOMIZING TABLE.                           
					REFERENCE_DATE = :LV_TODAY,
					OUTPUT_UNIT_COLUMN = 'CONV_CURR_CODE'
				 ],[GROSS_AMOUNT])                                              -- GROSS_AMOUNT IS THE COLUMN WHICH IT NEEDS FOR CONVERT AND IT WILL PUT THAT
																				-- DATA BACK INTO THE COLUMN ITSELF.



LT_AMOUNT = SELECT BP_ID, :LV_CURRENCY AS CURRENCY_CODE, 
			SUM(GROSS_AMOUNT) AS GROSS_AMOUNT 
			FROM :LT_CONV_AMOUNT
			GROUP BY BP_ID, CONV_CURR_CODE;
						
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTE - WILL HAVE TO HARDCODE CURRENY CODE(:LV_CURRENCY IN LT_AMOUNT) SINCE NO EXCHANGE RATES MAINTAINED SO HERE USING VARIBLE AS CURRENCY CODE.

-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- STEP 4 : DOING THE TAGGING FOR OPEN DAYS AND GROSS AMOUNT.




LT_RESULT = SELECT BPA.BP_ID, BPA.COMPANY_NAME, DATS.OPEN_DAYS AS OPEN_DAYS,
	   AMT.GROSS_AMOUNT AS GROSS_AMOUNT, AMT.CURRENCY_CODE AS CURRENCY_CODE,
	   '' AS TAGGING FROM SNWD_BPA AS BPA INNER JOIN :LT_AVG_DATS AS DATS
	   ON BPA.BP_ID = DATS.BP_ID
	   INNER JOIN :LT_AMOUNT AS AMT ON BPA.BP_ID = AMT.BP_ID;

-----------------------------------------------------------------------------------------------------------------------------------------

ETAB = SELECT BP_ID, COMPANY_NAME, OPEN_DAYS, GROSS_AMOUNT, CURRENCY_CODE,
			CASE WHEN GROSS_AMOUNT > LV_GROSS_AMOUNT AND OPEN_DAYS > LV_MAX_DAYS
				THEN 'X' ELSE '' END AS TAGGING
				FROM :LT_RESULT;


-----------------------------------------------------------------------------------------------------------------------------------------
-- O/P - THUS TAGGING THE CUSTOMERS WITH HIGHEST AMOUNT AND HIGHEST NUMBER OF OPEN DAYS.



				





