# 📝 LifeLink Technical Specification

This document details the software class architecture, class hierarchies, processing algorithms, and database design.

---

## 🛠 Software Class Structures

### 1. SAPUI5 Frontend Architecture
The application runs as a modular SAPUI5 Component matching Fiori design requirements.

#### MVC Components Mapping:
*   **Component.js**: The routing initialization and app startup class. Loads the device model and boots navigation.
*   **models.js**: Model instantiation helper. Exposes `device` model, empty schema models for forms binding (`newDonor`, `newRequest`), and select lists.
*   **formatter.js**: Custom formatting logic mapping database fields to front-facing components:
    *   `formatStatusState`: Maps status fields (`Pending`/`Approved`/`Rejected`/`Completed`) to semantic state strings (`Warning`/`Success`/`Error`/`Information`).
    *   `isDonorEligible`: Javascript representation of the 56-day gap calculation rule.
    *   `formatExpiryState`: Maps date differentials to semantic colors for inventory health.

---

## ⚙ ABAP Backend Classes & Modular Logic

### 1. Gateway Data Provider Extension (`ZCL_ZLL_ODATA_DPC_EXT`)
This class handles request dispatching and maps ABAP structures to JSON payloads.

```
       /iwbep/if_mgw_appl_srv_runtime~execute_action()
                             │
            ┌────────────────┴────────────────┐
            ▼                                 ▼
   CheckDonorEligibility              ApproveRequest / RejectRequest
   (Eligibility calculations)         (Update request status fields)
```

#### Code Segment: Action Handler (`EXECUTE_ACTION` Implementation)
```abap
  METHOD /iwbep/if_mgw_appl_srv_runtime~execute_action.
    CASE iv_action_name.
      WHEN 'CheckDonorEligibility'.
        DATA(lv_donor_id) = VALUE #( it_parameter[ name = 'DonorId' ]-value OPTIONAL ).
        DATA(lv_eligible) = _check_donor_eligibility( lv_donor_id ).
        copy_data_to_ref( exporting is_data = lv_eligible changing cr_data = er_data ).
      " ... status workflows ...
    ENDCASE.
  ENDMETHOD.
```

### 2. Core Function Modules

#### A. Recording Blood Donation (`ZLL_FM_RECORD_DONATION`)
1.  **Read Donor details** from database table `ZLL_DONOR`.
2.  **Evaluate eligibility rules** calling `ZLL_FM_CHECK_ELIGIBILITY`. If `EV_ELIGIBLE = ABAP_FALSE`, raise exception `NOT_ELIGIBLE`.
3.  **Insert new record** to history logger database table `ZLL_DON_HIST`.
4.  **Update Donor profile** setting `LAST_DONATION = SY-DATUM`.
5.  **Commit Transaction**.

#### B. Blood Availability Search (`ZLL_FM_GET_BLOOD_AVAIL`)
Performs SQL SELECT JOIN statements to find available stock units matching the criteria:
```abap
  SELECT inv~inventory_id, inv~blood_group, inv~units, hosp~name AS hospital_name, hosp~city
    FROM zll_blood_inv AS inv
    INNER JOIN zll_hospital AS hosp ON inv~hospital_id = hosp~hospital_id
    WHERE inv~status = 'AVAILABLE'
      AND inv~units > 0
      AND ( @iv_blood_group IS INITIAL OR inv~blood_group = @iv_blood_group )
      AND ( @iv_city IS INITIAL OR hosp~city LIKE @iv_city )
    INTO TABLE @et_results.
```

---

## 📊 Analytical Core Data Services (CDS Views)

CDS views execute database projections and aggregates on the HANA DB layer to boost performance.

### Example: Dashboard Integration (`ZLL_CDS_DASHBOARD`)
```abap
@AbapCatalog.sqlViewName: 'ZLL_V_DASH'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view ZLL_CDS_DASHBOARD
  as select from zll_donor as d
{
  count( distinct d.donor_id ) as TotalDonors,
  count( case d.status when 'ACTIVE' then d.donor_id end ) as ActiveDonors,
  count( case d.status when 'INACTIVE' then d.donor_id end ) as InactiveDonors
}
```
This view uses HANA-optimized SQL aggregations to calculate KPIs.
