sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/m/MessageToast",
    "sap/m/MessageBox"
], function (Controller, MessageToast, MessageBox) {
    "use strict";

    return Controller.extend("lifelink.controller.SignIn", {
        onInit: function () {
            // Reset input values on page navigation
            this.getOwnerComponent().getRouter().getRoute("signin").attachPatternMatched(this._onPatternMatched, this);
        },

        _onPatternMatched: function () {
            var oUsernameInput = this.byId("usernameInput");
            var oPasswordInput = this.byId("passwordInput");
            if (oUsernameInput) { oUsernameInput.setValue(""); }
            if (oPasswordInput) { oPasswordInput.setValue(""); }
        },

        onSignIn: function () {
            var sUsername = this.byId("usernameInput").getValue().trim();
            var sPassword = this.byId("passwordInput").getValue().trim();

            if (!sUsername || !sPassword) {
                MessageToast.show("Please enter both username and password.");
                return;
            }

            // Simple demo validation logic
            if (sUsername.toLowerCase() === "admin" && sPassword === "admin") {
                MessageToast.show("Signed in successfully as Blood Bank Administrator!");
                
                // Navigate to dashboard
                this.getOwnerComponent().getRouter().navTo("dashboard");
            } else {
                // To keep it developer-friendly, allow any login but show info message
                MessageToast.show("Signed in successfully! (Demo mode auto-approval)");
                this.getOwnerComponent().getRouter().navTo("dashboard");
            }
        },

        onNavToHome: function () {
            this.getOwnerComponent().getRouter().navTo("home");
        },

        onNavToSignUp: function () {
            this.getOwnerComponent().getRouter().navTo("signup");
        }
    });
});
