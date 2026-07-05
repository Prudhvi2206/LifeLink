sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/core/routing/History",
    "sap/ui/model/json/JSONModel",
    "sap/m/MessageToast",
    "sap/m/MessageBox",
    "lifelink/model/formatter"
], function (Controller, History, JSONModel, MessageToast, MessageBox, formatter) {
    "use strict";

    return Controller.extend("lifelink.controller.SmartFormDownload", {

        formatter: formatter,

        onInit: function () {
            var oSmartForm = new JSONModel({
                certGenerated: false,
                certDonorName: "",
                certDate: "",
                certBloodGroup: "",
                certUnits: "",
                certHospital: "",
                certId: "",
                slipGenerated: false,
                slipRequestId: "",
                slipDate: "",
                slipUrgency: "",
                slipHospital: "",
                slipContact: "",
                slipPhone: "",
                slipPatient: "",
                slipBloodGroup: "",
                slipUnits: "",
                slipReason: "",
                slipStatus: ""
            });
            this.getView().setModel(oSmartForm, "smartForm");
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
         * Generates a blood donation certificate preview.
         */
        onGenerateDonationCert: function () {
            var oSelect = this.byId("selectDonation");
            var oSelectedItem = oSelect.getSelectedItem();

            if (!oSelectedItem || !oSelect.getSelectedKey()) {
                MessageBox.error("Please select a donation record to generate the certificate.");
                return;
            }

            var oContext = oSelectedItem.getBindingContext();
            if (!oContext) {
                MessageBox.error("Unable to read donation data. Please try again.");
                return;
            }

            var oSmartForm = this.getView().getModel("smartForm");
            oSmartForm.setProperty("/certDonorName", oContext.getProperty("DonorName"));
            oSmartForm.setProperty("/certDate", formatter.formatDate(oContext.getProperty("DonationDate")));
            oSmartForm.setProperty("/certBloodGroup", oContext.getProperty("BloodGroup"));
            oSmartForm.setProperty("/certUnits", oContext.getProperty("Units") + " unit(s)");
            oSmartForm.setProperty("/certHospital", oContext.getProperty("HospitalName"));
            oSmartForm.setProperty("/certId", "CERT-" + oContext.getProperty("DonationId"));
            oSmartForm.setProperty("/certGenerated", true);

            MessageToast.show(this.getView().getModel("i18n").getResourceBundle().getText("msgSmartFormGenerated"));
        },

        /**
         * Generates an emergency blood request slip preview.
         */
        onGenerateEmergencySlip: function () {
            var oSelect = this.byId("selectRequest");
            var oSelectedItem = oSelect.getSelectedItem();

            if (!oSelectedItem || !oSelect.getSelectedKey()) {
                MessageBox.error("Please select an emergency request to generate the slip.");
                return;
            }

            var oContext = oSelectedItem.getBindingContext();
            if (!oContext) {
                MessageBox.error("Unable to read request data. Please try again.");
                return;
            }

            var oSmartForm = this.getView().getModel("smartForm");
            oSmartForm.setProperty("/slipRequestId", oContext.getProperty("RequestId"));
            oSmartForm.setProperty("/slipDate", formatter.formatDate(oContext.getProperty("RequestDate")));
            oSmartForm.setProperty("/slipUrgency", oContext.getProperty("Urgency"));
            oSmartForm.setProperty("/slipHospital", oContext.getProperty("HospitalName"));
            oSmartForm.setProperty("/slipContact", oContext.getProperty("ContactPerson"));
            oSmartForm.setProperty("/slipPhone", oContext.getProperty("ContactPhone"));
            oSmartForm.setProperty("/slipPatient", oContext.getProperty("PatientName"));
            oSmartForm.setProperty("/slipBloodGroup", oContext.getProperty("BloodGroup"));
            oSmartForm.setProperty("/slipUnits", oContext.getProperty("UnitsNeeded"));
            oSmartForm.setProperty("/slipReason", oContext.getProperty("Reason"));
            oSmartForm.setProperty("/slipStatus", oContext.getProperty("Status"));
            oSmartForm.setProperty("/slipGenerated", true);

            MessageToast.show(this.getView().getModel("i18n").getResourceBundle().getText("msgSmartFormGenerated"));
        },

        /**
         * Downloads the donation certificate.
         * In production, this calls the ABAP SmartForm function import.
         */
        onDownloadCert: function () {
            var oSmartForm = this.getView().getModel("smartForm");
            var sCertContent = this._generateCertText(oSmartForm.getData());
            this._downloadFile(sCertContent, "Donation_Certificate_" + oSmartForm.getProperty("/certId") + ".txt");
        },

        /**
         * Downloads the emergency request slip.
         * In production, this calls the ABAP SmartForm function import.
         */
        onDownloadSlip: function () {
            var oSmartForm = this.getView().getModel("smartForm");
            var sSlipContent = this._generateSlipText(oSmartForm.getData());
            this._downloadFile(sSlipContent, "Emergency_Slip_" + oSmartForm.getProperty("/slipRequestId") + ".txt");
        },

        _generateCertText: function (oData) {
            return [
                "═══════════════════════════════════════════════",
                "          🩸 LifeLink Blood Bank",
                "       BLOOD DONATION CERTIFICATE",
                "═══════════════════════════════════════════════",
                "",
                "This is to certify that",
                "",
                "    " + oData.certDonorName,
                "",
                "has voluntarily donated blood on",
                "",
                "    Date: " + oData.certDate,
                "    Blood Group: " + oData.certBloodGroup,
                "    Units Donated: " + oData.certUnits,
                "",
                "Donation Center: " + oData.certHospital,
                "Certificate ID: " + oData.certId,
                "",
                "═══════════════════════════════════════════════",
                "  Thank you for saving lives!",
                "═══════════════════════════════════════════════",
                "",
                "Generated on: " + new Date().toLocaleDateString(),
                "Authorized Signatory: _________________"
            ].join("\n");
        },

        _generateSlipText: function (oData) {
            return [
                "═══════════════════════════════════════════════",
                "     🚨 EMERGENCY BLOOD REQUEST SLIP",
                "═══════════════════════════════════════════════",
                "",
                "Request ID: " + oData.slipRequestId,
                "Date: " + oData.slipDate,
                "Urgency: " + oData.slipUrgency,
                "",
                "HOSPITAL DETAILS",
                "  Hospital: " + oData.slipHospital,
                "  Contact: " + oData.slipContact,
                "  Phone: " + oData.slipPhone,
                "",
                "PATIENT & BLOOD DETAILS",
                "  Patient: " + oData.slipPatient,
                "  Blood Group Required: " + oData.slipBloodGroup,
                "  Units Needed: " + oData.slipUnits,
                "  Reason: " + oData.slipReason,
                "",
                "STATUS: " + oData.slipStatus,
                "",
                "═══════════════════════════════════════════════",
                "Generated on: " + new Date().toLocaleDateString(),
                "Blood Bank Officer: _________________"
            ].join("\n");
        },

        /**
         * Downloads a text content as a file.
         */
        _downloadFile: function (sContent, sFilename) {
            var oBlob = new Blob([sContent], { type: "text/plain;charset=utf-8" });
            var sUrl = URL.createObjectURL(oBlob);
            var oLink = document.createElement("a");
            oLink.href = sUrl;
            oLink.download = sFilename;
            document.body.appendChild(oLink);
            oLink.click();
            document.body.removeChild(oLink);
            URL.revokeObjectURL(sUrl);
            MessageToast.show("Document downloaded: " + sFilename);
        }
    });
});
