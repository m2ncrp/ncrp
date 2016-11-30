include("modules/jobs/commands.nut");
include("modules/jobs/busdriver");
include("modules/jobs/fueldriver");
include("modules/jobs/taxi");
include("modules/jobs/milkdriver");
include("modules/jobs/cargodriver");
//include("modules/jobs/telephone");
include("modules/jobs/docker");
include("modules/jobs/realtor");


event("onServerStarted", function() {
    // nothing there anymore :C
    log("[jobs] starting...");
});


local jobBlips = {};
local playerJobBlips = {};

function registerPersonalJobBlip(jobname, x, y) {
    //dbg("register personal job blip for: "+jobname);
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

function getLocalizedPlayerJob(playerid, forced = null) {
    return localize("job." + getPlayerJob(playerid), [], (forced) ? forced : getPlayerLocale(playerid));
}
