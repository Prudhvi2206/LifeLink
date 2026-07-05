# 🚀 LifeLink Setup & Deployment Guide

This guide describes how to configure, run, and deploy both the **SAPUI5 Frontend** locally and the **ABAP Backend** on an SAP S/4HANA system.

---

## 💻 Part 1: SAPUI5 Frontend Local Setup

The frontend application includes a built-in mock OData server allowing developer execution without an active SAP system.

### Prerequisites:
1.  **Node.js**: Install Node.js LTS (v18 or v20).
2.  **IDE**: VS Code (recommended) or SAP Business Application Studio.

### Steps to Run:
1.  Open your command shell and navigate to the frontend root folder:
    ```bash
    cd frontend
    ```
2.  Install required NPM dependencies:
    ```bash
    npm install
    ```
3.  Boot up the UI5 local development server:
    ```bash
    npm start
    ```
4.  Open your browser and navigate to `http://localhost:8080/index.html` (this usually opens automatically).
5.  Click through navigation links to verify mock OData bindings load correctly.

---

## 🗄 Part 2: ABAP Backend Installation (SAP S/4HANA)

### Step 1: Create Data Dictionary (DDIC) Objects
Log into your SAP system via **Eclipse ADT** or **SAP GUI (T-Code: SE11)** and recreate the tables and domains.

1.  **Domains**:
    *   Create domain `ZLL_BLOOD_GROUP` with CHAR(3) and add the 8 blood group types as Fixed Values.
    *   Create domain `ZLL_REQUEST_STATUS` with CHAR(10) and configure values `PENDING`, `APPROVED`, `REJECTED`, `COMPLETED`, `CANCELLED`.
    *   Create domain `ZLL_DONOR_STATUS` with CHAR(10) and configure values `ACTIVE`, `INACTIVE`.
2.  **Data Elements**:
    *   Create data elements corresponding to fields (e.g. `ZLL_DE_DONOR_ID` matching Domain `CHAR10`).
3.  **Transparent Tables**:
    *   Create transparent database tables `ZLL_DONOR`, `ZLL_BLOOD_INV`, `ZLL_EMRG_REQ`, `ZLL_DON_HIST`, and `ZLL_HOSPITAL`.
    *   Apply Technical Settings: Class `A`, Data Class `APPL0`. Set buffering off.

### Step 2: Implement Core CDS Views
In Eclipse ADT, create a new DDL Source for the following views:
*   `ZLL_CDS_DONOR`
*   `ZLL_CDS_BLOOD_INV`
*   `ZLL_CDS_EMRG_REQ`
*   `ZLL_CDS_DON_HIST`
*   `ZLL_CDS_DASHBOARD`
*   `ZLL_CDS_BLOOD_SEARCH`

Right-click and select **Activate** (`Ctrl+F3`).

### Step 3: Implement Function Modules
1.  Open Function Builder (T-Code: `SE37`).
2.  Create Function Group: `ZLL_FG_MAIN`.
3.  Create the 7 Function Modules using the provided `.abap` sources under `backend/function-modules/`.
4.  Configure interfaces matching Import/Export arguments and activate.

### Step 4: Configure OData Service (SAP Gateway)
1.  Go to Gateway Service Builder (T-Code: `SEGW`).
2.  Create project `ZLL_ODATA_PROJECT`.
3.  Right-click **Data Model ➔ Import ➔ DDIC Structure** or import from your CDS views directly.
4.  Generate runtime artifacts. This creates base MPC and DPC classes.
5.  Right-click class `ZCL_ZLL_ODATA_DPC_EXT` and implement CRUD methods by copying the source code from `backend/odata-services/ZLL_ODATA_DPC_EXT.abap`.
6.  Activate MPC and DPC extension classes.
7.  Register service in Gateway client (T-Code: `/IWFND/MAINT_SERVICE`):
    *   Add service `ZLL_ODATA_SRV`.
    *   Test connection using Gateway Client (`/IWFND/GW_CLIENT`) to verify `/sap/opu/odata/sap/ZLL_ODATA_SRV/$metadata` returns successful status `200`.

### Step 5: Import ALV Reports
1.  Go to ABAP Editor (T-Code: `SE38`).
2.  Create reports:
    *   `ZLL_RPT_DONOR`
    *   `ZLL_RPT_BLOOD_INV`
    *   `ZLL_RPT_EMRG_REQ`
    *   `ZLL_RPT_DONATION`
3.  Copy and paste code from respective report `.abap` files.
4.  Activate and run to test selection screens.

### Step 6: Create SmartForms
1.  Open SmartForms Designer (T-Code: `SMARTFORMS`).
2.  Create forms:
    *   `ZLL_SF_DONATION_CERT`
    *   `ZLL_SF_EMERGENCY_SLIP`
3.  Set Import parameters and design layouts matching details inside `backend/smartforms/` documents.
