include("controllers/jobs/commands.nut");
include("controllers/jobs/busdriver");
include("controllers/jobs/fuel");
include("controllers/jobs/taxi");
include("controllers/jobs/cargodriver");

addEventHandlerEx("onServerStarted", function() {
    // nothing there anymore :C
    log("[jobs] starting...");
});
