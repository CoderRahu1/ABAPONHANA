*&---------------------------------------------------------------------*
*& Report ZRAHUL_HANA_03
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRAHUL_HANA_03.

"""" TOPICS - 1) FUNCTIONAL DB CHECKS TO BE PERFORMED.


DATA: ITAB TYPE TABLE OF SFLIGHT,
      WA   TYPE SFLIGHT.

SELECT * FROM SFLIGHT INTO TABLE ITAB
         WHERE CARRID = 'LH' AND CONNID = '0400' .

READ TABLE ITAB INTO WA WITH KEY
CARRID = 'LH' CONNID = '0400' FLDATE = '20130101' BINARY SEARCH.

SELECT * FROM SFLIGHT INTO TABLE ITAB WHERE CARRID = 'LH' AND
CONNID = '0400' .
DELETE ADJACENT DUPLICATES FROM ITAB COMPARING CARRID.

SORT ITAB BY CARRID.
LOOP AT ITAB INTO WA.
  AT NEW CARRID.
    WRITE: / WA-CARRID, WA-CONNID.
  ENDAT.
ENDLOOP.


*&---------------------------------------------------------------------*
*& Report ZAOH_INCOMPATIBLE_MATNR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZAOH_INCOMPATIBLE_MATNR.

**incompatible material types

data: lv_matnr type char13, "--> matnr
      wa type matdoc.

select SINGLE * FROM matdoc INTO wa WHERE matnr like 'A%'.
lv_matnr = wa-matnr.

WRITE : lv_matnr.



*&---------------------------------------------------------------------*
*& Report ZAOH_INCOMPATIBLE_TCODE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZAOH_INCOMPATIBLE_TCODE.
**incompatible tcode
PARAMETERS : tr1 RADIOBUTTON GROUP g1,
             tr2 RADIOBUTTON GROUP g1.
data : lv_tcode type TCODE.

IF tr1 = 'X'.
 CALL TRANSACTION 'MB11' WITHOUT AUTHORITY-CHECK.
 ""REPLACE WITH MB11 -> MIGO
ELSE.
  CALL TRANSACTION 'MATGRP03' WITHOUT AUTHORITY-CHECK. ""MATGRP03 -> WMATGRP03
ENDIF.


*&---------------------------------------------------------------------*
*& Report ZAOH_INCOMPATIBLE_TYPES
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZAOH_INCOMPATIBLE_TYPES.


**incompatible type
data: lv_vbtyp type vbtyp VALUE 'L'. ""VBTYPL data type
call function 'SD_SALESDOCUMENT_DISPLAY'
  exporting
    i_vbeln            = '0000011'
    I_VBTYP_L          = lv_vbtyp
 EXCEPTIONS
   NO_AUTHORITY       = 1
   OTHERS             = 2
          .
*if sy-subrc <> 0.
** Implement suitable error handling here
*endif.


*&---------------------------------------------------------------------*
*& Report ZAOH_OBSOLETE_TABLE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZAOH_OBSOLETE_TABLE.

"VBUK -> VBAK
data: ls_vbak type VBUK,
      lv_gbstk type gbstk.

select SINGLE * from VBAK INTO ls_vbak.
LV_GBSTK = ls_vbak-gbstk.

IF sy-subrc = 0.
  WRITE : lv_gbstk.
ENDIF.


*&---------------------------------------------------------------------*
*& Report ZSOH_PRICING_COND_READ
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSOH_PRICING_COND_READ.

SELECT SINGLE * FROM konv INTO @DATA(LS_KONV). "prcd_elements
write : / LS_KONV-kawrt.



*&---------------------------------------------------------------------*
*& Report ZSUPPLIER_DATA_GET
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSUPPLIER_DATA_GET.

call TRANSACTION 'XK01'.

