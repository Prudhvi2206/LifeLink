*&---------------------------------------------------------------------*
*& Report: ZLL_RPT_DONOR
*& Description: ALV Report - Registered Donors
*&---------------------------------------------------------------------*
REPORT zll_rpt_donor.

*--- Type Definitions ---
TYPES: BEGIN OF ty_donor_report,
         donor_id        TYPE zll_donor-donor_id,
         first_name      TYPE zll_donor-first_name,
         last_name       TYPE zll_donor-last_name,
         blood_group     TYPE zll_donor-blood_group,
         date_of_birth   TYPE zll_donor-date_of_birth,
         gender          TYPE zll_donor-gender,
         phone           TYPE zll_donor-phone,
         email           TYPE zll_donor-email,
         city            TYPE zll_donor-city,
         state           TYPE zll_donor-state,
         weight          TYPE zll_donor-weight,
         last_donation   TYPE zll_donor-last_donation,
         status          TYPE zll_donor-status,
         eligibility(20) TYPE c,
         total_donations TYPE i,
       END OF ty_donor_report.

*--- Data Declarations ---
DATA: gt_donor   TYPE TABLE OF ty_donor_report,
      gs_donor   TYPE ty_donor_report,
      go_alv     TYPE REF TO cl_salv_table,
      gx_msg     TYPE REF TO cx_salv_msg.

*--- Selection Screen ---
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_bgroup FOR gs_donor-blood_group,
                  s_city   FOR gs_donor-city,
                  s_status FOR gs_donor-status DEFAULT 'ACTIVE'.
  PARAMETERS:     p_all    AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK b1.

*--- Initialization ---
INITIALIZATION.
  TEXT-001 = 'Selection Criteria'.

*--- Start of Selection ---
START-OF-SELECTION.

  " Fetch donor data
  SELECT d~donor_id, d~first_name, d~last_name, d~blood_group,
         d~date_of_birth, d~gender, d~phone, d~email,
         d~city, d~state, d~weight, d~last_donation, d~status
    FROM zll_donor AS d
    WHERE d~blood_group IN @s_bgroup
      AND d~city IN @s_city
      AND d~status IN @s_status
    INTO TABLE @gt_donor.

  " Calculate eligibility and donation count
  LOOP AT gt_donor ASSIGNING FIELD-SYMBOL(<fs_donor>).
    " Check eligibility (56-day rule)
    IF <fs_donor>-last_donation IS INITIAL.
      <fs_donor>-eligibility = 'Eligible'.
    ELSE.
      DATA(lv_days) = sy-datum - <fs_donor>-last_donation.
      IF lv_days >= 56.
        <fs_donor>-eligibility = 'Eligible'.
      ELSE.
        DATA(lv_rem) = 56 - lv_days.
        <fs_donor>-eligibility = |Not Eligible ({ lv_rem }d)|.
      ENDIF.
    ENDIF.

    " Count donations
    SELECT COUNT(*) FROM zll_don_hist
      WHERE donor_id = <fs_donor>-donor_id
      INTO <fs_donor>-total_donations.
  ENDLOOP.

*--- Display ALV ---
END-OF-SELECTION.

  TRY.
      cl_salv_table=>factory(
        IMPORTING r_salv_table = go_alv
        CHANGING  t_table      = gt_donor ).

      " Set column headers
      DATA(lo_cols) = go_alv->get_columns( ).
      lo_cols->set_optimize( abap_true ).

      TRY.
          lo_cols->get_column( 'DONOR_ID' )->set_short_text( 'Donor ID' ).
          lo_cols->get_column( 'FIRST_NAME' )->set_short_text( 'First Name' ).
          lo_cols->get_column( 'LAST_NAME' )->set_short_text( 'Last Name' ).
          lo_cols->get_column( 'BLOOD_GROUP' )->set_short_text( 'Blood Grp' ).
          lo_cols->get_column( 'ELIGIBILITY' )->set_short_text( 'Eligibility' ).
          lo_cols->get_column( 'TOTAL_DONATIONS' )->set_short_text( 'Donations' ).
        CATCH cx_salv_not_found.
      ENDTRY.

      " Enable toolbar functions
      go_alv->get_functions( )->set_all( abap_true ).

      " Set title
      go_alv->get_display_settings( )->set_list_header( 'LifeLink - Donor Report' ).
      go_alv->get_display_settings( )->set_striped_pattern( abap_true ).

      " Enable sorting
      DATA(lo_sort) = go_alv->get_sorts( ).
      TRY.
          lo_sort->add_sort( columnname = 'BLOOD_GROUP' ).
        CATCH cx_salv_not_found cx_salv_existing cx_salv_data_error.
      ENDTRY.

      " Display the ALV
      go_alv->display( ).

    CATCH cx_salv_msg INTO gx_msg.
      MESSAGE gx_msg TYPE 'E'.
  ENDTRY.
