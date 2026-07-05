*&---------------------------------------------------------------------*
*& Function Module: ZLL_FM_RECORD_DONATION
*& Description: Records a blood donation and updates donor/inventory
*&---------------------------------------------------------------------*
FUNCTION zll_fm_record_donation.
*"----------------------------------------------------------------------
*" Local Interface:
*"  IMPORTING
*"     VALUE(IV_DONOR_ID) TYPE ZLL_DE_DONOR_ID
*"     VALUE(IV_HOSPITAL_ID) TYPE ZLL_DE_HOSP_ID
*"     VALUE(IV_UNITS) TYPE I DEFAULT 1
*"     VALUE(IV_NOTES) TYPE STRING OPTIONAL
*"  EXPORTING
*"     VALUE(EV_DONATION_ID) TYPE ZLL_DE_DON_ID
*"  EXCEPTIONS
*"     NOT_ELIGIBLE
*"     DONOR_NOT_FOUND
*"     ERROR
*"----------------------------------------------------------------------

  DATA: ls_donor     TYPE zll_donor,
        ls_donation  TYPE zll_don_hist,
        lv_eligible  TYPE abap_bool,
        lv_message   TYPE string,
        lv_remaining TYPE i.

  " Get donor
  SELECT SINGLE * FROM zll_donor INTO ls_donor
    WHERE donor_id = iv_donor_id.

  IF sy-subrc <> 0.
    RAISE donor_not_found.
  ENDIF.

  " Check eligibility
  CALL FUNCTION 'ZLL_FM_CHECK_ELIGIBILITY'
    EXPORTING
      iv_donor_id      = iv_donor_id
    IMPORTING
      ev_eligible      = lv_eligible
      ev_message       = lv_message
      ev_days_remaining = lv_remaining
    EXCEPTIONS
      not_found        = 1
      OTHERS           = 2.

  IF lv_eligible = abap_false.
    RAISE not_eligible.
  ENDIF.

  " Generate Donation ID
  DATA: lv_timestamp TYPE timestamp.
  GET TIME STAMP FIELD lv_timestamp.
  ev_donation_id = 'DON' && lv_timestamp+8(6).

  " Create donation record
  ls_donation-donation_id   = ev_donation_id.
  ls_donation-donor_id      = iv_donor_id.
  ls_donation-blood_group   = ls_donor-blood_group.
  ls_donation-donation_date = sy-datum.
  ls_donation-hospital_id   = iv_hospital_id.
  ls_donation-units         = iv_units.
  ls_donation-notes         = iv_notes.
  ls_donation-created_by    = sy-uname.
  ls_donation-created_on    = sy-datum.

  INSERT zll_don_hist FROM ls_donation.

  " Update donor's last donation date
  UPDATE zll_donor SET
    last_donation = sy-datum,
    changed_by    = sy-uname,
    changed_on    = sy-datum
  WHERE donor_id = iv_donor_id.

  IF sy-subrc <> 0.
    RAISE error.
  ENDIF.

  COMMIT WORK.

ENDFUNCTION.
