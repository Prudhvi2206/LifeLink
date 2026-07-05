sap.ui.define([
    "sap/ui/core/util/MockServer",
    "sap/base/util/UriParameters"
], function (MockServer, UriParameters) {
    "use strict";

    return {
        /**
         * Initializes the mock server.
         * You can call this method before the Descriptor is loaded.
         * @public
         */
        init: function () {
            var oUriParameters = new UriParameters(window.location.href);

            // Create a mock server instance
            var oMockServer = new MockServer({
                rootUri: "/sap/opu/odata/sap/ZLL_ODATA_SRV/"
            });

            // Configure mock server with a delay
            MockServer.config({
                autoRespond: true,
                autoRespondAfter: oUriParameters.get("serverDelay") || 500
            });

            // Load local metadata and mock data
            var sPath = sap.ui.require.toUrl("lifelink/localService");
            oMockServer.simulate(sPath + "/metadata.xml", {
                sMockdataBaseUrl: sPath + "/mockdata",
                bGenerateMissingMockData: true
            });

            // Start the mock server
            oMockServer.start();

            jQuery.sap.log.info("Running the app with mock data");
        }
    };
});
