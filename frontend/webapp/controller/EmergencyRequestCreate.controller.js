sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/core/routing/History",
    "sap/ui/model/json/JSONModel",
    "sap/m/MessageToast",
    "lifelink/model/models",
    "lifelink/model/formatter"
], function (Controller, History, JSONModel, MessageToast, models, formatter) {
    "use strict";

    return Controller.extend("lifelink.controller.EmergencyRequestCreate", {

        formatter: formatter,

        onInit: function () {
            this._initNewRequestModel();
            this.getOwnerComponent().getRouter().getRoute("emergencyRequestCreate").attachPatternMatched(this._onRouteMatched, this);
        },

        _onRouteMatched: function () {
            this._initNewRequestModel();
            this.byId("reqFormMessage").setVisible(false);
        },

        _initNewRequestModel: function () {
            var oModel = models.createNewRequestModel();
            this.getView().setModel(oModel, "newRequest");
        },

        onNavBack: function () {
            var oHistory = History.getInstance();
            var sPreviousHash = oHistory.getPreviousHash();
            if (sPreviousHash !== undefined) {
                window.history.go(-1);
            } else {
                this.getOwnerComponent().getRouter().navTo("emergencyRequests", {}, true);
            }
        },

        onSubmitRequest: function () {
            var oData = this.getView().getModel("newRequest").getData();
            var aErrors = this._validateForm(oData);

            if (aErrors.length > 0) {
                this.byId("reqFormMessage").setText(aErrors.join("\n"));
                this.byId("reqFormMessage").setVisible(true);
                return;
            }

            this.byId("reqFormMessage").setVisible(false);

            // Generate mock request ID
            oData.RequestId = "ER" + String(Math.floor(Math.random() * 9000) + 1000);
            oData.Status = "Pending";
            oData.RequestDate = new Date().toISOString();

            MessageToast.show(this.getView().getModel("i18n").getResourceBundle().getText("msgRequestCreated"));
            this.getOwnerComponent().getRouter().navTo("emergencyRequests");
        },

        _validateForm: function (oData) {
            var aErrors = [];
            if (!oData.HospitalId) aErrors.push("Hospital is required.");
            if (!oData.ContactPerson || oData.ContactPerson.trim() === "") aErrors.push("Contact Person is required.");
            if (!oData.ContactPhone || oData.ContactPhone.trim() === "") aErrors.push("Contact Phone is required.");
            if (!oData.PatientName || oData.PatientName.trim() === "") aErrors.push("Patient Name is required.");
            if (!oData.BloodGroup) aErrors.push("Blood Group is required.");
            if (!oData.UnitsNeeded || oData.UnitsNeeded < 1) aErrors.push("At least 1 unit must be requested.");
            if (!oData.Reason || oData.Reason.trim() === "") aErrors.push("Reason is required.");
            return aErrors;
        }
    });
});
