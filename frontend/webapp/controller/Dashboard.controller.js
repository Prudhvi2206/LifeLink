sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/model/json/JSONModel",
    "lifelink/model/formatter"
], function (Controller, JSONModel, formatter) {
    "use strict";

    return Controller.extend("lifelink.controller.Dashboard", {

        formatter: formatter,

        onInit: function () {
            // Dashboard statistics model
            var oDashStats = new JSONModel({
                TotalDonors: 15,
                AvailableUnits: 161,
                PendingRequests: 3,
                ApprovedRequests: 4,
                BloodGroupsAvailable: 8,
                ExpiringUnits: 3,
                TotalDonationsThisMonth: 4,
                CompletedRequests: 2
            });
            this.getView().setModel(oDashStats, "dashStats");

            // Blood group distribution model
            var oBloodGroups = new JSONModel([
                { BloodGroup: "O+", TotalUnits: 57, DonorCount: 3 },
                { BloodGroup: "A+", TotalUnits: 30, DonorCount: 2 },
                { BloodGroup: "B+", TotalUnits: 35, DonorCount: 2 },
                { BloodGroup: "AB+", TotalUnits: 18, DonorCount: 2 },
                { BloodGroup: "O-", TotalUnits: 6, DonorCount: 2 },
                { BloodGroup: "A-", TotalUnits: 9, DonorCount: 2 },
                { BloodGroup: "B-", TotalUnits: 4, DonorCount: 1 },
                { BloodGroup: "AB-", TotalUnits: 2, DonorCount: 1 }
            ]);
            this.getView().setModel(oBloodGroups, "bloodGroups");
        },

        /**
         * Calculates percentage for progress indicator (max 60 units = 100%).
         * @param {number} iUnits - Number of units
         * @returns {number} Percentage value
         */
        calcPercentage: function (iUnits) {
            return Math.min((iUnits / 60) * 100, 100);
        },

        /**
         * Navigates to the Donor Create page.
         */
        onNavToDonorCreate: function () {
            this.getOwnerComponent().getRouter().navTo("donorCreate");
        },

        /**
         * Navigates to the Emergency Request Create page.
         */
        onNavToRequestCreate: function () {
            this.getOwnerComponent().getRouter().navTo("emergencyRequestCreate");
        },

        /**
         * Navigates to the Blood Search page.
         */
        onNavToSearch: function () {
            this.getOwnerComponent().getRouter().navTo("bloodSearch");
        },

        /**
         * Navigates to the Donation History page.
         */
        onNavToHistory: function () {
            this.getOwnerComponent().getRouter().navTo("donationHistory");
        },

        /**
         * Navigates to the Emergency Requests page.
         */
        onNavToRequests: function () {
            this.getOwnerComponent().getRouter().navTo("emergencyRequests");
        },

        /**
         * Handles press on a donation row in recent donations table.
         */
        onDonationPress: function () {
            this.getOwnerComponent().getRouter().navTo("donationHistory");
        },

        /**
         * Handles press on a request row in recent requests table.
         */
        onRequestPress: function () {
            this.getOwnerComponent().getRouter().navTo("emergencyRequests");
        }
    });
});
