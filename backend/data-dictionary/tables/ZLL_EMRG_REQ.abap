*&---------------------------------------------------------------------*
*& Transparent Table: ZLL_EMRG_REQ
*& Description: LifeLink - Emergency Blood Request Table
*&---------------------------------------------------------------------*
*& Primary Key: MANDT, REQUEST_ID
*& Foreign Keys: HOSPITAL_ID -> ZLL_HOSPITAL
*&---------------------------------------------------------------------*

* Field Name        | Type    | Length | Description
* -------------------|---------|--------|----------------------------
* MANDT              | CLNT    | 3      | Client (key)
* REQUEST_ID         | CHAR    | 10     | Request ID (key)
* HOSPITAL_ID        | CHAR    | 10     | Hospital ID (FK)
* PATIENT_NAME       | CHAR    | 80     | Patient Name
* BLOOD_GROUP        | CHAR    | 3      | Required Blood Group
* UNITS_NEEDED       | INT4    | 10     | Units Needed
* URGENCY            | CHAR    | 10     | Critical/High/Normal/Low
* CONTACT_PERSON     | CHAR    | 80     | Contact Person
* CONTACT_PHONE      | CHAR    | 15     | Contact Phone
* REASON             | CHAR    | 255    | Reason for Request
* STATUS             | CHAR    | 10     | Pending/Approved/Rejected/Completed
* REQUEST_DATE       | DATS    | 8      | Request Date
* APPROVED_DATE      | DATS    | 8      | Approval Date
* APPROVED_BY        | CHAR    | 12     | Approved By User
* NOTES              | CHAR    | 255    | Additional Notes
* CREATED_BY         | CHAR    | 12     | Created By
* CREATED_ON         | DATS    | 8      | Created On
* CHANGED_BY         | CHAR    | 12     | Changed By
* CHANGED_ON         | DATS    | 8      | Changed On

*--- ABAP DDL ---
* @EndUserText.label : 'LifeLink Emergency Requests'
* define table zll_emrg_req {
*   key mandt          : mandt not null;
*   key request_id     : zll_de_req_id not null;
*   hospital_id        : zll_de_hosp_id;
*   patient_name       : zll_de_patient;
*   blood_group        : zll_de_blood_group;
*   units_needed       : int4;
*   urgency            : zll_de_urgency;
*   contact_person     : zll_de_contact;
*   contact_phone      : zll_de_phone;
*   reason             : zll_de_reason;
*   status             : zll_de_req_status;
*   request_date       : dats;
*   approved_date      : dats;
*   approved_by        : ernam;
*   notes              : zll_de_notes;
*   created_by         : ernam;
*   created_on         : erdat;
*   changed_by         : aenam;
*   changed_on         : aedat;
* }
