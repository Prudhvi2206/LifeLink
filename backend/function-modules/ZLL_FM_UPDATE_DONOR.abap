*&---------------------------------------------------------------------*
*& Function Module: ZLL_FM_UPDATE_DONOR
*& Description: Updates an existing donor record
*&---------------------------------------------------------------------*
FUNCTION zll_fm_update_donor.
*"----------------------------------------------------------------------
*" Local Interface:
*"  IMPORTING
*"     VALUE(IS_DONOR) TYPE ZLL_DONOR
*"  EXCEPTIONS
*"     NOT_FOUND
*"     ERROR
*"----------------------------------------------------------------------

  DATA: ls_existing TYPE zll_donor.

  " Check if donor exists
  SELECT SINGLE * FROM zll_donor INTO ls_existing
    WHERE donor_id = is_donor-donor_id.

  IF sy-subrc <> 0.
    RAISE not_found.
  ENDIF.

  " Update fields
  UPDATE zll_donor SET
    first_name    = is_donor-first_name,
    last_name     = is_donor-last_name,
    blood_group   = is_donor-blood_group,
    date_of_birth = is_donor-date_of_birth,
    gender        = is_donor-gender,
    phone         = is_donor-phone,
    email         = is_donor-email,
    street        = is_donor-street,
    city          = is_donor-city,
    state         = is_donor-state,
    pin_code      = is_donor-pin_code,
    weight        = is_donor-weight,
    status        = is_donor-status,
    medical_notes = is_donor-medical_notes,
    changed_by    = sy-uname,
    changed_on    = sy-datum
  WHERE donor_id = is_donor-donor_id.

  IF sy-subrc <> 0.
    RAISE error.
  ENDIF.

  COMMIT WORK.

ENDFUNCTION.
