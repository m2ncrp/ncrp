include("modules/jobs/commands.nut");
include("modules/jobs/busdriver");
include("modules/jobs/fueldriver");
include("modules/jobs/taxi");
include("modules/jobs/milkdriver");
include("modules/jobs/fishdriver");
include("modules/jobs/truckdriver");
include("modules/jobs/telephone");
include("modules/jobs/docker");
include("modules/jobs/stationporter");
// include("modules/jobs/realtor");
// include("modules/jobs/slaughterhouseworker");


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
        if (isPlayerLoaded(playerid) && isPlayerHaveValidJob(playerid, jobname)) {
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

/**
 * New job stating algo
 */

local job_state = {};
local job_callbacks = {};

function setPlayerJobState(playerid, state) {
    job_state[playerid] <- state;
}

function getPlayerJobState(playerid) {
    return (playerid in job_state) ? job_state[playerid] : null;
}

function addJobEvent(button, jobname, state, callback) {
    if (!(button in job_callbacks)) {
        job_callbacks[button] <- {};
    }

    if (!(jobname in job_callbacks[button])) {
        job_callbacks[button][jobname] <- {};
    }

    if (!(state in job_callbacks[button][jobname])) {
        job_callbacks[button][jobname][state] <- [];
    }

    job_callbacks[button][jobname][state].push(callback);
}

function callJobEvent(button, playerid) {
    if (!(button in job_callbacks)) {
        return;
    }

    local job = getPlayerJob(playerid);

    if (!(job in job_callbacks[button])) {
        return;
    }

    local states = job_callbacks[button][job];
    local state  = getPlayerJobState(playerid);

    if (!(state in states)) return;

    local callbacks = states[state];

    foreach (idx, callback in callbacks) {
        callback(playerid);
    }
}

key("e", function(playerid) { callJobEvent("e", playerid); });
key("q", function(playerid) { callJobEvent("q", playerid); });
key("2", function(playerid) { callJobEvent("2", playerid); });
