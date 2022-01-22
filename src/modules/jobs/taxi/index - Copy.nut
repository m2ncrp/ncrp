include("modules/jobs/taxi/commands.nut");
include("modules/jobs/taxi/translations.nut");
include("modules/jobs/taxi/peds_coords.nut");

local job_taxi = {};
local price = 0.0015; // for 1 meter

const TAXI_JOB_SKIN = 171;
const TAXI_JOB_LEVEL = 2;

local TAXI_BLIP = [-710.638, 255.64, 0.365978];
local TAXI_COORDS = [-720.586, 248.261, 0.365978];
local TAXI_RADIUS = 2.0;

local TAXI_CALLS = {};
// format: TAXI_CALLS[playerid] <- [place, "open" / "inprocess" / "close"];
local TAXI_LASTCALL = null;

local TAXI_CHARACTERS_LIMIT = 100000;


event("onServerStarted", function() {
    logStr("[jobs] loading taxi job...");
    local taxicars = [

        createVehicle(24, -127.650, 412.521, -13.98, -90.0, 0.2, -0.2),   // taxi East Side 1
        createVehicle(24, -127.650, 408.872, -13.98, -90.0, 0.2, -0.2),   // taxi East Side 2
        createVehicle(24, -127.650, 405.611, -13.98, -90.0, 0.2, -0.2),   // taxi East Side 3
        createVehicle(24, -127.650, 402.069, -13.98, -90.0, 0.2, -0.2),   // taxi East Side 4
        createVehicle(33, -127.650, 398.769, -13.98, -90.0, 0.2, -0.2),   // taxi East Side 5


//createVehicle(   24, -658.287, 236.719, 1.17881, -179.192, 0.255169, -0.234465 ), // TaxiDEVELOPER


        createVehicle(33, -708.733, 248.0, 0.504346, -0.44367, -0.00094714, -0.230679 ), // Taxi1
        createVehicle(33, -714.508, 248.0, 0.504346, -0.44367, -0.00094714, -0.244627 ), // Taxi2
        createVehicle(24, -718.301, 261.576, 0.504056, 141.868, -0.025185, 0.340924 ), // Taxi3
        createVehicle(24, -712.0, 262.183, 0.504394, 141.868, -0.025185, 0.340924   ), // Taxi4

        createVehicle(33, -479.656, 702.3, 1.2, -179.983, -2.09183, 0.445576  ),     // taxi Uptown 1
        createVehicle(24, -483.363, 702.3, 1.2, -178.785, -2.16034, 0.16853   ),     // taxi Uptown 2
     // createVehicle(33, -487.191, 702.3, 1.2, -178.078, -2.24803, 0.0579244 ),     // taxi Uptown 3

        createVehicle(24, -533.348, 1583.63, -16.4578, 0.272268, 0.379557, -0.261274 ),     // taxi_naprotiv_vokzala_1
     // createVehicle(24, -551.133, 1583.27, -16.4543, 0.443711, 0.00174642, -0.451021 ),   // taxi_naprotiv_vokzala_3
        createVehicle(33, -547.207, 1600.14, -16.4299, -179.116, -0.221615, 0.447305 ),     // taxi_naprotiv_vokzala_2
    ];

    registerPersonalJobBlip("taxidriver", TAXI_BLIP[0], TAXI_BLIP[1]);
    callTaxiByPed();
});

event("onPlayerConnect", function(playerid) {
    job_taxi[players[playerid].id] <- {};
    job_taxi[players[playerid].id]["userstatus"] <- "offair";
    job_taxi[players[playerid].id]["counter"] <- [ "stop", null ]; // [ status, value ], where status = stop / play / pause
    job_taxi[players[playerid].id]["customer"] <- null; // customer == characterid who called taxi car
    job_taxi[players[playerid].id]["car"] <- null; // car == vehicleid of driver

});


event("onServerPlayerStarted", function( playerid ){
    if(isTaxiDriver(playerid)) {
        msg_taxi_dr( playerid, "job.taxi.continue");
        msg_taxi_dr( playerid, "job.taxi.ifyouwantstart");
        createText ( playerid, "taxileavejob3dtext", TAXI_COORDS[0], TAXI_COORDS[1], TAXI_COORDS[2]+0.20, "Press Q to leave job", CL_WHITE.applyAlpha(150), TAXI_RADIUS );
    } else {
        createText ( playerid, "taxileavejob3dtext", TAXI_COORDS[0], TAXI_COORDS[1], TAXI_COORDS[2]+0.20, "Press E to get job", CL_WHITE.applyAlpha(150), TAXI_RADIUS );
    }
});

/* onVehicleEnter */
event( "onPlayerVehicleEnter", function ( playerid, vehicleid, seat ) {
    /* for DRIVER */
    if(isPlayerCarTaxi(playerid) && seat == 0) {
        if(isTaxiDriver (playerid)) {
            unblockDriving(vehicleid);
        } else {
            blockDriving(vehicleid);
        }
    }
    /* for CUSTOMER */
    if(isPlayerCarTaxi(playerid) && seat == 1 ) {
        local driverid = getVehicleDriver(vehicleid);
        if(driverid == null) return;
        if(!isTaxiDriver(driverid) || job_taxi[driverid]["customer"] == null) return;
        if(playerid == job_taxi[driverid]["customer"]) {
            // start taximeter
            taxiStartCounter(driverid);

            if(job_taxi[driverid]["counter"][0] != "pause") { // if player enters into vehicle in process again - don't show messages
                msg_taxi_cu( playerid, "taxi.call.isfree");
                msg_taxi_dr( driverid, "job.taxi.taximeteron");
            }
        }
    }
});


/* onVehicleExit for CUSTOMER */
event( "onPlayerVehicleExit", function ( playerid, vehicleid, seat ) {
    if(isVehicleCarTaxi(vehicleid) && seat == 1 ) {
        local driverid = getVehicleDriver(vehicleid);
        if(driverid == null) return;
        if(!isTaxiDriver(driverid) || job_taxi[driverid]["customer"] == null) return;
        if(playerid == job_taxi[driverid]["customer"]) {
            msg_taxi_dr( driverid, "job.taxi.iftripend");
            taxiPauseCounter(driverid);
        }
    }
});


/* onVehicleEnter for DRIVER */
event( "onPlayerVehicleEnter", function ( playerid, vehicleid, seat ) {
    if(seat == 0 && isTaxiDriver(playerid) && isVehicleCarTaxi(vehicleid) && getPlayerTaxiUserStatus(playerid) != "offair" && job_taxi[players[playerid].id]["car"] == vehicleid && isPlaceExists("TaxiDriverZone"+playerid)) {
        removeArea("TaxiDriverZone"+playerid);
    }
});


/* onVehicleExit for DRIVER */
event( "onPlayerVehicleExit", function ( playerid, vehicleid, seat ) {
    if(seat == 0 && isTaxiDriver(playerid) && isVehicleCarTaxi(vehicleid) && getPlayerTaxiUserStatus(playerid) != "offair" && job_taxi[players[playerid].id]["car"] == vehicleid) {
        local vehPos = getVehiclePosition(vehicleid);
        createPlace("TaxiDriverZone"+playerid,   vehPos[0]-25, vehPos[1]+25, vehPos[0]+25, vehPos[1]-25);
    }
});





/* ******************************************************************************************************************************************************* */

/* onPlaceEnter for DRIVER */
event("onPlayerAreaEnter", function(playerid, name) {

    if (!isTaxiDriver(playerid)) {
        return;
    }

    if (!isPlayerCarTaxi(playerid)) {
        return;
    }

    if(job_taxi[players[playerid].id]["customer"] == null) {
        return;
    }

    local customerCharacterId = job_taxi[players[playerid].id]["customer"];
    if ("taxi"+playerid+"Customer"+customerCharacterId == name) {

        if (customerCharacterId < TAXI_CHARACTERS_LIMIT) {
            removeArea("taxiSmall" + customerCharacterId);
            removeArea("taxiBig" + customerCharacterId);
            msg_taxi_cu(getPlayerIdFromCharacterId(customerCharacterId), "taxi.call.arrived", plate);
        }

        removeArea("taxi"+playerid+"Customer"+customerCharacterId);
        trigger(playerid, "removeGPS");

        local plate = getVehiclePlateText( getPlayerVehicle( playerid ) );
        msg_taxi_dr(playerid, "job.taxi.wait");
        setPlayerTaxiUserStatus(playerid, "onroute");
    }
});

/* onPlaceExit for DRIVER */
event("onPlayerAreaLeave", function(playerid, name) {
    if(!isTaxiDriver(playerid) || getPlayerTaxiUserStatus(playerid) == "offair" || name != "TaxiDriverZone"+playerid ) {
        return;
    }
    taxiStopCounter(playerid);
    setPlayerTaxiUserStatus(playerid, "offair");
    setTaxiLightState(job_taxi[players[playerid].id]["car"], false);
    job_taxi[players[playerid].id]["car"] = null;
    removeArea("TaxiDriverZone"+playerid);
    msg_taxi_dr(playerid, "job.taxi.leaveline");

});

/* onPlaceExit for CUSTOMER */
event("onPlayerAreaLeave", function(playerid, name) {

    if ("taxiSmall" + playerid  == name) {
        msg_taxi_cu(playerid, "taxi.call.ifyouaway");
        return;
    }

    if ("taxiBig" + playerid  == name) {
        msg_taxi_cu(playerid, "taxi.call.fakecall");
        removeArea("taxiSmall" + playerid);
        removeArea("taxiBig" + playerid);
        if(TAXI_LASTCALL == playerid) TAXI_LASTCALL = null;
        delete TAXI_CALLS[playerid];

        foreach (targetid, value in job_taxi) {
            if (value["customer"] == playerid) {
                removeArea("taxi"+targetid+"Customer"+playerid);
                job_taxi[targetid]["customer"] = null;
                job_taxi[targetid]["userstatus"] = "onair";
                trigger(targetid, "removeGPS");
                msg_taxi_dr(targetid, "job.taxi.callnotexist");
            }
        }
    }


});



event("onPlayerPhoneCall", function(playerid, number, place) {
    if(number == "taxi") {
        taxiCall(playerid, place);
    }
});



/* ******************************************************************************************************************************************************* */


function taxiCounter (playerid, vx = null, vy = null, vz = null) {
    if (!isPlayerConnected(playerid) || job_taxi[players[playerid].id]["customer"] == null || !isPlayerConnected(job_taxi[players[playerid].id]["customer"]) || job_taxi[players[playerid].id]["counter"][0] != "play" || (job_taxi[players[playerid].id]["car"] != getPlayerVehicle(playerid) && getPlayerVehicle(playerid) != -1) ) {
        return;
    }

    local vehicleid = job_taxi[players[playerid].id]["car"];
   /*
dbg(getDistanceBtwPlayerAndVehicle(playerid, vehicleid));
    if( getPlayerVehicle(playerid) == -1) {
        delayedFunction(3000, function(){
            if (checkDistanceBtwPlayerAndVehicle(playerid, vehicleid, 40) == false) {
                job_taxi[players[playerid].id]["counter"] = null;
                dbg("Taxi counter bye");
                return;
            }
        });
    }
*/
    local vehPosOld = null;
    if (vx != null) {
        vehPosOld = [vx, vy, vz];
    } else {
        vehPosOld = getVehiclePosition(vehicleid);
    }


    local vehPosNew = getVehiclePosition(vehicleid);
    local dis = getDistanceBetweenPoints3D( vehPosOld[0], vehPosOld[1], vehPosOld[2], vehPosNew[0], vehPosNew[1], vehPosNew[2] );
    job_taxi[players[playerid].id]["counter"][1] += dis;
//dbg("taxi counter: "+dis);
    //msg( playerid, "Distance: "+job_taxi[players[playerid].id]["counter"] );

    delayedFunction(3500, function(){
        taxiCounter (playerid, vehPosNew[0], vehPosNew[1], vehPosNew[2]);
    });
}

/* ******************************************************************************************************************************************************* */


function taxiStartCounter(playerid) {
    if(job_taxi[players[playerid].id]["counter"][0] == "stop" ) {
        job_taxi[players[playerid].id]["counter"][1] = 0;
    }
    job_taxi[players[playerid].id]["counter"][0] = "play";
    taxiCounter (playerid);
}

function taxiStopCounter(playerid) {
    job_taxi[players[playerid].id]["counter"][0] = "stop";
    job_taxi[players[playerid].id]["counter"][1] = null;
    taxiCounter (playerid);
}

function taxiPauseCounter(playerid) {
    job_taxi[players[playerid].id]["counter"][0] = "pause";
    taxiCounter (playerid);
}

function isCounterStarted(playerid) {
    return (job_taxi[players[playerid].id]["counter"][0] != "stop") ? true : false;
}


/* ******************************************************************************************************************************************************* */
/**
 * Call taxi car from <place>
 * @param  {int} playerid
 * @param  {string} place   - address place of call
 * @param  {int} again      - if set 1, message not be shown for playerid
 */


function taxiCall(playerid, place, again = 0) {

    if ((isTaxiDriver(playerid) && getPlayerTaxiUserStatus(playerid) != "offair") || (isTaxiDriver(playerid) && isPlayerCarTaxi(playerid))) {
        return msg_taxi_dr(playerid, "job.taxi.driver.dontfoolaround"); // don't fool around
    }

    local check = false;
    foreach (characterid, value in job_taxi) {
        local targetid = getPlayerIdFromCharacterId(characterid);
        if (value["userstatus"] == "onair" && isPlayerCarTaxi(targetid) ) { // need changed to onair for correct work !!!!!!!!!!!!!!!!!!!!!!!!
            check = true;
            msg_taxi_dr(targetid, "job.taxi.call.new", [ plocalize(targetid, place) /*, playerid */]);
            msg_taxi_dr(targetid, "job.taxi.call.new.if" );
        }
    }

    if(!check) {
        return msg_taxi_cu(playerid, "taxi.call.nofreecars");
    }

    local characterid = players[playerid].id;

    TAXI_CALLS[characterid] <- [place, "open"];
    TAXI_LASTCALL = characterid;
    delayedFunction(300000, function() {
        if (characterid in TAXI_CALLS) {
            if(TAXI_CALLS[characterid][1] == "open") {
                delete TAXI_CALLS[characterid];
            }
            if (TAXI_LASTCALL == characterid) {
                TAXI_LASTCALL = null;
            }
        }
    });

    local placeNameSmall = "taxiSmall"+characterid;
    local placeNameBig   = "taxiBig"+characterid;
    if(isPlaceExists(placeNameSmall) || isPlaceExists(placeNameBig)) {
        removeArea(placeNameSmall);
        removeArea(placeNameBig);
    }
    local phoneObj = getPhoneObj(place);

    createPlace(placeNameSmall, phoneObj[0]-7.5, phoneObj[1]+7.5, phoneObj[0]+7.5, phoneObj[1]-7.5);
    createPlace(placeNameBig,   phoneObj[0]-15, phoneObj[1]+15, phoneObj[0]+15, phoneObj[1]-15);

    if (!again) msg_taxi_cu(playerid, "taxi.call.youcalled", plocalize(playerid, place));
}










/**
 * Taking call
 * @param  {int} playerid
 * @param  {int} customerid - id customer
 */
function taxiCallTakeRefuse(playerid) {

    if (!isTaxiDriver(playerid)) {
        return;
    }
logStr("if 1 complete");
    if (!isPlayerCarTaxi(playerid)) {
        return; //msg_taxi_dr(playerid, "job.taxi.needcar");
    }
logStr("if 2 complete");
    if (job_taxi[players[playerid].id]["car"] != getPlayerVehicle(playerid) && job_taxi[players[playerid].id]["car"] != null) {
        return msg_taxi_dr(playerid, "Sit into your taxi car with plate "+getVehiclePlateText(job_taxi[players[playerid].id]["car"]));
    }
logStr("if 3 complete");
    if(getPlayerTaxiUserStatus(playerid) == "offair") {
        return msg_taxi_dr(playerid, "job.taxi.canttakecall");
    }
logStr("if 4 complete");
    if(getPlayerTaxiUserStatus(playerid) == "onroute") {
        if(isCounterStarted(playerid)) {
            taxiCallDone(playerid);
        }
        return;
    }
logStr("if 5 complete");
    if(job_taxi[players[playerid].id]["customer"] != null) {  dbg("refusing"); return taxiCallRefuse(playerid); };
logStr("if 6 complete");
    // если id персонажа (TAXI_LASTCALL) меньше 100 тысяч, тогда это реальный игрок, иначе - бот
    if (TAXI_LASTCALL < TAXI_CHARACTERS_LIMIT) {

        local customerCharacterId = TAXI_LASTCALL;
        local customerid = getPlayerIdFromCharacterId(TAXI_LASTCALL);

        if ( customerid == null ) {
            return msg_taxi_dr(playerid, "job.taxi.nofreecalls");
        }

        if ( !isPlayerConnected(customerid) || playerid == customerid ) {
            return msg_taxi_dr(playerid, "job.taxi.callnotexist");
        }

        if(job_taxi[players[playerid].id]["customer"] == customerCharacterId) {
            return msg_taxi_dr(playerid, "job.taxi.takenthiscall", customerid);
        }

        if(getPlayerTaxiUserStatus(playerid) == "busy") {
            return msg_taxi_dr(playerid, "job.taxi.takencall");
        }

        if (TAXI_CALLS[customerCharacterId][1] != "open") {
            return msg_taxi_dr(playerid, "job.taxi.callalreadytaken", customerid);
        }

        TAXI_LASTCALL = null;
        TAXI_CALLS[customerCharacterId][1] = "inprocess";
        job_taxi[players[playerid].id]["customer"] = customerCharacterId;
        setPlayerTaxiUserStatus(playerid, "busy");

        msg_taxi_dr(playerid, "job.taxi.youtakencall");
        msg_taxi_cu(customerid, "taxi.call.received");
        local phoneObj = getPhoneObj(TAXI_CALLS[customerCharacterId][0]);
        trigger(playerid, "setGPS", phoneObj[0], phoneObj[1]);
        createPlace("taxi"+playerid+"Customer"+customerCharacterId, phoneObj[0]-50, phoneObj[1]+50, phoneObj[0]+50, phoneObj[1]-50);
    } else {
        local customerPedId = TAXI_LASTCALL;

        if(getPlayerTaxiUserStatus(playerid) == "busy") {
            return msg_taxi_dr(playerid, "job.taxi.takencall");
        }

        if (TAXI_CALLS[customerPedId][1] != "open") {
            return msg_taxi_dr(playerid, "job.taxi.callalreadytaken", customerPedId);
        }

        TAXI_LASTCALL = null;
        TAXI_CALLS[customerPedId][1] = "inprocess";
        job_taxi[players[playerid].id]["customer"] = customerPedId;
        setPlayerTaxiUserStatus(playerid, "busy");
        msg_taxi_dr(playerid, "job.taxi.youtakencall");

        local phoneObj = getPhoneObj(TAXI_CALLS[customerPedId][0]);
        trigger(playerid, "setGPS", phoneObj[0], phoneObj[1]);
        createPlace("taxi"+playerid+"Customer"+customerPedId, phoneObj[0]-10, phoneObj[1]+10, phoneObj[0]+10, phoneObj[1]-10);


        local ped_coords = getPedTaxiCoords(TAXI_CALLS[customerPedId][0]);
        if (ped_coords != false) {
            trigger(playerid, "createPedTaxiPassenger", getPlayerName(playerid), 145, ped_coords[0], ped_coords[1], ped_coords[2], ped_coords[3], 0.0, 0.0 );
        }
    }
}


/* ******************************************************************************************************************************************************* */



/**
 * Report that the taxicar has arrived to the address
 * @param  {int} playerid
 */
/*
function taxiCallReady(playerid) {

    if (!isTaxiDriver(playerid)) {
        return msg_taxi_dr(playerid, "job.taxi.driver.not");
    }

    if (!isPlayerCarTaxi(playerid)) {
        return msg_taxi_dr(playerid, "job.taxi.needcar");
    }

    local customerid = job_taxi[players[playerid].id]["customer"];

    if (customerid == null){
dbg(customerid);
        return msg_taxi_dr(playerid, "job.taxi.noanycalls");
    }

    local plate = getVehiclePlateText( getPlayerVehicle( playerid ) );
    msg_taxi_dr(playerid, "job.taxi.wait");
    msg_taxi_cu(customerid, "taxi.call.arrived", plate);
    setPlayerTaxiUserStatus(playerid, "onroute");
}
*/
/**
 * Refuse the call
 * @param  {int} playerid
 */
function taxiCallRefuse(playerid) {

    local customerid = job_taxi[players[playerid].id]["customer"];
/*
    if (customerid == null){
        return msg_taxi_dr(playerid, "job.taxi.noanycalls");
    }
*/
    if(getPlayerTaxiUserStatus(playerid) == "onroute") {
        return msg_taxi_dr(playerid, "job.taxi.cantrefuse");
    }

    job_taxi[players[playerid].id]["customer"] = null;
    setPlayerTaxiUserStatus(playerid, "onair");

    msg_taxi_dr(playerid, "job.taxi.refusedcall");
    msg_taxi_cu(customerid, "taxi.call.refused");
    removeArea("taxi"+playerid+"Customer"+customerid);
    trigger(playerid, "removeGPS");

    delayedFunction(5000,  function() {
        taxiCall(customerid, TAXI_CALLS[customerid][0], 1);
    });
}



/* ******************************************************************************************************************************************************* */


/**
 * End trip, pay for trip and call
 * @param  {int} playerid
 * @param  {float} amount   - amount for trip at taxi. Default $3.0
 */
function taxiCallDone(playerid) {


    local customerid = job_taxi[players[playerid].id]["customer"];

    if (customerid == null){
        return msg_taxi_dr(playerid, "job.taxi.noanycalls");
    }

    local distance = job_taxi[players[playerid].id]["counter"][1];
    msg_taxi_dr( playerid, "job.taxi.endtrip", [ distance ] );
    msg_taxi_cu( customerid, "taxi.call.completed" );
    taxiStopCounter(playerid);

    delete TAXI_CALLS[ job_taxi[players[playerid].id]["customer"] ];

    setPlayerTaxiUserStatus(playerid, "onair");
    //job_taxi[players[playerid].id]["counter"][0] <- "stop";
    //job_taxi[players[playerid].id]["counter"][1] <- null;
    job_taxi[players[playerid].id]["customer"] <- null;

    if(distance > 250.0) {
    local amount = distance * price;
        if(canTreasuryMoneyBeSubstracted(amount)) {
            addPlayerMoney(playerid, amount);
            subWorldMoney(amount);
            msg_taxi_dr( playerid, "job.taxi.youearn", amount );
            dbg("[TAXI] "+getPlayerName(playerid)+" earned $"+amount+" for "+distance+" meters");
        } else {
            msg_taxi_dr( playerid, "job.taxi.treasurynotenough" );
        }
    } else {
        msg_taxi_dr( playerid, "job.taxi.treasurynotenough" );
    }

/*
    msg_taxi_dr(playerid, "job.taxi.requested", amount );
    msg_taxi_cu(customerid, "taxi.call.request", amount);
    sendInvoiceSilent(playerid, customerid, amount, function(customerid, driverid, result) {
        // playerid responded to invoice from customerid with result
        // (true - acepted / false - declined)
        if(result == true) {
            players[customerid]["taxi"]["call_state"] = "closed";
            job_taxi[driverid]["customer"] = null;
            job_taxi[driverid]["userstatus"] = "onair";
            msg_taxi_dr(driverid, "job.taxi.completed", playerid );
            msg_taxi_cu(customerid, "taxi.call.completed" );
        } else {
            msg(driverid "job.taxi.psngdeclined", getPlayerNameShort(customerid), CL_RED );
            msg(customerid, "taxi.call.declined", CL_RED );
        }
    }
    );
*/

}


/**
 * Close call
 * @param  {int} playerid
 */
function taxiCallClose(playerid) {

    if (!isTaxiDriver(playerid)) {
        return msg_taxi_dr(playerid, "job.taxi.driver.not");
    }

    if (!isPlayerCarTaxi(playerid)) {
        return msg_taxi_dr(playerid, "job.taxi.needcar");
    }

    local customerid = job_taxi[players[playerid].id]["customer"];

    if (customerid == null){
        return msg_taxi_dr(playerid, "job.taxi.noanycalls");
    }

    players[customerid]["taxi"]["call_state"] = "closed";
    job_taxi[players[playerid].id]["customer"] = null;
    setPlayerTaxiUserStatus(playerid, "onair");
    msg_taxi_dr(playerid, "job.taxi.callclosed" );
}


/* ******************************************************************************************************************************************************* */

/**
 * Switch userstatus air
 * @param  {int} playerid
 */
function taxiSwitchAir(playerid) {

    if (!isTaxiDriver(playerid) || !isPlayerCarTaxi(playerid)) {
        return ;
    }

    if (job_taxi[players[playerid].id]["car"] != getPlayerVehicle(playerid) && job_taxi[players[playerid].id]["car"] != null) {
        return msg_taxi_dr(playerid, "job.taxi.sitintoyoucar", getVehiclePlateText(job_taxi[players[playerid].id]["car"]) );
    }

    if (job_taxi[players[playerid].id]["car"] != getPlayerVehicle(playerid) && isCarTaxiFreeForDriver(getPlayerVehicle(playerid)) == false ) {
        return msg_taxi_dr(playerid, "job.taxi.carbusy");
    }

    local userstatus = getPlayerTaxiUserStatus(playerid);
    if(userstatus != "onair" && userstatus != "offair") {
        return msg_taxi_dr(playerid, "job.taxi.cantchangestatus");
    }

    if (userstatus == "offair") {
        setPlayerTaxiUserStatus(playerid, "onair");
        job_taxi[players[playerid].id]["car"] = getPlayerVehicle(playerid);
        setTaxiLightState(getPlayerVehicle(playerid), true);
        msg_taxi_dr(playerid, "job.taxi.statuson" );

        // вызываем такси от бота
        //delayedFunction(random(15, 50) * 1000, function(){
        //    callTaxiByPed(playerid);
        //});
    } else {
        setPlayerTaxiUserStatus(playerid, "offair");
        job_taxi[players[playerid].id]["car"] = null;
        setTaxiLightState(getPlayerVehicle(playerid), false);
        msg_taxi_dr(playerid, "job.taxi.statusoff");
    }
}



/* ******************************************************************************************************************************************************* */



key("e", function(playerid) {
    taxiJobGet ( playerid );
}, KEY_UP);

key("q", function(playerid) {
    taxiJobRefuseLeave ( playerid );
}, KEY_UP);

key("1", function(playerid) {
    taxiSwitchAir(playerid);
}, KEY_UP);

key("2", function(playerid) {
    taxiCallTakeRefuse ( playerid );
}, KEY_UP);


/*

key("3", function(playerid) {
    job_taxi[players[playerid].id]["userstatus"] <- "onair";
}, KEY_UP);

key("4", function(playerid) {
    dbg("=====================================================");
    dbg("LASTCALL: "+TAXI_LASTCALL);
    dbg(TAXI_CALLS);
    dbg("userstatus: "+getPlayerTaxiUserStatus(playerid));
    dbg(job_taxi[players[playerid].id]["counter"]);
    dbg("customer: "+job_taxi[players[playerid].id]["customer"]);
    dbg("car: "+job_taxi[players[playerid].id]["car"]);
}, KEY_UP);

local posA = null;
key("5", function(playerid) {
    if(posA == null) { posA = getPlayerPosition(playerid); msg( playerid, "Save posA." );}
    else {
    local posB = getPlayerPosition(playerid);
    local distance = getDistanceBetweenPoints3D( posA[0], posA[1], posA[2], posB[0], posB[1], posB[2] );
        msg( playerid, "Distance: " + distance + "." );
    posA = null;
    }

}, KEY_UP);

*/

/* ******************************************************************************************************************************************************* */



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

    screenFadeinFadeoutEx(playerid, 250, 200, function() {
        msg_taxi_dr(playerid, "job.taxi.driver.now");
        msg_taxi_dr( playerid, "job.taxi.ifyouwantstart");
        renameText ( playerid, "taxileavejob3dtext", "Press Q to leave job");
        setPlayerJob( playerid, "taxidriver");
        setPlayerModel( playerid, TAXI_JOB_SKIN );
    });
}



/* ******************************************************************************************************************************************************* */



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

    if(getPlayerTaxiUserStatus(playerid) == "busy") {
        return msg_taxi_dr(playerid, "job.taxi.cantleavejob1");
    }

    if(getPlayerTaxiUserStatus(playerid) == "onroute") {
        return msg_taxi_dr(playerid, "job.taxi.cantleavejob2");
    }

    screenFadeinFadeoutEx(playerid, 250, 200, function() {
        msg_taxi_dr(playerid, "job.leave");
        setPlayerJob( playerid, null );
        restorePlayerModel(playerid);
        renameText ( playerid, "taxileavejob3dtext", "Press E to get job");
        setPlayerTaxiUserStatus(playerid, "offair");

        if(job_taxi[players[playerid].id]["car"] != null) {
            setTaxiLightState(job_taxi[players[playerid].id]["car"], false);
            job_taxi[players[playerid].id]["car"] = null;
        }
    });
}


/* ******************************************************************************************************************************************************* */


function callTaxiByPed() {

    local pedid = (random(10, 99).tostring()+random(10, 99).tostring()+random(10, 99).tostring()).tointeger();
    local place = "telephone"+random(0, 93 /* 54, 54 */).tostring();

    local check = false;
    foreach (characterid, value in job_taxi) {
        local targetid = getPlayerIdFromCharacterId(characterid);
        //logStr("targetid: "+ targetid);
        //logStr(value["userstatus"]);
        //logStr("is taxi: "+isPlayerCarTaxi(targetid));
        if (value["userstatus"] == "onair" && isPlayerCarTaxi(targetid) ) { // need changed to onair for correct work !!!!!!!!!!!!!!!!!!!!!!!!
            check = true;
            msg_taxi_dr(targetid, "job.taxi.call.new", [ plocalize(targetid, place)/*, playerid*/]);
            msg_taxi_dr(targetid, "job.taxi.call.new.if" );
        }
    }

    // вызывать такси от бота каждый 5-15 секунд
    delayedFunction(random(5, 15)*1000, function() {
        callTaxiByPed();
    });

    if(!check) {
        //logStr("No free drivers");
        return;
    }

    TAXI_CALLS[pedid] <- [place, "open"];
    TAXI_LASTCALL = pedid;

    // если никто не принял вызов, через 5 минут заказ удаляется
    delayedFunction(300000, function() {
        if (pedid in TAXI_CALLS) {
            if(TAXI_CALLS[pedid][1] == "open") {
                delete TAXI_CALLS[pedid];
            }
            if (TAXI_LASTCALL == pedid) {
                TAXI_LASTCALL = null;
            }
        }
    });

    logStr("Pedid "+pedid+" called taxi to "+place);

}




/* ******************************************************************************************************************************************************* */


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


function getPlayerTaxiUserStatus (playerid) {
    logStr("get status");
    return job_taxi[players[playerid].id]["userstatus"];
}

function setPlayerTaxiUserStatus (playerid, status) {
    logStr("set status to "+status);
    return job_taxi[players[playerid].id]["userstatus"] = status;
}
