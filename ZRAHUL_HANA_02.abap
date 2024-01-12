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

*SELECT COMPANY_NAME, BP_ROLE FROM SNWD_BPA INTO TABLE @DATA(ITAB).

*LOOP AT ITAB INTO DATA(WA).
*WRITE :/ WA-COMPANY_NAME, WA-BP_ROLE.
*ENDLOOP.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""" INLINE DATA DECLARATION

"""" SYNTAX : DATA(VARNAME)


*SELECT MATNR, MEINS FROM MARA INTO TABLE @DATA(LT_MARA).    """" NOW THIS WILL HAVE ONLY 2 COLUMN SINCE IT ALLOCATES DYNAMICALLY.
*
*LOOP AT lt_mara INTO DATA(ls_mara).
*WRITE: / ls_mara-MATNR, ls_mara-MEINS.
*ENDLOOP.


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" FIELD-SYMBOL - CAN BE DECLARED SAME WAY AS IN ECC.

*SELECT MATNR, MEINS FROM MARA INTO TABLE @DATA(LT_MARA).
*
*LOOP AT LT_MARA ASSIGNING FIELD-SYMBOL(<FS>).
*
*WRITE : / <FS>-MATNR, <FS>-MEINS.
*
*ENDLOOP.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" NEW LOOP SYNTAX TO CONVERT EVERY LINE OF INTERNAL TABLE INTO AN OBJECT.

*SELECT MATNR, MEINS FROM MARA INTO TABLE @DATA(LT_MARA).
*
*LOOP AT LT_MARA REFERENCE INTO DATA(LO_LINE).
*
*WRITE : / LO_LINE->MATNR, LO_LINE->MEINS.
*
*ENDLOOP.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" LITERALS.
"""" CAN PASS LITERALS INTO THE SQL COMMAND.

"""" REQ- SUPPOSE THERE IS REQUIREMENT TO PRINT COMPANY NAMES BEFORE EVERY COMPANY NAME YOU ARE SUPPOSED TO PRINT MESSERS TO WRITE ADDRESS.

*SELECT 'M/s' && ' ' && COMPANY_NAME AS COMPANY_NAME FROM SNWD_BPA INTO TABLE @DATA(ITAB).
*
*LOOP AT ITAB INTO DATA(WA).
*    WRITE : / WA-COMPANY_NAME.
*ENDLOOP.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" SQL FUNCTIONS IN SAP FOR PUSHING LOGIC TO HANA.
"""" REQ- WRITE DOWN THE SALES ORDER AMOUNT FOR EVERY COMPANY TO ROUND OF THAT VALUE.

*SELECT BUYER_GUID , GROSS_AMOUNT FROM SNWD_SO INTO TABLE @DATA(ITAB).
*
*LOOP AT ITAB INTO DATA(WA).
*WRITE: / WA-BUYER_GUID, WA-GROSS_AMOUNT.
*ENDLOOP.

"""" NOW USING THE ROUND AND CEIL FUNTION.

*SELECT BUYER_GUID, ROUND( GROSS_AMOUNT , 0 ) AS GROSS_AMOUNT, 
*    CEIL( GROSS_AMOUNT ) AS ROUND_AMOUNT FROM SNWD_SO INTO TABLE @DATA(ITAB).
*
*LOOP AT ITAB INTO DATA(WA).
*WRITE: / WA-BUYER_GUID, WA-GROSS_AMOUNT, WA-ROUND_AMOUNT.
*ENDLOOP.    

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""COLLECT STATEMENT

types: begin of ty_sample,
        company type c length 30,
        sales   type int4,
       end of ty_sample.

data: itab type table of ty_sample,
      wa type ty_Sample.

wa-company = 'IBM'.
wa-sales = 200.
COLLECT wa into itab.
wa-company = 'SAP'.
wa-sales = 200.
COLLECT wa into itab.
wa-company = 'IBM'.
wa-sales = 300.
COLLECT wa into itab.
wa-company = 'IBM'.
wa-sales = 100.
COLLECT wa into itab.
wa-company = 'SAP'.
wa-sales = 500.
COLLECT wa into itab.
wa-company = 'IBM'.
wa-sales = 50.
COLLECT wa into itab.


loop at itab into wa.
write: / wa-company, wa-sales.
endloop.




"Table Expression

*data(itab) = value ztt_oia( ( bp_id = 11000 gross_amount = 65000 )
*                            ( bp_id = 12000 gross_amount = 65000 )
*                            ( bp_id = 13000 gross_amount = 65000 ) ).
*
*read table itab into data(wa) with key bp_id = 13000.
*
*if line_exists( itab[ bp_id = 14000 ] ).
*    data(wa1) = itab[ bp_id = 14000 ].
*endif.
*
*write : / wa1-bp_id, wa1-gross_amount.


"New Class Syntax for object creation
*data: lo_obj type ref to cl_start_activate_utility.
*
*create object lo_obj.

*data(lo_obj) = new cl_start_activate_utility(  ).



"Value expression, Corresponding
*types: begin of ty_team,
*           teamname type c length 20,
*           captain  type c length 30,
*           score    type i,
*       end of ty_team,
*       tt_team type standard table of ty_team with default key,
*       begin of ty_team2,
*           scrum    type c length 20,
*           lead     type c length 30,
*           goals    type i,
*       end of ty_team2,
*       tt_team2 type standard table of ty_team2 with default key.
*
*data : itab type table of ty_team,
*       jtab type table of ty_team2.
*
*itab = value #( ( teamname = 'RCB' captain = 'Ganguly' score = 20 )
*                ( teamname = 'RR' captain = 'Watson' score = 50 )
*                ( teamname = 'KKR' captain = 'Tendulkar' score = 80 ) ).
*
**data(itab) = value tt_team( ( teamname = 'RCB' captain = 'Ganguly' score = 20 )
**                            ( teamname = 'RR' captain = 'Watson' score = 50 )
**                            ( teamname = 'KKR' captain = 'Tendulkar' score = 80 ) ).
*
*"Simple copy of data and creation of table
*"jtab = corresponding #( itab ).
*
*
*"If the target and source column names are not same, we can use a new syntax
*"jtab = corresponding #( itab mapping scrum = teamname lead = captain goals = score  ).
*
*"If we want to change some values before the values are moved to target
*jtab = value #( for line in itab ( scrum = line-teamname
*                                lead = line-captain
*                                goals = line-score * 110 / 100 ) ).
*
**data: itab type table of ty_team,
**      wa   type ty_team.
**
**wa-teamname = 'RCB'.
**wa-captain = 'Ganguly'.
**wa-score = 20.
**append wa to itab.
**wa-teamname = 'RR'.
**wa-captain = 'Watson'.
**wa-score = 50.
**append wa to itab.
**wa-teamname = 'KKR'.
**wa-captain = 'Tendulkar'.
**wa-score = 150.
**append wa to itab.
*
*loop at itab into data(wa).
*write: / wa-teamname, wa-captain, wa-score.
*endloop.
*uline.
*loop at jtab into data(wa2).
*write: / wa2-scrum, wa2-lead, wa2-goals.
*endloop.



"String Expression - Concatenation and print I Love 'India'
*data: lv_string type string,
*      lv_ctry type c length 20 value 'India'.
*
*"concatenate 'I Love ' '''' 'India' '''' into lv_string respecting blanks.
*lv_string = |I love '{ lv_ctry }'|.
*write : lv_string.



"Use of Agg functions inside SQL Case

*select buyer_guid, sum( gross_amount ) as gross_amount,
*                case
*                when sum( gross_amount ) > 2000000 then 'X'
*                else ' ' end as ord_type
*             from snwD_so
*              group by buyer_guid
*              having sum( gross_amount ) > 2000000
*              into table @data(itab).
*
*loop at itab into data(wa).
*write: / wa-buyer_guid, wa-gross_amount, wa-ord_type.
*endloop.



"Complex case
*select so_id, gross_amount,
*            case
*                when gross_amount >= 100000 then 'High'
*                when gross_amount < 1000000 and gross_amount > 25000 then 'Medium'
*                else 'Low' end as order_type
*            from snwD_so into table @data(itab).
*
*loop at itab into data(wa).
*write: / wa-so_id, wa-gross_amount, wa-order_type.
*endloop.



"Simple case with SQL
*select company_name,
*                    case bp_role
*                    when '1' then 'Customer'
*                    when '2' then 'Supplier'
*                    when '4' then 'Contractor'
*                    else 'i dont know'
*                    end as bp_role
* from snwd_bpa into table @data(itab).
*
*loop at itab into data(wa).
*write: / wa-company_name, wa-bp_role.
*endloop.


"SQL Functions in SAP for pushing logic to HANA
*Select buyer_guid, round( gross_amount, 0 ) as gross_amount,
*                   ceil( gross_amount ) as round_amount
*       from snwd_so into table @data(itab).
*
*loop at itab into data(wa).
*write: / wa-buyer_guid, wa-gross_amount, wa-round_amount.
*endloop.


"Literals in SQL Command
*select 'M/s' && ' ' && company_name as company_name from snwd_bpa
*into table @data(itab).
*
*loop at itab into data(wa).
*write: / wa-company_name.
*endloop.


"Inline data declaration - data(varname)

*select matnr, meins from mara into table @data(lt_mara).
*
*loop at lt_mara into data(ls_mara).
*write: / ls_mara-matnr, ls_mara-meins.
*endloop.
*loop at lt_mara assigning field-symbol(<fs>).
*write: / <fs>-matnr, <fs>-meins.
*endloop.
*"New loop at itab which convert every line of internal table to an object
*loop at lt_mara reference into data(lo_line).
*    write : lo_line->matnr, lo_line->meins.
*endloop.


"Comma seprated field list and escaping of host variable-SQL
*data: lt_mara type table of mara,
*      ls_mara like line of lt_mara.
*
*select matnr, meins from mara into corresponding fields of table @lt_mara.
*
*loop at lt_mara into ls_mara.
*write: / ls_mara-matnr, ls_mara-meins.
*endloop.






