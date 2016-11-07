

include("controllers/jobs/commands.nut");
include("controllers/jobs/busdriver");
include("controllers/jobs/fuel");
include("controllers/jobs/taxi");
include("controllers/jobs/cargodriver");


addEventHandlerEx("onServerStarted", function() {
    // nothing there anymore :C
    log("[jobs] starting...");
});

jobphrases  = {
    "letsgo" : "Let's go to TOOOOOOOO bus station in Uptown (central door of the building).",
    "driveralready" : "You're busdriver already.",
    "toDerek" : "Let's go to Derek office at City Port.",
    "notCDD" : "You're not a cargo delivery driver."
};
