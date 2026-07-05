@AbapCatalog.sqlViewName: 'ZLL_V_DONOR'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LifeLink - Donor CDS View'

@OData.publish: true

@UI.headerInfo: {
  typeName: 'Donor',
  typeNamePlural: 'Donors',
  title: { type: #STANDARD, value: 'FirstName' },
  description: { type: #STANDARD, value: 'LastName' }
}

define view ZLL_CDS_DONOR
  as select from zll_donor as Donor
  association [0..*] to ZLL_CDS_DON_HIST as _Donations
    on $projection.DonorId = _Donations.DonorId
{
      @UI.lineItem: [{ position: 10, importance: #HIGH }]
      @UI.identification: [{ position: 10 }]
  key Donor.donor_id        as DonorId,

      @UI.lineItem: [{ position: 20, importance: #HIGH }]
      @UI.identification: [{ position: 20 }]
      Donor.first_name       as FirstName,

      @UI.lineItem: [{ position: 30, importance: #HIGH }]
      @UI.identification: [{ position: 30 }]
      Donor.last_name        as LastName,

      @UI.lineItem: [{ position: 40, importance: #HIGH }]
      @UI.selectionField: [{ position: 10 }]
      Donor.blood_group      as BloodGroup,

      @UI.identification: [{ position: 50 }]
      Donor.date_of_birth    as DateOfBirth,

      @UI.identification: [{ position: 60 }]
      Donor.gender           as Gender,

      @UI.lineItem: [{ position: 50, importance: #MEDIUM }]
      @UI.identification: [{ position: 70 }]
      Donor.phone            as Phone,

      @UI.identification: [{ position: 80 }]
      Donor.email            as Email,

      Donor.street           as Street,

      @UI.lineItem: [{ position: 60, importance: #MEDIUM }]
      @UI.selectionField: [{ position: 20 }]
      Donor.city             as City,

      Donor.state            as State,
      Donor.pin_code         as PinCode,
      Donor.weight           as Weight,

      @UI.lineItem: [{ position: 70, importance: #MEDIUM }]
      Donor.last_donation    as LastDonationDate,

      @UI.lineItem: [{ position: 80, importance: #HIGH }]
      @UI.selectionField: [{ position: 30 }]
      Donor.status           as Status,

      Donor.medical_notes    as MedicalNotes,
      Donor.created_by       as CreatedBy,
      Donor.created_on       as CreatedOn,
      Donor.changed_by       as ChangedBy,
      Donor.changed_on       as ChangedOn,

      // Association
      _Donations
}
