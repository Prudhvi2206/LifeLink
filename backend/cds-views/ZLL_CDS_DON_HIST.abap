@AbapCatalog.sqlViewName: 'ZLL_V_DHIST'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LifeLink - Donation History CDS View'

@OData.publish: true

define view ZLL_CDS_DON_HIST
  as select from zll_don_hist as Donation
  inner join zll_donor as Donor
    on Donation.donor_id = Donor.donor_id
  inner join zll_hospital as Hospital
    on Donation.hospital_id = Hospital.hospital_id
{
  key Donation.donation_id    as DonationId,
      Donation.donor_id       as DonorId,
      concat_with_space(Donor.first_name, Donor.last_name, 1) as DonorName,
      Donation.blood_group    as BloodGroup,
      Donation.donation_date  as DonationDate,
      Donation.hospital_id    as HospitalId,
      Hospital.name           as HospitalName,
      Donation.units          as Units,
      Donation.notes          as Notes
}
