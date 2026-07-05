*&---------------------------------------------------------------------*
*& Report: ZLL_RPT_EMRG_REQ
*& Description: ALV Report - Emergency Blood Requests
*&---------------------------------------------------------------------*
REPORT zll_rpt_emrg_req.

TYPES: BEGIN OF ty_request_report,
         request_id     TYPE zll_emrg_req-request_id,
         hospital_name  TYPE zll_hospital-name,
         patient_name   TYPE zll_emrg_req-patient_name,
         blood_group    TYPE zll_emrg_req-blood_group,
         units_needed   TYPE zll_emrg_req-units_needed,
         urgency        TYPE zll_emrg_req-urgency,
         contact_person TYPE zll_emrg_req-contact_person,
         status         TYPE zll_emrg_req-status,
         request_date   TYPE zll_emrg_req-request_date,
         approved_date  TYPE zll_emrg_req-approved_date,
         reason         TYPE zll_emrg_req-reason,
       END OF ty_request_report.

DATA: gt_req TYPE TABLE OF ty_request_report,
      go_alv TYPE REF TO cl_salv_table.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_status FOR gt_req-status,
                  s_urgent FOR gt_req-urgency,
                  s_bgroup FOR gt_req-blood_group,
                  s_date   FOR gt_req-request_date.
SELECTION-SCREEN END OF BLOCK b1.

INITIALIZATION.
  TEXT-001 = 'Selection Criteria'.

START-OF-SELECTION.

  SELECT req~request_id, hosp~name AS hospital_name,
         req~patient_name, req~blood_group, req~units_needed,
         req~urgency, req~contact_person, req~status,
         req~request_date, req~approved_date, req~reason
    FROM zll_emrg_req AS req
    INNER JOIN zll_hospital AS hosp ON req~hospital_id = hosp~hospital_id
    WHERE req~status IN @s_status
      AND req~urgency IN @s_urgent
      AND req~blood_group IN @s_bgroup
      AND req~request_date IN @s_date
    INTO TABLE @gt_req
    ORDER BY req~request_date DESCENDING.

END-OF-SELECTION.

  TRY.
      cl_salv_table=>factory(
        IMPORTING r_salv_table = go_alv
        CHANGING  t_table      = gt_req ).

      go_alv->get_columns( )->set_optimize( abap_true ).
      go_alv->get_functions( )->set_all( abap_true ).
      go_alv->get_display_settings( )->set_list_header( 'LifeLink - Emergency Request Report' ).
      go_alv->get_display_settings( )->set_striped_pattern( abap_true ).
      go_alv->display( ).

    CATCH cx_salv_msg INTO DATA(lx_msg).
      MESSAGE lx_msg TYPE 'E'.
  ENDTRY.
