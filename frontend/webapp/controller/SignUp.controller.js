sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/m/MessageToast",
    "sap/m/MessageBox"
], function (Controller, MessageToast, MessageBox) {
    "use strict";

    return Controller.extend("lifelink.controller.SignUp", {
        onInit: function () {
            // Reset input values on page navigation
            this.getOwnerComponent().getRouter().getRoute("signup").attachPatternMatched(this._onPatternMatched, this);
        },

        _onPatternMatched: function () {
            var oNameInput = this.byId("nameInput");
            var oEmailInput = this.byId("emailInput");
            var oPasswordInput = this.byId("passwordInput");
            var oPhoneInput = this.byId("phoneInput");
            var oCityInput = this.byId("cityInput");
            var oBloodSelect = this.byId("bloodSelect");
            var oRoleSelect = this.byId("roleSelect");

            if (oNameInput) { oNameInput.setValue(""); }
            if (oEmailInput) { oEmailInput.setValue(""); }
            if (oPasswordInput) { oPasswordInput.setValue(""); }
            if (oPhoneInput) { oPhoneInput.setValue(""); }
            if (oCityInput) { oCityInput.setValue(""); }
            if (oBloodSelect) { oBloodSelect.setSelectedKey("A+"); }
            if (oRoleSelect) { oRoleSelect.setSelectedKey("donor"); }
        },

        onSignUp: function () {
            var sName = this.byId("nameInput").getValue().trim();
            var sEmail = this.byId("emailInput").getValue().trim();
            var sPassword = this.byId("passwordInput").getValue();
            var sPhone = this.byId("phoneInput").getValue().trim();
            var sCity = this.byId("cityInput").getValue().trim();
            var sBloodGroup = this.byId("bloodSelect").getSelectedKey();
            var sRole = this.byId("roleSelect").getSelectedKey();

            var aErrors = [];

            if (!sName) {
                aErrors.push("Full Name is required.");
            }
            if (!sEmail || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(sEmail)) {
                aErrors.push("Please enter a valid email address.");
            }
            if (!sPassword || sPassword.length < 6) {
                aErrors.push("Password must be at least 6 characters long.");
            }
            if (!sPhone || sPhone.length < 10) {
                aErrors.push("Please enter a valid phone number.");
            }
            if (!sCity) {
                aErrors.push("City is required.");
            }

            if (aErrors.length > 0) {
                MessageBox.error(aErrors.join("\n"));
                return;
            }

            // Simulate database registration success
            var sSuccessMsg = sRole === "donor" ? 
                "Voluntary Donor registration submitted successfully! Please sign in." :
                "Hospital partnership request submitted successfully! Please sign in.";
            
            MessageToast.show(sSuccessMsg);

            // Redirect to Sign In
            this.getOwnerComponent().getRouter().navTo("signin");
        },

        onNavToHome: function () {
            this.getOwnerComponent().getRouter().navTo("home");
        },

        onNavToSignIn: function () {
            this.getOwnerComponent().getRouter().navTo("signin");
        }
    });
});
