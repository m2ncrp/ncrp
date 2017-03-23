include("modules/jobs/milkdriver/commands.nut");
include("modules/jobs/milkdriver/translations.nut");

local job_milk = {};
local milktrucks = {};
local milkJobStationMarks = {};
local job_milk_blocked = {};

const MILK_JOB_RADIUS = 2.0;
const MILK_JOB_X =  176.834;
const MILK_JOB_Y = 439.305;
const MILK_JOB_Z = -20.1758;

const MILK_JOB_SKIN = 171;
const MILK_JOB_DISTANCE = 35;
const MILK_JOB_NUMBER_STATIONS = 7;
const MILK_JOB_LEVEL = 1;
const MILK_JOB_SALARY = 28.0;
local MILK_JOB_COLOR = CL_CRUSTA;
local MILK_JOB_NAME = "milkdriver";
local MILK_JOB_LOAD    = [185.295, 471.471, -19.9552];
local MILK_JOB_PARKING = [170.803, 436.015, -20.221];
local MILK_JOB_TIMEOUT = 1800;
local MILK_JOB_GET_HOUR_START = 7;
local MILK_JOB_GET_HOUR_END   = 8;
local MILK_JOB_LEAVE_HOUR_START = 7;
local MILK_JOB_LEAVE_HOUR_END   = 11;
local MILK_JOB_WORKING_HOUR_START = 7;
local MILK_JOB_WORKING_HOUR_END   = 8;
local MILK_ROUTE_IN_HOUR = 1;
local MILK_ROUTE_NOW = 1;


// 788.288, -78.0801, -20.132   // coords of place to load milk truck
// 551.762, -266.866, -20.1644  // coords of place to get job milkdriver

local milkcoordsall = [
    [-1162.5,   1599.26,    6.46012,    "The Hill Of Tara (Emergency exit)" ],
    [-1594.78,  1602.47,    -5.90717,   "Empire Diner (Kingston)"           ],
    [-1418.26,  975.404,    -13.577,    "Empire Diner (Greenfield)"         ],
    [-634.34,   1292.31,    3.26542,    "Empire Diner (Highbrook)"          ],
    [131.316,   -434.314,   -19.9878,   "Empire Diner (Oyster Bay)"         ],
    [-758.831,  -377.673,   -20.6368,   "Illias Bar (SouthPort)"            ],
    [-561.424,  441.203,    1.07133,    "Stellas Diner (Uptown)"            ],
    [-626.332,  345.59,     1.49028,    "The Mona Lisa (Uptown)"            ],
    [-54.6979,  722.117,    -21.9211,   "Freddys Bar (Little Italy)"        ],
    [239.853,   696.646,    -24.0973,   "Stellas Diner (Little Italy)"      ],
    [624.514,   904.991,    -12.6217,   "The Dragstrip (North Millvlille)"  ],
    [-1396.19,  476.477,    -22.2102,   "The Lone Star (Hunters Point)"     ],
    [-1591.16,  187.75,     -12.8383,   "Empire Diner (Sand Island)"        ],
    [-1546.54, -171.372,    -19.8428,   "Steaks & Chops (Sand Island)"      ]
];

local function showMilkLoadBlip (playerid, visible) {
    if (job_milk[getPlayerName(playerid)]["milkloadBlip"] != null) {
        removeBlip(job_milk[getPlayerName(playerid)]["milkloadBlip"]);
    }

    if (visible) {
        job_milk[getPlayerName(playerid)]["milkloadBlip"] = createPrivateBlip(playerid, MILK_JOB_LOAD[0], MILK_JOB_LOAD[1], ICON_YELLOW, 4000.0 );
    }
}

local function showLeave3dText (playerid, visible) {
    if (visible) {
        createText (playerid, "leavejob3dtext", MILK_JOB_X, MILK_JOB_Y, MILK_JOB_Z+0.05, "Press Q to leave job", CL_WHITE.applyAlpha(100), MILK_JOB_RADIUS );
        createText (playerid, "milkload3dtextTitle", MILK_JOB_LOAD[0], MILK_JOB_LOAD[1], MILK_JOB_LOAD[2]+0.35, "LOAD MILK", CL_ROYALBLUE, 40 );
        createText (playerid, "milkload3dtext", MILK_JOB_LOAD[0], MILK_JOB_LOAD[1], MILK_JOB_LOAD[2]+0.10, "Press E to load", CL_WHITE.applyAlpha(100), MILK_JOB_RADIUS );
    } else {
        removeText(playerid, "leavejob3dtext");
        removeText(playerid, "milkload3dtextTitle");
        removeText(playerid, "milkload3dtext");
    }
}

event("onServerStarted", function() {
    log("[jobs] loading milkdriver job...");
    // milktrucks[i][0] - Truck ready: true/false
    // milktrucks[i][1] - milk load: integer
    //milktrucks[createVehicle(19, 172.868, 436, -20.04, -178.634, 0.392045, -0.829271)]  <- 0 ;
    milktrucks[createVehicle(19, 168.812, 436, -20.04, 179.681, 0.427494, -0.637235)]  <- 0 ;

    //creating 3dtext for milk ferm
    create3DText ( MILK_JOB_X, MILK_JOB_Y, MILK_JOB_Z+0.35, "EMPIRE BAY MILK CO.", CL_ROYALBLUE );
    create3DText ( MILK_JOB_X, MILK_JOB_Y, MILK_JOB_Z+0.20, "Press E", CL_WHITE.applyAlpha(150), 2.0 );

    registerPersonalJobBlip(MILK_JOB_NAME, MILK_JOB_X, MILK_JOB_Y);

    createPlace("milkParking", 165.48, 439.856, 175.043, 435.5);

});

event("onPlayerConnect", function(playerid) {
    if ( ! (getPlayerName(playerid) in job_milk) ) {
        job_milk[getPlayerName(playerid)] <- {};
        job_milk[getPlayerName(playerid)]["milkready"] <- false;
        job_milk[getPlayerName(playerid)]["milkcoords"] <- [];
        job_milk[getPlayerName(playerid)]["milkstatus"] <- [false, false, false, false, false, false, false];
        job_milk[getPlayerName(playerid)]["milkcomplete"] <- 0;  // number of completed milk address. Default is 0
        job_milk[getPlayerName(playerid)]["milkloadBlip"] <- null;
    }
});


event("onPlayerPlaceEnter", function(playerid, name) {
    if(name != "milkParking" || !isMilkDriver(playerid) || !isPlayerVehicleMilk(playerid) || getPlayerJobState(playerid) == "sitting") return;

    if(getPlayerJobState(playerid) == "working" && job_milk[getPlayerName(playerid)]["milkcomplete"] < MILK_JOB_NUMBER_STATIONS) {
        return msg( playerid, "job.milkdriver.completedelivery", MILK_JOB_COLOR );
    }

    if(getPlayerJobState(playerid) != "needparking") return;

    local vehicleid = getPlayerVehicle(playerid);
    local vehRot = getVehicleRotation(vehicleid);

    if (vehRot[0] < 172 && vehRot[0] > -172 ) {
        return msg(playerid, "job.milkdriver.needcorrectpark", MILK_JOB_COLOR );
    }
    setPlayerJobState(playerid, "complete");
    blockVehicle(vehicleid);
    setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
    msg(playerid, "job.milkdriver.gototakemoney", MILK_JOB_COLOR );
    trigger(playerid, "removeGPS");
});

event("onServerPlayerStarted", function( playerid ) {

    if(isMilkDriver(playerid)) {

        showLeave3dText (playerid, true);

        if (getPlayerJobState(playerid) == "working") {
            if ( getPlayerName(playerid) in milkJobStationMarks ) {
                milkJobStationMarks[getPlayerName(playerid)].clear();
            }
            return msg( playerid, "job.milkdriver.completedelivery", MILK_JOB_COLOR );
        }
        if (getPlayerJobState(playerid) == null) {
            return msg( playerid, "job.milkdriver.ifyouwantstart", MILK_JOB_COLOR );
        }
        if(getPlayerJobState(playerid) == "wait") {
            return setPlayerJobState(playerid, "working");
        }

        if (getPlayerJobState(playerid) == "needparking") {
            msg( playerid, "job.milkdriver.nicejob.needpark", MILK_JOB_COLOR );
            trigger(playerid, "setGPS", 170.803, 436.015);
            showLeave3dText(playerid, false);
            return;
        }
    }
});


event("onPlayerVehicleEnter", function(playerid, vehicleid, seat) {
    if (!isPlayerVehicleMilk(playerid)) return;

    // if player on seat 0 is a fuel driver
    if (isMilkDriver(playerid) && getPlayerJobState(playerid) != null) {
        unblockVehicle(vehicleid);

        if(getPlayerJobState(playerid) == "working") {
            setPlayerJobState(playerid, "sitting");
            delayedFunction(3000, function() {
                setPlayerJobState(playerid, "working");
                local vehicleid = getPlayerVehicle(playerid);
                //if(vehicleid == -1) return;

                if(milktrucks[vehicleid] >= 12) {
                    createMilkJobStationMarks(playerid, job_milk[getPlayerName(playerid)]["milkcoords"]);
                    msg( playerid, "job.milkdriver.milktruckloaded", milktrucks[vehicleid], MILK_JOB_COLOR );
                } else {
                    msg( playerid, "job.milkdriver.route.now.empty", MILK_JOB_COLOR );
                    showMilkLoadBlip (playerid, true);
                }
            });
        }
    } else {
        blockVehicle(vehicleid);
    }
});

event("onServerHourChange", function() {
    MILK_ROUTE_NOW = MILK_ROUTE_IN_HOUR;
});

function createMilkJobStationMarks(playerid, data) {
    if (!(getPlayerName(playerid) in milkJobStationMarks)) {
        milkJobStationMarks[getPlayerName(playerid)] <- {};
    }

    // ignore creation if they already set
    if (milkJobStationMarks[getPlayerName(playerid)].len()) {
        return;
    }

    foreach (id, value in data) {
        if (job_milk[getPlayerName(playerid)]["milkstatus"][id] == false) {
            milkJobStationMarks[getPlayerName(playerid)][id] <- {
                text1 = createPrivate3DText(playerid, value[0], value[1], value[2]+0.35, "PARK HERE", CL_RIPELEMON, MILK_JOB_DISTANCE ),
                text2 = createPrivate3DText(playerid, value[0], value[1], value[2]+0.20, "Press E", CL_WHITE.applyAlpha(100), 5.0 ),
                blip  = createPrivateBlip(playerid, value[0], value[1], ICON_RED, 4000.0 )
            };
        }
    }
}

function removeMilkJobStationMark(playerid, id) {
    if (getPlayerName(playerid) in milkJobStationMarks) {
        if (id in milkJobStationMarks[getPlayerName(playerid)]) {
            remove3DText(milkJobStationMarks[getPlayerName(playerid)][id].text1);
            remove3DText(milkJobStationMarks[getPlayerName(playerid)][id].text2);
            removeBlip(milkJobStationMarks[getPlayerName(playerid)][id].blip);

            delete milkJobStationMarks[getPlayerName(playerid)][id];
        }
    }
}

function clearMilkJobStationMarks(playerid) {
    if (getPlayerName(playerid) in milkJobStationMarks) {
        foreach (id, value in milkJobStationMarks[getPlayerName(playerid)]) {
            remove3DText(milkJobStationMarks[getPlayerName(playerid)][id].text1);
            remove3DText(milkJobStationMarks[getPlayerName(playerid)][id].text2); // curenlty disabled
            removeBlip(milkJobStationMarks[getPlayerName(playerid)][id].blip);
        }
        delete milkJobStationMarks[getPlayerName(playerid)];
    }
}


/**
 * Check is player is a milk driver
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isMilkDriver(playerid) {
    return (isPlayerHaveValidJob(playerid, MILK_JOB_NAME));
}

/**
 * Check is player's vehicle is a milk truck
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isPlayerVehicleMilk(playerid) {
    return (isPlayerInValidVehicle(playerid, 19));
}


/**
Event: JOB - Milk driver - Get job
*/
function milkJobGet ( playerid ) {
    if(!isPlayerInValidPoint(playerid, MILK_JOB_X, MILK_JOB_Y, MILK_JOB_RADIUS)) {
        return;
    }

    local hour = getHour();
    if(hour < MILK_JOB_GET_HOUR_START || hour >= MILK_JOB_GET_HOUR_END) {
        return msg( playerid, "job.closed", [ MILK_JOB_GET_HOUR_START.tostring(), MILK_JOB_GET_HOUR_END.tostring()], MILK_JOB_COLOR );
    }

    if(!isPlayerLevelValid ( playerid, MILK_JOB_LEVEL )) {
        return msg(playerid, "job.milkdriver.needlevel", MILK_JOB_LEVEL, MILK_JOB_COLOR );
    }

    if (getPlayerName(playerid) in job_milk_blocked) {
        if (getTimestamp() - job_milk_blocked[getPlayerName(playerid)] < MILK_JOB_TIMEOUT) {
            return msg( playerid, "job.milkdriver.badworker", MILK_JOB_COLOR);
        }
    }

    setPlayerJob( playerid, MILK_JOB_NAME);
    setPlayerJobState( playerid, null);

    screenFadeinFadeoutEx(playerid, 250, 200, function() {
        setPlayerModel( playerid, MILK_JOB_SKIN );
        showLeave3dText(playerid, true);
    });
    msg( playerid, "job.milkdriver.now", MILK_JOB_COLOR );
    milkJobGetRoute ( playerid );
}
addJobEvent("e", null,    null, milkJobGet);
addJobEvent("e", null, "nojob", milkJobGet);


/**
Event: JOB - Milk driver - Leave job
*/
function milkJobLeave ( playerid ) {

    if(!isPlayerInValidPoint(playerid, MILK_JOB_X, MILK_JOB_Y, MILK_JOB_RADIUS)) {
        return;
    }

    local hour = getHour();
    if(hour < MILK_JOB_LEAVE_HOUR_START || hour >= MILK_JOB_LEAVE_HOUR_END) {
        return msg( playerid, "job.closed", [ MILK_JOB_LEAVE_HOUR_START.tostring(), MILK_JOB_LEAVE_HOUR_END.tostring()], MILK_JOB_COLOR );
    }

    if (getPlayerJobState(playerid) == "working") {
        msg( playerid, "job.milkdriver.badworker.onleave", MILK_JOB_COLOR);
        setPlayerJobState(playerid, "nojob");
        job_milk_blocked[getPlayerName(playerid)] <- getTimestamp();
        showMilkLoadBlip (playerid, false);
    }

    if (getPlayerJobState(playerid) == "null") {
        msg( playerid, "job.milkdriver.goodluck", MILK_JOB_COLOR);
        setPlayerJobState(playerid, null);
    }

    setPlayerJob( playerid, null );

    job_milk[getPlayerName(playerid)]["milkready"] = false;
    job_milk[getPlayerName(playerid)]["milkcoords"] = null;
    showLeave3dText(playerid, false);

    screenFadeinFadeoutEx(playerid, 250, 200, function() {
        restorePlayerModel(playerid);
        msg( playerid, "job.leave", MILK_JOB_COLOR );
    });

    // remove private blip job
    removePersonalJobBlip ( playerid );

    // clear all marks
    clearMilkJobStationMarks(playerid);
}
addJobEvent("q", MILK_JOB_NAME,      null, milkJobLeave);
addJobEvent("q", MILK_JOB_NAME, "working", milkJobLeave);


/**
Event: JOB - Milk driver - Get route
*/
function milkJobGetRoute ( playerid ) {
    if(!isPlayerInValidPoint(playerid, MILK_JOB_X, MILK_JOB_Y, MILK_JOB_RADIUS)) {
        return;
    }

    local hour = getHour();
    if(hour < MILK_JOB_WORKING_HOUR_START || hour >= MILK_JOB_WORKING_HOUR_END) {
        return msg( playerid, "job.closed", [ MILK_JOB_WORKING_HOUR_START.tostring(), MILK_JOB_WORKING_HOUR_END.tostring()], MILK_JOB_COLOR );
    }

    if(MILK_ROUTE_NOW < 1) {
        return msg( playerid, "job.nojob", MILK_JOB_COLOR );
    }

    setPlayerJobState( playerid, "working");
    job_milk[getPlayerName(playerid)]["milkcoords"] = getRandomSubArray(milkcoordsall, MILK_JOB_NUMBER_STATIONS);
    dbg(job_milk[getPlayerName(playerid)]["milkcoords"]);

    // create milk marks
    createMilkJobStationMarks(playerid, job_milk[getPlayerName(playerid)]["milkcoords"]);

    msg( playerid, "job.milkdriver.takenroute", MILK_JOB_COLOR );
}
addJobEvent("e", MILK_JOB_NAME, null, milkJobGetRoute);


/**
Event: JOB - Milk driver - Need complete delivery
*/
function milkJobNeedComplete ( playerid ) {
    if(!isPlayerInValidPoint(playerid, MILK_JOB_X, MILK_JOB_Y, MILK_JOB_RADIUS)) {
        return;
    }

    msg( playerid, "job.milkdriver.carrymilkalladdresses", MILK_JOB_COLOR );
}
addJobEvent("e", MILK_JOB_NAME, "working", milkJobNeedComplete);


/**
Event: JOB - Milk driver - Load truck
*/
function milkJobLoad ( playerid ) {

    if(!isVehicleInValidPoint(playerid, MILK_JOB_LOAD[0], MILK_JOB_LOAD[1], 4.0)) {
        return;
    }

    if (!isPlayerVehicleMilk(playerid)) {
        return msg(playerid, "job.milkdriver.needtruck", MILK_JOB_COLOR );
    }

    if(isPlayerVehicleMoving(playerid)){
        return msg( playerid, "job.milkdriver.driving", CL_RED );
    }

    local vehicleid = getPlayerVehicle(playerid);
    local vehRot = getVehicleRotation(vehicleid);

    if (vehRot[0] < 172 && vehRot[0] > -172 ) {
        return msg(playerid, "job.milkdriver.needcorrectpark", CL_RED );
    }

    if(milktrucks[vehicleid] == 120) {
        return msg( playerid, "job.milkdriver.truckalreadyloaded", MILK_JOB_COLOR );
    }

    freezePlayer( playerid, true);
    setPlayerJobState(playerid, "wait");
    setVehiclePartOpen(vehicleid, 1, true);
    msg( playerid, "job.milkdriver.loading", FISH_JOB_COLOR );
    trigger(playerid, "hudCreateTimer", 25.0, true, true);
    showMilkLoadBlip (playerid, false);
    delayedFunction(25000, function () {
        setVehiclePartOpen(vehicleid, 1, false);
        freezePlayer( playerid, false);
        delayedFunction(1000, function () { freezePlayer( playerid, false); });
        setPlayerJobState(playerid, "working");
        milktrucks[vehicleid] = 120;
        msg( playerid, "job.milkdriver.milktruckloadedcarrymilk", MILK_JOB_COLOR );
    });
}
addJobEvent("e", MILK_JOB_NAME, "working", milkJobLoad);


/**
Event: JOB - Milk driver - Unload truck
*/
function milkJobUnload ( playerid ) {

    if (!isPlayerVehicleMilk(playerid)) {
        return;
    }

    local check = false;
    local i = -1;
    foreach (key, value in job_milk[getPlayerName(playerid)]["milkcoords"]) {
        if (isVehicleInValidPoint(playerid, value[0], value[1], 5.0 )) {
            check = true;
            i = key;
            break;
        }
    }

    if (!check) {
       return;
    }


    if(isPlayerVehicleMoving(playerid)){
        return msg( playerid, "job.milkdriver.driving", CL_RED );
    }

    local vehicleid = getPlayerVehicle(playerid);
    if(milktrucks[vehicleid] < 12) {
        return msg( playerid, "job.milkdriver.milknotenough", MILK_JOB_COLOR );
    }

    if(job_milk[getPlayerName(playerid)]["milkstatus"][i]) {
        return msg( playerid, "job.milkdriver.alreadybeenhere", MILK_JOB_COLOR );
    }

    local vehicleid = getPlayerVehicle(playerid);

    job_milk[getPlayerName(playerid)]["milkstatus"][i] = true;
    job_milk[getPlayerName(playerid)]["milkcomplete"] += 1;

    freezePlayer( playerid, true);
    setPlayerJobState(playerid, "wait");
    setVehiclePartOpen(vehicleid, 1, true);
    setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
    msg( playerid, "job.milkdriver.unloading", FISH_JOB_COLOR );
    trigger(playerid, "hudCreateTimer", 10.0, true, true);
    // remove blip on complete unload
    removeMilkJobStationMark(playerid, i);

    delayedFunction(10000, function () {
        setVehiclePartOpen(vehicleid, 1, false);
        freezePlayer( playerid, false);
        delayedFunction(1000, function () { freezePlayer( playerid, false); });
        setPlayerJobState(playerid, "working");
        milktrucks[vehicleid] -= 12;

        if (job_milk[getPlayerName(playerid)]["milkcomplete"] == MILK_JOB_NUMBER_STATIONS) {
            setPlayerJobState(playerid, "needparking");
            msg( playerid, "job.milkdriver.nicejob.needpark", MILK_JOB_COLOR );
            trigger(playerid, "setGPS", 170.803, 436.015);
            showLeave3dText(playerid, false);
        } else {
            if (milktrucks[vehicleid] >= 12) {
                msg( playerid, "job.milkdriver.unloadingcompleted.truckloaded", milktrucks[vehicleid], MILK_JOB_COLOR );
            } else {
                msg( playerid, "job.milkdriver.unloadingcompleted.milknotenough", MILK_JOB_COLOR );
                showMilkLoadBlip (playerid, true);
            }
        }
    });
}
addJobEvent("e", MILK_JOB_NAME, "working", milkJobUnload);


/**
Event: JOB - Milk driver - On complete job and get salary
*/
function milkJobComplete ( playerid ) {

    if(!isPlayerInValidPoint(playerid, MILK_JOB_X, MILK_JOB_Y, MILK_JOB_RADIUS)) {
        return;
    }
    setPlayerJobState(playerid, null);
    job_milk[getPlayerName(playerid)]["milkcomplete"] = 0;
    job_milk[getPlayerName(playerid)]["milkstatus"] <- [false, false, false, false, false, false, false];

    milkGetSalary( playerid );
    showLeave3dText(playerid, true);
    // clear all marks
    clearMilkJobStationMarks( playerid );
}
addJobEvent("e", MILK_JOB_NAME, "complete", milkJobComplete);


/**
Event: JOB - Milk driver - Get salary
*/
function milkGetSalary( playerid ) {
    local amount = MILK_JOB_SALARY + (random(-2, 1)).tofloat();
    msg( playerid, "job.milkdriver.nicejob", amount, MILK_JOB_COLOR );
    addMoneyToPlayer(playerid, amount);
}

/**
Event: JOB - Milk driver - Show route list
*/
function milkJobList ( playerid ) {

    if(!isMilkDriver(playerid)) {
        return msg( playerid, "job.milkdriver.not", MILK_JOB_COLOR );
    }

    if (getPlayerJobState(playerid) != "working") {
        return msg( playerid, "job.milkdriver.route.nohave", MILK_JOB_COLOR );
    }

    msg( playerid, "job.milkdriver.route.title", CL_JOB_LIST);
    foreach (key, value in job_milk[getPlayerName(playerid)]["milkstatus"]) {
        local i = key+1;
        if (value == true) {
            msg( playerid, "job.milkdriver.route.completed", [i, job_milk[getPlayerName(playerid)]["milkcoords"][key][3]], CL_JOB_LIST_GR);
        } else {
            msg( playerid, "job.milkdriver.route.waiting", [i, job_milk[getPlayerName(playerid)]["milkcoords"][key][3]], CL_JOB_LIST_R);
        }
    }
}

/**
Event: JOB - Milk driver - Check loading truck
*/
function milkJobCheck ( playerid ) {

    if(!isMilkDriver(playerid)) {
        return msg( playerid, "job.milkdriver.not", MILK_JOB_COLOR );
    }

    if (!isPlayerVehicleMilk(playerid)) {
        return msg(playerid, "job.milkdriver.needtruck", MILK_JOB_COLOR );
    }

    if (getPlayerJobState(playerid) != "working") {
        return msg( playerid, "job.milkdriver.route.nohave", MILK_JOB_COLOR );
    }

    local vehicleid = getPlayerVehicle(playerid);
    msg( playerid, "job.milkdriver.milktruckloaded", milktrucks[vehicleid], MILK_JOB_COLOR );
}


/**
Event: JOB - Milk driver - Already have job
*/
key("e", function(playerid) {

    if(!isPlayerInValidPoint(playerid, MILK_JOB_X, MILK_JOB_Y, MILK_JOB_RADIUS)) {
        return;
    }

    if (getPlayerJob(playerid) && getPlayerJob(playerid) != MILK_JOB_NAME) {
        msg(playerid, "job.alreadyhavejob", [getPlayerJob(playerid)]);
    }
})
