# 📋 LifeLink Functional Specification

This document details the functional capabilities and workflows of **LifeLink – Blood Donation & Emergency Request System**.

---

## 👥 User Roles & Access Control

### 1. System/Blood Bank Administrator
*   Responsible for overall operations.
*   Approves, rejects, and completes emergency requests.
*   Registers, edits, and soft-deletes donors.
*   Enters collected blood units into the inventory.
*   Views analytics on dashboard and downloads administrative PDF logs.

### 2. Hospital Representative
*   Submits emergency requests for patients.
*   Searches regional stock availability.
*   Downloads printed Emergency Request Slips to dispatch drivers to blood bank locations.

### 3. Blood Donor
*   Self-registers via public screens.
*   Receives signed Blood Donation Certificates after completing donation sessions.

---

## 🏛 Functional Modules & Workflows

```
  ┌─────────────────────────────────────────────────────────────┐
  │                        Dashboard                            │
  └──────────────────────────────┬──────────────────────────────┘
                                 │
         ┌───────────────────────┼───────────────────────┐
         ▼                       ▼                       ▼
  Donor Management        Blood Inventory        Emergency Requests
```

### 1. Dashboard
*   **KPI Widgets**: Real-time display of total registered donors, available blood bags (sum of units), active pending requests, and expired/expiring stocks.
*   **Expiry Alerts**: System-wide header warning displaying lists of blood inventory units expiring within 7 days.
*   **Visual Analytics**: Graphical table representing unit distribution by blood group (e.g. O+, O-, A+) with dynamic colored health status progress indicators (Adequate, Low, Critical).
*   **Quick Actions**: Shortcuts to register a donor, request blood, or query availability.

### 2. Donor Management
*   **Donor Registry**: Registration form capturing personal metadata, contact fields, postal code, weight, and history.
*   **Eligibility Engine**: Automatically performs safety rules check before logging a donation.
    *   **56-day gap rule**: Donors cannot donate within 56 days of their last donation.
    *   **Weight check**: Donor weight must be at least 45 kg.
    *   **Donor state**: Only `ACTIVE` status profiles are permitted to donate.
*   **Profiles**: Detailed page showing donor records mapped with their historical list of donation events.

### 3. Blood Inventory Tracking
*   **Stock Ingestion**: Adding collected blood units, specifying hospital/bank center, shelf location, and collection date.
*   **Expiry Calculation**: Blood bags have an active shelf-life of 42 days. The system automatically computes the expiration date field based on `CollectionDate + 42`.
*   **Status Management**:
    *   `Available`: Shelf life > 7 days.
    *   `Expiring`: Shelf life between 1 and 7 days.
    *   `Expired`: Shelf life <= 0 days (automatically blocked from search results and requests allocations).

### 4. Emergency Requests Processing
*   **Initiation Form**: Hospital representatives enter request units needed, required blood group, urgency level, patient name, and doctor contact parameters.
*   **Urgency Levels**:
    *   `Critical`: Triggers blinking alarm banners across dashboards. Requires immediate attention.
    *   `High`: Urgent attention.
    *   `Normal`: Standard processing for scheduled surgeries.
    *   `Low`: Routine therapy backup.
*   **Processing States**:
    *   `Pending` ➔ `Approved`: Admin confirms supply availability and sets state.
    *   `Pending` ➔ `Rejected`: If supply is unavailable and cannot be fulfilled.
    *   `Approved` ➔ `Completed`: When blood units are successfully hand-delivered/dispatched.

### 5. Document Downloads
*   **Donation Certificate**: Form-based PDF compilation containing donor name, units donated, blood bank stamp, and date.
*   **Request Release Slip**: PDF sheet showing hospital authorization details, contact person, patient name, and quantity requested. This serves as the courier transit clearance document.
