include("controllers/jobs/taxi/commands.nut");

local job_taxi = {};

addEventHandlerEx("onServerStarted", function() {
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

addEventHandlerEx("onPlayerConnect", function(playerid, name, ip, serial ){
     job_taxi[playerid] <- {};
     job_taxi[playerid]["status"] <- "offair";
     job_taxi[playerid]["customer"] <- null; // customer == playerid who called taxi car
});

/**
 * msg to taxi customer
 * @param  {int}  playerid
 * @param  {string} text - text to print in chat
 */
function msg_taxi_cu(playerid, text) {
    return msg(playerid, "[TAXI] " + text, CL_CREAMCAN);
}

/**
 * msg to taxi driver
 * @param  {int}  playerid
 * @param  {string} text - text to print in chat
 */
function msg_taxi_dr(playerid, text) {
    return msg(playerid, "[TAXI] " + text, CL_ECSTASY);
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
            return msg_taxi_cu(playerid, "You can't call taxi without address.");
    }
    local check = false;
    foreach (key, value in job_taxi) {
        if (value["status"] == "onair") { // need changed to onair for correct work !!!!!!!!!!!!!!!!!!!!!!!!
            check = true;
            msg_taxi_dr(key, "New call from address: " + place + ". If you want take this call, write /taxi take " + playerid);
        }
    }

    if(!check) {
        return msg_taxi_cu(playerid, "No free cars. Please try later.");
    }

    players[playerid]["taxi"]["call_address"] <- place;
    players[playerid]["taxi"]["call_state"] <- "open";
    if (!again) msg_taxi_cu(playerid, "You've called taxi from " + place);
}

/**
 * Taking call
 * @param  {int} playerid
 * @param  {int} customerid - id customer
 */
function taxiCallTake(playerid, customerid) {

    if (!isTaxiDriver(playerid)) {
        return msg_taxi_dr(playerid, "You're not a taxi driver.");
    }

    if (!isPlayerCarTaxi(playerid)) {
        return msg_taxi_dr(playerid, "You need a taxi car.");
    }

    if(job_taxi[playerid]["customer"] == customerid) {
        return msg_taxi_dr(playerid, "You have already taken this call #" + customerid);
    }

    if(job_taxi[playerid]["status"] == "offair") {
        return msg_taxi_dr(playerid, "You can't take call until your status is OFF air.");
    }

    if(job_taxi[playerid]["status"] == "busy") {
        return msg_taxi_dr(playerid, "You have already taken a call.");
    }

    if (players[customerid]["taxi"]["call_state"] != "open") {
        return msg_taxi_dr(playerid, "Call #" + customerid + " is already taken.");
    }

    players[customerid]["taxi"]["call_state"] = "inprocess";
    job_taxi[playerid]["customer"] = customerid;
    job_taxi[playerid]["status"] = "busy";

    msg_taxi_dr(playerid, "You've taken a call #" + customerid);
    msg_taxi_cu(customerid, "Your call is received by driver. The car goes to you.");
}

/**
 * Report that the taxicar has arrived to the address
 * @param  {int} playerid
 */
function taxiCallReady(playerid) {

    if (!isTaxiDriver(playerid)) {
        return msg_taxi_dr(playerid, "You're not a taxi driver.");
    }

    if (!isPlayerCarTaxi(playerid)) {
        return msg_taxi_dr(playerid, "You need a taxi car.");
    }

    local customerid = job_taxi[playerid]["customer"];

    if (customerid == null){
        dbg(customerid);
        return msg_taxi_dr(playerid, "You didn't take any calls.");
    }

    local plate = getVehiclePlateText( getPlayerVehicle( playerid ) );
    msg_taxi_dr(playerid, "Wait for the passenger...");
    msg_taxi_cu(customerid, "Your taxi car with plate "+ plate +" arrived to address.");
}

/**
 * Refuse the call
 * @param  {int} playerid
 */
function taxiCallRefuse(playerid) {

    if (!isTaxiDriver(playerid)) {
        return msg_taxi_dr(playerid, "You're not a taxi driver.");
    }

    if (!isPlayerCarTaxi(playerid)) {
        return msg_taxi_dr(playerid, "You need a taxi car.");
    }

    local customerid = job_taxi[playerid]["customer"];

    if (customerid == null){
        return msg_taxi_dr(playerid, "You didn't take any calls.");
    }

    job_taxi[playerid]["customer"] = null;
    job_taxi[playerid]["status"] = "onair";
    players[customerid]["taxi"]["call_state"] = "open";
    msg_taxi_dr(playerid, "You've refused from call #" + customerid);
    msg_taxi_cu(customerid, "Driver refused from your call. Wait another driver.");
    taxiCall(customerid, players[customerid]["taxi"]["call_address"], 1);
}

/**
 * End trip, pay for trip and call
 * @param  {int} playerid
 * @param  {float} amount   - amount for trip at taxi. Default $3.0
 */
function taxiCallEnd(playerid, amount) {

    if (!isTaxiDriver(playerid)) {
        return msg_taxi_dr(playerid, "You're not a taxi driver.");
    }

    if (!isPlayerCarTaxi(playerid)) {
        return msg_taxi_dr(playerid, "You need a taxi car.");
    }

    local customerid = job_taxi[playerid]["customer"];

    if (customerid == null){
        return msg_taxi_dr(playerid, "You didn't take any calls.");
    }

    players[customerid]["taxi"]["call_state"] = "closed";
    job_taxi[playerid]["customer"] = null;
    job_taxi[playerid]["status"] = "onair";
    msg_taxi_dr(playerid, "You've completed the trip for call #" + customerid );
    sendInvoice(playerid, customerid, amount);
}

/**
 * Set status as ON air
 * @param  {int} playerid
 */
function taxiGoOnAir(playerid) {

    if (!isTaxiDriver(playerid)) {
        return msg_taxi_dr(playerid, "You're not a taxi driver.");
    }

    if (!isPlayerCarTaxi(playerid)) {
        return msg_taxi_dr(playerid, "You need a taxi car.");
    }

    job_taxi[playerid]["status"] = "onair";
    msg_taxi_dr(playerid, "Your taxi driver status: ON air. Wait for a call...");
}

/**
 * Set status as OFF air
 * @param  {int} playerid
 */
function taxiGoOffAir(playerid) {

    if (!isTaxiDriver(playerid)) {
        return msg_taxi_dr(playerid, "You're not a taxi driver.");
    }

    if (!isPlayerCarTaxi(playerid)) {
        return msg_taxi_dr(playerid, "You need a taxi car.");
    }

    if(job_taxi[playerid]["status"] == "busy") {
        return msg_taxi_dr(playerid, "You can't change status until you'll complete the trip or refuse the call.");
    }

    job_taxi[playerid]["status"] = "offair";
    msg_taxi_dr(playerid, "Your taxi driver status: OFF air. You won't receive calls now.");
}


/**
 * Get taxi driver job
 * @param  {int} playerid
 */
function taxiJob(playerid) {

    if(isTaxiDriver(playerid)) {
        return msg(playerid, "You're taxi driver already.");
    }

    if(isPlayerHaveJob(playerid)) {
        return msg(playerid, "You already have a job: " + getPlayerJob(playerid) + ".");
    }

    if (!isPlayerCarTaxi(playerid)) {
        return msg(playerid, "You need a taxi car.");
    }

    players[playerid]["job"] = "taxidriver";
    msg(playerid, "You became a taxi driver. Change status to ON air to begin to receive calls.");
}

/**
 * Leave from taxi driver job
 * @param  {int} playerid
 */
function taxiJobLeave(playerid) {
    if(!isTaxiDriver(playerid)) {
        return msg(playerid, "You're not a taxi driver.");
    }

    if(isPlayerHaveJob(playerid) && !isTaxiDriver(playerid)) {
        return msg(playerid, "You have a job: " + getPlayerJob(playerid) + ".");
    }

    players[playerid]["job"] = null;
    job_taxi[playerid]["status"] = "offair";
    msg(playerid, "You leave a taxi driver job.");
}
