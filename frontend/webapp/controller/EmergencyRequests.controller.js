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

    return Controller.extend("lifelink.controller.EmergencyRequests", {

        formatter: formatter,

        onInit: function () {
            var oViewModel = new JSONModel({
                allCount: 10,
                pendingCount: 3,
                approvedCount: 4,
                rejectedCount: 1,
                completedCount: 2,
                hasCritical: true
            });
            this.getView().setModel(oViewModel, "viewModel");
            this.getOwnerComponent().getRouter().getRoute("emergencyRequests").attachPatternMatched(this._onRouteMatched, this);
        },

        _onRouteMatched: function () {
            // Refresh counts when page is shown
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
                        new Filter("RequestId", FilterOperator.Contains, sQuery),
                        new Filter("PatientName", FilterOperator.Contains, sQuery),
                        new Filter("HospitalName", FilterOperator.Contains, sQuery),
                        new Filter("BloodGroup", FilterOperator.Contains, sQuery)
                    ],
                    and: false
                }));
            }
            this.byId("requestTable").getBinding("items").filter(aFilters);
        },

        onFilterStatus: function () {
            this._applyAllFilters();
        },

        onFilterUrgency: function () {
            this._applyAllFilters();
        },

        _applyAllFilters: function () {
            var aFilters = [];
            var sStatus = this.byId("filterReqStatus").getSelectedKey();
            var sUrgency = this.byId("filterUrgency").getSelectedKey();

            if (sStatus && sStatus !== "ALL") {
                aFilters.push(new Filter("Status", FilterOperator.EQ, sStatus));
            }
            if (sUrgency && sUrgency !== "ALL") {
                aFilters.push(new Filter("Urgency", FilterOperator.EQ, sUrgency));
            }
            this.byId("requestTable").getBinding("items").filter(aFilters);
        },

        onTabSelect: function (oEvent) {
            var sKey = oEvent.getParameter("key");
            var aFilters = [];
            if (sKey !== "ALL") {
                aFilters.push(new Filter("Status", FilterOperator.EQ, sKey));
            }
            this.byId("requestTable").getBinding("items").filter(aFilters);
        },

        onCreateRequest: function () {
            this.getOwnerComponent().getRouter().navTo("emergencyRequestCreate");
        },

        onRequestPress: function (oEvent) {
            var oContext = oEvent.getSource().getBindingContext();
            var sRequestId = oContext.getProperty("RequestId");
            MessageToast.show("Request details: " + sRequestId);
        },

        onApproveRequest: function () {
            this._changeStatus("Approved", "msgRequestApproved", "msgConfirmApprove");
        },

        onRejectRequest: function () {
            this._changeStatus("Rejected", "msgRequestRejected", "msgConfirmReject");
        },

        onCompleteRequest: function () {
            this._changeStatus("Completed", "msgRequestCompleted", "Are you sure you want to complete this request?");
        },

        onApproveRow: function (oEvent) {
            var oContext = oEvent.getSource().getBindingContext();
            var sRequestId = oContext.getProperty("RequestId");
            var that = this;
            MessageBox.confirm("Approve request " + sRequestId + "?", {
                title: "Confirm Approval",
                onClose: function (sAction) {
                    if (sAction === MessageBox.Action.OK) {
                        MessageToast.show("Request " + sRequestId + " approved.");
                    }
                }
            });
        },

        onRejectRow: function (oEvent) {
            var oContext = oEvent.getSource().getBindingContext();
            var sRequestId = oContext.getProperty("RequestId");
            MessageBox.confirm("Reject request " + sRequestId + "?", {
                title: "Confirm Rejection",
                onClose: function (sAction) {
                    if (sAction === MessageBox.Action.OK) {
                        MessageToast.show("Request " + sRequestId + " rejected.");
                    }
                }
            });
        },

        _changeStatus: function (sNewStatus, sMsgKey, sConfirmKey) {
            var oTable = this.byId("requestTable");
            var oItem = oTable.getSelectedItem();
            if (!oItem) {
                MessageToast.show("Please select a request first.");
                return;
            }
            var oContext = oItem.getBindingContext();
            var sRequestId = oContext.getProperty("RequestId");

            MessageBox.confirm("Change status of " + sRequestId + " to " + sNewStatus + "?", {
                title: "Confirm Status Change",
                onClose: function (sAction) {
                    if (sAction === MessageBox.Action.OK) {
                        MessageToast.show("Request " + sRequestId + " status changed to " + sNewStatus + ".");
                    }
                }
            });
        },

        onRefresh: function () {
            this.byId("requestTable").getBinding("items").refresh();
            MessageToast.show("Requests refreshed.");
        }
    });
});
