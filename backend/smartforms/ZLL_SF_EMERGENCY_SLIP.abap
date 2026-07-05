*&---------------------------------------------------------------------*
*& SmartForm: ZLL_SF_EMERGENCY_SLIP
*& Description: Emergency Blood Request Slip SmartForm
*&---------------------------------------------------------------------*
*& Generates a formal Emergency Blood Request Slip document.
*& Called from OData function import 'GenerateEmergencySlip'.
*&---------------------------------------------------------------------*

*--- SmartForm Interface ---
* Form Name: ZLL_SF_EMERGENCY_SLIP
*
* Import Parameters:
*   IS_REQUEST   TYPE ZLL_EMRG_REQ   - Emergency request record
*   IS_HOSPITAL  TYPE ZLL_HOSPITAL   - Hospital information

*--- SmartForm Layout Description ---
* Page: FIRST_PAGE (A4 Portrait)
*
* HEADER Window:
*   - URGENT banner (red background for Critical requests)
*   - Title: "EMERGENCY BLOOD REQUEST SLIP"
*   - Request ID: &IS_REQUEST-REQUEST_ID&
*   - Date: &IS_REQUEST-REQUEST_DATE&
*
* MAIN Window:
*   - Hospital Details Section:
*     | Hospital     | &IS_HOSPITAL-NAME&           |
*     | Address      | &IS_HOSPITAL-ADDRESS&        |
*     | City         | &IS_HOSPITAL-CITY&           |
*     | Phone        | &IS_HOSPITAL-PHONE&          |
*
*   - Contact Section:
*     | Contact Person | &IS_REQUEST-CONTACT_PERSON& |
*     | Contact Phone  | &IS_REQUEST-CONTACT_PHONE&  |
*
*   - Patient & Blood Details Section:
*     | Patient Name      | &IS_REQUEST-PATIENT_NAME&  |
*     | Blood Group Req.  | &IS_REQUEST-BLOOD_GROUP&   |
*     | Units Needed      | &IS_REQUEST-UNITS_NEEDED&  |
*     | Urgency Level     | &IS_REQUEST-URGENCY&       |
*     | Reason            | &IS_REQUEST-REASON&        |
*
*   - Status Section:
*     | Request Status  | &IS_REQUEST-STATUS&        |
*     | Approved Date   | &IS_REQUEST-APPROVED_DATE& |
*     | Notes           | &IS_REQUEST-NOTES&         |
*
*   - Authorization:
*     | Requesting Doctor    | Blood Bank Officer |
*     | ___________________  | __________________ |
*     | Signature & Stamp    | Signature & Stamp  |
*
* FOOTER Window:
*   - "For blood bank use only"
*   - "LifeLink Blood Donation & Emergency Request System"
*   - Timestamp

*--- Driver Program ---
*
* REPORT zll_print_emergency_slip.
*
* DATA: lv_fm_name  TYPE rs38l_fnam,
*       ls_request  TYPE zll_emrg_req,
*       ls_hospital TYPE zll_hospital.
*
* CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
*   EXPORTING formname = 'ZLL_SF_EMERGENCY_SLIP'
*   IMPORTING fm_name  = lv_fm_name.
*
* SELECT SINGLE * FROM zll_emrg_req INTO ls_request
*   WHERE request_id = p_reqid.
* SELECT SINGLE * FROM zll_hospital INTO ls_hospital
*   WHERE hospital_id = ls_request-hospital_id.
*
* CALL FUNCTION lv_fm_name
*   EXPORTING
*     is_request  = ls_request
*     is_hospital = ls_hospital
*   EXCEPTIONS
*     OTHERS      = 1.
