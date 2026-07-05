sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/m/MessageToast",
    "sap/ui/model/json/JSONModel"
], function (Controller, MessageToast, JSONModel) {
    "use strict";

    return Controller.extend("lifelink.controller.Home", {
        onInit: function () {
            var oModel = new JSONModel({
                showSearchResults: false,
                showEligibilityResults: false,
                searchResults: [],
                eligibilityText: "",
                eligibilityState: "None"
            });
            this.getView().setModel(oModel, "homeView");
        },

        onNavToSignIn: function () {
            this.getOwnerComponent().getRouter().navTo("signin");
        },

        onNavToSignUp: function () {
            this.getOwnerComponent().getRouter().navTo("signup");
        },

        onNavToRequestCreate: function () {
            this.getOwnerComponent().getRouter().navTo("emergencyRequestCreate");
        },

        onNavToDashboard: function () {
            this.getOwnerComponent().getRouter().navTo("dashboard");
        },

        onContactSupport: function () {
            MessageToast.show("Support channels are open. Email: support@lifelink.org");
        },

        /**
         * Simulates a quick blood search on the homepage.
         */
        onQuickSearch: function () {
            var sGroup = this.byId("quickBloodGroup").getSelectedKey();
            var sCity = this.byId("quickCity").getValue().trim();

            if (!sCity) {
                MessageToast.show("Please enter a city name to search.");
                return;
            }

            // Simulate local search results
            var aResults = [
                { HospitalName: "Central Blood Bank & Depot", StorageLocation: sCity + " Sector 4", AvailableUnits: 14 },
                { HospitalName: "City General Hospital", StorageLocation: sCity + " Downtown", AvailableUnits: 3 },
                { HospitalName: "Red Cross Donation Hub", StorageLocation: sCity + " North Wing", AvailableUnits: 8 }
            ];

            var oHomeModel = this.getView().getModel("homeView");
            oHomeModel.setProperty("/searchResults", aResults);
            oHomeModel.setProperty("/showSearchResults", true);
            
            MessageToast.show("Search completed. Found " + sGroup + " units in " + sCity);
        },

        onCloseQuickSearch: function () {
            var oHomeModel = this.getView().getModel("homeView");
            oHomeModel.setProperty("/showSearchResults", false);
            this.byId("quickCity").setValue("");
        },

        /**
         * Dynamic donor eligibility validation on the landing page.
         */
        onQuickCheckEligibility: function () {
            var sAge = this.byId("quickAge").getValue();
            var sWeight = this.byId("quickWeight").getValue();
            var sDays = this.byId("quickDays").getValue();

            if (!sAge || !sWeight || !sDays) {
                MessageToast.show("Please fill out all eligibility checker fields.");
                return;
            }

            var iAge = parseInt(sAge, 10);
            var iWeight = parseInt(sWeight, 10);
            var iDays = parseInt(sDays, 10);
            var oHomeModel = this.getView().getModel("homeView");

            if (isNaN(iAge) || isNaN(iWeight) || isNaN(iDays)) {
                MessageToast.show("Please enter valid numbers.");
                return;
            }

            var sText = "";
            var sState = "None";

            if (iAge < 18 || iAge > 65) {
                sText = "❌ Age requirement not met: You must be between 18 and 65 years old to donate.";
                sState = "Error";
            } else if (iWeight < 45) {
                sText = "❌ Weight requirement not met: You must weigh at least 45 kg (99 lbs) to donate.";
                sState = "Error";
            } else if (iDays < 56) {
                var iWait = 56 - iDays;
                sText = "❌ Wait period not met: You must wait 56 days between donations. Please wait " + iWait + " more days.";
                sState = "Warning";
            } else {
                sText = "🎉 Congratulations! You meet the medical criteria to be a voluntary blood donor. Please register above to schedule a donation.";
                sState = "Success";
            }

            oHomeModel.setProperty("/eligibilityText", sText);
            oHomeModel.setProperty("/eligibilityState", sState);
            oHomeModel.setProperty("/showEligibilityResults", true);
        },

        onCloseEligibility: function () {
            var oHomeModel = this.getView().getModel("homeView");
            oHomeModel.setProperty("/showEligibilityResults", false);
            this.byId("quickAge").setValue("");
            this.byId("quickWeight").setValue("");
            this.byId("quickDays").setValue("");
        },

        onScrollToFeatures: function () {
            this._scrollToSection("featuresSection");
        },

        onScrollToTools: function () {
            this._scrollToSection("interactiveSection");
        },

        onScrollToStats: function () {
            this._scrollToSection("statsSection");
        },

        onScrollToTestimonials: function () {
            this._scrollToSection("testimonialsSection");
        },

        _scrollToSection: function (sId) {
            var oView = this.getView();
            var oSection = oView.byId(sId);
            if (oSection) {
                var oDomRef = oSection.getDomRef();
                if (oDomRef) {
                    oDomRef.scrollIntoView({ behavior: 'smooth', block: 'start' });
                }
            }
        }
    });
});
