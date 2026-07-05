@AbapCatalog.sqlViewName: 'ZLL_V_DASH'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LifeLink - Dashboard Statistics CDS View'

@Analytics.dataCategory: #CUBE

define view ZLL_CDS_DASHBOARD
  as select from zll_donor as d
{
  @EndUserText.label: 'Total Donors'
  count( distinct d.donor_id ) as TotalDonors,

  @EndUserText.label: 'Active Donors'
  count( case d.status when 'ACTIVE' then d.donor_id end ) as ActiveDonors,

  @EndUserText.label: 'Inactive Donors'
  count( case d.status when 'INACTIVE' then d.donor_id end ) as InactiveDonors
}

-- Note: In production, this would be a UNION with additional
-- aggregate queries from zll_blood_inv, zll_emrg_req, and zll_don_hist
-- to provide all dashboard KPIs in a single view.
--
-- Additional calculated fields would include:
--   AvailableUnits    : SUM(units) from zll_blood_inv WHERE status = 'Available'
--   PendingRequests   : COUNT(*) from zll_emrg_req WHERE status = 'PENDING'
--   ApprovedRequests  : COUNT(*) from zll_emrg_req WHERE status = 'APPROVED'
--   BloodGroupsAvail  : COUNT(DISTINCT blood_group) from zll_blood_inv
--   ExpiringUnits     : COUNT(*) from zll_blood_inv WHERE expiry_date <= today + 7
--   MonthlyDonations  : COUNT(*) from zll_don_hist WHERE month = current_month
