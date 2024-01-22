*&---------------------------------------------------------------------*
*& Report ZRAHUL_HANA_09.
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRAHUL_HANA_09.




""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" TOPICS - 1) CONSUMING VIEW PROXY. 2) MUCH SIMPLE THAN ADBC.



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" FIRING SELECT QUERY.

SELECT BP_ID, COMPANY_NAME, AVG( OPEN_DAYS ) AS OPEN_DAYS,
SUM( CONV_GROSS_AMOUNT ) AS GROSS_AMOUNT,
CONV_GROSS_AMOUNT_CURRENCY FROM ZJAN_VP
GROUP BY BP_ID, COMPANY_NAME, CONV_GROSS_AMOUNT_CURRENCY
INTO TABLE @DATA(ITAB).

CL_DEMO_OUTPUT=>display_data(
  EXPORTING
    value   = ITAB
*    name    =
*    exclude =
*    include =
).
