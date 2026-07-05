sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/core/routing/History",
    "sap/m/MessageToast",
    "sap/m/MessageBox",
    "lifelink/model/formatter"
], function (Controller, History, MessageToast, MessageBox, formatter) {
    "use strict";

    return Controller.extend("lifelink.controller.DonorDetail", {

        formatter: formatter,

        onInit: function () {
            this.getOwnerComponent().getRouter().getRoute("donorDetail").attachPatternMatched(this._onRouteMatched, this);
        },

        _onRouteMatched: function (oEvent) {
            var sDonorId = oEvent.getParameter("arguments").donorId;
            var sPath = "/DonorSet('" + sDonorId + "')";
            this.getView().bindElement({
                path: sPath,
                events: {
                    dataReceived: function () {
                        // Data loaded
                    }
                }
            });
        },

        onNavBack: function () {
            var oHistory = History.getInstance();
            var sPreviousHash = oHistory.getPreviousHash();
            if (sPreviousHash !== undefined) {
                window.history.go(-1);
            } else {
                this.getOwnerComponent().getRouter().navTo("donorList", {}, true);
            }
        },

        onEditDonor: function () {
            var oContext = this.getView().getBindingContext();
            if (oContext) {
                MessageToast.show("Edit mode enabled for " + oContext.getProperty("DonorId"));
            }
        },

        onDeleteDonor: function () {
            var that = this;
            var oContext = this.getView().getBindingContext();
            if (!oContext) return;

            var sName = oContext.getProperty("FirstName") + " " + oContext.getProperty("LastName");
            MessageBox.confirm("Are you sure you want to delete donor " + sName + "?", {
                title: "Confirm Delete",
                onClose: function (sAction) {
                    if (sAction === MessageBox.Action.OK) {
                        MessageToast.show("Donor deleted successfully.");
                        that.onNavBack();
                    }
                }
            });
        },

        onCheckEligibility: function () {
            var oContext = this.getView().getBindingContext();
            if (!oContext) return;

            var sLastDonation = oContext.getProperty("LastDonationDate");
            var sName = oContext.getProperty("FirstName") + " " + oContext.getProperty("LastName");

            if (!sLastDonation) {
                MessageBox.success(sName + " is ELIGIBLE for blood donation.\n\nNo previous donation on record.");
                return;
            }

            var oDate = new Date(sLastDonation);
            var iDaysSince = Math.floor((new Date() - oDate) / (1000 * 60 * 60 * 24));

            if (iDaysSince >= 56) {
                MessageBox.success(sName + " is ELIGIBLE for blood donation.\n\nDays since last donation: " + iDaysSince + " (minimum: 56 days)");
            } else {
                var iRemaining = 56 - iDaysSince;
                MessageBox.warning(sName + " is NOT ELIGIBLE for blood donation.\n\nDays since last donation: " + iDaysSince + "\nDays remaining: " + iRemaining);
            }
        },

        onToggleFullScreen: function () {
            MessageToast.show("Full screen toggled");
        }
    });
});
