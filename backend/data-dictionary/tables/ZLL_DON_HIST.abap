*&---------------------------------------------------------------------*
*& Transparent Table: ZLL_DON_HIST
*& Description: LifeLink - Donation History Table
*&---------------------------------------------------------------------*
*& Primary Key: MANDT, DONATION_ID
*& Foreign Keys: DONOR_ID -> ZLL_DONOR, HOSPITAL_ID -> ZLL_HOSPITAL
*&---------------------------------------------------------------------*

* Field Name        | Type    | Length | Description
* -------------------|---------|--------|----------------------------
* MANDT              | CLNT    | 3      | Client (key)
* DONATION_ID        | CHAR    | 10     | Donation ID (key)
* DONOR_ID           | CHAR    | 10     | Donor ID (FK -> ZLL_DONOR)
* BLOOD_GROUP        | CHAR    | 3      | Blood Group
* DONATION_DATE      | DATS    | 8      | Donation Date
* HOSPITAL_ID        | CHAR    | 10     | Hospital ID (FK -> ZLL_HOSPITAL)
* UNITS              | INT4    | 10     | Units Donated
* NOTES              | CHAR    | 255    | Notes
* CREATED_BY         | CHAR    | 12     | Created By
* CREATED_ON         | DATS    | 8      | Created On

*--- ABAP DDL ---
* @EndUserText.label : 'LifeLink Donation History'
* define table zll_don_hist {
*   key mandt          : mandt not null;
*   key donation_id    : zll_de_don_id not null;
*   donor_id           : zll_de_donor_id;
*   blood_group        : zll_de_blood_group;
*   donation_date      : dats;
*   hospital_id        : zll_de_hosp_id;
*   units              : int4;
*   notes              : zll_de_notes;
*   created_by         : ernam;
*   created_on         : erdat;
* }
