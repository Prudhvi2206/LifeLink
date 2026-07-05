*&---------------------------------------------------------------------*
*& Function Module: ZLL_FM_GET_BLOOD_AVAIL
*& Description: Searches blood availability by group, hospital, city
*&---------------------------------------------------------------------*
FUNCTION zll_fm_get_blood_avail.
*"----------------------------------------------------------------------
*" Local Interface:
*"  IMPORTING
*"     VALUE(IV_BLOOD_GROUP) TYPE ZLL_DE_BLOOD_GROUP OPTIONAL
*"     VALUE(IV_HOSPITAL) TYPE STRING OPTIONAL
*"     VALUE(IV_CITY) TYPE STRING OPTIONAL
*"  EXPORTING
*"     VALUE(ET_RESULTS) TYPE TABLE
*"  EXCEPTIONS
*"     NO_RESULTS
*"----------------------------------------------------------------------

  DATA: lt_results TYPE TABLE OF zll_blood_inv.

  " Build dynamic selection
  SELECT inv~inventory_id, inv~blood_group, inv~units,
         inv~hospital_id, hosp~name AS hospital_name,
         hosp~city, inv~expiry_date, inv~storage_location
    FROM zll_blood_inv AS inv
    INNER JOIN zll_hospital AS hosp
      ON inv~hospital_id = hosp~hospital_id
    WHERE inv~status = 'AVAILABLE'
      AND inv~units > 0
      AND ( @iv_blood_group IS INITIAL OR inv~blood_group = @iv_blood_group )
      AND ( @iv_city IS INITIAL OR hosp~city LIKE @iv_city )
    INTO TABLE @et_results.

  IF lines( et_results ) = 0.
    RAISE no_results.
  ENDIF.

ENDFUNCTION.
