*&---------------------------------------------------------------------*
*& Transparent Table: ZLL_DONOR
*& Description: LifeLink - Donor Master Table
*&---------------------------------------------------------------------*
*& Primary Key: MANDT, DONOR_ID
*& Delivery Class: A (Application Table)
*& Data Class: APPL0 (Master Data)
*& Size Category: 2
*&---------------------------------------------------------------------*

* Field Name       | Data Element        | Type    | Length | Description
* ------------------|---------------------|---------|--------|---------------------------
* MANDT             | MANDT               | CLNT    | 3      | Client (key)
* DONOR_ID          | ZLL_DE_DONOR_ID     | CHAR    | 10     | Donor ID (key)
* FIRST_NAME        | ZLL_DE_FIRST_NAME   | CHAR    | 40     | First Name
* LAST_NAME         | ZLL_DE_LAST_NAME    | CHAR    | 40     | Last Name
* BLOOD_GROUP       | ZLL_DE_BLOOD_GROUP  | CHAR    | 3      | Blood Group
* DATE_OF_BIRTH     | DATS                | DATS    | 8      | Date of Birth
* GENDER            | ZLL_DE_GENDER       | CHAR    | 1      | Gender (M/F/O)
* PHONE             | ZLL_DE_PHONE        | CHAR    | 15     | Phone Number
* EMAIL             | AD_SMTPADR          | CHAR    | 241    | Email Address
* STREET            | AD_STREET           | CHAR    | 60     | Street Address
* CITY              | AD_CITY1            | CHAR    | 40     | City
* STATE             | REGIO               | CHAR    | 3      | State/Region
* PIN_CODE          | AD_PSTCD1           | CHAR    | 10     | PIN/Postal Code
* WEIGHT            | ZLL_DE_WEIGHT       | DEC     | 5,2    | Weight in KG
* LAST_DONATION     | DATS                | DATS    | 8      | Last Donation Date
* STATUS            | ZLL_DE_DONOR_STATUS | CHAR    | 10     | Donor Status
* MEDICAL_NOTES     | ZLL_DE_NOTES        | CHAR    | 255    | Medical Notes
* CREATED_BY        | ERNAM               | CHAR    | 12     | Created By
* CREATED_ON        | ERDAT               | DATS    | 8      | Created On
* CHANGED_BY        | AENAM               | CHAR    | 12     | Changed By
* CHANGED_ON        | AEDAT               | DATS    | 8      | Changed On

*--- ABAP DDL (for reference) ---
* @EndUserText.label : 'LifeLink Donor Master'
* @AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
* @AbapCatalog.tableCategory : #TRANSPARENT
* @AbapCatalog.deliveryClass : #A
* @AbapCatalog.dataMaintenance : #ALLOWED
* define table zll_donor {
*   key mandt         : mandt not null;
*   key donor_id      : zll_de_donor_id not null;
*   first_name        : zll_de_first_name;
*   last_name         : zll_de_last_name;
*   blood_group       : zll_de_blood_group;
*   date_of_birth     : dats;
*   gender            : zll_de_gender;
*   phone             : zll_de_phone;
*   email             : ad_smtpadr;
*   street            : ad_street;
*   city              : ad_city1;
*   state             : regio;
*   pin_code          : ad_pstcd1;
*   weight            : zll_de_weight;
*   last_donation     : dats;
*   status            : zll_de_donor_status;
*   medical_notes     : zll_de_notes;
*   created_by        : ernam;
*   created_on        : erdat;
*   changed_by        : aenam;
*   changed_on        : aedat;
* }
