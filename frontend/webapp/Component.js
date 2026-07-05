sap.ui.define([
    "sap/ui/core/UIComponent",
    "lifelink/model/models",
    "sap/ui/model/json/JSONModel"
], function (UIComponent, models, JSONModel) {
    "use strict";

    return UIComponent.extend("lifelink.Component", {

        metadata: {
            manifest: "json"
        },

        /**
         * Initializes the LifeLink application component.
         * Sets up the device model and initializes the router.
         */
        init: function () {
            // Call the base component's init function
            UIComponent.prototype.init.apply(this, arguments);

            // Set the device model
            this.setModel(models.createDeviceModel(), "device");

            // Set the app view model for global state
            var oAppModel = new JSONModel({
                busy: false,
                delay: 0,
                layout: "OneColumn",
                previousLayout: "",
                actionButtonsInfo: { midColumn: { fullScreen: false } }
            });
            this.setModel(oAppModel, "appView");

            // Initialize the router
            this.getRouter().initialize();
        },

        /**
         * Returns the content density class based on the device.
         * @returns {string} CSS class for content density
         */
        getContentDensityClass: function () {
            if (!this._sContentDensityClass) {
                if (!sap.ui.Device.support.touch) {
                    this._sContentDensityClass = "sapUiSizeCompact";
                } else {
                    this._sContentDensityClass = "sapUiSizeCozy";
                }
            }
            return this._sContentDensityClass;
        }
    });
});
