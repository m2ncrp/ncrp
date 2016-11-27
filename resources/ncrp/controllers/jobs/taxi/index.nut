include("controllers/jobs/taxi/commands.nut");

local job_taxi = {};
local price = 3.0;

const TAXI_JOB_SKIN = 171;

event("onServerStarted", function() {
    log("[jobs] loading taxi job...");
    local taxicars = [
        createVehicle(24, -127.650, 412.521, -13.98, -90.0, 0.2, -0.2),   // taxi East Side 1
        createVehicle(24, -127.650, 408.872, -13.98, -90.0, 0.2, -0.2),   // taxi East Side 2
        createVehicle(24, -127.650, 405.611, -13.98, -90.0, 0.2, -0.2),   // taxi East Side 3
        createVehicle(24, -127.650, 402.069, -13.98, -90.0, 0.2, -0.2),   // taxi East Side 4
        createVehicle(24, -127.650, 398.769, -13.98, -90.0, 0.2, -0.2),   // taxi East Side 5
        createVehicle(24, -479.656, 702.3, 1.2, -179.983, -2.09183, 0.445576  ),     // taxi Uptown 1
        createVehicle(24, -483.363, 702.3, 1.2, -178.785, -2.16034, 0.16853   ),     // taxi Uptown 2
        createVehicle(24, -487.191, 702.3, 1.2, -178.078, -2.24803, 0.0579244 ),     // taxi Uptown 3
        createVehicle(24, -562.499, 1531.58, -15.8716, 179.774, -0.783486, -0.861209 ),     // taxi_naprotiv_vokzala_1
        createVehicle(24, -555.26, 1531.58, -15.9158, -175.993, -0.224305, -2.7155   ),     // taxi_naprotiv_vokzala_3
        createVehicle(24, -558.958, 1531.63, -15.8925, -179.154, -0.772926, -1.93243 ),     // taxi_naprotiv_vokzala_2
        createVehicle(24, -551.591, 1531.58, -15.9196, -176.976, -0.349312, -2.70036 )      // taxi_naprotiv_vokzala_4
    ];
});

event("onPlayerConnect", function(playerid, name, ip, serial ){
    players[playerid]["taxi"] <- {};
    players[playerid]["taxi"]["call_address"] <- false; // Address from which was caused by a taxi
    players[playerid]["taxi"]["call_state"] <- false; // Address from which was caused by a taxi

    job_taxi[playerid] <- {};
    job_taxi[playerid]["status"] <- "offair";
    job_taxi[playerid]["customer"] <- null; // customer == playerid who called taxi car
});

event( "onPlayerVehicleEnter", function ( playerid, vehicleid, seat ) {
    if(isPlayerCarTaxi(playerid) && getPlayerJob(playerid) != "taxidriver" && isVehicleEmpty(vehicleid)) {
        setVehicleFuel(vehicleid, 0.0);
        return msg(playerid, "taxi.needpay", price);
    }

});

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
    if (!place || place.len() < 1) {
            return msg_taxi_cu(playerid, "taxi.call.addresswithout");
    }
    local check = false;
    foreach (key, value in job_taxi) {
        if (value["status"] == "onair") { // need changed to onair for correct work !!!!!!!!!!!!!!!!!!!!!!!!
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

    if(job_taxi[playerid]["customer"] == customerid) {
        return msg_taxi_dr(playerid, "job.taxi.takenthiscall", customerid);
    }

    if(job_taxi[playerid]["status"] == "offair") {
        return msg_taxi_dr(playerid, "job.taxi.canttakecall");
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
    delayedFunction(1000,  function() {
        taxiCall(customerid, players[customerid]["taxi"]["call_address"], 1);
    });
}

/**
 * End trip, pay for trip and call
 * @param  {int} playerid
 * @param  {float} amount   - amount for trip at taxi. Default $3.0
 */
function taxiCallEnd(playerid, amount) {

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
    msg_taxi_dr(playerid, "job.taxi.completed", customerid );
    sendInvoice(playerid, customerid, amount);
}

/**
 * Set status as ON air
 * @param  {int} playerid
 */
function taxiGoOnAir(playerid) {

    if (!isTaxiDriver(playerid)) {
        return msg_taxi_dr(playerid, "job.taxi.driver.not" );
    }

    if (!isPlayerCarTaxi(playerid)) {
        return msg_taxi_dr(playerid, "job.taxi.needcar" );
    }

    job_taxi[playerid]["status"] = "onair";
    setTaxiLightState(getPlayerVehicle(playerid), true);
    msg_taxi_dr(playerid, "job.taxi.statuson" );
}

/**
 * Set status as OFF air
 * @param  {int} playerid
 */
function taxiGoOffAir(playerid) {

    if (!isTaxiDriver(playerid)) {
        return msg_taxi_dr(playerid, "job.taxi.driver.not" );
    }

    if (!isPlayerCarTaxi(playerid)) {
        return msg_taxi_dr(playerid, "job.taxi.needcar" );
    }

    if(job_taxi[playerid]["status"] != "onair") {
        return msg_taxi_dr(playerid, "job.taxi.cantchangestatus");
    }

    job_taxi[playerid]["status"] = "offair";
    setTaxiLightState(getPlayerVehicle(playerid), false);
    msg_taxi_dr(playerid, "job.taxi.statusoff");
}


/**
 * Get taxi driver job
 * @param  {int} playerid
 */
function taxiJob(playerid) {

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

    msg(playerid, "job.taxi.driver.now");

    players[playerid]["job"] = "taxidriver";

    players[playerid]["skin"] = TAXI_JOB_SKIN;
    setPlayerModel( playerid, TAXI_JOB_SKIN );
}

/**
 * Leave from taxi driver job
 * @param  {int} playerid
 */
function taxiJobLeave(playerid) {
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

    if ( isPlayerInVehicle(playerid) ) {
        local vehicleid = getPlayerVehicle( playerid );
        setTaxiLightState(getPlayerVehicle(playerid), false);
        setVehicleFuel(vehicleid, 0.0);
    }
    screenFadeinFadeoutEx(playerid, 250, 200, function() {

        msg(playerid, "job.leave");

        players[playerid]["job"] = null;

        players[playerid]["skin"] = players[playerid]["default_skin"];
        setPlayerModel( playerid, players[playerid]["default_skin"]);

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
