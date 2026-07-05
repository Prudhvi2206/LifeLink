# 🔌 LifeLink OData V2 API Documentation

Exposed Gateway service URL: `/sap/opu/odata/sap/ZLL_ODATA_SRV/`

---

## 📌 Entity Sets Summary

| Entity Set Name | Primary Key | Methods Supported | Description |
| :--- | :--- | :--- | :--- |
| **DonorSet** | `DonorId` | GET, POST, PUT, DELETE | Donor master details registry |
| **BloodInventorySet** | `InventoryId` | GET, POST, PUT, DELETE | Active blood bags database |
| **EmergencyRequestSet**| `RequestId` | GET, POST, PUT | Emergency requests workflow |
| **DonationHistorySet** | `DonationId` | GET, POST | Historical list of donations |
| **HospitalSet** | `HospitalId` | GET | Hospital centers master data |
| **DashboardStatsSet** | `StatId` | GET | Aggregated counts for homepage KPIs|
| **BloodGroupStatSet** | `BloodGroup` | GET | Breakdown units per blood group |

---

## 📡 Entity Endpoints Detail

### 1. Donor Operations (`/DonorSet`)

#### A. Read All Donors
*   **Method**: `GET`
*   **Path**: `/DonorSet`
*   **Query Options**: `$filter`, `$select`, `$top`, `$skip`
*   **Example Filter**: `/DonorSet?$filter=BloodGroup eq 'O-' and City eq 'Mumbai'`

#### B. Read Single Donor
*   **Method**: `GET`
*   **Path**: `/DonorSet('{DonorId}')`
*   **Example**: `/DonorSet('DN0001')`

#### C. Create New Donor
*   **Method**: `POST`
*   **Path**: `/DonorSet`
*   **Payload (JSON)**:
    ```json
    {
      "FirstName": "Aarav",
      "LastName": "Sharma",
      "BloodGroup": "O+",
      "DateOfBirth": "1990-05-15T00:00:00",
      "Gender": "M",
      "Phone": "9876543210",
      "Email": "aarav.sharma@email.com",
      "Street": "42 MG Road",
      "City": "Mumbai",
      "State": "MH",
      "PinCode": "400001",
      "Weight": 72.5,
      "MedicalNotes": "No allergies"
    }
    ```
*   **Response**: `201 Created` with generated ID (`DonorId`).

#### D. Update Donor Info
*   **Method**: `PUT` (Merge / Patch)
*   **Path**: `/DonorSet('{DonorId}')`
*   **Payload (JSON)**: Same as POST containing updated field keys.

#### E. Delete Donor
*   **Method**: `DELETE`
*   **Path**: `/DonorSet('{DonorId}')`
*   **Behavior**: Performs a hard delete if donor has zero historical records; otherwise, runs a soft delete changing status to `INACTIVE`.

---

### 2. Blood Inventory (`/BloodInventorySet`)

#### A. Retrieve Inventory
*   **Method**: `GET`
*   **Path**: `/BloodInventorySet`

#### B. Add Blood Unit to Stock
*   **Method**: `POST`
*   **Path**: `/BloodInventorySet`
*   **Payload (JSON)**:
    ```json
    {
      "BloodGroup": "A+",
      "Units": 10,
      "HospitalId": "H001",
      "CollectionDate": "2026-06-01T00:00:00",
      "StorageLocation": "Cold Storage A1"
    }
    ```
*   **Behavior**: Expiration date is calculated as `CollectionDate + 42 days` in the backend.

---

### 3. Emergency Requests (`/EmergencyRequestSet`)

#### A. Submit Request
*   **Method**: `POST`
*   **Path**: `/EmergencyRequestSet`
*   **Payload (JSON)**:
    ```json
    {
      "HospitalId": "H001",
      "PatientName": "Rajesh Kapoor",
      "BloodGroup": "O-",
      "UnitsNeeded": 3,
      "Urgency": "Critical",
      "ContactPerson": "Dr. Meena Shah",
      "ContactPhone": "9800000001",
      "Reason": "Emergency trauma surgery"
    }
    ```

---

## ⚙ Function Imports (Custom Operations)

Function imports handle non-CRUD transactional behaviors.

### 1. Check Donor Eligibility
Check if a donor is medically ready to give blood (56 days since last donation).
*   **Method**: `GET`
*   **Path**: `/CheckDonorEligibility?DonorId='{DonorId}'`
*   **Response**:
    ```json
    {
      "d": {
        "CheckDonorEligibility": true
      }
    }
    ```

### 2. Approve Emergency Request
*   **Method**: `POST`
*   **Path**: `/ApproveRequest?RequestId='{RequestId}'`
*   **Behavior**: Sets state to `APPROVED`, populates `ApprovedDate` and logs username.

### 3. Generate Donation Certificate
Obtain binary stream representing the print layout of a certificate.
*   **Method**: `GET`
*   **Path**: `/GenerateDonationCertificate?DonationId='{DonationId}'`
*   **Response**: Raw PDF binary stream (`application/pdf`).
