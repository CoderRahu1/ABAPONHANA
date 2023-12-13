*&---------------------------------------------------------------------*
*& Report zrahul_hana_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


"""" TOPIC -BASIC PROG ON HANA 01


REPORT zrahul_hana_01.

data: lv_matnr type matnr.
.

select single matnr into lv_matnr from mara.

LOOP AT LV_MATNR INTO WA.
WRITE :/ WA-A, WA-B.
ENDLOOP.


  write : lv_matnr.
