*&---------------------------------------------------------------------*
*& Function Module: ZLL_FM_PROCESS_REQUEST
*& Description: Processes emergency request status changes
*&---------------------------------------------------------------------*
FUNCTION zll_fm_process_request.
*"----------------------------------------------------------------------
*" Local Interface:
*"  IMPORTING
*"     VALUE(IV_REQUEST_ID) TYPE ZLL_DE_REQUEST_ID
*"     VALUE(IV_NEW_STATUS) TYPE ZLL_DE_REQUEST_STATUS
*"     VALUE(IV_NOTES) TYPE STRING OPTIONAL
*"  EXCEPTIONS
*"     NOT_FOUND
*"     INVALID_STATUS
*"     ERROR
*"----------------------------------------------------------------------

  DATA: ls_request TYPE zll_emrg_req.

  " Get current request
  SELECT SINGLE * FROM zll_emrg_req INTO ls_request
    WHERE request_id = iv_request_id.

  IF sy-subrc <> 0.
    RAISE not_found.
  ENDIF.

  " Validate status transition
  CASE ls_request-status.
    WHEN 'PENDING'.
      IF iv_new_status <> 'APPROVED' AND iv_new_status <> 'REJECTED' AND iv_new_status <> 'CANCELLED'.
        RAISE invalid_status.
      ENDIF.
    WHEN 'APPROVED'.
      IF iv_new_status <> 'COMPLETED' AND iv_new_status <> 'CANCELLED'.
        RAISE invalid_status.
      ENDIF.
    WHEN OTHERS.
      RAISE invalid_status.  "Cannot change from Rejected/Completed/Cancelled
  ENDCASE.

  " Update request
  UPDATE zll_emrg_req SET
    status     = iv_new_status,
    notes      = COND #( WHEN iv_notes IS NOT INITIAL THEN iv_notes ELSE ls_request-notes ),
    changed_by = sy-uname,
    changed_on = sy-datum
  WHERE request_id = iv_request_id.

  " Set approved date if approving
  IF iv_new_status = 'APPROVED'.
    UPDATE zll_emrg_req SET
      approved_date = sy-datum,
      approved_by   = sy-uname
    WHERE request_id = iv_request_id.
  ENDIF.

  IF sy-subrc <> 0.
    RAISE error.
  ENDIF.

  COMMIT WORK.

ENDFUNCTION.
