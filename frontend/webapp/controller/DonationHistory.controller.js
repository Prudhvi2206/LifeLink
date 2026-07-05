sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/core/routing/History",
    "sap/ui/model/json/JSONModel",
    "sap/ui/model/Filter",
    "sap/ui/model/FilterOperator",
    "sap/m/MessageToast",
    "lifelink/model/formatter"
], function (Controller, History, JSONModel, Filter, FilterOperator, MessageToast, formatter) {
    "use strict";

    return Controller.extend("lifelink.controller.DonationHistory", {

        formatter: formatter,

        onInit: function () {
            var oViewModel = new JSONModel({
                donationCount: 0
            });
            this.getView().setModel(oViewModel, "viewModel");
            this.getOwnerComponent().getRouter().getRoute("donationHistory").attachPatternMatched(this._onRouteMatched, this);
        },

        _onRouteMatched: function () {
            var oTable = this.byId("historyTable");
            var oBinding = oTable.getBinding("items");
            if (oBinding) {
                oBinding.detachEvent("change", this._updateCount, this);
                oBinding.attachEvent("change", this._updateCount, this);
                oBinding.detachEvent("dataReceived", this._updateCount, this);
                oBinding.attachEvent("dataReceived", this._updateCount, this);
            }
            this._updateCount();
        },

        _updateCount: function () {
            var oTable = this.byId("historyTable");
            var oBinding = oTable.getBinding("items");
            if (oBinding) {
                this.getView().getModel("viewModel").setProperty("/donationCount", oBinding.getLength());
            }
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

        onSearch: function (oEvent) {
            var sQuery = oEvent.getParameter("newValue") || "";
            var aFilters = [];
            if (sQuery) {
                aFilters.push(new Filter({
                    filters: [
                        new Filter("DonorName", FilterOperator.Contains, sQuery),
                        new Filter("DonorId", FilterOperator.Contains, sQuery),
                        new Filter("DonationId", FilterOperator.Contains, sQuery),
                        new Filter("HospitalName", FilterOperator.Contains, sQuery),
                        new Filter("BloodGroup", FilterOperator.Contains, sQuery)
                    ],
                    and: false
                }));
            }
            this.byId("historyTable").getBinding("items").filter(aFilters);
            this._updateCount();
        },

        onDateFilter: function () {
            var aFilters = [];
            var sDateFrom = this.byId("dpDateFrom").getValue();
            var sDateTo = this.byId("dpDateTo").getValue();
            var sBloodGroup = this.byId("filterHistBloodGroup").getSelectedKey();

            if (sDateFrom) {
                aFilters.push(new Filter("DonationDate", FilterOperator.GE, new Date(sDateFrom)));
            }
            if (sDateTo) {
                aFilters.push(new Filter("DonationDate", FilterOperator.LE, new Date(sDateTo)));
            }
            if (sBloodGroup && sBloodGroup !== "ALL") {
                aFilters.push(new Filter("BloodGroup", FilterOperator.EQ, sBloodGroup));
            }

            this.byId("historyTable").getBinding("items").filter(aFilters);
            this._updateCount();
        },

        onFilterBloodGroup: function () {
            this.onDateFilter(); // Re-apply all filters together
        },

        onExport: function () {
            MessageToast.show("Exporting donation history to Excel...");
        },

        onRefresh: function () {
            this.byId("historyTable").getBinding("items").refresh();
            MessageToast.show("Donation history refreshed.");
        }
    });
});
