include("controllers/organizations/police/commands.nut");

addEventHandlerEx("onServerStarted", function() {
    log("[police] starting police...");
    createVehicle(42, -387.247, 644.23, -11.1051, -0.540928, 0.0203334, 4.30543 ); // policecar1
    createVehicle(42, -327.361, 677.508, -17.4467, 88.647, -2.7285, 0.00588255 ); // policecarParking3
    createVehicle(42, -327.382, 682.532, -17.433, 90.5207, -3.07545, 0.378189 ); // policecarParking4
    createVehicle(21, -324.296, 693.308, -17.4131, -179.874, -0.796982, -0.196363 ); // policeBusParking1
    createVehicle(51, -326.669, 658.13, -17.5624, 90.304, -3.56444, -0.040828 ); // policeOldCarParking1
    createVehicle(51, -326.781, 663.293, -17.5188, 93.214, -2.95046, -0.0939897 ); // policeOldCarParking2
});

addEventHandler ( "onPlayerVehicleEnter", function ( playerid, vehicleid, seat ) {
    if(isPlayerInPoliceVehicle(playerid) && getPlayerJob(playerid) != "policeofficer") {
        // set player wanted level or smth like that
        return msg(playerid, "Would better not to do it.");
    }
});


/**
 * Check is player's vehicle is a police car
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isPlayerInPoliceVehicle(playerid) {
    return (isPlayerInValidVehicle(playerid, 42) || isPlayerInValidVehicle(playerid, 51) || isPlayerInValidVehicle(playerid, 21));
}


/**
 * Check if player is a police officer
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isOfficer(playerid) {
    return (isPlayerHaveValidJob(playerid, "policeofficer"));
}


/**
 * Become police officer
 * @param  {int} playerid
 */
function getPoliceJob(playerid) {
    if(isOfficer(playerid)) {
        return msg(playerid, "You're police officer already.");
    }

    if(isPlayerHaveJob(playerid)) {
        return msg(playerid, "You already have a job: " + getPlayerJob(playerid) + ".");
    }

    if (!isPlayerInPoliceVehicle(playerid)) {
        return msg(playerid, "You need a police car."); // not a car, but PD or PD chief
    }

    //setVehicleFuel( getPlayerVehicle(playerid), 56.0 );
    players[playerid]["job"] = "policeofficer";
    msg(playerid, "You became a police officer.");
}


/**
 * Leave from police
 * @param  {int} playerid
 */
function leavePoliceJob(playerid) {
    if(!isOfficer(playerid)) {
        return msg(playerid, "You're not a police officer.");
    }

    if(isPlayerHaveJob(playerid) && !isOfficer(playerid)) {
        return msg(playerid, "You already have got a job: " + getPlayerJob(playerid) + ".");
    }

    // IDK Y, but I'll leave it here
    if( isPlayerInPoliceVehicle(playerid) ) {
        setVehicleFuel( getPlayerVehicle(playerid), 0.0 );
    }

    players[playerid]["job"] = null;
    msg(playerid, "You leave police department.");
}
