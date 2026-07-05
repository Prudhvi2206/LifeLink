*&---------------------------------------------------------------------*
*& Function Module: ZLL_FM_CHECK_ELIGIBILITY
*& Description: Checks if a donor is eligible for blood donation
*& Rules: 56 days since last donation, weight >= 45kg, status Active
*&---------------------------------------------------------------------*
FUNCTION zll_fm_check_eligibility.
*"----------------------------------------------------------------------
*" Local Interface:
*"  IMPORTING
*"     VALUE(IV_DONOR_ID) TYPE ZLL_DE_DONOR_ID
*"  EXPORTING
*"     VALUE(EV_ELIGIBLE) TYPE ABAP_BOOL
*"     VALUE(EV_MESSAGE) TYPE STRING
*"     VALUE(EV_DAYS_REMAINING) TYPE I
*"  EXCEPTIONS
*"     NOT_FOUND
*"----------------------------------------------------------------------

  DATA: ls_donor TYPE zll_donor,
        lv_days  TYPE i.

  " Get donor record
  SELECT SINGLE * FROM zll_donor INTO ls_donor
    WHERE donor_id = iv_donor_id.

  IF sy-subrc <> 0.
    RAISE not_found.
  ENDIF.

  " Check 1: Donor must be Active
  IF ls_donor-status <> 'ACTIVE'.
    ev_eligible = abap_false.
    ev_message = 'Donor status is Inactive. Cannot donate.'.
    RETURN.
  ENDIF.

  " Check 2: Weight must be >= 45 kg
  IF ls_donor-weight < 45.
    ev_eligible = abap_false.
    ev_message = 'Donor weight is below minimum (45 kg).'.
    RETURN.
  ENDIF.

  " Check 3: 56-day gap since last donation
  IF ls_donor-last_donation IS NOT INITIAL.
    lv_days = sy-datum - ls_donor-last_donation.
    IF lv_days < 56.
      ev_eligible = abap_false.
      ev_days_remaining = 56 - lv_days.
      ev_message = |Not eligible. { ev_days_remaining } days remaining (minimum 56 days between donations).|.
      RETURN.
    ENDIF.
  ENDIF.

  " All checks passed
  ev_eligible = abap_true.
  ev_days_remaining = 0.
  ev_message = 'Donor is eligible for blood donation.'.

ENDFUNCTION.
