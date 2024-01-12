*&---------------------------------------------------------------------*
*& Report ZRAHUL_HANA_06.
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRAHUL_HANA_06.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" IMPROVING PERFORMANCE OF THE PROGRAM WHICH TOOK 327 MS.
"""" 1) SHOULD NOT USE SELECT *.
"""" 2) SHOULD USE AGGREGATE FUNTIONS(GROUP BY ETC).

"""" RUNTIME OF THE PROGRAM - 27 MS.










""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" NOTE - THERE MIGHT BE SENARIO WHERE THERE  MIGHT NOT BE ANY DATA IN THE TABLES TO TRY OIA SENARIO.
""""        SO NEED TO GENERATE SALES ORDER AND SALES ORDER AND SALES ORDER ITEM DATA TO DO THAT USE CTRL + 6.
""""        USE TCODE CALLED SEPM_DG (DG = DATA GENERATOR) TO GENERATE BASIC DATA.
""""        CLICK RECRETE > 2000 SALES ORDERS > 2000 PURCHASE ORDERS > EXECUTE.














""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

*SENARIO
*
*Mr. Jems is working in ITeIO as account receivable accountant.
*He is 59 year old, lives in down town near lake side. 
*He is a proud father of 2 girls studying in high school. 
*He drives Audi A8 model and a lover of art and music. 
*He is a seasonal gold player as well. 
*Working in this company since last 26 year by now and has very good report across colleagues

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


*Account Receivable accountant
*
*Cash plays a very important role for the future growth of a company, 
*it is in the upmost interest for a company to collect pending dues from the customer very much on time. 
*Pulling this money, the company can pump it back into the system and expand the growth plans for future better at faster pace.
*Mr. Jems job demands him to 
*find all the open invoices (unpaid) from the SAP system and mark customers with a risk level in terms of ability to pay their due bills. 
*The classification will be based upon a threshold level which includes average no. of days the invoices are due and the total amount which is due.




"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
******* HIGH LEVEL DESIGN *******

*1.Create customizing table which can contain user specific threshold value
*2.Find out since how long on average the invoices are open
*      A.Go to invoice header table and find from SNWD_SO_INV_HEAD open invoice PAYMENT_STATUS = ‘’
*      B.Calculate since when each invoice is open = TODAY-WHEN_INV_CHANGED
*      C.Calculate how many invoices are pending 
*      D.Average days since when invoice is pending = Total Days since / Count of open invoices
*      E.Join the invoice data with BP to get Company Details– SNWD_BPA
*3.Total amount for unpaid invoices which is due in common currency
*      A.Find out all the items in foreign currency for PENDING invoices – SNWD_SO_INV_ITEM
*      B.Convert the amount in a common currency from customizing tableS
*      C.Total of the amount which is pending
*      D.Join this data with BPA
*      E.Combine it with result of step 2
*4.Read the customizing from table – Check if it exceeds the Threshold, Tag customer as High Risk
*5.Perform Dunning to customer for unpaid bills (manual) 

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" DOING STEPS ONE BY ONE.


TYPES : BEGIN OF TY_OPEN_DAYS,                                     """" FOR FINDING TOTAL NUMBER OF DUE DAYS AND OPEN DAYS FOR THE INVOICE.
        BP_ID TYPE SNWD_BPA-BP_ID,                                 """" BUSINESS PARTNER ID.
        company_name TYPE SNWD_BPA-company_name,                   """" COMPANY NAME.
        OPEN_DAYS TYPE INT4,                                       """" NUMBER OF OPEN DAYS STORED HERE.
        INV_COUNT TYPE INT4,                                       """" NUMBER OF INVOICES WHICH ARE DUE/OPEN STORED HERE
        END OF TY_OPEN_DAYS,
        
        BEGIN OF TY_AMOUNT,                                        """" FOR FINDING THE AMOUNT IT CROSSED.
        BP_ID TYPE SNWD_BPA-BP_ID,                                     
        GROSS_AMOUNT TYPE SNWD_SO_INV_ITEM-GROSS_AMOUNT,           """" FINDING THE TOTAL DUE AMOUNT.
        CURRENCY_CODE TYPE SNWD_SO_INV_ITEM-currency_code,         """" COMPARING THE CURRENCY.
        END OF TY_AMOUNT,
        
        BEGIN OF TY_OIA,                                           """" FINAL STRUCTURE FOR CLUBBING ALL THE INVOICES WHICH CROSSES OPEN DAYS AND EXCEEDING THE THRESHOLD VALUE.
        BP_ID TYPE SNWD_BPA-BP_ID,                                 """" FINAL INTERNAL TABLE RECORD IS HOLDED HERE WHICH WILL BE DISPLAYED.
        company_name TYPE SNWD_BPA-company_name,
        OPEN_DAYS TYPE INT4,
        GROSS_AMOUNT TYPE SNWD_SO_INV_ITEM-GROSS_AMOUNT,
        CURRENCY_CODE TYPE SNWD_SO_INV_ITEM-currency_code,
        TAGGING TYPE FLAG,
        END OF TY_OIA.
        
        
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""" NOW CREATING INTERNAL TABLE TO HOLD DATA FROM THE STRUCTURE RECORD.
 DATA : LT_OPEN_DAYS TYPE TABLE OF TY_OPEN_DAYS,
        LS_OPEN_DAYS LIKE LINE OF LT_OPEN_DAYS,
        LT_AMOUNT TYPE TABLE OF TY_AMOUNT,
        LS_AMOUNT LIKE LINE OF LT_AMOUNT,
        LT_OIA TYPE TABLE OF TY_OIA,
        LS_OIA LIKE LINE OF LT_OIA.
        
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""" CALCULATING THE PROGRAM PERFORMANCE.


DATA(LO_TIMER) = cl_abap_runtime=>create_hr_timer(  ).
DATA(T1) = LO_TIMER->get_runtime( ).


                            
                            
                                                  )
        
        
        
        
        
        
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" TAKT 1.

"""" FIRST PART OF THE INFORMATION (WE GOT THE OPEN DAYS).





*1.Create customizing table which can contain user specific threshold value

SELECT SINGLE * FROM ZDP_CUST INTO @DATA(LS_CUST) where usrid = @sy-uname.
"""" SO WHOM SO EVER RUN THIS REPORT BASED ON THEIR CURRENT USER NAME WE WILL READ THE CUSTOMIZING.
*C.Calculate how many invoices are pending AND HOW MANY ARE DUE.

SELECT head~changed_at, bpa~bp_id, bpa~company_name, COUNT( * ) as INV_COUNT FROM SNWD_SO_INV_HEAD AS HEAD INNER JOIN SNWD_BPA AS BPA 
ON HEAD~buyer_guid = BPA~node_key INTO @DATA(LS_DAYS) WHERE HEAD~PAYMENT_STATUS = ''
GROUP BY head~changed_at, bpa~bp_id, bpa~company_name.

"""" NOW DECLARE A TABLE TYPE WHERE WE WOULD BE STORING TOTAL NUMBER OF DAYS WHICH IS DUE.

"""" NOW CHECKING SINCE HOW MANY DAYS THE INVOICE IS OPEN.
"""  1. CONVERT TIME TO DATE
"""  2. FROM DATE NEED TO SUBTRACT TODAYS DATE.(SY-DATUM - DATE WHEN INVOICE CHANGED[CONVERT TIME STAMP TO DATE])SO THIS WILL GIVE SINCE HOW MANY DAYS INVOICE IS OPEN.
"""  3. CALCULATE OPEN DAYS FOR EVERY CUSTOMER.
"""  4. TOTAL OPEN DAYS PER CUSTOMER.
"""  5. ALSO TOTAL THE INVOICE COUNT.
"""  6. TOTAL NUMBER OF INVOICES / COUNT WILL GIVE THE AVERAGE.

        CONVERT TIME STAMP LS_DAYS-CHANGED_AT TIME ZONE SY-zonlo INTO DATE DATA(LV_DATE).
        
        """" DIFFERENCE BETWEEN LAST CHANGED DATE AND TODAYS DATE.
        
        LS_OPEN_DAYS-open_days = ( SY-DATUM - LV_DATE ) * LS_DAYS-INV_COUNT .
        """" MISSING SOMETHING IN THE ABOVE STATEMENT - WE DON'T WANT DIFFERENCE OF ALL INVOICES WE ARE INTRESTED ONLY IN INVOICES WHICH ARE OPEN.
        """" SO USE WHERE  IN THE ABOVE SELECT WITH WHERE HEAD~PAYMENT_STATUS = ''.
        
        LS_OPEN_DAYS-inv_count = LS_DAYS-INV_COUNT.
        ls_open_days-BP_ID = LS_DAYS-bp_id.
        LS_OPEN_DAYS-company_name = LS_DAYS-company_name.
        
        
        
        COLLECT LS_OPEN_DAYS INTO LT_OPEN_DAYS.                  """" SUM THE VALUES WHICH ARE NUMERIC BASED ON NON NUMERIC VALUES.
 
ENDSELECT.  

*Average days since when invoice is pending = Total Days since / Count of open invoices

"""" TRYING TO SEE THE OUTUT BY LOOPING 
LOOP AT  LT_OPEN_DAYS INTO LS_OPEN_DAYS.

MOVE-CORRESPONDING LS_OPEN_DAYS TO LS_OIA.

"""" NOW COMPUTING THE OPEN DAYS.

"""" CALCULATING THE AVRAGE HERE.
LS_OIA-open_days = LS_OPEN_DAYS-open_days / LS_OPEN_DAYS-inv_count.

*APPEND LS_OIA TO LT_OIA.    """" INITIAL UNCOMMENTED IN TAKT 2.


"""" TAKT 3(PREPARING THE FINAL OIA).

READ TABLE LT_AMOUNT INTO LS_AMOUNT WITH KEY BP_ID = LS_OIA-bp_id.
LS_OIA-gross_amount = LS_AMOUNT-gross_amount.
LS_OIA-currency_code = LS_AMOUNT-currency_code.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" NOW TAGGING LEFT SO AS TO COMPARE 

IF LS_OIA-gross_amount > LS_CUST-max_amount AND LS_OIA-open_days > LS_CUST-max_open_days.
    LS_OIA-tagging = ABAP_TRUE.
    
ELSE.
    LS_OIA-tagging = ABAP_FALSE.    

ENDIF.


APPEND LS_OIA TO LT_OIA.



ENDLOOP.
DATA(T2) = LO_TIMER->get_runtime( ).
DATA(T3) = ( T2 - T1 ) / 1000.

"""" NOW PRINTING THE TIME ON THE SCREEN.

cl_demo_output=>write_text( text = |time taken was { t3 } ms| ).



cl_demo_output=>display_data(                    """" BUILT IN NEW CLASS PROVIDED BY SAP TO SEE ALV DATA IN POP UP.
  EXPORTING
    value   = LT_OIA
*    name    = 
*    exclude = 
*    include = 
).




""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" TAKT 2 (AMOUNT PART ).
"""" TOTAL AMOUNT OF UNPAID INVOICES FROM ITEM TABLE.

*3.Total amount for unpaid invoices which is due in common currency
*      A.Find out all the items in foreign currency for PENDING invoices – SNWD_SO_INV_ITEM
*      B.Convert the amount in a common currency from customizing tableS
*      C.Total of the amount which is pending
*      D.Join this data with BPA
*      E.Combine it with result of step 2

"""" Q - WHY DO WE NEED HEADER TABLE?
"""" A - BECAUSE OF PAYMENT STATUS BEING LOCATED IN THE HEADER TABLE.

SELECT BPA~BP_ID,SUM( ITEM~GROSS_AMOUNT ) AS GROSS_AMOUNT,
         ITEM~CURRENCY_CODE FROM SNWD_SO_INV_ITEM AS ITEM INNER JOIN SNWD_SO_INV_HEAD AS HEAD 
         ON ITEM~parent_key = HEAD~node_key INNER JOIN SNWD_BPA AS BPA 
         ON HEAD~buyer_guid = BPA~node_key INTO @DATA(LS_OPEN_AMOUNT)
         WHERE HEAD~payment_status = ''
         GROUP BY BPA~BP_ID, ITEM~CURRENCY_CODE .
         
"""" Q - WHY ARE WE USING SELECT AND END SELECT? AND NOT INTO ITAB.
"""" A - BECAUSE OF BEING FRESHER.


"""" NOW CONVERTING THE CURRENCY.

CALL FUNCTION 'CONVERT_TO_LOCAL_CURRENCY'
  EXPORTING
*    client            = SY-MANDT
    date              = SY-DATUM
    foreign_amount    = LS_OPEN_AMOUNT-item-gross_amount
    foreign_currency  = LS_OPEN_AMOUNT-item-currency_code
    local_currency    = LS_CUST=currency-code
*    rate              = 0
*    type_of_rate      = 'M'
*    read_tcurr        = 'X'
  IMPORTING
*    exchange_rate     = 
*    foreign_factor    = 
    local_amount      = LS_AMOUNT-gross_amount 
        .

"""" NOW CURRENCY CODE WHICH IS FIXED TO THE CUSTOMIZING CURRENCY.
LS_AMOUNT-currency_code = LS_CUST-curreny_code.
LS_AMOUNT-bp_id = ls_open_amount-bpa-bp_id.
COLLECT LS_AMOUNT INTO LT_AMOUNT.

"""" TAKT 2 - COMPLETE .
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" TAKT 3 (NEED TO COMBINE THE FINAL DATA INTO THE FINAL OIA).
"""" WHICH IS DONE INSIDE LOOP OF THE OIA.
