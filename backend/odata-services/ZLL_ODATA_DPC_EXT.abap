*&---------------------------------------------------------------------*
*& OData Service: ZLL_ODATA_SRV
*& Data Provider Class Extension (DPC_EXT)
*& Description: CRUD implementations for LifeLink OData Service
*&---------------------------------------------------------------------*
*& This class extends the generated DPC base class and implements
*& the CRUD methods for all entity sets.
*&---------------------------------------------------------------------*

CLASS zcl_zll_odata_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zll_odata_dpc
  CREATE PUBLIC.

  PUBLIC SECTION.
  PROTECTED SECTION.

    "--- DonorSet CRUD Methods ---
    METHODS donorset_get_entityset REDEFINITION.
    METHODS donorset_get_entity REDEFINITION.
    METHODS donorset_create_entity REDEFINITION.
    METHODS donorset_update_entity REDEFINITION.
    METHODS donorset_delete_entity REDEFINITION.

    "--- BloodInventorySet CRUD Methods ---
    METHODS bloodinventoryset_get_entityset REDEFINITION.
    METHODS bloodinventoryset_get_entity REDEFINITION.
    METHODS bloodinventoryset_create_entity REDEFINITION.
    METHODS bloodinventoryset_update_entity REDEFINITION.
    METHODS bloodinventoryset_delete_entity REDEFINITION.

    "--- EmergencyRequestSet CRUD Methods ---
    METHODS emergencyrequestset_get_entset REDEFINITION.
    METHODS emergencyrequestset_get_entity REDEFINITION.
    METHODS emergencyrequestset_create_ent REDEFINITION.
    METHODS emergencyrequestset_update_ent REDEFINITION.

    "--- DonationHistorySet Methods ---
    METHODS donationhistoryset_get_entset REDEFINITION.
    METHODS donationhistoryset_get_entity REDEFINITION.
    METHODS donationhistoryset_create_ent REDEFINITION.

    "--- HospitalSet Methods ---
    METHODS hospitalset_get_entityset REDEFINITION.
    METHODS hospitalset_get_entity REDEFINITION.

    "--- DashboardStatsSet Methods ---
    METHODS dashboardstatsset_get_entset REDEFINITION.

    "--- BloodGroupStatSet Methods ---
    METHODS bloodgroupstatset_get_entset REDEFINITION.

    "--- Function Imports ---
    METHODS /iwbep/if_mgw_appl_srv_runtime~execute_action REDEFINITION.

  PRIVATE SECTION.
    METHODS _generate_id
      IMPORTING iv_prefix    TYPE string
      RETURNING VALUE(rv_id) TYPE string.

    METHODS _check_donor_eligibility
      IMPORTING iv_donor_id       TYPE string
      RETURNING VALUE(rv_eligible) TYPE abap_bool.

ENDCLASS.

CLASS zcl_zll_odata_dpc_ext IMPLEMENTATION.

*----------------------------------------------------------------------*
* DonorSet - GET Entity Set (Read All Donors)
*----------------------------------------------------------------------*
  METHOD donorset_get_entityset.

    DATA: lt_donors TYPE TABLE OF zll_donor,
          ls_entity TYPE zcl_zll_odata_mpc=>ts_donor.

    " Read all donors from the database
    SELECT * FROM zll_donor INTO TABLE lt_donors.

    " Apply filters if provided
    IF it_filter_select_options IS NOT INITIAL.
      " Process $filter parameters
      DATA(lt_filter) = it_filter_select_options.
      " Filter logic would be applied here based on OData filter parameters
    ENDIF.

    " Map DB records to entity type
    LOOP AT lt_donors INTO DATA(ls_donor).
      CLEAR ls_entity.
      ls_entity-donor_id        = ls_donor-donor_id.
      ls_entity-first_name      = ls_donor-first_name.
      ls_entity-last_name       = ls_donor-last_name.
      ls_entity-blood_group     = ls_donor-blood_group.
      ls_entity-date_of_birth   = ls_donor-date_of_birth.
      ls_entity-gender          = ls_donor-gender.
      ls_entity-phone           = ls_donor-phone.
      ls_entity-email           = ls_donor-email.
      ls_entity-street          = ls_donor-street.
      ls_entity-city            = ls_donor-city.
      ls_entity-state           = ls_donor-state.
      ls_entity-pin_code        = ls_donor-pin_code.
      ls_entity-weight          = ls_donor-weight.
      ls_entity-last_donation   = ls_donor-last_donation.
      ls_entity-status          = ls_donor-status.
      ls_entity-medical_notes   = ls_donor-medical_notes.
      ls_entity-created_on      = ls_donor-created_on.
      ls_entity-changed_on      = ls_donor-changed_on.
      APPEND ls_entity TO et_entityset.
    ENDLOOP.

  ENDMETHOD.

*----------------------------------------------------------------------*
* DonorSet - GET Entity (Read Single Donor)
*----------------------------------------------------------------------*
  METHOD donorset_get_entity.

    DATA: ls_donor TYPE zll_donor.

    " Extract key from URI
    DATA(lv_donor_id) = VALUE #( it_key_tab[ name = 'DonorId' ]-value OPTIONAL ).

    " Read single donor
    SELECT SINGLE * FROM zll_donor INTO ls_donor
      WHERE donor_id = lv_donor_id.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING textid = /iwbep/cx_mgw_busi_exception=>resource_not_found.
    ENDIF.

    " Map to entity
    er_entity-donor_id      = ls_donor-donor_id.
    er_entity-first_name    = ls_donor-first_name.
    er_entity-last_name     = ls_donor-last_name.
    er_entity-blood_group   = ls_donor-blood_group.
    er_entity-date_of_birth = ls_donor-date_of_birth.
    er_entity-gender        = ls_donor-gender.
    er_entity-phone         = ls_donor-phone.
    er_entity-email         = ls_donor-email.
    er_entity-street        = ls_donor-street.
    er_entity-city          = ls_donor-city.
    er_entity-state         = ls_donor-state.
    er_entity-pin_code      = ls_donor-pin_code.
    er_entity-weight        = ls_donor-weight.
    er_entity-last_donation = ls_donor-last_donation.
    er_entity-status        = ls_donor-status.
    er_entity-medical_notes = ls_donor-medical_notes.

  ENDMETHOD.

*----------------------------------------------------------------------*
* DonorSet - CREATE Entity
*----------------------------------------------------------------------*
  METHOD donorset_create_entity.

    DATA: ls_donor TYPE zll_donor.

    " Read request payload
    io_data_provider->read_entry_data( IMPORTING es_data = er_entity ).

    " Validate required fields
    IF er_entity-first_name IS INITIAL OR
       er_entity-last_name IS INITIAL OR
       er_entity-blood_group IS INITIAL.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING textid = /iwbep/cx_mgw_busi_exception=>resource_not_found.
    ENDIF.

    " Generate Donor ID
    er_entity-donor_id = _generate_id( 'DN' ).

    " Map to DB structure
    MOVE-CORRESPONDING er_entity TO ls_donor.
    ls_donor-created_by = sy-uname.
    ls_donor-created_on = sy-datum.
    ls_donor-changed_by = sy-uname.
    ls_donor-changed_on = sy-datum.
    ls_donor-status     = 'ACTIVE'.

    " Call Function Module to create
    CALL FUNCTION 'ZLL_FM_CREATE_DONOR'
      EXPORTING
        is_donor = ls_donor
      EXCEPTIONS
        error    = 1
        OTHERS   = 2.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception.
    ENDIF.

  ENDMETHOD.

*----------------------------------------------------------------------*
* DonorSet - UPDATE Entity
*----------------------------------------------------------------------*
  METHOD donorset_update_entity.

    DATA: ls_donor TYPE zll_donor.

    io_data_provider->read_entry_data( IMPORTING es_data = er_entity ).

    DATA(lv_donor_id) = VALUE #( it_key_tab[ name = 'DonorId' ]-value OPTIONAL ).

    MOVE-CORRESPONDING er_entity TO ls_donor.
    ls_donor-donor_id   = lv_donor_id.
    ls_donor-changed_by = sy-uname.
    ls_donor-changed_on = sy-datum.

    CALL FUNCTION 'ZLL_FM_UPDATE_DONOR'
      EXPORTING
        is_donor = ls_donor
      EXCEPTIONS
        error    = 1
        OTHERS   = 2.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception.
    ENDIF.

  ENDMETHOD.

*----------------------------------------------------------------------*
* DonorSet - DELETE Entity
*----------------------------------------------------------------------*
  METHOD donorset_delete_entity.

    DATA(lv_donor_id) = VALUE #( it_key_tab[ name = 'DonorId' ]-value OPTIONAL ).

    CALL FUNCTION 'ZLL_FM_DELETE_DONOR'
      EXPORTING
        iv_donor_id = lv_donor_id
      EXCEPTIONS
        error       = 1
        OTHERS      = 2.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception.
    ENDIF.

  ENDMETHOD.

*----------------------------------------------------------------------*
* BloodInventorySet - GET Entity Set
*----------------------------------------------------------------------*
  METHOD bloodinventoryset_get_entityset.

    SELECT inv~inventory_id, inv~blood_group, inv~units,
           inv~hospital_id, hosp~name AS hospital_name,
           inv~collection_date, inv~expiry_date,
           inv~storage_location, inv~status
      FROM zll_blood_inv AS inv
      INNER JOIN zll_hospital AS hosp
        ON inv~hospital_id = hosp~hospital_id
      INTO TABLE @et_entityset.

  ENDMETHOD.

*----------------------------------------------------------------------*
* BloodInventorySet - GET Entity
*----------------------------------------------------------------------*
  METHOD bloodinventoryset_get_entity.

    DATA(lv_inv_id) = VALUE #( it_key_tab[ name = 'InventoryId' ]-value OPTIONAL ).

    SELECT SINGLE inv~inventory_id, inv~blood_group, inv~units,
           inv~hospital_id, hosp~name AS hospital_name,
           inv~collection_date, inv~expiry_date,
           inv~storage_location, inv~status
      FROM zll_blood_inv AS inv
      INNER JOIN zll_hospital AS hosp
        ON inv~hospital_id = hosp~hospital_id
      WHERE inv~inventory_id = @lv_inv_id
      INTO @er_entity.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING textid = /iwbep/cx_mgw_busi_exception=>resource_not_found.
    ENDIF.

  ENDMETHOD.

*----------------------------------------------------------------------*
* BloodInventorySet - CREATE Entity
*----------------------------------------------------------------------*
  METHOD bloodinventoryset_create_entity.

    DATA: ls_inv TYPE zll_blood_inv.

    io_data_provider->read_entry_data( IMPORTING es_data = er_entity ).

    ls_inv-inventory_id     = _generate_id( 'INV' ).
    ls_inv-blood_group      = er_entity-blood_group.
    ls_inv-units            = er_entity-units.
    ls_inv-hospital_id      = er_entity-hospital_id.
    ls_inv-collection_date  = er_entity-collection_date.
    ls_inv-expiry_date      = er_entity-collection_date + 42. "42-day shelf life
    ls_inv-storage_location = er_entity-storage_location.
    ls_inv-status           = 'AVAILABLE'.
    ls_inv-created_by       = sy-uname.
    ls_inv-created_on       = sy-datum.

    INSERT zll_blood_inv FROM ls_inv.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception.
    ENDIF.

    er_entity-inventory_id = ls_inv-inventory_id.
    er_entity-expiry_date  = ls_inv-expiry_date.
    er_entity-status       = ls_inv-status.

  ENDMETHOD.

*----------------------------------------------------------------------*
* BloodInventorySet - UPDATE Entity
*----------------------------------------------------------------------*
  METHOD bloodinventoryset_update_entity.

    io_data_provider->read_entry_data( IMPORTING es_data = er_entity ).

    DATA(lv_inv_id) = VALUE #( it_key_tab[ name = 'InventoryId' ]-value OPTIONAL ).

    UPDATE zll_blood_inv SET
      units            = er_entity-units,
      storage_location = er_entity-storage_location,
      status           = er_entity-status,
      changed_by       = sy-uname,
      changed_on       = sy-datum
    WHERE inventory_id = lv_inv_id.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception.
    ENDIF.

  ENDMETHOD.

*----------------------------------------------------------------------*
* BloodInventorySet - DELETE Entity
*----------------------------------------------------------------------*
  METHOD bloodinventoryset_delete_entity.

    DATA(lv_inv_id) = VALUE #( it_key_tab[ name = 'InventoryId' ]-value OPTIONAL ).

    DELETE FROM zll_blood_inv WHERE inventory_id = lv_inv_id.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception.
    ENDIF.

  ENDMETHOD.

*----------------------------------------------------------------------*
* EmergencyRequestSet - GET Entity Set
*----------------------------------------------------------------------*
  METHOD emergencyrequestset_get_entset.

    SELECT req~request_id, req~hospital_id, hosp~name AS hospital_name,
           req~patient_name, req~blood_group, req~units_needed,
           req~urgency, req~contact_person, req~contact_phone,
           req~reason, req~status, req~request_date,
           req~approved_date, req~notes
      FROM zll_emrg_req AS req
      INNER JOIN zll_hospital AS hosp
        ON req~hospital_id = hosp~hospital_id
      INTO TABLE @et_entityset.

  ENDMETHOD.

*----------------------------------------------------------------------*
* EmergencyRequestSet - GET Entity
*----------------------------------------------------------------------*
  METHOD emergencyrequestset_get_entity.

    DATA(lv_req_id) = VALUE #( it_key_tab[ name = 'RequestId' ]-value OPTIONAL ).

    SELECT SINGLE req~request_id, req~hospital_id, hosp~name AS hospital_name,
           req~patient_name, req~blood_group, req~units_needed,
           req~urgency, req~contact_person, req~contact_phone,
           req~reason, req~status, req~request_date,
           req~approved_date, req~notes
      FROM zll_emrg_req AS req
      INNER JOIN zll_hospital AS hosp
        ON req~hospital_id = hosp~hospital_id
      WHERE req~request_id = @lv_req_id
      INTO @er_entity.

  ENDMETHOD.

*----------------------------------------------------------------------*
* EmergencyRequestSet - CREATE Entity
*----------------------------------------------------------------------*
  METHOD emergencyrequestset_create_ent.

    DATA: ls_req TYPE zll_emrg_req.

    io_data_provider->read_entry_data( IMPORTING es_data = er_entity ).

    MOVE-CORRESPONDING er_entity TO ls_req.
    ls_req-request_id  = _generate_id( 'ER' ).
    ls_req-status      = 'PENDING'.
    ls_req-request_date = sy-datum.
    ls_req-created_by  = sy-uname.
    ls_req-created_on  = sy-datum.

    INSERT zll_emrg_req FROM ls_req.

    er_entity-request_id  = ls_req-request_id.
    er_entity-status      = ls_req-status.
    er_entity-request_date = ls_req-request_date.

  ENDMETHOD.

*----------------------------------------------------------------------*
* EmergencyRequestSet - UPDATE Entity (Status changes)
*----------------------------------------------------------------------*
  METHOD emergencyrequestset_update_ent.

    io_data_provider->read_entry_data( IMPORTING es_data = er_entity ).

    DATA(lv_req_id) = VALUE #( it_key_tab[ name = 'RequestId' ]-value OPTIONAL ).

    CALL FUNCTION 'ZLL_FM_PROCESS_REQUEST'
      EXPORTING
        iv_request_id = lv_req_id
        iv_new_status = er_entity-status
        iv_notes      = er_entity-notes
      EXCEPTIONS
        error         = 1
        OTHERS        = 2.

  ENDMETHOD.

*----------------------------------------------------------------------*
* DonationHistorySet - GET Entity Set
*----------------------------------------------------------------------*
  METHOD donationhistoryset_get_entset.

    SELECT don~donation_id, don~donor_id,
           concat_with_space( d~first_name, d~last_name, 1 ) AS donor_name,
           don~blood_group, don~donation_date,
           don~hospital_id, hosp~name AS hospital_name,
           don~units, don~notes
      FROM zll_don_hist AS don
      INNER JOIN zll_donor AS d ON don~donor_id = d~donor_id
      INNER JOIN zll_hospital AS hosp ON don~hospital_id = hosp~hospital_id
      INTO TABLE @et_entityset
      ORDER BY don~donation_date DESCENDING.

  ENDMETHOD.

*----------------------------------------------------------------------*
* DonationHistorySet - GET Entity
*----------------------------------------------------------------------*
  METHOD donationhistoryset_get_entity.

    DATA(lv_don_id) = VALUE #( it_key_tab[ name = 'DonationId' ]-value OPTIONAL ).

    SELECT SINGLE don~donation_id, don~donor_id,
           concat_with_space( d~first_name, d~last_name, 1 ) AS donor_name,
           don~blood_group, don~donation_date,
           don~hospital_id, hosp~name AS hospital_name,
           don~units, don~notes
      FROM zll_don_hist AS don
      INNER JOIN zll_donor AS d ON don~donor_id = d~donor_id
      INNER JOIN zll_hospital AS hosp ON don~hospital_id = hosp~hospital_id
      WHERE don~donation_id = @lv_don_id
      INTO @er_entity.

  ENDMETHOD.

*----------------------------------------------------------------------*
* DonationHistorySet - CREATE Entity
*----------------------------------------------------------------------*
  METHOD donationhistoryset_create_ent.

    io_data_provider->read_entry_data( IMPORTING es_data = er_entity ).

    CALL FUNCTION 'ZLL_FM_RECORD_DONATION'
      EXPORTING
        iv_donor_id    = er_entity-donor_id
        iv_hospital_id = er_entity-hospital_id
        iv_units       = er_entity-units
        iv_notes       = er_entity-notes
      IMPORTING
        ev_donation_id = er_entity-donation_id
      EXCEPTIONS
        not_eligible   = 1
        error          = 2
        OTHERS         = 3.

    IF sy-subrc = 1.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING textid = /iwbep/cx_mgw_busi_exception=>resource_not_found.
    ENDIF.

  ENDMETHOD.

*----------------------------------------------------------------------*
* HospitalSet - GET Entity Set
*----------------------------------------------------------------------*
  METHOD hospitalset_get_entityset.

    SELECT hospital_id, name, city, state, address, phone, email, type
      FROM zll_hospital
      INTO TABLE @et_entityset.

  ENDMETHOD.

*----------------------------------------------------------------------*
* HospitalSet - GET Entity
*----------------------------------------------------------------------*
  METHOD hospitalset_get_entity.

    DATA(lv_hosp_id) = VALUE #( it_key_tab[ name = 'HospitalId' ]-value OPTIONAL ).

    SELECT SINGLE hospital_id, name, city, state, address, phone, email, type
      FROM zll_hospital
      WHERE hospital_id = @lv_hosp_id
      INTO @er_entity.

  ENDMETHOD.

*----------------------------------------------------------------------*
* DashboardStatsSet - GET Entity Set
*----------------------------------------------------------------------*
  METHOD dashboardstatsset_get_entset.

    DATA: ls_stats TYPE zcl_zll_odata_mpc=>ts_dashboardstats.

    ls_stats-stat_id = 'MAIN'.

    SELECT COUNT(*) FROM zll_donor INTO ls_stats-total_donors.
    SELECT SUM( units ) FROM zll_blood_inv INTO ls_stats-available_units
      WHERE status = 'AVAILABLE'.
    SELECT COUNT(*) FROM zll_emrg_req INTO ls_stats-pending_requests
      WHERE status = 'PENDING'.
    SELECT COUNT(*) FROM zll_emrg_req INTO ls_stats-approved_requests
      WHERE status = 'APPROVED'.
    SELECT COUNT( DISTINCT blood_group ) FROM zll_blood_inv
      INTO ls_stats-blood_groups_available
      WHERE status = 'AVAILABLE'.
    SELECT COUNT(*) FROM zll_blood_inv INTO ls_stats-expiring_units
      WHERE expiry_date <= sy-datum + 7 AND status = 'AVAILABLE'.
    SELECT COUNT(*) FROM zll_don_hist INTO ls_stats-total_donations_this_month
      WHERE donation_date >= sy-datum - 30.
    SELECT COUNT(*) FROM zll_emrg_req INTO ls_stats-completed_requests
      WHERE status = 'COMPLETED'.

    APPEND ls_stats TO et_entityset.

  ENDMETHOD.

*----------------------------------------------------------------------*
* BloodGroupStatSet - GET Entity Set
*----------------------------------------------------------------------*
  METHOD bloodgroupstatset_get_entset.

    SELECT blood_group AS BloodGroup,
           SUM( units ) AS TotalUnits,
           COUNT( DISTINCT hospital_id ) AS DonorCount
      FROM zll_blood_inv
      WHERE status = 'AVAILABLE'
      GROUP BY blood_group
      INTO TABLE @et_entityset.

  ENDMETHOD.

*----------------------------------------------------------------------*
* Function Import Handler
*----------------------------------------------------------------------*
  METHOD /iwbep/if_mgw_appl_srv_runtime~execute_action.

    CASE iv_action_name.

      WHEN 'CheckDonorEligibility'.
        DATA(lv_donor_id) = VALUE #( it_parameter[ name = 'DonorId' ]-value OPTIONAL ).
        DATA(lv_eligible) = _check_donor_eligibility( lv_donor_id ).
        " Return result
        er_data = lv_eligible.

      WHEN 'ApproveRequest'.
        DATA(lv_req_id_appr) = VALUE #( it_parameter[ name = 'RequestId' ]-value OPTIONAL ).
        UPDATE zll_emrg_req SET
          status = 'APPROVED', approved_date = sy-datum, approved_by = sy-uname,
          changed_by = sy-uname, changed_on = sy-datum
        WHERE request_id = lv_req_id_appr AND status = 'PENDING'.

      WHEN 'RejectRequest'.
        DATA(lv_req_id_rej) = VALUE #( it_parameter[ name = 'RequestId' ]-value OPTIONAL ).
        UPDATE zll_emrg_req SET
          status = 'REJECTED', changed_by = sy-uname, changed_on = sy-datum
        WHERE request_id = lv_req_id_rej AND status = 'PENDING'.

      WHEN 'CompleteRequest'.
        DATA(lv_req_id_comp) = VALUE #( it_parameter[ name = 'RequestId' ]-value OPTIONAL ).
        UPDATE zll_emrg_req SET
          status = 'COMPLETED', changed_by = sy-uname, changed_on = sy-datum
        WHERE request_id = lv_req_id_comp AND status = 'APPROVED'.

      WHEN 'GenerateDonationCertificate'.
        " Call SmartForm function module
        DATA(lv_don_id) = VALUE #( it_parameter[ name = 'DonationId' ]-value OPTIONAL ).
        " SmartForm generation logic would go here
        " CALL FUNCTION 'ZLL_SF_DONATION_CERT' ...

      WHEN 'GenerateEmergencySlip'.
        DATA(lv_slip_req_id) = VALUE #( it_parameter[ name = 'RequestId' ]-value OPTIONAL ).
        " CALL FUNCTION 'ZLL_SF_EMERGENCY_SLIP' ...

    ENDCASE.

  ENDMETHOD.

*----------------------------------------------------------------------*
* Private: Generate unique ID with prefix
*----------------------------------------------------------------------*
  METHOD _generate_id.

    DATA: lv_timestamp TYPE timestamp.
    GET TIME STAMP FIELD lv_timestamp.
    rv_id = iv_prefix && lv_timestamp+8(6).

  ENDMETHOD.

*----------------------------------------------------------------------*
* Private: Check donor eligibility (56-day gap rule)
*----------------------------------------------------------------------*
  METHOD _check_donor_eligibility.

    DATA: lv_last_date TYPE dats.

    SELECT SINGLE last_donation FROM zll_donor
      INTO lv_last_date
      WHERE donor_id = iv_donor_id.

    IF lv_last_date IS INITIAL.
      rv_eligible = abap_true.
      RETURN.
    ENDIF.

    DATA(lv_days) = sy-datum - lv_last_date.
    rv_eligible = COND #( WHEN lv_days >= 56 THEN abap_true ELSE abap_false ).

  ENDMETHOD.

ENDCLASS.
