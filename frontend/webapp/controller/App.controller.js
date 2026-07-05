sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/core/routing/History",
    "sap/m/MessageToast",
    "lifelink/model/formatter"
], function (Controller, History, MessageToast, formatter) {
    "use strict";

    return Controller.extend("lifelink.controller.App", {

        formatter: formatter,

        onInit: function () {
            // Set initial side nav state based on device
            var oDevice = this.getOwnerComponent().getModel("device").getData();
            if (oDevice.system.phone) {
                this.byId("toolPage").setSideExpanded(false);
            }

            // Attach route matched listener
            this.getOwnerComponent().getRouter().attachRouteMatched(this.onRouteMatched, this);
        },

        onRouteMatched: function (oEvent) {
            var sRouteName = oEvent.getParameter("name");
            var oAppModel = this.getOwnerComponent().getModel("appView");
            
            var bPublic = (sRouteName === "home" || sRouteName === "signin" || sRouteName === "signup");
            oAppModel.setProperty("/isPublicPage", bPublic);
            
            // Also select correct item in side nav if it's a private page
            if (!bPublic) {
                var oSideNav = this.byId("sideNavigation");
                if (oSideNav) {
                    oSideNav.setSelectedKey(sRouteName);
                }
            }
        },

        /**
         * Toggles the side navigation panel.
         */
        onToggleSideNav: function () {
            var oToolPage = this.byId("toolPage");
            oToolPage.setSideExpanded(!oToolPage.getSideExpanded());
        },

        /**
         * Handles navigation item selection.
         * @param {sap.ui.base.Event} oEvent - The selection event
         */
        onNavItemSelect: function (oEvent) {
            var sKey = oEvent.getParameter("item").getKey();
            this.getOwnerComponent().getRouter().navTo(sKey);

            // Collapse sidebar on phone
            var oDevice = this.getOwnerComponent().getModel("device").getData();
            if (oDevice.system.phone) {
                this.byId("toolPage").setSideExpanded(false);
            }
        },

        /**
         * Shows notification popover.
         */
        onNotifications: function () {
            MessageToast.show("No new notifications");
        },

        /**
         * Shows user profile popover.
         * @param {sap.ui.base.Event} oEvent - The click event
         */
        onUserProfile: function (oEvent) {
            var oButton = oEvent.getSource();

            if (!this._oPopover) {
                this.loadFragment({
                    name: "lifelink.fragment.UserProfilePopover"
                }).then(function (oPopover) {
                    this._oPopover = oPopover;
                    this.getView().addDependent(this._oPopover);
                    this._oPopover.openBy(oButton);
                }.bind(this));
            } else {
                this._oPopover.openBy(oButton);
            }
        },

        /**
         * Handles Log Out action.
         */
        onLogOut: function () {
            if (this._oPopover) {
                this._oPopover.close();
            }
            MessageToast.show("Logged out successfully.");
            // Navigate back to the landing home page
            this.getOwnerComponent().getRouter().navTo("home");
        }
    });
});
