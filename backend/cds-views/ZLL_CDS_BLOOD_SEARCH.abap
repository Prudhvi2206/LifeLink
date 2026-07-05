@AbapCatalog.sqlViewName: 'ZLL_V_BSRCH'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LifeLink - Blood Availability Search CDS View'

define view ZLL_CDS_BLOOD_SEARCH
  as select from zll_blood_inv as Inventory
  inner join zll_hospital as Hospital
    on Inventory.hospital_id = Hospital.hospital_id
{
  key Inventory.inventory_id      as InventoryId,
      Inventory.blood_group       as BloodGroup,
      Inventory.units             as Units,
      Inventory.hospital_id       as HospitalId,
      Hospital.name               as HospitalName,
      Hospital.city               as City,
      Hospital.state              as State,
      Inventory.expiry_date       as ExpiryDate,
      Inventory.storage_location  as StorageLocation,
      Inventory.status            as Status
}
where Inventory.status <> 'EXPIRED'
  and Inventory.units > 0
