*&---------------------------------------------------------------------*
*& Report ZRAHUL_HANA_08
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRAHUL_HANA_08.


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" TOPIC - 1) CONSUMING VIEWS(CALCULATION VIEWS) CREATED IN HANA DATABASE INTO THE ABAP PROGRAM USING ADBC(ABAP DATABASE CONNECTIVITY).





""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
TYPES : BEGIN OF TY_OIA,
            BP_ID TYPE SNWD_BPA-bp_id,
            COMPANY_NAME TYPE SNWD_BPA-company_name,
            OPEN_DAYS TYPE INT4,
            GROSS_AMOUNT TYPE SNWD_SO-gross_amount,
            CURRENCY_CODE TYPE SNWD_SO-currency_code,
        END OF TY_OIA.

PARAMETERS : P_CURR TYPE SNWD_SO-currency_code.

DATA : ITAB TYPE STANDARD TABLE OF TY_OIA,
       WA LIKE LINE OF ITAB,
       LR_DATA TYPE REF TO DATA,                                                               """" WATCH OOPS RTTS VEDIO -48 MINUTES.
       LV_QUERY TYPE STRING.

GET REFERENCE OF ITAB INTO LR_DATA.


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

LV_QUERY = |SELECT BP_ID, COMPANY_NAME, | &&
| ROUND(AVG(OPEN_DAYS),0) AS OPEN_DAYS, | &&
| SUM(CONV_GROSS_AMOUNT) AS GROSS_AMOUNT, | &&
| CONV_GROSS_AMOUNT_CURRENCY FROM | &&
| "_SYS_BIC"."ZVIEWS_PKG/CV_OIA" ('PLACEHOLDER' = ('$$IM_CURR$$','{ P_CURR }')) | &&
| GROUP BY BP_ID, COMPANY_NAME, CONV_GROSS_AMOUNT_CURRENCY|.


try.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" ACTUAL ADBC CODE STARTS HERE

 DATA(lo_sql_conn) = cl_sql_connection=>get_connection(
*                       con_name = 'SECONDARY DATABASE CAN BE PASSED HERE'
*                       sharable = space
                     ).

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" NOW USING CONNECTION OBJECT CREATING STATEMENT OBJECT.

DATA(LO_SQL_STATEMENT) = lo_sql_conn->create_statement(  ).                  """" inline data declaration.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" execute the query.

data(lo_query) = lo_sql_statement->execute_query(                                             """" this statement won't execute the query , it would keep the query in the buffer.
  EXPORTING
    statement             = lv_query
).

"""" EXAMPLE - I BOUGHT THE CAR(QUERY) BUT DIDN'T PROVIDE THE GARAGECONTAINER/ ITAB).
"""" NOTE - THIS DATA CANNOT BE A TYPED DATA. IT HAS TO BE A UNTYPED OR A DYNAMIC DATA TYPE.






""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" SET THE CONTAINER WHERE WILL THE DATA COME.
""""  we tell the system what is my container to store data which comes from  DB.


lo_query->set_param_table(
  EXPORTING
    itab_ref             = lr_data
).

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" shoots the query into the database.


"""" sending this query to db and loading data into the internal table - shoots the query.

lo_query->next_package( ).                             """" its time to shoot the moment its done its fired to the database. this will do the job it will
                                                      """" go to the database once it grabs the data it will eventually be received by my system.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" closing the query.

lo_query->close( ).


"""" all the data will finally come into the itab.


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" NOW JUST LOOP OVER THE DATASET AND PRINT THE DATA.
"""" OR CAN USE THE CLASS CL_DEMO_OUTPUT.


cl_demo_output=>display_data(
  EXPORTING
    value   = itab
*    name    =
*    exclude =
*    include =
).

catch cx_sql_exception into DATA(lo_ex).
ENDTRY.



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" NOTE - cl_sql_connection is called the adbc class.
"""" and the above whole stuff is called adbc technique to load data.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" o/p - showing the data from hana views into the abap system as kind of alv reports.


