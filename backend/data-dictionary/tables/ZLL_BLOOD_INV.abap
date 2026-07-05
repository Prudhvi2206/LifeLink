*&---------------------------------------------------------------------*
*& Transparent Table: ZLL_BLOOD_INV
*& Description: LifeLink - Blood Inventory Table
*&---------------------------------------------------------------------*
*& Primary Key: MANDT, INVENTORY_ID
*& Delivery Class: A (Application Table)
*& Foreign Keys: HOSPITAL_ID -> ZLL_HOSPITAL
*&---------------------------------------------------------------------*

* Field Name        | Type    | Length | Description
* -------------------|---------|--------|----------------------------
* MANDT              | CLNT    | 3      | Client (key)
* INVENTORY_ID       | CHAR    | 10     | Inventory ID (key)
* BLOOD_GROUP        | CHAR    | 3      | Blood Group (domain: ZLL_BLOOD_GROUP)
* UNITS              | INT4    | 10     | Available Units
* HOSPITAL_ID        | CHAR    | 10     | Hospital ID (FK -> ZLL_HOSPITAL)
* COLLECTION_DATE    | DATS    | 8      | Collection Date
* EXPIRY_DATE        | DATS    | 8      | Expiry Date (42 days from collection)
* STORAGE_LOCATION   | CHAR    | 40     | Storage Location
* STATUS             | CHAR    | 15     | Available / Expiring / Expired
* CREATED_BY         | CHAR    | 12     | Created By
* CREATED_ON         | DATS    | 8      | Created On
* CHANGED_BY         | CHAR    | 12     | Changed By
* CHANGED_ON         | DATS    | 8      | Changed On

*--- ABAP DDL ---
* @EndUserText.label : 'LifeLink Blood Inventory'
* define table zll_blood_inv {
*   key mandt            : mandt not null;
*   key inventory_id     : zll_de_inv_id not null;
*   blood_group          : zll_de_blood_group;
*   units                : int4;
*   hospital_id          : zll_de_hosp_id;
*   collection_date      : dats;
*   expiry_date          : dats;
*   storage_location     : zll_de_storage;
*   status               : zll_de_inv_status;
*   created_by           : ernam;
*   created_on           : erdat;
*   changed_by           : aenam;
*   changed_on           : aedat;
* }
