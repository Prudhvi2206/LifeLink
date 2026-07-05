*&---------------------------------------------------------------------*
*& Report: ZLL_RPT_DONATION
*& Description: ALV Report - Donation History
*&---------------------------------------------------------------------*
REPORT zll_rpt_donation.

TYPES: BEGIN OF ty_donation_report,
         donation_id    TYPE zll_don_hist-donation_id,
         donor_id       TYPE zll_don_hist-donor_id,
         donor_name(80) TYPE c,
         blood_group    TYPE zll_don_hist-blood_group,
         donation_date  TYPE zll_don_hist-donation_date,
         hospital_name  TYPE zll_hospital-name,
         units          TYPE zll_don_hist-units,
         notes          TYPE zll_don_hist-notes,
       END OF ty_donation_report.

DATA: gt_don TYPE TABLE OF ty_donation_report,
      go_alv TYPE REF TO cl_salv_table.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_date   FOR gt_don-donation_date,
                  s_donor  FOR gt_don-donor_id,
                  s_bgroup FOR gt_don-blood_group.
SELECTION-SCREEN END OF BLOCK b1.

INITIALIZATION.
  TEXT-001 = 'Selection Criteria'.

START-OF-SELECTION.

  SELECT don~donation_id, don~donor_id,
         concat_with_space( d~first_name, d~last_name, 1 ) AS donor_name,
         don~blood_group, don~donation_date,
         hosp~name AS hospital_name, don~units, don~notes
    FROM zll_don_hist AS don
    INNER JOIN zll_donor AS d ON don~donor_id = d~donor_id
    INNER JOIN zll_hospital AS hosp ON don~hospital_id = hosp~hospital_id
    WHERE don~donation_date IN @s_date
      AND don~donor_id IN @s_donor
      AND don~blood_group IN @s_bgroup
    INTO TABLE @gt_don
    ORDER BY don~donation_date DESCENDING.

END-OF-SELECTION.

  TRY.
      cl_salv_table=>factory(
        IMPORTING r_salv_table = go_alv
        CHANGING  t_table      = gt_don ).

      go_alv->get_columns( )->set_optimize( abap_true ).
      go_alv->get_functions( )->set_all( abap_true ).
      go_alv->get_display_settings( )->set_list_header( 'LifeLink - Donation History Report' ).
      go_alv->get_display_settings( )->set_striped_pattern( abap_true ).

      TRY.
          go_alv->get_aggregations( )->add_aggregation( columnname = 'UNITS' aggregation = if_salv_c_aggregation=>total ).
        CATCH cx_salv_not_found cx_salv_existing cx_salv_data_error.
      ENDTRY.

      go_alv->display( ).

    CATCH cx_salv_msg INTO DATA(lx_msg).
      MESSAGE lx_msg TYPE 'E'.
  ENDTRY.
