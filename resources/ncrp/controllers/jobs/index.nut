jobtext <- {
    "need" : "You need a ",
    "notCDD" : "You're not a cargo delivery driver."
};


include("controllers/jobs/commands.nut");
include("controllers/jobs/busdriver");
include("controllers/jobs/fuel");
include("controllers/jobs/taxi");
include("controllers/jobs/milkdriver");
include("controllers/jobs/cargodriver");
include("controllers/jobs/telephone");
include("controllers/jobs/docker");
include("controllers/jobs/realty");

addEventHandlerEx("onServerStarted", function() {
    // nothing there anymore :C
    log("[jobs] starting...");
});

local jobBlips = {};

function registerPersonalJobBlip(jobname, x, y) {
    dbg("function");
    addEventHandler("onPlayerSpawn", function(playerid) {
        if (playerid in players && players[playerid].job == jobname) {
            createPersonalJobBlip(playerid, x, y);
        }
    })
}

function createPersonalJobBlip(playerid, x, y) {
    jobBlips[playerid] <- createPrivateBlip(playerid, x, y, ICON_STAR, 2000.0);
}

function removePersonalJobBlip(playerid) {
    if(jobBlips[playerid]){
        removeBlip(jobBlips[playerid]);
    }
}
