@AbapCatalog.sqlViewName: 'ZLL_V_BINV'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LifeLink - Blood Inventory CDS View'

@OData.publish: true

define view ZLL_CDS_BLOOD_INV
  as select from zll_blood_inv as Inventory
  inner join zll_hospital as Hospital
    on Inventory.hospital_id = Hospital.hospital_id
{
  key Inventory.inventory_id      as InventoryId,
      Inventory.blood_group       as BloodGroup,
      Inventory.units             as Units,
      Inventory.hospital_id       as HospitalId,
      Hospital.name               as HospitalName,
      Inventory.collection_date   as CollectionDate,
      Inventory.expiry_date       as ExpiryDate,
      Inventory.storage_location  as StorageLocation,
      Inventory.status            as Status,
      Hospital.city               as City,
      Hospital.state              as State
}
