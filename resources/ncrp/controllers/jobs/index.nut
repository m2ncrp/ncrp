include("controllers/jobs/commands.nut");
include("controllers/jobs/busdriver");
include("controllers/jobs/fuel");
include("controllers/jobs/taxi");
include("controllers/jobs/milkdriver");
include("controllers/jobs/cargodriver");
include("controllers/jobs/telephone");
include("controllers/jobs/docker");
include("controllers/jobs/realty");


event("onServerStarted", function() {
    // nothing there anymore :C
    log("[jobs] starting...");
});


local jobBlips = {};
local playerJobBlips = {};

function registerPersonalJobBlip(jobname, x, y) {
    dbg("register personal job blip for: "+jobname);
    if (!(jobname in jobBlips)) {
        jobBlips[jobname] <- {x = x, y = y};
    }
}

event("onPlayerSpawn", function(playerid) {
    foreach (jobname, coords in jobBlips) {
        if (playerid in players && players[playerid].job == jobname) {
            createPersonalJobBlip(playerid, coords.x, coords.y);
        }
    }
});

function createPersonalJobBlip(playerid, x, y) {
    playerJobBlips[playerid] <- createPrivateBlip(playerid, x, y, ICON_STAR, 4000.0);
}

function removePersonalJobBlip(playerid) {
   if (playerid in playerJobBlips) {
       removeBlip(playerJobBlips[playerid]);
   }
}

function getLocalizedPlayerJob(playerid) {
    return localize("job."+getPlayerJob(playerid), [], getPlayerLocale(playerid));
}
