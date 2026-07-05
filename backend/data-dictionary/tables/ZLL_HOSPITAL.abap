*&---------------------------------------------------------------------*
*& Transparent Table: ZLL_HOSPITAL
*& Description: LifeLink - Hospital Master Table
*&---------------------------------------------------------------------*
*& Primary Key: MANDT, HOSPITAL_ID
*& Delivery Class: A
*&---------------------------------------------------------------------*

* Field Name        | Type    | Length | Description
* -------------------|---------|--------|----------------------------
* MANDT              | CLNT    | 3      | Client (key)
* HOSPITAL_ID        | CHAR    | 10     | Hospital ID (key)
* NAME               | CHAR    | 100    | Hospital Name
* CITY               | CHAR    | 40     | City
* STATE              | CHAR    | 40     | State
* ADDRESS            | CHAR    | 200    | Full Address
* PHONE              | CHAR    | 15     | Phone Number
* EMAIL              | CHAR    | 100    | Email Address
* TYPE               | CHAR    | 20     | Hospital Type
* CREATED_BY         | CHAR    | 12     | Created By
* CREATED_ON         | DATS    | 8      | Created On
* CHANGED_BY         | CHAR    | 12     | Changed By
* CHANGED_ON         | DATS    | 8      | Changed On

*--- ABAP DDL ---
* @EndUserText.label : 'LifeLink Hospital Master'
* define table zll_hospital {
*   key mandt        : mandt not null;
*   key hospital_id  : zll_de_hosp_id not null;
*   name             : zll_de_hosp_name;
*   city             : ad_city1;
*   state            : regio;
*   address          : ad_strspp1;
*   phone            : zll_de_phone;
*   email            : ad_smtpadr;
*   type             : zll_de_hosp_type;
*   created_by       : ernam;
*   created_on       : erdat;
*   changed_by       : aenam;
*   changed_on       : aedat;
* }
