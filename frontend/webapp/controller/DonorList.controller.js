sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/core/routing/History",
    "sap/ui/model/json/JSONModel",
    "sap/ui/model/Filter",
    "sap/ui/model/FilterOperator",
    "sap/m/MessageToast",
    "sap/m/MessageBox",
    "lifelink/model/formatter"
], function (Controller, History, JSONModel, Filter, FilterOperator, MessageToast, MessageBox, formatter) {
    "use strict";

    return Controller.extend("lifelink.controller.DonorList", {

        formatter: formatter,

        onInit: function () {
            var oViewModel = new JSONModel({
                hasSelection: false,
                donorCount: 0,
                selectedDonorId: ""
            });
            this.getView().setModel(oViewModel, "viewModel");

            this.getOwnerComponent().getRouter().getRoute("donorList").attachPatternMatched(this._onRouteMatched, this);
        },

        _onRouteMatched: function () {
            var oTable = this.byId("donorTable");
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
            var oTable = this.byId("donorTable");
            var oBinding = oTable.getBinding("items");
            if (oBinding) {
                this.getView().getModel("viewModel").setProperty("/donorCount", oBinding.getLength());
            }
        },

        /**
         * Navigates back in history or to the dashboard.
         */
        onNavBack: function () {
            var oHistory = History.getInstance();
            var sPreviousHash = oHistory.getPreviousHash();
            if (sPreviousHash !== undefined) {
                window.history.go(-1);
            } else {
                this.getOwnerComponent().getRouter().navTo("dashboard", {}, true);
            }
        },

        /**
         * Searches donors by name, ID, city, or blood group.
         * @param {sap.ui.base.Event} oEvent - The search event
         */
        onSearch: function (oEvent) {
            var sQuery = oEvent.getParameter("newValue") || "";
            var aFilters = [];
            if (sQuery) {
                aFilters.push(new Filter({
                    filters: [
                        new Filter("FirstName", FilterOperator.Contains, sQuery),
                        new Filter("LastName", FilterOperator.Contains, sQuery),
                        new Filter("DonorId", FilterOperator.Contains, sQuery),
                        new Filter("City", FilterOperator.Contains, sQuery),
                        new Filter("BloodGroup", FilterOperator.Contains, sQuery)
                    ],
                    and: false
                }));
            }
            this._applyFilters(aFilters);
        },

        /**
         * Filters donors by blood group.
         * @param {sap.ui.base.Event} oEvent - The selection event
         */
        onFilterBloodGroup: function (oEvent) {
            this._applyAllFilters();
        },

        /**
         * Filters donors by status.
         * @param {sap.ui.base.Event} oEvent - The selection event
         */
        onFilterStatus: function (oEvent) {
            this._applyAllFilters();
        },

        _applyAllFilters: function () {
            var aFilters = [];
            var sBloodGroup = this.byId("filterBloodGroup").getSelectedKey();
            var sStatus = this.byId("filterStatus").getSelectedKey();

            if (sBloodGroup && sBloodGroup !== "ALL") {
                aFilters.push(new Filter("BloodGroup", FilterOperator.EQ, sBloodGroup));
            }
            if (sStatus && sStatus !== "ALL") {
                aFilters.push(new Filter("Status", FilterOperator.EQ, sStatus));
            }
            this._applyFilters(aFilters);
        },

        _applyFilters: function (aFilters) {
            var oTable = this.byId("donorTable");
            var oBinding = oTable.getBinding("items");
            oBinding.filter(aFilters);
            this._updateCount();
        },

        /**
         * Handles donor row selection.
         */
        onDonorSelect: function (oEvent) {
            var oItem = oEvent.getParameter("listItem");
            if (oItem) {
                this.getView().getModel("viewModel").setProperty("/hasSelection", true);
                var oContext = oItem.getBindingContext();
                this.getView().getModel("viewModel").setProperty("/selectedDonorId", oContext.getProperty("DonorId"));
            }
        },

        /**
         * Navigates to the donor detail page.
         * @param {sap.ui.base.Event} oEvent - The press event
         */
        onDonorPress: function (oEvent) {
            var oItem = oEvent.getSource();
            var oContext = oItem.getBindingContext();
            var sDonorId = oContext.getProperty("DonorId");
            this.getOwnerComponent().getRouter().navTo("donorDetail", { donorId: sDonorId });
        },

        /**
         * Navigates to the Add Donor page.
         */
        onAddDonor: function () {
            this.getOwnerComponent().getRouter().navTo("donorCreate");
        },

        /**
         * Edits the selected donor.
         */
        onEditDonor: function () {
            var sDonorId = this.getView().getModel("viewModel").getProperty("/selectedDonorId");
            if (sDonorId) {
                this.getOwnerComponent().getRouter().navTo("donorDetail", { donorId: sDonorId });
            }
        },

        /**
         * Inline edit button handler.
         */
        onEditDonorRow: function (oEvent) {
            var oContext = oEvent.getSource().getBindingContext();
            var sDonorId = oContext.getProperty("DonorId");
            this.getOwnerComponent().getRouter().navTo("donorDetail", { donorId: sDonorId });
        },

        /**
         * Deletes the selected donor after confirmation.
         */
        onDeleteDonor: function () {
            var that = this;
            var sDonorId = this.getView().getModel("viewModel").getProperty("/selectedDonorId");
            if (!sDonorId) return;

            MessageBox.confirm(this.getView().getModel("i18n").getResourceBundle().getText("msgConfirmDelete"), {
                title: "Confirm Delete",
                onClose: function (sAction) {
                    if (sAction === MessageBox.Action.OK) {
                        MessageToast.show(that.getView().getModel("i18n").getResourceBundle().getText("msgDonorDeleted"));
                        that.getView().getModel("viewModel").setProperty("/hasSelection", false);
                    }
                }
            });
        },

        /**
         * Inline delete button handler.
         */
        onDeleteDonorRow: function (oEvent) {
            var that = this;
            var oContext = oEvent.getSource().getBindingContext();
            var sDonorId = oContext.getProperty("DonorId");
            var sName = oContext.getProperty("FirstName") + " " + oContext.getProperty("LastName");

            MessageBox.confirm("Are you sure you want to delete donor " + sName + " (" + sDonorId + ")?", {
                title: "Confirm Delete",
                onClose: function (sAction) {
                    if (sAction === MessageBox.Action.OK) {
                        MessageToast.show("Donor " + sDonorId + " deleted successfully.");
                    }
                }
            });
        },

        /**
         * Refreshes the donor table data.
         */
        onRefresh: function () {
            this.byId("donorTable").getBinding("items").refresh();
            MessageToast.show("Data refreshed.");
        }
    });
});
