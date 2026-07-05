sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/core/routing/History",
    "sap/ui/model/json/JSONModel",
    "sap/m/MessageToast",
    "sap/m/MessageBox",
    "lifelink/model/models",
    "lifelink/model/formatter"
], function (Controller, History, JSONModel, MessageToast, MessageBox, models, formatter) {
    "use strict";

    return Controller.extend("lifelink.controller.DonorCreate", {

        formatter: formatter,

        onInit: function () {
            this._initNewDonorModel();
            this.getOwnerComponent().getRouter().getRoute("donorCreate").attachPatternMatched(this._onRouteMatched, this);
        },

        _onRouteMatched: function () {
            this._initNewDonorModel();
            this.byId("formMessage").setVisible(false);
        },

        _initNewDonorModel: function () {
            var oModel = models.createNewDonorModel();
            this.getView().setModel(oModel, "newDonor");
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

        /**
         * Validates form fields and saves the new donor.
         */
        onSaveDonor: function () {
            var oData = this.getView().getModel("newDonor").getData();
            var aErrors = this._validateForm(oData);

            if (aErrors.length > 0) {
                this.byId("formMessage").setText(aErrors.join("\n"));
                this.byId("formMessage").setVisible(true);
                return;
            }

            this.byId("formMessage").setVisible(false);

            // Generate a mock donor ID
            oData.DonorId = "DN" + String(Math.floor(Math.random() * 9000) + 1000);
            oData.Status = "Active";
            oData.CreatedOn = new Date().toISOString();
            oData.ChangedOn = new Date().toISOString();

            // In production, this would call OData create
            // this.getView().getModel().create("/DonorSet", oData, { ... });

            MessageToast.show(this.getView().getModel("i18n").getResourceBundle().getText("msgDonorCreated"));

            // Navigate back to donor list
            this.getOwnerComponent().getRouter().navTo("donorList");
        },

        /**
         * Validates form fields.
         * @param {Object} oData - Form data
         * @returns {Array} Array of error messages
         */
        _validateForm: function (oData) {
            var aErrors = [];

            if (!oData.FirstName || oData.FirstName.trim() === "") {
                aErrors.push("First Name is required.");
            }
            if (!oData.LastName || oData.LastName.trim() === "") {
                aErrors.push("Last Name is required.");
            }
            if (!oData.BloodGroup) {
                aErrors.push("Blood Group is required.");
            }
            if (!oData.DateOfBirth) {
                aErrors.push("Date of Birth is required.");
            }
            if (!oData.Gender) {
                aErrors.push("Gender is required.");
            }
            if (!oData.Phone || oData.Phone.trim() === "") {
                aErrors.push("Phone Number is required.");
            } else if (!/^\d{10,15}$/.test(oData.Phone.replace(/\D/g, ""))) {
                aErrors.push("Phone Number must be 10-15 digits.");
            }
            if (!oData.City || oData.City.trim() === "") {
                aErrors.push("City is required.");
            }
            if (!oData.State || oData.State.trim() === "") {
                aErrors.push("State is required.");
            }
            if (oData.Weight && (oData.Weight < 45 || oData.Weight > 200)) {
                aErrors.push("Weight must be between 45 and 200 kg for eligibility.");
            }
            if (oData.Email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(oData.Email)) {
                aErrors.push("Please enter a valid email address.");
            }

            return aErrors;
        }
    });
});
