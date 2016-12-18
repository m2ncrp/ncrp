include("modules/jobs/commands.nut");
include("modules/jobs/busdriver");
include("modules/jobs/fueldriver");
include("modules/jobs/taxi");
include("modules/jobs/milkdriver");
include("modules/jobs/fishdriver");
include("modules/jobs/truckdriver");
//include("modules/jobs/telephone");
include("modules/jobs/docker");
include("modules/jobs/stationporter");
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

function applyPersonalJobBlip(playerid) {
    foreach (jobname, coords in jobBlips) {
        if (playerid in players && players[playerid].job == jobname) {
            createPersonalJobBlip(playerid, coords.x, coords.y, ICON_TARGET); // for current job
        }
        if (!getPlayerJob(playerid)) {
            createPersonalJobBlip(playerid, coords.x, coords.y, ICON_STAR); // for all jobs
        }
    }
}

event("onServerPlayerStarted", function(playerid) {
    applyPersonalJobBlip(playerid);
});

event("onPlayerJobChanged", function(playerid) {
    removePersonalJobBlip(playerid);
    delayedFunction(250, function() {
        applyPersonalJobBlip(playerid);
    })
});

function createPersonalJobBlip(playerid, x, y, icon = ICON_STAR) {
    if (!(playerid in playerJobBlips)) {
        playerJobBlips[playerid] <- [];
    }
    playerJobBlips[playerid].push(createPrivateBlip(playerid, x, y, icon, 4000.0));
}

function removePersonalJobBlip(playerid) {
   if (playerid in playerJobBlips) {
        playerJobBlips[playerid].apply(removeBlip)
        playerJobBlips[playerid] = [];
   }
}

function getLocalizedPlayerJob(playerid, forced = null) {
    return localize("job." + getPlayerJob(playerid), [], (forced) ? forced : getPlayerLocale(playerid));
}
