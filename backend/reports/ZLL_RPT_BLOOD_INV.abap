*&---------------------------------------------------------------------*
*& Report: ZLL_RPT_BLOOD_INV
*& Description: ALV Report - Blood Inventory with Expiry Alerts
*&---------------------------------------------------------------------*
REPORT zll_rpt_blood_inv.

TYPES: BEGIN OF ty_inventory_report,
         inventory_id     TYPE zll_blood_inv-inventory_id,
         blood_group      TYPE zll_blood_inv-blood_group,
         units            TYPE zll_blood_inv-units,
         hospital_name    TYPE zll_hospital-name,
         city             TYPE zll_hospital-city,
         collection_date  TYPE zll_blood_inv-collection_date,
         expiry_date      TYPE zll_blood_inv-expiry_date,
         storage_location TYPE zll_blood_inv-storage_location,
         status           TYPE zll_blood_inv-status,
         days_to_expiry   TYPE i,
         traffic_light    TYPE char1,
       END OF ty_inventory_report.

DATA: gt_inv   TYPE TABLE OF ty_inventory_report,
      go_alv   TYPE REF TO cl_salv_table.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_bgroup FOR gt_inv-blood_group,
                  s_hosp   FOR gt_inv-hospital_name.
  PARAMETERS:     p_expiry AS CHECKBOX DEFAULT ' '.  "Show only expiring
SELECTION-SCREEN END OF BLOCK b1.

INITIALIZATION.
  TEXT-001 = 'Selection Criteria'.

START-OF-SELECTION.

  SELECT inv~inventory_id, inv~blood_group, inv~units,
         hosp~name AS hospital_name, hosp~city,
         inv~collection_date, inv~expiry_date,
         inv~storage_location, inv~status
    FROM zll_blood_inv AS inv
    INNER JOIN zll_hospital AS hosp ON inv~hospital_id = hosp~hospital_id
    WHERE inv~blood_group IN @s_bgroup
    INTO TABLE @gt_inv.

  " Calculate expiry days and traffic light
  LOOP AT gt_inv ASSIGNING FIELD-SYMBOL(<fs_inv>).
    <fs_inv>-days_to_expiry = <fs_inv>-expiry_date - sy-datum.
    IF <fs_inv>-days_to_expiry <= 0.
      <fs_inv>-traffic_light = '1'. "Red
      <fs_inv>-status = 'Expired'.
    ELSEIF <fs_inv>-days_to_expiry <= 7.
      <fs_inv>-traffic_light = '2'. "Yellow
      <fs_inv>-status = 'Expiring'.
    ELSE.
      <fs_inv>-traffic_light = '3'. "Green
    ENDIF.
  ENDLOOP.

  " Filter expiring only if checkbox set
  IF p_expiry = 'X'.
    DELETE gt_inv WHERE days_to_expiry > 7.
  ENDIF.

END-OF-SELECTION.

  TRY.
      cl_salv_table=>factory(
        IMPORTING r_salv_table = go_alv
        CHANGING  t_table      = gt_inv ).

      go_alv->get_columns( )->set_optimize( abap_true ).
      go_alv->get_functions( )->set_all( abap_true ).
      go_alv->get_display_settings( )->set_list_header( 'LifeLink - Blood Inventory Report' ).
      go_alv->get_display_settings( )->set_striped_pattern( abap_true ).

      " Sort by expiry date
      TRY.
          go_alv->get_sorts( )->add_sort( columnname = 'EXPIRY_DATE' ).
        CATCH cx_salv_not_found cx_salv_existing cx_salv_data_error.
      ENDTRY.

      " Calculate totals
      TRY.
          go_alv->get_aggregations( )->add_aggregation( columnname = 'UNITS' aggregation = if_salv_c_aggregation=>total ).
        CATCH cx_salv_not_found cx_salv_existing cx_salv_data_error.
      ENDTRY.

      go_alv->display( ).

    CATCH cx_salv_msg INTO DATA(lx_msg).
      MESSAGE lx_msg TYPE 'E'.
  ENDTRY.
