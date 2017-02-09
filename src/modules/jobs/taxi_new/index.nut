include("modules/jobs/taxi_new/commands.nut");

local job_taxi = {};
local price = 3.0;

const TAXI_JOB_SKIN = 171;
const TAXI_JOB_LEVEL = 2;

local TAXI_BLIP = [-710.638, 255.64, 0.365978];
local TAXI_COORDS = [-720.586, 248.261, 0.365978];
local TAXI_RADIUS = 2.0;

local TAXI_CALLS = {};
// format: TAXI_CALLS[playerid] <- [place, "open" / "inprocess" / "close"];
local TAXI_LASTCALL = null;

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
   

createVehicle(   24, -658.287, 236.719, 1.17881, -179.192, 0.255169, -0.234465 ), // TaxiDEVELOPER


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
});

event("onPlayerConnect", function(playerid) {
    //players[playerid]["taxi"] = {};
    //players[playerid]["taxi"]["call_address"] <- false; // Address from which was caused by a taxi
    //players[playerid]["taxi"]["call_state"] <- false; // Address from which was caused by a taxi

    job_taxi[playerid] <- {};
    job_taxi[playerid]["userstatus"] <- "offair";
    job_taxi[playerid]["counter"] <- null; // counter / taximeter
    job_taxi[playerid]["customer"] <- null; // customer == playerid who called taxi car
    job_taxi[playerid]["car"] <- null; // car == vehicleid of driver
});


event("onServerPlayerStarted", function( playerid ){
    if(isTaxiDriver(playerid)) {
        msg_taxi_dr( playerid, "job.taxi.continue");
        msg_taxi_dr( playerid, "job.taxi.ifyouwantstart");
        createText ( playerid, "leavejob3dtext", TAXI_COORDS[0], TAXI_COORDS[1], TAXI_COORDS[2]+0.20, "Press Q to leave job", CL_WHITE.applyAlpha(150), TAXI_RADIUS );
    } else {
        createText ( playerid, "leavejob3dtext", TAXI_COORDS[0], TAXI_COORDS[1], TAXI_COORDS[2]+0.20, "Press E to get job", CL_WHITE.applyAlpha(150), TAXI_RADIUS );
    }
});


event( "onPlayerVehicleEnter", function ( playerid, vehicleid, seat ) {
    if(isPlayerCarTaxi(playerid) && seat == 0) {
        if(isTaxiDriver (playerid)) {
            unblockVehicle(vehicleid);
        } else {
            blockVehicle(vehicleid);
        }
    }

    if(isPlayerCarTaxi(playerid) && seat == 1 ) {
        local driverid = getVehicleDriver(vehicleid);
        if(driverid == null) return;
        if(!isTaxiDriver(driverid) || job_taxi[driverid]["customer"] == null) return;
        if(playerid == job_taxi[driverid]["customer"]) {
            // start taximeter
            taxiStartCounter(driverid);
            msg_taxi_cu( playerid, "Такси бесплатное. Все расходы покрывает казна города.");
            msg_taxi_dr( driverid, "Taximeter ON. Press 2 to stop taximeter.");
        }
    }
});


event("onPlayerPlaceExit", function(playerid, name) {

    if ("taxiSmall" + playerid  == name) {
        msg_taxi_cu(playerid, "Если вы далеко отойдёте от места вызова - таксист не сможет подъехать.");
        return;
    }

    if ("taxiBig" + playerid  == name) {
        msg_taxi_cu(playerid, "Вы отошли слишком далеко.");
        removePlace("taxiSmall" + playerid);
        removePlace("taxiBig" + playerid);
        if(TAXI_LASTCALL == playerid) TAXI_LASTCALL = null;
        delete TAXI_CALLS[playerid];

        foreach (targetid, value in job_taxi) {
            if (value["customer"] == playerid) {
                removePlace("taxi"+targetid+"Customer"+playerid);
                job_taxi[targetid]["customer"] = null;
                job_taxi[targetid]["userstatus"] = "onair";
                trigger(targetid, "removeGPS");
                msg_taxi_dr(targetid, "job.taxi.callnotexist");
            }
        }
    }


});


event("onPlayerPlaceEnter", function(playerid, name) {

    if (!isTaxiDriver(playerid)) {
        return;
    }

    if (!isPlayerCarTaxi(playerid)) {
        return;
    }

    if(job_taxi[playerid]["customer"] == null) {
        return;
    }
    local customerid = job_taxi[playerid]["customer"];
    if ("taxi"+playerid+"Customer"+customerid  == name) {

        removePlace("taxiSmall" + customerid);
        removePlace("taxiBig" + customerid);
        removePlace("taxi"+playerid+"Customer"+customerid);
        trigger(playerid, "removeGPS");

        local plate = getVehiclePlateText( getPlayerVehicle( playerid ) );
        msg_taxi_dr(playerid, "job.taxi.wait");
        msg_taxi_cu(customerid, "taxi.call.arrived", plate);
        job_taxi[playerid]["userstatus"] = "onroute";
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



/* ******************************************************************************************************************************************************* */

/*

███████████████████████████████████████████████████████████████████████████████████████████████████
█─██─█─██─█──█──█─█─█────█████────█─██─█────█████─██─█───█████────█────█────█────█───█────█───█───█
█─██─█─██─██───██─█─█─██─█████─██─█─██─█─██─█████─██─█─███████─██─█─██─█─████─██─██─██─██─█─████─██
█────█─█──███─███───█────█████─██─█────█─██─█████────█───█████────█────█────█─██─██─██────█───██─██
█─██─█──█─██───████─██─█─█████─██─█─██─█─██─█████─██─█─███████─████─██─█─██─█─██─██─██─██─█─████─██
█─██─█─██─█──█──█───██─█─█████────█─██─█────█████─██─█───█████─████─██─█────█────██─██─██─█───██─██
███████████████████████████████████████████████████████████████████████████████████████████████████

 */


function taxiCounter (playerid, vx = null, vy = null, vz = null) {
    if (!isPlayerConnected(playerid) || job_taxi[playerid]["counter"] == null || (job_taxi[playerid]["car"] != getPlayerVehicle(playerid) && getPlayerVehicle(playerid) != -1) ) {
        return;
    }

    local vehicleid = job_taxi[playerid]["car"];
    dbg(getDistanceBtwPlayerAndVehicle(playerid, vehicleid));
    if( getPlayerVehicle(playerid) == -1) {
        dbg(getDistanceBtwPlayerAndVehicle(playerid, vehicleid));
        if (checkDistanceBtwPlayerAndVehicle(playerid, vehicleid, 25) == false) {
            job_taxi[playerid]["counter"] = null;
            dbg("bye");
            return;
        }
    }

    dbg("taxiCounter");

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
    //msg( playerid, "Distance: "+job_taxi[playerid]["counter"] );

    delayedFunction(2500, function(){
        taxiCounter (playerid, vehPosNew[0], vehPosNew[1], vehPosNew[2]);
    });
}

/* ******************************************************************************************************************************************************* */


function taxiStartCounter(playerid) {
    job_taxi[playerid]["counter"] = 0;
    taxiCounter (playerid);
}

function taxiStopCounter(playerid) {
    //msg( playerid, "End. Distance: "+job_taxi[playerid]["counter"], CL_EUCALYPTUS );
    job_taxi[playerid]["counter"] = null;
    taxiCounter (playerid);
}

function isCounterStarted(playerid) {
    return (job_taxi[playerid]["counter"] == null) ? false : true;
}


/* ******************************************************************************************************************************************************* */
/**
 * Call taxi car from <place>
 * @param  {int} playerid
 * @param  {string} place   - address place of call
 * @param  {int} again      - if set 1, message not be shown for playerid
 */


function taxiCall(playerid, place, again = 0) {

    if ((isTaxiDriver(playerid) && job_taxi[playerid]["userstatus"] != "offair") || (isTaxiDriver(playerid) && isPlayerCarTaxi(playerid))) {
        return msg_taxi_dr(playerid, "job.taxi.driver.dontfoolaround"); // don't fool around
    }

    local check = false;
    foreach (targetid, value in job_taxi) {
        if (value["userstatus"] == "onair" && isPlayerCarTaxi(targetid) ) { // need changed to onair for correct work !!!!!!!!!!!!!!!!!!!!!!!!
            check = true;
            msg_taxi_dr(targetid, "job.taxi.call.new", [ plocalize(targetid, place), playerid]);
        }
    }

    if(!check) {
        return msg_taxi_cu(playerid, "taxi.call.nofreecars");
    }


    TAXI_CALLS[playerid] <- [place, "open"];
    TAXI_LASTCALL = playerid;
    delayedFunction(300000, function() {
        if (playerid in TAXI_CALLS) {
            if(TAXI_CALLS[playerid][1] == "open") {
            //delete TAXI_CALLS[playerid];
            //TAXI_LASTCALL = null;
            }
        }
    });

    local placeNameSmall = "taxiSmall"+playerid;
    local placeNameBig   = "taxiBig"+playerid;
    if(isPlaceExists(placeNameSmall) || isPlaceExists(placeNameBig)) {
        removePlace(placeNameSmall);
        removePlace(placeNameBig);
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

    if (!isPlayerCarTaxi(playerid)) {
        return; //msg_taxi_dr(playerid, "job.taxi.needcar");
    }

    if (job_taxi[playerid]["car"] != getPlayerVehicle(playerid) && job_taxi[playerid]["car"] != null) {
        return msg_taxi_dr(playerid, "Sit into your taxi car with plate "+getVehiclePlateText(job_taxi[playerid]["car"]));
    }

    if(job_taxi[playerid]["userstatus"] == "offair") {
        return msg_taxi_dr(playerid, "job.taxi.canttakecall");
    }

    if(job_taxi[playerid]["userstatus"] == "onroute") {
        if(isCounterStarted(playerid)) {               
            taxiCallDone(playerid);
        }
        return;
    }

    if(job_taxi[playerid]["customer"] != null) {  dbg("refusing"); return taxiCallRefuse(playerid); };

    local customerid = TAXI_LASTCALL;

    if ( customerid == null) {
        return msg_taxi_dr(playerid, "На текущий момент звонков нет.");
    }

    if ( !isPlayerConnected(customerid) || playerid == customerid ) {
        return msg_taxi_dr(playerid, "job.taxi.callnotexist");
    }

    if(job_taxi[playerid]["customer"] == customerid) {
        return msg_taxi_dr(playerid, "job.taxi.takenthiscall", customerid);
    }

    if(job_taxi[playerid]["userstatus"] == "busy") {
        return msg_taxi_dr(playerid, "job.taxi.takencall");
    }

    if (TAXI_CALLS[customerid][1] != "open") {
        return msg_taxi_dr(playerid, "job.taxi.callalreadytaken", customerid);
    }

    TAXI_LASTCALL = null;
    TAXI_CALLS[customerid][1] = "inprocess";
    job_taxi[playerid]["customer"] = customerid;
    job_taxi[playerid]["userstatus"] = "busy";

    msg_taxi_dr(playerid, "job.taxi.youtakencall");
    msg_taxi_cu(customerid, "taxi.call.received");
    local phoneObj = getPhoneObj(TAXI_CALLS[customerid][0]);
    trigger(playerid, "setGPS", phoneObj[0], phoneObj[1]);
    createPlace("taxi"+playerid+"Customer"+customerid, phoneObj[0]-50, phoneObj[1]+50, phoneObj[0]+50, phoneObj[1]-50);

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

    local customerid = job_taxi[playerid]["customer"];

    if (customerid == null){
dbg(customerid);
        return msg_taxi_dr(playerid, "job.taxi.noanycalls");
    }

    local plate = getVehiclePlateText( getPlayerVehicle( playerid ) );
    msg_taxi_dr(playerid, "job.taxi.wait");
    msg_taxi_cu(customerid, "taxi.call.arrived", plate);
    job_taxi[playerid]["userstatus"] = "onroute";
}
*/
/**
 * Refuse the call
 * @param  {int} playerid
 */
function taxiCallRefuse(playerid) {

    local customerid = job_taxi[playerid]["customer"];
/*
    if (customerid == null){
        return msg_taxi_dr(playerid, "job.taxi.noanycalls");
    }
*/
    if(job_taxi[playerid]["userstatus"] == "onroute") {
        return msg_taxi_dr(playerid, "job.taxi.cantrefuse");
    }

    job_taxi[playerid]["customer"] = null;
    job_taxi[playerid]["userstatus"] = "onair";

    msg_taxi_dr(playerid, "job.taxi.refusedcall");
    msg_taxi_cu(customerid, "taxi.call.refused");
    removePlace("taxi"+playerid+"Customer"+customerid);
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


    local customerid = job_taxi[playerid]["customer"];

    if (customerid == null){
        return msg_taxi_dr(playerid, "job.taxi.noanycalls");
    }

    local distance = job_taxi[playerid]["counter"];
    msg_taxi_dr( playerid, "End of trip. Distance: "+distance );
    msg_taxi_cu( playerid, "End of trip. Distance: "+distance );
    taxiStopCounter(playerid);

    delete TAXI_CALLS[ job_taxi[playerid]["customer"] ];

    job_taxi[playerid]["userstatus"] = "onair";
    job_taxi[playerid]["counter"] <- null;
    job_taxi[playerid]["customer"] <- null;

    if(distance > 250.0) {
    local amount = distance * 0.0015;
        if(canTreasuryMoneyBeSubstracted(amount)) {
            subMoneyToTreasury(amount);
            addMoneyToPlayer(playerid, amount);
            msg_taxi_dr( playerid, "You earned $"+amount );
        } else {
            msg_taxi_dr( playerid, "Not enough money in treasury to give salary." );
        }
    } else {
        msg_taxi_dr( playerid, "Not enough money in treasury to give salary." );
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

    local customerid = job_taxi[playerid]["customer"];

    if (customerid == null){
        return msg_taxi_dr(playerid, "job.taxi.noanycalls");
    }

    players[customerid]["taxi"]["call_state"] = "closed";
    job_taxi[playerid]["customer"] = null;
    job_taxi[playerid]["userstatus"] = "onair";
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

    if (job_taxi[playerid]["car"] != getPlayerVehicle(playerid) && job_taxi[playerid]["car"] != null) {
        return msg_taxi_dr(playerid, "Sit into your taxi car with plate "+getVehiclePlateText(job_taxi[playerid]["car"]));
    }

    if (job_taxi[playerid]["car"] != getPlayerVehicle(playerid) && isCarTaxiFreeForDriver(getPlayerVehicle(playerid)) == false ) {
        return msg_taxi_dr(playerid, "This car is busy by another driver");
    }

    local userstatus = job_taxi[playerid]["userstatus"];
    if(userstatus != "onair" && userstatus != "offair") {
        return msg_taxi_dr(playerid, "job.taxi.cantchangestatus");
    }

    if (userstatus == "offair") {
        job_taxi[playerid]["userstatus"] = "onair";
        job_taxi[playerid]["car"] = getPlayerVehicle(playerid);
        setTaxiLightState(getPlayerVehicle(playerid), true);
        msg_taxi_dr(playerid, "job.taxi.statuson" );
    } else {
        job_taxi[playerid]["userstatus"] = "offair";
        job_taxi[playerid]["car"] = null;
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


cmd("ta", function(playerid) {
    taxiStartCounter(playerid);
});

cmd("tb", function(playerid) {
    taxiStopCounter(playerid)
});








key("3", function(playerid) {
    job_taxi[playerid]["userstatus"] <- "onair";
}, KEY_UP);

key("4", function(playerid) {
    dbg("=====================================================");
    dbg("LASTCALL: "+TAXI_LASTCALL);
    dbg(TAXI_CALLS);
    dbg("userstatus: "+job_taxi[playerid]["userstatus"]);
    dbg("counter: "+job_taxi[playerid]["counter"]);
    dbg("customer: "+job_taxi[playerid]["customer"]);
    dbg("car: "+job_taxi[playerid]["car"]);
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


/* ******************************************************************************************************************************************************* */



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

    screenFadeinFadeoutEx(playerid, 250, 200, function() {
        msg_taxi_dr(playerid, "job.taxi.driver.now");
        msg_taxi_dr( playerid, "job.taxi.ifyouwantstart");
        renameText ( playerid, "leavejob3dtext", "Press Q to leave job");
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

    if(job_taxi[playerid]["userstatus"] == "busy") {
        return msg_taxi_dr(playerid, "job.taxi.cantleavejob1");
    }

    if(job_taxi[playerid]["userstatus"] == "onroute") {
        return msg_taxi_dr(playerid, "job.taxi.cantleavejob2");
    }

    screenFadeinFadeoutEx(playerid, 250, 200, function() {
        msg(playerid, "job.leave");
        setPlayerJob( playerid, null );
        restorePlayerModel(playerid);
        renameText ( playerid, "leavejob3dtext", "Press E to get job");
        job_taxi[playerid]["userstatus"] = "offair";

        if(job_taxi[playerid]["car"] != null) {
            setTaxiLightState(job_taxi[playerid]["car"], false);
            job_taxi[playerid]["car"] = null;
        }
    });
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


function isCarTaxiFreeForDriver(vehicleid) {
    local check = true;
    foreach (targetid, value in job_taxi) {
        if (value["car"] == vehicleid ) {
            check = false;
        }
    }
    return check;
}
