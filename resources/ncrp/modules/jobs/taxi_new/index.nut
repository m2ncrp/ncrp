include("modules/jobs/taxi_new/commands.nut");

local job_taxi = {};
local price = 3.0;

const TAXI_JOB_SKIN = 171;
const TAXI_JOB_LEVEL = 2;

local TAXI_COORDS = [-710.638, 255.64, 0.365978];
local TAXI_RADIUS = 2.0;

// general
translation("en", {
    "job.taxidriver"                    :   "taxi driver"
    "job.taxi.needlevel"                :   "[TAXI JOB] You need level %d to become taxi driver."
    "job.taxi.driver.not"               :   "[TAXI JOB] You're not a Taxi Driver."
    "job.taxi.driver.already"           :   "[TAXI JOB] You're Taxi Driver already."
    "job.taxi.driver.dontfoolaround"    :   "[TAXI JOB] Don't fool around! You are a taxi driver."
    "job.taxi.driver.now"               :   "[TAXI JOB] You became a taxi driver. Change status to ON air to begin to receive calls."
    "job.taxi.call.new"                 :   "[TAXI JOB] New call from address: %s. If you want take this call, write /taxi take %d."
    "job.taxi.needcar"                  :   "[TAXI JOB] You need a taxi car."
    "job.taxi.noanycalls"               :   "[TAXI JOB] You didn't take any calls."
    "job.taxi.wait"                     :   "[TAXI JOB] Wait for the passenger..."
    "job.taxi.canttakecall"             :   "[TAXI JOB] You can't take call while your status is OFF air."
    "job.taxi.callnotexist"             :   "[TAXI JOB] Customer has canceled the call. Wait other calls..."
    "job.taxi.takenthiscall"            :   "[TAXI JOB] You have already taken this call #%d."
    "job.taxi.takencall"                :   "[TAXI JOB] You have already taken a call."
    "job.taxi.callalreadytaken"         :   "[TAXI JOB] Call #%d is already taken."
    "job.taxi.youtakencall"             :   "[TAXI JOB] You've taken a call #%d."
    "job.taxi.completed"                :   "[TAXI JOB] Customer paid the trip. You've completed the call #%d."
    "job.taxi.statuson"                 :   "[TAXI JOB] Your taxi driver status: ON air. Wait for a call..."
    "job.taxi.cantchangestatus"         :   "[TAXI JOB] You can't change status while you'll complete trip or refuse call."
    "job.taxi.statusoff"                :   "[TAXI JOB] Your taxi driver status: OFF air. You won't receive calls now."
    "job.taxi.requested"                :   "[TAXI JOB] You have requested payment of $%.2f."
    "job.taxi.psngdeclined"             :   "[TAXI JOB] Passenger %s declined to pay."
    "job.taxi.callclosed"               :   "[TAXI JOB] Call has been closed successfully."
    "job.taxi.havejob"                  :   "[TAXI JOB] You have a job: %s."
    "job.taxi.refusedcall"              :   "[TAXI JOB] You've refused from call #%d."
    "job.taxi.cantrefuse"               :   "[TAXI JOB] You can't refuse from call while you carry a passenger."
    "job.taxi.cantleavejob1"            :   "[TAXI JOB] You can't leave job while you have a call."
    "job.taxi.cantleavejob2"            :   "[TAXI JOB] You can't leave job while you'll complete the trip."

    "job.taxi.help.title"               :   "List of available commands for TAXI JOB:"
    "job.taxi.help.job"                 :   "Get taxi driver job"
    "job.taxi.help.jobleave"            :   "Leave from taxi driver job"
    "job.taxi.help.onair"               :   "Set status as ON air"
    "job.taxi.help.offair"              :   "Set status as OFF air"
    "job.taxi.help.take"                :   "Take call with ID. Example: /taxi take 5"
    "job.taxi.help.refuse"              :   "Refuse the current taken call"
    "job.taxi.help.ready"               :   "Report that the taxicar has arrived to the address"
    "job.taxi.help.done"                :   "End trip and send invoice to pay AMOUNT dollars. Example: /taxi done 1.25"
    "job.taxi.help.close"               :   "Close the call as completed"

    "taxi.needpay"                      :   "To drive this car you need to pay $%.2f for fuel and rent. If you agree: /drive"
    "taxi.notenough"                    :   "You don't have enough money."
    "taxi.youpay"                       :   "You paid $%.2f. Now you can drive this car."
    "taxi.attention"                    :   "Attention!!! If you leave the car and want to drive again, you need to pay again too."

    "taxi.call.addresswithout"          :   "[TAXI] You can't call taxi without address."
    "taxi.call.nofreecars"              :   "[TAXI] No free cars. Please try later."
    "taxi.call.youcalled"               :   "[TAXI] You've called taxi from %s."
    "taxi.call.received"                :   "[TAXI] Your call is received by driver. The car goes to you."
    "taxi.call.arrived"                 :   "[TAXI] Your taxi car with plate %s arrived to address."
    "taxi.call.refused"                 :   "[TAXI] Driver refused from your call. Wait another driver."
    "taxi.call.request"                 :   "[TAXI] You have to pay $%.2f for taxi."
    "taxi.call.declined"                :   "[TAXI] You declined to pay for taxi."
    "taxi.call.completed"               :   "[TAXI] The trip is completed. Please, leave the car."

    "taxi.help.title"                   :   "List of available commands for TAXI:"
    "taxi.help.taxi"                    :   "/taxi - Call a taxi from phonebooth"
});

event("onServerStarted", function() {
    log("[jobs] loading taxi job...");
    local taxicars = [
    /*
        createVehicle(24, -127.650, 412.521, -13.98, -90.0, 0.2, -0.2),   // taxi East Side 1
        createVehicle(24, -127.650, 408.872, -13.98, -90.0, 0.2, -0.2),   // taxi East Side 2
        createVehicle(24, -127.650, 405.611, -13.98, -90.0, 0.2, -0.2),   // taxi East Side 3
        createVehicle(24, -127.650, 402.069, -13.98, -90.0, 0.2, -0.2),   // taxi East Side 4
        createVehicle(33, -127.650, 398.769, -13.98, -90.0, 0.2, -0.2),   // taxi East Side 5
    */
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

    registerPersonalJobBlip("taxidriver", TAXI_COORDS[0], TAXI_COORDS[1]);
});

event("onPlayerConnect", function(playerid) {
    players[playerid]["taxi"] = {};
    players[playerid]["taxi"]["call_address"] <- false; // Address from which was caused by a taxi
    players[playerid]["taxi"]["call_state"] <- false; // Address from which was caused by a taxi

    job_taxi[getPlayerName(playerid)] <- {};
    job_taxi[getPlayerName(playerid)]["userstatus"] <- "offair";
    job_taxi[getPlayerName(playerid)]["counter"] <- null; // counter / taximeter
    job_taxi[getPlayerName(playerid)]["customer"] <- null; // customer == playerid who called taxi car
});

event( "onPlayerVehicleEnter", function ( playerid, vehicleid, seat ) {
    if(isPlayerCarTaxi(playerid) && seat == 0) {
        if(getPlayerJob(playerid) == "taxidriver") {
            return setVehicleFuel(vehicleid, 65.0);
        }
        setVehicleFuel(vehicleid, 0.0);
        return msg(playerid, "taxi.needpay", price);
    }
});
/*
cmd("drive", function(playerid) {
    if(isPlayerCarTaxi(playerid) && getPlayerJob(playerid) != "taxidriver") {
        if(!canMoneyBeSubstracted(playerid, price.tofloat())) {
            return msg(playerid, "taxi.notenough");
        }
        subMoneyToPlayer(playerid, price);
        setVehicleFuel(getPlayerVehicle(playerid), 56.0);
        msg(playerid, "taxi.youpay", price);
        msg(playerid, "taxi.attention");
    }
});
*/

event("onPlayerPhoneCall", function(playerid, number, place) {
    if(number == "taxi") {
        taxiCall(playerid, place);
    }
});

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
 * Call taxi car from <place>
 * @param  {int} playerid
 * @param  {string} place   - address place of call
 * @param  {int} again      - if set 1, message not be shown for playerid
 */
function taxiCall(playerid, place, again = 0) {

    if ((isTaxiDriver(playerid) && job_taxi[playerid]["status"] == "onair") || (isTaxiDriver(playerid) && isPlayerCarTaxi(playerid))) {
        return msg_taxi_dr(playerid, "job.taxi.driver.dontfoolaround"); // don't fool around
    }
/*
    if (!place || place.len() < 1) {
            return msg_taxi_cu(playerid, "taxi.call.addresswithout");
    }
*/
    local check = false;
    foreach (key, value in job_taxi) {
        if (value["status"] == "offair") { // need changed to onair for correct work !!!!!!!!!!!!!!!!!!!!!!!!
            check = true;
            msg_taxi_dr(key, "job.taxi.call.new", [place, playerid]);
        }
    }

    if(!check) {
        return msg_taxi_cu(playerid, "taxi.call.nofreecars");
    }

    players[playerid]["taxi"]["call_address"] <- place;
    players[playerid]["taxi"]["call_state"] <- "open";
    if (!again) msg_taxi_cu(playerid, "taxi.call.youcalled", place);
}

/**
 * Taking call
 * @param  {int} playerid
 * @param  {int} customerid - id customer
 */
function taxiCallTake(playerid, customerid) {

    if (!isTaxiDriver(playerid)) {
        return msg_taxi_dr(playerid, "job.taxi.driver.not");
    }

    if (!isPlayerCarTaxi(playerid)) {
        return msg_taxi_dr(playerid, "job.taxi.needcar");
    }

    if(job_taxi[playerid]["status"] == "offair") {
        return msg_taxi_dr(playerid, "job.taxi.canttakecall");
    }

    if ( !isPlayerConnected(customerid) || playerid == customerid ) {
        return msg_taxi_dr(playerid, "job.taxi.callnotexist");
    }

    if(job_taxi[playerid]["customer"] == customerid) {
        return msg_taxi_dr(playerid, "job.taxi.takenthiscall", customerid);
    }

    if(job_taxi[playerid]["status"] == "busy") {
        return msg_taxi_dr(playerid, "job.taxi.takencall");
    }

    if (players[customerid]["taxi"]["call_state"] != "open") {
        return msg_taxi_dr(playerid, "job.taxi.callalreadytaken", customerid);
    }

    players[customerid]["taxi"]["call_state"] = "inprocess";
    job_taxi[playerid]["customer"] = customerid;
    job_taxi[playerid]["status"] = "busy";

    msg_taxi_dr(playerid, "job.taxi.youtakencall", customerid);
    msg_taxi_cu(customerid, "taxi.call.received");
}

/**
 * Report that the taxicar has arrived to the address
 * @param  {int} playerid
 */
function taxiCallReady(playerid) {

    if (!isTaxiDriver(playerid)) {
        return msg_taxi_dr(playerid, "job.taxi.driver.not");
    }

    if (!isPlayerCarTaxi(playerid)) {
        return msg_taxi_dr(playerid, "job.taxi.needcar");
    }

    local customerid = job_taxi[playerid]["customer"];

    if (customerid == null){
dbg(customerid);
        return msg_taxi_dr(playerid, "job.taxi.noanycalls");
    }

    local plate = getVehiclePlateText( getPlayerVehicle( playerid ) );
    msg_taxi_dr(playerid, "job.taxi.wait");
    msg_taxi_cu(customerid, "taxi.call.arrived", plate);
    job_taxi[playerid]["status"] = "onroute";
}

/**
 * Refuse the call
 * @param  {int} playerid
 */
function taxiCallRefuse(playerid) {

    if (!isTaxiDriver(playerid)) {
        return msg_taxi_dr(playerid, "job.taxi.driver.not");
    }

    if (!isPlayerCarTaxi(playerid)) {
        return msg_taxi_dr(playerid, "job.taxi.needcar");
    }

    local customerid = job_taxi[playerid]["customer"];

    if (customerid == null){
        return msg_taxi_dr(playerid, "job.taxi.noanycalls");
    }

    if(job_taxi[playerid]["status"] == "onroute") {
        return msg_taxi_dr(playerid, "job.taxi.cantrefuse");
    }

    job_taxi[playerid]["customer"] = null;
    job_taxi[playerid]["status"] = "onair";
    players[customerid]["taxi"]["call_state"] = "open";
    msg_taxi_dr(playerid, "job.taxi.refusedcall", customerid);
    msg_taxi_cu(customerid, "taxi.call.refused");
    delayedFunction(3000,  function() {
        taxiCall(customerid, players[customerid]["taxi"]["call_address"], 1);
    });
}

/**
 * End trip, pay for trip and call
 * @param  {int} playerid
 * @param  {float} amount   - amount for trip at taxi. Default $3.0
 */
function taxiCallDone(playerid, amount) {

    if (!isTaxiDriver(playerid)) {
        return msg_taxi_dr(playerid, "job.taxi.driver.not");
    }

    if (!isPlayerCarTaxi(playerid)) {
        return msg_taxi_dr(playerid, "job.taxi.needcar");
    }

    local customerid = job_taxi[playerid]["customer"];

    if (customerid == null){
        return msg_taxi_dr(playerid, "job.taxi.noanycalls");
    }

    msg_taxi_dr(playerid, "job.taxi.requested", amount );
    msg_taxi_cu(customerid, "taxi.call.request", amount);
    sendInvoiceSilent(playerid, customerid, amount, function(customerid, driverid, result) {
        // playerid responded to invoice from customerid with result
        // (true - acepted / false - declined)
        if(result == true) {
            players[customerid]["taxi"]["call_state"] = "closed";
            job_taxi[driverid]["customer"] = null;
            job_taxi[driverid]["status"] = "onair";
            msg_taxi_dr(driverid, "job.taxi.completed", playerid );
            msg_taxi_cu(customerid, "taxi.call.completed" );
        } else {
            msg(driverid "job.taxi.psngdeclined", getPlayerNameShort(customerid), CL_RED );
            msg(customerid, "taxi.call.declined", CL_RED );
        }
    }
    );
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

    local customerid = job_taxi[playerid]["customer"];

    if (customerid == null){
        return msg_taxi_dr(playerid, "job.taxi.noanycalls");
    }

    players[customerid]["taxi"]["call_state"] = "closed";
    job_taxi[playerid]["customer"] = null;
    job_taxi[playerid]["status"] = "onair";
    msg_taxi_dr(playerid, "job.taxi.callclosed" );
}


/**
 * Switch status air
 * @param  {int} playerid
 */
function taxiSwitchAir(playerid) {

    if (!isTaxiDriver(playerid) || !isPlayerCarTaxi(playerid)) {
        return ;
    }

    if (job_taxi[playerid]["status"] != "onair") {
        job_taxi[playerid]["status"] = "offair";
        setTaxiLightState(getPlayerVehicle(playerid), true);
        msg_taxi_dr(playerid, "job.taxi.statuson" );
    } else {
        job_taxi[playerid]["status"] = "offair";
        setTaxiLightState(getPlayerVehicle(playerid), false);
        msg_taxi_dr(playerid, "job.taxi.statusoff");
    }
}






key("e", function(playerid) {
    taxiJobGet ( playerid );
}, KEY_UP);

key("q", function(playerid) {
    taxiJobRefuseLeave ( playerid )
}, KEY_UP);








/**
 * Get taxi driver job
 * @param  {int} playerid
 */
function taxiJobGet(playerid) {
    if(!isPlayerInValidPoint(playerid, TAXI_COORDS[0], TAXI_COORDS[1], TAXI_RADIUS)) {
        return;
    }


    if(!isPlayerLevelValid ( playerid, TAXI_JOB_LEVEL )) {
        return msg(playerid, "job.taxi.needlevel", TAXI_JOB_LEVEL );
    }



    if(isTaxiDriver(playerid)) {
        return msg(playerid, "job.taxi.driver.already");
    }

    if(isPlayerHaveJob(playerid)) {
        return msg(playerid, "job.alreadyhavejob", getLocalizedPlayerJob(playerid) );
    }

    if (!isPlayerCarTaxi(playerid)) {
        return msg(playerid, "job.taxi.needcar");
    }



    setTaxiLightState(getPlayerVehicle(playerid), false);
    setVehicleFuel(getPlayerVehicle(playerid), 56.0);

    msg_taxi_dr(playerid, "job.taxi.driver.now");

    setPlayerJob( playerid, "taxidriver");
    setPlayerModel( playerid, TAXI_JOB_SKIN );
}

/**
 * Leave from taxi driver job
 * @param  {int} playerid
 */
function fuelJobRefuseLeave(playerid) {
    if(!isTaxiDriver(playerid)) {
        return msg(playerid, "job.taxi.driver.not");
    }

    if(isPlayerHaveJob(playerid) && !isTaxiDriver(playerid)) {
        return msg(playerid, "job.taxi.driver.not" );
    }

    if(job_taxi[playerid]["status"] == "busy") {
        return msg_taxi_dr(playerid, "job.taxi.cantleavejob1");
    }

    if(job_taxi[playerid]["status"] == "onroute") {
        return msg_taxi_dr(playerid, "job.taxi.cantleavejob2");
    }

    if ( isPlayerInVehicle(playerid) && isPlayerCarTaxi(playerid) ) {
        local vehicleid = getPlayerVehicle( playerid );
        setTaxiLightState(getPlayerVehicle(playerid), false);
        setVehicleFuel(vehicleid, 0.0);
    }
    screenFadeinFadeoutEx(playerid, 250, 200, function() {

        msg(playerid, "job.leave");

        setPlayerJob( playerid, null );
        restorePlayerModel(playerid);

        job_taxi[playerid]["status"] = "offair";
    });
}

/*
addEventHandler ( "onPlayerVehicleExit", function ( playerid, vehicleid, seat )
{
    local vehicleModel = getVehicleModel( vehicleid );

    if (vehicleModel == 24 || vehicleModel == 33) {
         setTaxiLightState(vehicleid, false);
    }
    //msg(playerid, playerid+" - "+vehicleid+" - "+seat);
    return 1;
});
*/


function taxiCounter (playerid, vx = null, vy = null, vz = null) {
    if (job_taxi[playerid]["counter"] == null) {
        return;
    }
    dbg("taxiCounter");
    local vehicleid = getPlayerVehicle(playerid);
    local vehPosOld = null;
    if (vx != null) {
        dbg("vx");
        vehPosOld = [vx, vy, vz];
    } else {
        vehPosOld = getVehiclePosition(vehicleid);
        dbg("else");
    }

    local vehPosNew = getVehiclePosition(vehicleid);
    local dis = getDistanceBetweenPoints3D( vehPosOld[0], vehPosOld[1], vehPosOld[2], vehPosNew[0], vehPosNew[1], vehPosNew[2] );
    job_taxi[playerid]["counter"] += dis;
    msg( playerid, "Distance: "+job_taxi[playerid]["counter"] );

    delayedFunction(2500, function(){
        taxiCounter (playerid, vehPosNew[0], vehPosNew[1], vehPosNew[2]);
    });
}


cmd("ta", function(playerid) {
    job_taxi[playerid]["counter"] = 0;
    taxiCounter (playerid);
});

cmd("tb", function(playerid) {
    msg( playerid, "End. Distance: "+job_taxi[playerid]["counter"], CL_EUCALYPTUS );
    job_taxi[playerid]["counter"] = null;
    taxiCounter (playerid);
});
