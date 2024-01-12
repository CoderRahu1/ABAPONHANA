*&---------------------------------------------------------------------*
*& Report ZRAHUL_HANA_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report ZRAHUL_HANA_04.
"""" TOPICS - 1) PERFORMANCE CHECKS TO BE PERFORMED USING PERFORMANCE_DB.


data : lt_items type table of snwd_so_inv_item.
select * from snwd_so_inv_head into @data(ls_inv_head).

  perform check_items using ls_inv_head.

endselect.

loop at lt_items assigning field-symbol(<fs>).
    "write : / <fs>-gross_amount, <fs>-currency_code. "2nd correction
    perform print_product using <fs>-product_guid.
endloop.

form check_items using p_inv structure snwd_so_inv_head.
  select single * from snwd_so_inv_item into @data(ls_inv_item) where parent_key = @p_inv-node_key.
  if sy-subrc = 0.
    append ls_inv_item to lt_items.
  endif.
endform.

form print_product using lv_prod.

  select single * from snwd_pd into @data(ls_product) where node_key = @<fs>-product_guid. "1st correction

endform.



