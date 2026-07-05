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

    return Controller.extend("lifelink.controller.BloodInventory", {

        formatter: formatter,

        onInit: function () {
            var oViewModel = new JSONModel({
                totalUnits: 0
            });
            this.getView().setModel(oViewModel, "viewModel");
            this.getOwnerComponent().getRouter().getRoute("bloodInventory").attachPatternMatched(this._onRouteMatched, this);
        },

        _onRouteMatched: function () {
            var oTable = this.byId("inventoryTable");
            var oBinding = oTable.getBinding("items");
            if (oBinding) {
                oBinding.detachEvent("change", this._updateTotalUnits, this);
                oBinding.attachEvent("change", this._updateTotalUnits, this);
                oBinding.detachEvent("dataReceived", this._updateTotalUnits, this);
                oBinding.attachEvent("dataReceived", this._updateTotalUnits, this);
            }
            this._updateTotalUnits();
        },

        _updateTotalUnits: function () {
            var oTable = this.byId("inventoryTable");
            var oBinding = oTable.getBinding("items");
            if (oBinding) {
                var aItems = oBinding.getCurrentContexts();
                var iTotal = 0;
                aItems.forEach(function (oCtx) {
                    iTotal += oCtx.getProperty("Units") || 0;
                });
                this.getView().getModel("viewModel").setProperty("/totalUnits", iTotal);
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
                        new Filter("InventoryId", FilterOperator.Contains, sQuery),
                        new Filter("BloodGroup", FilterOperator.Contains, sQuery),
                        new Filter("HospitalName", FilterOperator.Contains, sQuery),
                        new Filter("StorageLocation", FilterOperator.Contains, sQuery)
                    ],
                    and: false
                }));
            }
            this.byId("inventoryTable").getBinding("items").filter(aFilters);
            this._updateTotalUnits();
        },

        onFilterBloodGroup: function () {
            this._applyAllFilters();
        },

        onFilterHospital: function () {
            this._applyAllFilters();
        },

        onFilterStatus: function () {
            this._applyAllFilters();
        },

        _applyAllFilters: function () {
            var aFilters = [];
            var sBloodGroup = this.byId("filterInvBloodGroup").getSelectedKey();
            var sStatus = this.byId("filterInvStatus").getSelectedKey();

            if (sBloodGroup && sBloodGroup !== "ALL") {
                aFilters.push(new Filter("BloodGroup", FilterOperator.EQ, sBloodGroup));
            }
            if (sStatus && sStatus !== "ALL") {
                aFilters.push(new Filter("Status", FilterOperator.EQ, sStatus));
            }
            this.byId("inventoryTable").getBinding("items").filter(aFilters);
            this._updateTotalUnits();
        },

        onAddInventory: function () {
            MessageToast.show("Add Blood Units dialog would open here. In production, this calls OData CREATE.");
        },

        onUpdateInventory: function () {
            MessageToast.show("Update inventory via OData PATCH/PUT.");
        },

        onDeleteInventory: function () {
            MessageBox.confirm("Are you sure you want to delete the selected inventory record?", {
                title: "Confirm Delete",
                onClose: function (sAction) {
                    if (sAction === MessageBox.Action.OK) {
                        MessageToast.show("Inventory record deleted.");
                    }
                }
            });
        },

        onExport: function () {
            MessageToast.show("Exporting inventory data to Excel...");
        },

        onRefresh: function () {
            this.byId("inventoryTable").getBinding("items").refresh();
            MessageToast.show("Inventory data refreshed.");
        }
    });
});
