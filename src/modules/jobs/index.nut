/* ************************************************************************* */
local SALARY_BONUS = 0.0;
event("onPlayerConnect", function(playerid) {
    calcSalaryBonus();

    if(!("jobs" in players[playerid].data)) {
        local value = { count = 0, rang = 0 };
        players[playerid].data.jobs <- {
            docker          = clone(value),
            busdriver       = clone(value),
            porter          = clone(value),
            fishdriver      = clone(value),
            fueldriver      = clone(value),
            snowplowdriver  = clone(value),
            milkdriver      = clone(value),
            truckdriver     = clone(value),
        }
    }
});

event("onPlayerDisconnect", function(playerid, reason) {
    calcSalaryBonus();
});

function getSalaryBonus() {
    return SALARY_BONUS;
}

function calcSalaryBonus() {
    SALARY_BONUS = getPlayerCount() >= 9 ? 0.2 * getPlayerCount() : 0.0;
}
/* ************************************************************************* */

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
            createPersonalJobBlip(playerid, coords.x, coords.y, ICON_STAR, ICON_RANGE_FULL); // for current job
        }
        if (!getPlayerJob(playerid)) {
            createPersonalJobBlip(playerid, coords.x, coords.y, ICON_STAR); // for all jobs
        }
    }
}

event("onServerPlayerStarted", function(playerid) {
    applyPersonalJobBlip(playerid);

    if(isPlayerHaveValidJob(playerid, "snowplowdriver") && isSummer()) {
        setPlayerJob(playerid, null);
        // jobRestorePlayerModel(playerid);
    }

    local job = getPlayerJob(playerid);

    if(!job) return;
    if(job == "fueldriver") {
        setPlayerJob(playerid, null);
        // jobRestorePlayerModel(playerid);
    } else if(job.find("police") != null && job != "busdriver") {
        jobRestorePlayerModel(playerid);
    }
});

event("onPlayerJobChanged", function(playerid) {
    removePersonalJobBlip(playerid);
    delayedFunction(250, function() {
        applyPersonalJobBlip(playerid);
    })
});

function createPersonalJobBlip(playerid, x, y, icon = ICON_STAR, radius = ICON_RANGE_VISIBLE) {
    if (!(getCharacterIdFromPlayerId(playerid) in playerJobBlips)) {
        playerJobBlips[getCharacterIdFromPlayerId(playerid)] <- [];
    }
    playerJobBlips[getCharacterIdFromPlayerId(playerid)].push(createPrivateBlip(playerid, x, y, icon, radius));
}

function removePersonalJobBlip(playerid) {
   if (getCharacterIdFromPlayerId(playerid) in playerJobBlips) {
        playerJobBlips[getCharacterIdFromPlayerId(playerid)].apply(removeBlip)
        playerJobBlips[getCharacterIdFromPlayerId(playerid)] = [];
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
    job_state[getCharacterIdFromPlayerId(playerid)] <- state;
}

function getPlayerJobState(playerid) {
    return (getCharacterIdFromPlayerId(playerid) in job_state) ? job_state[getCharacterIdFromPlayerId(playerid)] : null;
}

function addJobEvent(button, jobname, state, callback) {
    if (!(button in job_callbacks)) {
        job_callbacks[button] <- {};
    }

    if (jobname == null) jobname = "0";
    if (state == null) state = "0";

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

    if (!job) job = "0";

    if (!(job in job_callbacks[button])) {
        return;
    }

    local states = job_callbacks[button][job];
    local state  = getPlayerJobState(playerid);

    if (state == null) state = "0";
    if (!(state in states)) return;

    local callbacks = states[state];

    foreach (idx, callback in callbacks) {
        callback(playerid);
    }
}

key("e", function(playerid) { callJobEvent("e", playerid); });
key("q", function(playerid) { callJobEvent("q", playerid); });
key("2", function(playerid) { callJobEvent("2", playerid); });


function jobSetPlayerModel(playerid, skin) {
    return;
    screenFadeinFadeoutEx(playerid, 250, 200, function() {
        setPlayerModel( playerid, skin );
    });
}

function jobRestorePlayerModel(playerid) {
    return;
    screenFadeinFadeoutEx(playerid, 250, 200, function() {
        restorePlayerModel(playerid);
    });
}

playerDelayedFunction <- function(playerid, time, callback) { delayedFunction(time, callback); }


include("modules/jobs/commands.nut");

event("onServerStarted", function() {
    if(!isSummer()) {
        include("modules/jobs/snowplower");
    }

    include("modules/jobs/busdriver");
    //include("modules/jobs/taxi");
    include("modules/jobs/milkdriver");
    include("modules/jobs/fishdriver");
    include("modules/jobs/truckdriver");
    include("modules/jobs/telephone");
    include("modules/jobs/docker");
    include("modules/jobs/stationporter");
});


// include("modules/jobs/realtor");
// include("modules/jobs/slaughterhouseworker");


// deprecated
// include("modules/jobs/fueldriver");

alternativeTranslate({
    "en|job.not-available"                 : "Sorry, this job is not available now."
    "ru|job.not-available"                 : "Работа временно недоступна."

    "en|job.busdriver"                     : "bus driver"
    "ru|job.busdriver"                     : "Водитель автобуса"

    "en|job.docker"                        : "docker"
    "ru|job.docker"                        : "Грузчик в порту"

    "en|job.fishdriver"                    : "fish truck driver"
    "ru|job.fishdriver"                    : "Развозчик рыбы"

    "en|job.fueldriver"                    : "fuel truck driver"
    "ru|job.fueldriver"                    : "Водитель бензовоза"

    "en|job.milkdriver"                    : "milk truck driver"
    "ru|job.milkdriver"                    : "Развозчик молока"

    "en|job.snowplowdriver"                : "snowplow driver"
    "ru|job.snowplowdriver"                : "Водитель снегоуборочной машины"

    "en|job.porter"                        : "station porter"
    "ru|job.porter"                        : "Грузчик на вокзале"

    "en|job.truckdriver"                   : "truck driver"
    "ru|job.truckdriver"                   : "Развозчик грузов"

    "en|job.police"                        : "policeman"
    "ru|job.police"                        : "Сотрудник полиции"
});
