# 🌀 LifeLink Data Flow Diagrams (DFD)

This document describes the flow of information across the LifeLink application layers.

---

## 🟢 Level 0: Context Diagram

The Context Diagram defines the system boundary, external actors, and key information flows.

```mermaid
graph LR
    Donor[Blood Donor]
    System((LifeLink Blood Management System))
    Hospital[Hospital Staff]
    Admin[Blood Bank Admin]

    %% Flows
    Donor -->|Personal Details / Blood Group| System
    System -->|Donation Certificate PDF| Donor

    Hospital -->|Emergency Blood Requests| System
    Hospital -->|Stock Availability Query| System
    System -->|Blood Unit Match Details / Slip| Hospital

    Admin -->|OData Approvals / Stock Entry| System
    System -->|Analytical Reports / KPI Logs| Admin
```

---

## 🟡 Level 1: Process Flow Diagram

Level 1 breaks down the core functional processing blocks and data stores.

```mermaid
graph TD
    %% Actors
    Actor[User / External System]

    %% Processes
    P1((1.0 Register & Manage Donors))
    P2((2.0 Manage Blood Inventory))
    P3((3.0 Process Emergency Requests))
    P4((4.0 Generate Documents))

    %% Data Stores
    D1[(ZLL_DONOR)]
    D2[(ZLL_BLOOD_INV)]
    D3[(ZLL_EMRG_REQ)]
    D4[(ZLL_DON_HIST)]
    D5[(ZLL_HOSPITAL)]

    %% Connections
    Actor -->|Donor parameters| P1
    P1 -->|Query last donation date| D4
    P1 -->|Create/Update registry| D1
    P1 -->|Read details| D1

    Actor -->|Collection details| P2
    P2 -->|Verify hospital ID| D5
    P2 -->|Increment stock units| D2
    P2 -->|Read current stock level| D2

    Actor -->|Hospital Request parameters| P3
    P3 -->|Check matching inventory| D2
    P3 -->|Record request entry| D3
    P3 -->|Process state workflow| D3

    Actor -->|Request / Donation IDs| P4
    P4 -->|Fetch donor & history| D1
    P4 -->|Fetch donor & history| D4
    P4 -->|Fetch request details| D3
    P4 -->|Export SmartForm PDF stream| Actor
```

---

## 🔴 Level 2: Detailed Process View (Fulfillment Workflow)

Level 2 drills down into the complex process of **Emergency Request Fulfillment**.

```mermaid
graph TD
    %% Input
    Start([Hospital Submits Request]) --> P3_1(3.1 Parse Request Payload)

    %% Step 1: Parsing
    P3_1 --> P3_2(3.2 Query Regional Blood Stock)

    %% Step 2: Querying
    DB_Inv[(ZLL_BLOOD_INV)] <-->|SELECT JOIN on BloodGroup & Urgency| P3_2

    %% Step 3: Decisions
    P3_2 --> Dec1{Stock Available?}
    
    Dec1 -->|No| P3_3(3.3 Set Status: REJECTED)
    Dec1 -->|Yes| P3_4(3.4 Reserve Stock & Set Status: PENDING)

    %% Step 4: Admin Process
    P3_4 --> AdminApprove{Admin Approval Action}
    
    AdminApprove -->|Approve Request| P3_5(3.5 Update Status: APPROVED)
    AdminApprove -->|Deny Request| P3_6(3.6 Release Reservation & Set Status: REJECTED)

    %% Step 5: Completion
    P3_5 --> P3_7(3.7 Dispatch Blood Bags & Update Status: COMPLETED)
    P3_7 --> P3_8(3.8 Deduct Units from Database Store)
    P3_8 --> DB_Inv
    P3_7 --> End([Fulfillment Complete])
```
