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

-- STEP 1: READ THE CUSTOMIZING,  ALSO READING THE CLIENT VALUE.

SELECT MANDT, MAX_OPEN_DAYS, MAX_AMOUNT, CURRENY_CODE,
CURRENT_DATE INTO LV_CLIENT, LV_MAX_DAYS, LV_GROSS_AMOUNT,
LV_CURRENCY, LV_TODAY                           -- WE CAN CREATE MUTIPLE PARAMS AND STORE VALUES 
FROM ZDP_CUST WHERE USRID = (SELECT UCASE(SESSION_CONTEXT('APPLICATIONUSER')) FROM DUMMY );

-- STEP 2 : CALCULATING OPENDAYS AND CONVERTING TIME STAMPS
SELECT FLOOR(SECONDS_BETWEEN(
			 TO_TIMESTAMP(LEFT(CHANGED_AT,14),'YYYYMMDDHHMISS'),                             -- X VALUE
			 TO_TIMESTAMP(LOCALTOUTC(NOW(), 'CET')))                                         -- Y VALUE AND CET(CENTRAL EUROPEAN TIME)
			 / 24 * 60 * 60 ,0) 
			 AS OPEN_DAYS,
			 
			 
			 
			 

