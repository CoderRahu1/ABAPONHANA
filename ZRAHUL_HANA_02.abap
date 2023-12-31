*&---------------------------------------------------------------------*
*& Report zrahul_hana_02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrahul_hana_02.


*TOPICS : 1.COMMA SEPARATED FIELD LIST :
"         2.ESCAPING OF HOST VARIABLE : IN ABAP WE CAN CREATE A INTERNAL TABLE WITH SAME NAME AS DATABASE TABLE. SO IN ORDER TO INFORM THE SYSTEM THAT WHAT IS MY SOURCE AND WHAT IS MY HOST WE NEED TO NOW USE ESCAPING OF HOST (ITAB). SYMBOL IS @.


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

*DATA : LT_MARA TYPE TABLE OF MARA,
*       LS_MARA LIKE LINE OF LT_MARA.
*
*
*SELECT MATNR, MEINS FROM MARA INTO CORRESPONDING FIELDS OF TABLE @LT_MARA.
*
*LOOP AT LT_MARA INTO LS_MARA.
*WRITE :/ LS_MARA-MATNR, LS_MARA-MEINS.
*ENDLOOP.



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""" INLINE DATA DECLARATION """"""
"""" NOTE : THE ABOVE CODE IS DIRTY AS THE LT_MARA CONTAINS ALL 365 COLUMNS. SYNTAX : DATA(VAR NAME)


*SELECT MATNR, MEINS FROM MARA INTO TABLE @DATA(LT_MARA).
*
*LOOP AT LT_MARA INTO DATA(LS_MARA).
*WRITE :/ LS_MARA-MATNR, LS_MARA-MEINS.
*ENDLOOP.
*
*
*LOOP AT LT_MARA ASSIGNING FIELD-SYMBOL(<FS>).              """" INLINE FIELD SYMBOL DECLARATION.
*WRITE :/ <FS>-MATNR, <FS>-MEINS.
*ENDLOOP.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" NEW LOOP AT ITAB WHICH CONVERT EVERY LINE OF INTERNAL TABLE TO AN OBJECT.

*LOOP AT LT_MARA REFERENCE INTO DATA(LO_LINE).  """" LO STANDS FOR LOCAL OBJECT, LT MEANS LOCAL TABLE AND LS MEANS LOCAL STRUCTURE.
*    WRITE : LO_LINE->matnr, LO_LINE->meins.
*
*ENDLOOP.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" LITERALS IN SQL COMMAMD""""

"""" REQUIREMENT : SUPPOSE THERE IS A REQUIREMENT TO PRINT COMPANY NAMES AND BEFORE EVERY COMPANY NAME YOU ARE SUPPOSED TO PRINT MESSERS.

*SELECT 'M/s' && ' ' && COMPANY_NAME AS COMPANY_NAME FROM SNWD_BPA
*INTO TABLE @DATA(ITAB).
*
*
*LOOP AT ITAB INTO DATA(WA).
*WRITE :/ WA-COMPANY_NAME.
*ENDLOOP.


"""" SO ITS GONNA PUSH THE CODE DOWN TO HANA.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" SQL FUNCTIONS IN SAP FOR PUSHING LOGIC TO HANA.
"""" REQUIREMENT : TO WRITE DOWN SALES ORDER AMOUNT FOR EVERY COMPANY AND ROUND OF THAT VALUE.

*SELECT BUYER_GUID, ROUND( GROSS_AMOUNT, 0 ) AS GROSS_AMOUNT,
*                   CEIL( GROSS_AMOUNT ) AS ROUND_AMOUNT
* FROM SNWD_SO INTO TABLE @DATA(ITAB).                    """" ROUND FUNCTION TO ROUND OF VALUE.
*
*LOOP AT ITAB INTO DATA(WA).
*WRITE :/ WA-BUYER_GUID, WA-GROSS_AMOUNT, WA-ROUND_AMOUNT.
*ENDLOOP.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" CASE EXPRESSIONS""""

"""" REQUIREMENT : TO SHOWCASE BUSINESS PARTNERS.

SELECT COMPANY_NAME, BP_ROLE FROM SNWD_BPA INTO TABLE @DATA(ITAB).

LOOP AT ITAB INTO DATA(WA).
WRITE :/ WA-COMPANY_NAME, WA-BP_ROLE.
ENDLOOP.
