@AbapCatalog.sqlViewName: 'ZLL_V_EREQ'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LifeLink - Emergency Request CDS View'

@OData.publish: true

define view ZLL_CDS_EMRG_REQ
  as select from zll_emrg_req as Request
  inner join zll_hospital as Hospital
    on Request.hospital_id = Hospital.hospital_id
{
  key Request.request_id       as RequestId,
      Request.hospital_id      as HospitalId,
      Hospital.name            as HospitalName,
      Request.patient_name     as PatientName,
      Request.blood_group      as BloodGroup,
      Request.units_needed     as UnitsNeeded,
      Request.urgency          as Urgency,
      Request.contact_person   as ContactPerson,
      Request.contact_phone    as ContactPhone,
      Request.reason           as Reason,
      Request.status           as Status,
      Request.request_date     as RequestDate,
      Request.approved_date    as ApprovedDate,
      Request.notes            as Notes
}
