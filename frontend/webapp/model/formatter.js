sap.ui.define([
    "sap/ui/core/format/DateFormat"
], function (DateFormat) {
    "use strict";

    return {
        /**
         * Formats the request status text.
         * @param {string} sStatus - Status key
         * @returns {string} Formatted status text
         */
        formatStatusText: function (sStatus) {
            var mStatusText = {
                "Pending": "Pending",
                "Approved": "Approved",
                "Rejected": "Rejected",
                "Completed": "Completed",
                "Cancelled": "Cancelled"
            };
            return mStatusText[sStatus] || sStatus;
        },

        /**
         * Formats the request status to a semantic state.
         * @param {string} sStatus - Status key
         * @returns {string} ValueState
         */
        formatStatusState: function (sStatus) {
            var mStatusState = {
                "Pending": "Warning",
                "Approved": "Success",
                "Rejected": "Error",
                "Completed": "Information",
                "Cancelled": "None"
            };
            return mStatusState[sStatus] || "None";
        },

        /**
         * Formats the status to a color-coded icon.
         * @param {string} sStatus - Status key
         * @returns {string} Icon URI
         */
        formatStatusIcon: function (sStatus) {
            var mStatusIcon = {
                "Pending": "sap-icon://pending",
                "Approved": "sap-icon://accept",
                "Rejected": "sap-icon://decline",
                "Completed": "sap-icon://complete",
                "Cancelled": "sap-icon://cancel"
            };
            return mStatusIcon[sStatus] || "sap-icon://status-inactive";
        },

        /**
         * Formats the donor status to a semantic state.
         * @param {string} sStatus - Donor status
         * @returns {string} ValueState
         */
        formatDonorStatusState: function (sStatus) {
            return sStatus === "Active" ? "Success" : "Error";
        },

        /**
         * Formats the urgency level to a semantic state.
         * @param {string} sUrgency - Urgency level
         * @returns {string} ValueState
         */
        formatUrgencyState: function (sUrgency) {
            var mUrgency = {
                "Critical": "Error",
                "High": "Warning",
                "Normal": "Information",
                "Low": "None"
            };
            return mUrgency[sUrgency] || "None";
        },

        /**
         * Formats a date value to a localized medium date string.
         * @param {Date|string} oDate - Date to format
         * @returns {string} Formatted date string
         */
        formatDate: function (oDate) {
            if (!oDate) {
                return "";
            }
            var oDateFormat = DateFormat.getDateInstance({ style: "medium" });
            if (typeof oDate === "string") {
                oDate = new Date(oDate);
            }
            return oDateFormat.format(oDate);
        },

        /**
         * Formats a date value to a relative time string.
         * @param {Date|string} oDate - Date to format
         * @returns {string} Relative time string
         */
        formatRelativeDate: function (oDate) {
            if (!oDate) {
                return "";
            }
            if (typeof oDate === "string") {
                oDate = new Date(oDate);
            }
            var iDiff = Math.floor((new Date() - oDate) / (1000 * 60 * 60 * 24));
            if (iDiff === 0) return "Today";
            if (iDiff === 1) return "Yesterday";
            if (iDiff < 7) return iDiff + " days ago";
            if (iDiff < 30) return Math.floor(iDiff / 7) + " weeks ago";
            return Math.floor(iDiff / 30) + " months ago";
        },

        /**
         * Formats blood group to a display icon.
         * @param {string} sBloodGroup - Blood group code
         * @returns {string} Icon URI
         */
        formatBloodGroupIcon: function (sBloodGroup) {
            return "sap-icon://heart";
        },

        /**
         * Formats blood group to a highlight color.
         * @param {string} sBloodGroup - Blood group code
         * @returns {string} Highlight class
         */
        formatBloodGroupHighlight: function (sBloodGroup) {
            var mHighlight = {
                "O-": "Error",
                "O+": "Warning",
                "AB-": "Information",
                "AB+": "Success",
                "A+": "Success",
                "A-": "Warning",
                "B+": "Success",
                "B-": "Warning"
            };
            return mHighlight[sBloodGroup] || "None";
        },

        /**
         * Checks if blood units are expiring soon (within 7 days).
         * @param {Date|string} oExpiryDate - Expiry date
         * @returns {string} ValueState
         */
        formatExpiryState: function (oExpiryDate) {
            if (!oExpiryDate) return "None";
            if (typeof oExpiryDate === "string") {
                oExpiryDate = new Date(oExpiryDate);
            }
            var iDaysLeft = Math.floor((oExpiryDate - new Date()) / (1000 * 60 * 60 * 24));
            if (iDaysLeft <= 0) return "Error";
            if (iDaysLeft <= 7) return "Warning";
            if (iDaysLeft <= 14) return "Information";
            return "Success";
        },

        /**
         * Formats the expiry date to days remaining text.
         * @param {Date|string} oExpiryDate - Expiry date
         * @returns {string} Days remaining text
         */
        formatExpiryText: function (oExpiryDate) {
            if (!oExpiryDate) return "";
            if (typeof oExpiryDate === "string") {
                oExpiryDate = new Date(oExpiryDate);
            }
            var iDaysLeft = Math.floor((oExpiryDate - new Date()) / (1000 * 60 * 60 * 24));
            if (iDaysLeft <= 0) return "Expired";
            if (iDaysLeft === 1) return "1 day left";
            return iDaysLeft + " days left";
        },

        /**
         * Formats donor eligibility to a semantic state.
         * @param {Date|string} oLastDonation - Last donation date
         * @returns {string} ValueState
         */
        formatEligibilityState: function (oLastDonation) {
            if (!oLastDonation) return "Success";
            if (typeof oLastDonation === "string") {
                oLastDonation = new Date(oLastDonation);
            }
            var iDaysSince = Math.floor((new Date() - oLastDonation) / (1000 * 60 * 60 * 24));
            return iDaysSince >= 56 ? "Success" : "Error";
        },

        /**
         * Checks donor eligibility based on last donation date (56-day gap required).
         * @param {Date|string} oLastDonation - Last donation date
         * @returns {boolean} true if eligible
         */
        isDonorEligible: function (oLastDonation) {
            if (!oLastDonation) return true;
            if (typeof oLastDonation === "string") {
                oLastDonation = new Date(oLastDonation);
            }
            var iDaysSince = Math.floor((new Date() - oLastDonation) / (1000 * 60 * 60 * 24));
            return iDaysSince >= 56;
        },

        /**
         * Formats donor eligibility to display text.
         * @param {Date|string} oLastDonation - Last donation date
         * @returns {string} Eligibility text
         */
        formatEligibilityText: function (oLastDonation) {
            if (!oLastDonation) return "Eligible";
            if (typeof oLastDonation === "string") {
                oLastDonation = new Date(oLastDonation);
            }
            var iDaysSince = Math.floor((new Date() - oLastDonation) / (1000 * 60 * 60 * 24));
            if (iDaysSince >= 56) return "Eligible";
            var iDaysRemaining = 56 - iDaysSince;
            return "Not Eligible (" + iDaysRemaining + " days remaining)";
        },

        /**
         * Formats a number with thousand separators.
         * @param {number} iNumber - Number to format
         * @returns {string} Formatted number
         */
        formatNumber: function (iNumber) {
            if (!iNumber && iNumber !== 0) return "0";
            return iNumber.toLocaleString();
        },

        /**
         * Formats units count with color state.
         * @param {number} iUnits - Number of units
         * @returns {string} ValueState based on stock level
         */
        formatStockState: function (iUnits) {
            if (iUnits <= 0) return "Error";
            if (iUnits <= 5) return "Warning";
            if (iUnits <= 10) return "Information";
            return "Success";
        },

        /**
         * Formats gender key to display text.
         * @param {string} sGender - Gender key
         * @returns {string} Display text
         */
        formatGender: function (sGender) {
            var mGender = {
                "M": "Male",
                "F": "Female",
                "O": "Other"
            };
            return mGender[sGender] || sGender;
        },

        /**
         * Formats a boolean to Yes/No.
         * @param {boolean} bValue - Boolean value
         * @returns {string} Yes or No
         */
        formatYesNo: function (bValue) {
            return bValue ? "Yes" : "No";
        },

        /**
         * Concatenates first and last name.
         * @param {string} sFirst - First name
         * @param {string} sLast - Last name
         * @returns {string} Full name
         */
        formatFullName: function (sFirst, sLast) {
            return [sFirst, sLast].filter(Boolean).join(" ");
        }
    };
});
