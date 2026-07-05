sap.ui.define([
    "sap/ui/model/json/JSONModel",
    "sap/ui/Device"
], function (JSONModel, Device) {
    "use strict";

    return {
        /**
         * Creates a device model with system information.
         * @returns {sap.ui.model.json.JSONModel} Device model
         */
        createDeviceModel: function () {
            var oModel = new JSONModel(Device);
            oModel.setDefaultBindingMode("OneWay");
            return oModel;
        },

        /**
         * Creates the dashboard statistics model with initial values.
         * @returns {sap.ui.model.json.JSONModel} Dashboard stats model
         */
        createDashboardModel: function () {
            return new JSONModel({
                totalDonors: 0,
                availableUnits: 0,
                pendingRequests: 0,
                approvedRequests: 0,
                bloodGroupsAvailable: 0,
                expiringUnits: 0,
                recentDonations: [],
                recentRequests: [],
                bloodGroupDistribution: [],
                monthlyDonations: []
            });
        },

        /**
         * Creates a new empty donor model for form binding.
         * @returns {sap.ui.model.json.JSONModel} Empty donor model
         */
        createNewDonorModel: function () {
            return new JSONModel({
                DonorId: "",
                FirstName: "",
                LastName: "",
                BloodGroup: "",
                DateOfBirth: null,
                Gender: "",
                Phone: "",
                Email: "",
                Street: "",
                City: "",
                State: "",
                PinCode: "",
                Weight: 0,
                LastDonationDate: null,
                Status: "Active",
                MedicalNotes: ""
            });
        },

        /**
         * Creates a new empty emergency request model for form binding.
         * @returns {sap.ui.model.json.JSONModel} Empty request model
         */
        createNewRequestModel: function () {
            return new JSONModel({
                RequestId: "",
                HospitalId: "",
                PatientName: "",
                BloodGroup: "",
                UnitsNeeded: 1,
                Urgency: "Normal",
                ContactPerson: "",
                ContactPhone: "",
                Reason: "",
                Status: "Pending",
                RequestDate: new Date(),
                Notes: ""
            });
        },

        /**
         * Creates a model with blood group options.
         * @returns {sap.ui.model.json.JSONModel} Blood groups model
         */
        createBloodGroupModel: function () {
            return new JSONModel({
                bloodGroups: [
                    { key: "A+", text: "A Positive (A+)" },
                    { key: "A-", text: "A Negative (A-)" },
                    { key: "B+", text: "B Positive (B+)" },
                    { key: "B-", text: "B Negative (B-)" },
                    { key: "AB+", text: "AB Positive (AB+)" },
                    { key: "AB-", text: "AB Negative (AB-)" },
                    { key: "O+", text: "O Positive (O+)" },
                    { key: "O-", text: "O Negative (O-)" }
                ]
            });
        }
    };
});
