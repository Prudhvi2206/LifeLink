*&---------------------------------------------------------------------*
*& SmartForm: ZLL_SF_DONATION_CERT
*& Description: Blood Donation Certificate SmartForm
*&---------------------------------------------------------------------*
*& This SmartForm generates a printable Blood Donation Certificate.
*& Called from OData function import 'GenerateDonationCertificate'.
*&---------------------------------------------------------------------*

*--- SmartForm Interface ---
* Form Name: ZLL_SF_DONATION_CERT
* Style: ZLL_CERT_STYLE (custom style with LifeLink branding)
*
* Import Parameters:
*   IS_DONATION  TYPE ZLL_DON_HIST   - Donation record
*   IS_DONOR     TYPE ZLL_DONOR      - Donor information
*   IS_HOSPITAL  TYPE ZLL_HOSPITAL   - Hospital information
*
* Output: PDF document via spool or download

*--- SmartForm Layout Description ---
* Page: FIRST_PAGE (A4 Portrait)
*
* HEADER Window (positioned at top):
*   - Logo placeholder (LifeLink brand)
*   - Title: "BLOOD DONATION CERTIFICATE"
*   - Subtitle: "LifeLink Blood Bank Management System"
*   - Horizontal line separator
*
* MAIN Window:
*   - Certificate text paragraph:
*     "This is to certify that"
*
*   - Donor Name (Bold, Large Font):
*     &IS_DONOR-FIRST_NAME& &IS_DONOR-LAST_NAME&
*
*   - Certificate body:
*     "has voluntarily donated blood at our center."
*
*   - Details Table:
*     | Field               | Value                        |
*     |---------------------|------------------------------|
*     | Donor ID            | &IS_DONOR-DONOR_ID&          |
*     | Blood Group         | &IS_DONOR-BLOOD_GROUP&        |
*     | Donation Date       | &IS_DONATION-DONATION_DATE&   |
*     | Units Donated       | &IS_DONATION-UNITS&           |
*     | Donation Center     | &IS_HOSPITAL-NAME&            |
*     | Center Address      | &IS_HOSPITAL-ADDRESS&         |
*     | Certificate No.     | CERT-&IS_DONATION-DONATION_ID&|
*
*   - Appreciation text:
*     "Your selfless act of donating blood helps save lives.
*      Thank you for being a hero!"
*
*   - Signature area:
*     | Blood Bank Officer     | Donor Signature |
*     | ___________________    | ________________|
*     | Date: &SY-DATUM&       |                 |
*
* FOOTER Window:
*   - "This is a computer-generated certificate."
*   - "LifeLink Blood Donation & Emergency Request System"
*   - Page number

*--- Driver Program (to call SmartForm) ---
*
* REPORT zll_print_donation_cert.
*
* DATA: lv_fm_name TYPE rs38l_fnam,
*       ls_donation TYPE zll_don_hist,
*       ls_donor    TYPE zll_donor,
*       ls_hospital TYPE zll_hospital.
*
* " Get SmartForm function module name
* CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
*   EXPORTING
*     formname = 'ZLL_SF_DONATION_CERT'
*   IMPORTING
*     fm_name  = lv_fm_name.
*
* " Fetch data
* SELECT SINGLE * FROM zll_don_hist INTO ls_donation
*   WHERE donation_id = p_donid.
* SELECT SINGLE * FROM zll_donor INTO ls_donor
*   WHERE donor_id = ls_donation-donor_id.
* SELECT SINGLE * FROM zll_hospital INTO ls_hospital
*   WHERE hospital_id = ls_donation-hospital_id.
*
* " Call SmartForm
* CALL FUNCTION lv_fm_name
*   EXPORTING
*     is_donation = ls_donation
*     is_donor    = ls_donor
*     is_hospital = ls_hospital
*   EXCEPTIONS
*     OTHERS      = 1.
