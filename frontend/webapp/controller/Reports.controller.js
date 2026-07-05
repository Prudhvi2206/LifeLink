sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/core/routing/History",
    "sap/ui/model/Filter",
    "sap/ui/model/FilterOperator",
    "sap/m/MessageToast",
    "lifelink/model/formatter"
], function (Controller, History, Filter, FilterOperator, MessageToast, formatter) {
    "use strict";

    return Controller.extend("lifelink.controller.Reports", {

        formatter: formatter,

        onInit: function () {
            this.getOwnerComponent().getRouter().getRoute("reports").attachPatternMatched(this._onRouteMatched, this);
        },

        _onRouteMatched: function () {
            // Reset filters when navigating back
        },

        onNavBack: function () {
            var oHistory = History.getInstance();
            var sPreviousHash = oHistory.getPreviousHash();
            if (sPreviousHash !== undefined) {
                window.history.go(-1);
            } else {
                this.getOwnerComponent().getRouter().navTo("dashboard", {}, true);
            }
        },

        onTabSelect: function (oEvent) {
            // Tab changed - data already bound
        },

        // --- Donor Report ---
        onSearchDonorReport: function (oEvent) {
            var sQuery = oEvent.getParameter("newValue") || "";
            var aFilters = [];
            if (sQuery) {
                aFilters.push(new Filter({
                    filters: [
                        new Filter("FirstName", FilterOperator.Contains, sQuery),
                        new Filter("LastName", FilterOperator.Contains, sQuery),
                        new Filter("DonorId", FilterOperator.Contains, sQuery),
                        new Filter("City", FilterOperator.Contains, sQuery)
                    ],
                    and: false
                }));
            }
            this.byId("donorReportTable").getBinding("items").filter(aFilters);
        },

        onExportDonorReport: function () {
            MessageToast.show("Exporting Donor Report to Excel...");
        },

        // --- Inventory Report ---
        onSearchInventoryReport: function (oEvent) {
            var sQuery = oEvent.getParameter("newValue") || "";
            var aFilters = [];
            if (sQuery) {
                aFilters.push(new Filter({
                    filters: [
                        new Filter("BloodGroup", FilterOperator.Contains, sQuery),
                        new Filter("HospitalName", FilterOperator.Contains, sQuery),
                        new Filter("InventoryId", FilterOperator.Contains, sQuery)
                    ],
                    and: false
                }));
            }
            this.byId("inventoryReportTable").getBinding("items").filter(aFilters);
        },

        onExportInventoryReport: function () {
            MessageToast.show("Exporting Blood Inventory Report to Excel...");
        },

        // --- Request Report ---
        onSearchRequestReport: function (oEvent) {
            var sQuery = oEvent.getParameter("newValue") || "";
            var aFilters = [];
            if (sQuery) {
                aFilters.push(new Filter({
                    filters: [
                        new Filter("PatientName", FilterOperator.Contains, sQuery),
                        new Filter("HospitalName", FilterOperator.Contains, sQuery),
                        new Filter("RequestId", FilterOperator.Contains, sQuery)
                    ],
                    and: false
                }));
            }
            this.byId("requestReportTable").getBinding("items").filter(aFilters);
        },

        onExportRequestReport: function () {
            MessageToast.show("Exporting Emergency Request Report to Excel...");
        },

        // --- Donation Report ---
        onSearchDonationReport: function (oEvent) {
            var sQuery = oEvent.getParameter("newValue") || "";
            var aFilters = [];
            if (sQuery) {
                aFilters.push(new Filter({
                    filters: [
                        new Filter("DonorName", FilterOperator.Contains, sQuery),
                        new Filter("DonationId", FilterOperator.Contains, sQuery),
                        new Filter("HospitalName", FilterOperator.Contains, sQuery)
                    ],
                    and: false
                }));
            }
            this.byId("donationReportTable").getBinding("items").filter(aFilters);
        },

        onExportDonationReport: function () {
            MessageToast.show("Exporting Donation Report to Excel...");
        },

        onRefresh: function () {
            MessageToast.show("Reports refreshed.");
        }
    });
});
