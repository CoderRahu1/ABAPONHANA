*********************************************************************************************************************
"""" SELECT QUERY TO BE USED IN THE OIA SENARIO.
*SELECT BP_ID, COMPANY_NAME,
*ROUND(AVG(OPEN_DAYS),0) AS OPEN_DAYS,
*SUM(CONV_GROSS_AMOUNT) AS GROSS_AMOUNT,
*CONV_GROSS_AMOUNT_CURRENCY FROM "_SYS_BIC"."ZVIEWS_PKG/CV_OIA" ('PLACEHOLDER' = ('$$IM_CURR$$','USD'))
*GROUP BY BP_ID, COMPANY_NAME, CONV_GROSS_AMOUNT_CURRENCY

*********************************************************************************************************************

"""" PROGRAM FOR ADBC .
