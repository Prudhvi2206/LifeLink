sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/core/routing/History",
    "sap/ui/model/json/JSONModel",
    "sap/m/MessageToast",
    "lifelink/model/formatter"
], function (Controller, History, JSONModel, MessageToast, formatter) {
    "use strict";

    return Controller.extend("lifelink.controller.BloodSearch", {

        formatter: formatter,

        onInit: function () {
            var oSearchModel = new JSONModel({
                bloodGroup: "",
                hospital: "",
                city: "",
                results: [],
                hasSearched: false,
                hasResults: false,
                resultCount: 0
            });
            this.getView().setModel(oSearchModel, "searchModel");
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

        /**
         * Performs blood availability search against mock inventory data.
         */
        onSearch: function () {
            var oSearchModel = this.getView().getModel("searchModel");
            var sBloodGroup = oSearchModel.getProperty("/bloodGroup");
            var sHospital = oSearchModel.getProperty("/hospital").toLowerCase();
            var sCity = oSearchModel.getProperty("/city").toLowerCase();

            // Get all inventory data from the OData model
            var oModel = this.getView().getModel();
            var that = this;

            // Read inventory data
            oModel.read("/BloodInventorySet", {
                success: function (oData) {
                    var aResults = oData.results || [];

                    // Add city from hospital data (mock enrichment)
                    var mHospitalCity = {
                        "H001": "Mumbai",
                        "H002": "Delhi",
                        "H003": "Bangalore",
                        "H004": "Hyderabad",
                        "H005": "Chennai",
                        "H006": "Jaipur"
                    };

                    // Filter results
                    var aFiltered = aResults.filter(function (item) {
                        var bMatch = true;
                        if (sBloodGroup && item.BloodGroup !== sBloodGroup) bMatch = false;
                        if (sHospital && item.HospitalName.toLowerCase().indexOf(sHospital) === -1) bMatch = false;
                        var itemCity = mHospitalCity[item.HospitalId] || "";
                        if (sCity && itemCity.toLowerCase().indexOf(sCity) === -1) bMatch = false;
                        // Only show available stock
                        if (item.Units <= 0 || item.Status === "Expired") bMatch = false;
                        return bMatch;
                    });

                    // Add city to results
                    aFiltered.forEach(function (item) {
                        item.City = mHospitalCity[item.HospitalId] || "Unknown";
                    });

                    oSearchModel.setProperty("/results", aFiltered);
                    oSearchModel.setProperty("/hasSearched", true);
                    oSearchModel.setProperty("/hasResults", aFiltered.length > 0);
                    oSearchModel.setProperty("/resultCount", aFiltered.length);

                    if (aFiltered.length > 0) {
                        MessageToast.show("Found " + aFiltered.length + " matching blood units.");
                    } else {
                        MessageToast.show("No blood units found matching your criteria.");
                    }
                },
                error: function () {
                    // Fallback: use mock data directly
                    oSearchModel.setProperty("/hasSearched", true);
                    oSearchModel.setProperty("/hasResults", false);
                    oSearchModel.setProperty("/resultCount", 0);
                    MessageToast.show("Unable to search. Please try again.");
                }
            });
        },

        /**
         * Clears all search fields and results.
         */
        onClearSearch: function () {
            var oSearchModel = this.getView().getModel("searchModel");
            oSearchModel.setProperty("/bloodGroup", "");
            oSearchModel.setProperty("/hospital", "");
            oSearchModel.setProperty("/city", "");
            oSearchModel.setProperty("/results", []);
            oSearchModel.setProperty("/hasSearched", false);
            oSearchModel.setProperty("/hasResults", false);
            oSearchModel.setProperty("/resultCount", 0);
        }
    });
});
