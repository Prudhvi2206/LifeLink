*&---------------------------------------------------------------------*
*& Function Module: ZLL_FM_DELETE_DONOR
*& Description: Deletes a donor record (soft delete - sets status)
*&---------------------------------------------------------------------*
FUNCTION zll_fm_delete_donor.
*"----------------------------------------------------------------------
*" Local Interface:
*"  IMPORTING
*"     VALUE(IV_DONOR_ID) TYPE ZLL_DE_DONOR_ID
*"  EXCEPTIONS
*"     NOT_FOUND
*"     HAS_DONATIONS
*"     ERROR
*"----------------------------------------------------------------------

  " Check if donor exists
  SELECT SINGLE donor_id FROM zll_donor
    WHERE donor_id = iv_donor_id
    INTO @DATA(lv_exists).

  IF sy-subrc <> 0.
    RAISE not_found.
  ENDIF.

  " Check for existing donation history
  SELECT COUNT(*) FROM zll_don_hist
    WHERE donor_id = iv_donor_id.

  IF sy-dbcnt > 0.
    " Soft delete - set status to INACTIVE instead of hard delete
    UPDATE zll_donor SET
      status     = 'INACTIVE',
      changed_by = sy-uname,
      changed_on = sy-datum
    WHERE donor_id = iv_donor_id.
  ELSE.
    " Hard delete if no donation history
    DELETE FROM zll_donor WHERE donor_id = iv_donor_id.
  ENDIF.

  IF sy-subrc <> 0.
    RAISE error.
  ENDIF.

  COMMIT WORK.

ENDFUNCTION.
