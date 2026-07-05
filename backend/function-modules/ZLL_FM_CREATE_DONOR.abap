*&---------------------------------------------------------------------*
*& Function Module: ZLL_FM_CREATE_DONOR
*& Description: Creates a new donor record in ZLL_DONOR table
*&---------------------------------------------------------------------*
FUNCTION zll_fm_create_donor.
*"----------------------------------------------------------------------
*" Local Interface:
*"  IMPORTING
*"     VALUE(IS_DONOR) TYPE ZLL_DONOR
*"  EXCEPTIONS
*"     DUPLICATE_DONOR
*"     VALIDATION_ERROR
*"     ERROR
*"----------------------------------------------------------------------

  DATA: ls_donor TYPE zll_donor.

  " Validate mandatory fields
  IF is_donor-first_name IS INITIAL OR
     is_donor-last_name IS INITIAL OR
     is_donor-blood_group IS INITIAL.
    RAISE validation_error.
  ENDIF.

  " Check for duplicate (same name + blood group + DOB)
  SELECT COUNT(*) FROM zll_donor
    WHERE first_name  = is_donor-first_name
      AND last_name   = is_donor-last_name
      AND blood_group = is_donor-blood_group
      AND date_of_birth = is_donor-date_of_birth.

  IF sy-subrc = 0 AND sy-dbcnt > 0.
    RAISE duplicate_donor.
  ENDIF.

  " Prepare record
  ls_donor = is_donor.
  IF ls_donor-status IS INITIAL.
    ls_donor-status = 'ACTIVE'.
  ENDIF.
  ls_donor-created_by = sy-uname.
  ls_donor-created_on = sy-datum.
  ls_donor-changed_by = sy-uname.
  ls_donor-changed_on = sy-datum.

  " Insert into database
  INSERT zll_donor FROM ls_donor.

  IF sy-subrc <> 0.
    RAISE error.
  ENDIF.

  COMMIT WORK.

ENDFUNCTION.
