include("modules/jobs/taxi/commands.nut");
include("modules/jobs/taxi/translations.nut");
include("modules/jobs/taxi/peds_coords.nut");
include("modules/jobs/taxi/taxicalls.nut");
include("modules/jobs/taxi/events_places.nut");
include("modules/jobs/taxi/events_vehicles.nut");

DRIVERS <- {}; // таблица водителей
TAXI_CHARACTERS_LIMIT <- 1000000;

const TAXI_JOB_SKIN = 171;
const TAXI_JOB_LEVEL = 2;

local TAXI_BLIP = [-710.638, 255.64, 0.365978];
local TAXI_COORDS = [-720.586, 248.261, 0.365978];
local TAXI_RADIUS = 2.0;




event("onServerStarted", function() {
    log("[jobs] loading taxi job...");

    registerPersonalJobBlip("taxidriver", TAXI_BLIP[0], TAXI_BLIP[1]);

    // вызываем такси каждые 15 секунд
    // delayedFunction(15000, function() {
    //     callTaxiByPed();
    // });

});

event("onPlayerConnect", function(playerid) {
    // Если игрок работает таксистом, получаем id персонажа, проверяем существует ли он в DRIVERS и если нет - добавляем.
    if(isTaxiDriver(playerid)) {
        local drid = getCharacterIdFromPlayerId(playerid);
        if ( !(drid in DRIVERS) ) {
            addTaxiDriver(drid);
        }
    }
});

event("onPlayerDisconnect", function(playerid, reason) {
    if(isTaxiDriver(playerid)) {
        local drid = getCharacterIdFromPlayerId(playerid);
        if(getTaxiDriverStatus(drid) == "onair") {
            setTaxiDriverStatus(drid, "offair");
        }

        local vehicleid = getTaxiDriverCar(drid);
        if(vehicleid) {
            setTaxiLightState(vehicleid, false);
            removePrivateKey(playerid, "b", "taxiSwitchAir")
        }
        setTaxiDriverCar(drid, null);
    }
});

event("onServerPlayerStarted", function( playerid ){
    createText ( playerid, "taxiJob3dText", TAXI_COORDS[0], TAXI_COORDS[1], TAXI_COORDS[2]+0.20, "...", CL_WHITE.applyAlpha(150), TAXI_RADIUS );

    if(isTaxiDriver(playerid)) {
        renameText ( playerid, "taxiJob3dText", "Press Q to leave job");

        local drid = getCharacterIdFromPlayerId(playerid);
        local callObject = getTaxiCallObjectByDrid(drid);

        if(callObject) {

            // автомобиль такси не доехал до клиента
            if(callObject.mileageStart == null) {
                local phoneObj = getPhoneObjById(callObject.placeId);

                trigger(playerid, "setGPS", phoneObj[0], phoneObj[1]);
                msg_taxi_dr( playerid, "job.taxi.call.goto", [ plocalize(playerid, "telephone"+callObject.placeId) ]);
                return;
            }

            // таксисит везёт бота, нужно восстановить маршрут
            if(callObject.cuid >= TAXI_CHARACTERS_LIMIT) {
                local targetPhoneObj = getPhoneObjById(callObject.targetPlaceId);

                trigger(playerid, "setGPS", targetPhoneObj[0], targetPhoneObj[1]);
                msg_taxi_dr( playerid, "job.taxi.call.goto", [ plocalize(playerid, "telephone"+callObject.targetPlaceId) ]);
                return;
            }
        }

        msg_taxi_dr( playerid, "job.taxi.ifyouwantstart");
        restorePlayerModel(playerid);
        setPlayerJobState(playerid, null);
    } else {
        renameText ( playerid, "taxiJob3dText", "Press E to get job");
    }
});

// добавить водителя такси по charid
function addTaxiDriver(drid) {
    DRIVERS[drid] <- {
        status = "offair",
        vehicleid = null,
    };
}

function setTaxiDriverStatus(drid, status) {
    log("Set status to "+status);
    return DRIVERS[drid].status = status;
}

function getTaxiDriverStatus(drid) {
    //if(byPlayerid) xid = getCharacterIdFromPlayerId(xid);
    return DRIVERS[drid].status;
}

function setTaxiDriverCar(drid, vehicleid) {
    log("Set vehicleid to "+vehicleid);
    return DRIVERS[drid].vehicleid = vehicleid;
}

function getTaxiDriverCar(drid) {
    log("get vehicleid");
    return DRIVERS[drid].vehicleid;
}

// есть ли свободная машина?
function isHaveFreeTaxiDriver() {
    foreach(drid, value in DRIVERS) {
        local driverid = getPlayerIdFromCharacterId(drid);
        if(value.status == "onair" && isPlayerCarTaxi(driverid)) {
            return true;
        }
    }
    return false;
}


/* JOB ***************************************************************************************************************************************************** */

/**
 * Get taxi driver job
 * @param  {int} playerid
 */
function taxiJobGet(playerid) {
    if(!isPlayerInValidPoint(playerid, TAXI_COORDS[0], TAXI_COORDS[1], TAXI_RADIUS)) {
        return;
    }

    //return msg(playerid, "job.taxi.novacancy", CL_WARNING);


    //if(!isPlayerLevelValid ( playerid, TAXI_JOB_LEVEL )) {
    //    return msg(playerid, "job.taxi.needlevel", TAXI_JOB_LEVEL );
    //}

    if(isTaxiDriver(playerid)) {
        return msg(playerid, "job.taxi.driver.already");
    }

    if(isPlayerHaveJob(playerid)) {
        return msg(playerid, "job.alreadyhavejob", getLocalizedPlayerJob(playerid) );
    }

    setPlayerJob( playerid, "taxidriver");

    local drid = getCharacterIdFromPlayerId(playerid);
    if ( !(drid in DRIVERS) ) {
        addTaxiDriver(drid);
    }

    screenFadeinFadeoutEx(playerid, 250, 200, function() {
        msg_taxi_dr(playerid, "job.taxi.driver.now");
        msg_taxi_dr( playerid, "job.taxi.ifyouwantstart");
        renameText ( playerid, "taxiJob3dText", "Press Q to leave job");
        setPlayerModel( playerid, TAXI_JOB_SKIN );
    });
}

/**
 * Leave from taxi driver job
 * @param  {int} playerid
 */
function taxiJobRefuseLeave(playerid) {
    if(!isPlayerInValidPoint(playerid, TAXI_COORDS[0], TAXI_COORDS[1], TAXI_RADIUS)) {
        return;
    }

    if(!isTaxiDriver(playerid)) {
        return msg(playerid, "job.taxi.driver.not");
    }

    local drid = getCharacterIdFromPlayerId(playerid);

    if(getTaxiDriverStatus(drid) == "busy") {
        return msg_taxi_dr(playerid, "job.taxi.cantleavejob1");
    }

    // if(getPlayerTaxiUserStatus(playerid) == "onroute") {
    //     return msg_taxi_dr(playerid, "job.taxi.cantleavejob2");
    // }

    screenFadeinFadeoutEx(playerid, 250, 200, function() {
        msg_taxi_dr(playerid, "job.leave");
        setPlayerJob( playerid, null );
        restorePlayerModel(playerid);
        renameText ( playerid, "taxiJob3dText", "Press E to get job");
        // setPlayerTaxiUserStatus(playerid, "offair");

        // if(job_taxi[players[playerid].id]["car"] != null) {
        //     setTaxiLightState(job_taxi[players[playerid].id]["car"], false);
        //     job_taxi[players[playerid].id]["car"] = null;
        // }
    });
}

/* MANAGE ***************************************************************************************************************************************************** */

/**
 * Switch userstatus air
 * @param  {int} playerid
 */
function taxiSwitchAir(playerid) {

    if (!isTaxiDriver(playerid) || !isPlayerCarTaxi(playerid)) {
        return ;
    }

    local drid = getCharacterIdFromPlayerId(playerid);
    local status = getTaxiDriverStatus(drid);
    local vehicleid = getPlayerVehicle(playerid);

    if(status == "busy") {
        return msg_taxi_dr(playerid, "job.taxi.cantchangestatus");
    }

    if(isPlayerVehicleMoving(playerid)) {
        return msg_taxi_dr(playerid, "job.taxi.stoptochangestatus");
    }

    if(status == "offair") {
        unblockDriving(vehicleid);
        repairVehicle(vehicleid);
        setTaxiDriverStatus(drid, "onair");
        setTaxiDriverCar(drid, vehicleid);
        setTaxiLightState(vehicleid, true);
        msg_taxi_dr(playerid, "job.taxi.statuson" );

        privateKey(playerid, "2", "taxiCallStartNew", taxiCallStartNew);
        privateKey(playerid, "3", "taxiCallFinishForPlayer", taxiCallFinishForPlayer);

    } else {
        blockDriving(playerid, vehicleid);
        setTaxiDriverStatus(drid, "offair");
        setTaxiDriverCar(drid, null);
        setTaxiLightState(vehicleid, false);
        msg_taxi_dr(playerid, "job.taxi.statusoff");

        removePrivateKey(playerid, "2", "taxiCallStartNew");
        removePrivateKey(playerid, "3", "taxiCallFinishForPlayer");
    }
}


/* KEY BUTTONS ***************************************************************************************************************************************************** */




/* SYSTEM FUNCTIONS ***************************************************************************************************************************************************** */


/**
 * msg to taxi customer
 * @param  {int}  playerid
 * @param  {string} text
 * @param  {string} options
 */
function msg_taxi_cu(playerid, text, options = []) {
    return msg(playerid, text, options, CL_CREAMCAN);
}

/**
 * msg to taxi driver
 * @param  {int}  playerid
 * @param  {string} text
 * @param  {string} options
 */

function msg_taxi_dr(playerid, text, options = []) {
    return msg(playerid, text, options, CL_ECSTASY);
}

/**
 * Check is player is a taxidriver
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isTaxiDriver (playerid) {
    return (isPlayerHaveValidJob(playerid, "taxidriver"));
}

/**
 * Check is player's vehicle is a taxi car
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isPlayerCarTaxi(playerid) {
    return (isPlayerInValidVehicle(playerid, 24) || isPlayerInValidVehicle(playerid, 33));
}


/**
 * Check vehicle is a taxi car
 * @param  {int}  vehicleid
 * @return {Boolean} true/false
 */
function isVehicleCarTaxi(vehicleid) {
    return (getVehicleModel( vehicleid ) == 24 || getVehicleModel( vehicleid ) == 33);
}


function isCarTaxiFreeForDriver(vehicleid) {
    local check = true;
    foreach (targetid, value in job_taxi) {
        if (value["car"] == vehicleid ) {
            check = false;
        }
    }
    return check;
}
