include("controllers/jobs/cargodriver/commands.nut");

local job_cargo = {};
local cargocars = {};


const RADIUS_CARGO = 1.0;
const CARGO_JOB_X = -422.731;
const CARGO_JOB_Y = 479.462;

local cargocoords = {};
cargocoords["PortChinese"] <- [-217.298, -724.771, -21.423]; // PortPlace P3 06 Chinese


addEventHandlerEx("onServerStarted", function() {
    log("[jobs] loading cargo job...");
    cargocars[createVehicle(38, 396.5, 101.977, -20.9432, -89.836, 0.40721, 0.0879066 )]  <- [ false ]; // SeagiftTruck0
    cargocars[createVehicle(38, 396.5, 98.0385, -20.9359, -88.4165, 0.479715, -0.0220962)]  <- [ false ];  //SeagiftTruck1
});

addEventHandler("onPlayerConnect", function(playerid, name, ip, serial) {
     job_cargo[playerid] <- {};
     job_cargo[playerid]["cargostatus"] <- false;
});


/**
 * Check is player is a cargo delivery driver
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isCargoDriver(playerid) {
    return (isPlayerHaveValidJob(playerid, "cargodriver"));
}

/**
 * Check is player's vehicle is a bus
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isPlayerVehicleCargo(playerid) {
    return (isPlayerInValidVehicle(playerid, 20));
}

/**
 * Check is BusReady
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isCargoReady(playerid) {
    return job_bus[playerid]["busready"];
}

function cargoJob( playerid ) {

}

// working good, check
addCommandHandler("job_cargo", function ( playerid ) {
    local myPos = getPlayerPosition( playerid );
        local check = isPointInCircle2D( myPos[0], myPos[1], -348.071, -731.48, RADIUS_CARGO );
        if(check) {
            if(players[playerid]["job"] == "cargodriver") {
                sendPlayerMessage( playerid, "You're cargo delivery driver already.");
                return;
            }
            if(players[playerid]["job"] == null) {
                sendPlayerMessage( playerid, "You're a cargo delivery driver now. Welcome! Ha-ha..." );
                sendPlayerMessage( playerid, "Go to Seagift Co. at Chinatown, get behind wheel of truck of fish and get your ass to warehouse P3 06 at Port." );
                setPlayerModel( playerid, 130 );
                players[playerid]["job"] = "cargodriver";

            } else {
                sendPlayerMessage( playerid, "You already have a job: " + players[playerid]["job"]);
            }
        } else {
            sendPlayerMessage( playerid, "Let's go to Derek office at City Port." );
        }
});


// working good, check
addCommandHandler("job_cargo_leave", function ( playerid ) {
    local myPos = getPlayerPosition( playerid );
        local check = isPointInCircle2D( myPos[0], myPos[1], -348.071, -731.48, RADIUS_CARGO );
        if(check) {
            if(players[playerid]["job"] == "cargodriver")    {
                sendPlayerMessage( playerid, "You leave this job." );
                setPlayerModel( playerid, 10 );
                players[playerid]["job"] = null;
                job_cargo[playerid]["cargostatus"] = false;
            } else { sendPlayerMessage( playerid, "You're not a cargo delivery driver."); }
        } else { sendPlayerMessage( playerid, "Let's go to Derek office at City Port." ); }
});

// working good, check
addCommandHandler("loadcargo", function ( playerid ) {
    if(players[playerid]["job"] == "cargodriver")    {
        if( isPlayerInVehicle( playerid ) ) {
            local vehicleid = getPlayerVehicle( playerid );
            local vehicleModel = getVehicleModel( vehicleid );
            if(vehicleModel == 38) {
                    local vehPos = getVehiclePosition( vehicleid );
                    local check = isPointInCircle2D( vehPos[0], vehPos[1], cargocoords["PortChinese"][0], cargocoords["PortChinese"][1], 4.0 );
                    if (check) {
                        local velocity = getVehicleSpeed( vehicleid );
                        if(fabs(velocity[0]) <= 0.5 && fabs(velocity[1]) <= 0.5) {
                            if(cargocars[vehicleid][0] == false) {
                                cargocars[vehicleid][0] = true;
                                sendPlayerMessage( playerid, "The truck loaded. Go back to Seagift to unload.")
                            } else { sendPlayerMessage( playerid, "Truck already loaded." ); }
                        } else { sendPlayerMessage( playerid, "You're driving. Please stop the truck.");    }
                    } else { sendPlayerMessage( playerid, "Go to warehouse P3 06 at Port to load fish truck." );   }
            } else { sendPlayerMessage( playerid, "This car isn't a fish truck." ); }
        } else { sendPlayerMessage( playerid, "You need a fish truck." ); }
    } else { sendPlayerMessage( playerid, "You're not a cargo delivery driver."); }

});

// working good, check
addCommandHandler("unloadcargo", function ( playerid ) {
    if(players[playerid]["job"] == "cargodriver")    {
        if( isPlayerInVehicle( playerid ) ) {
            local vehicleid = getPlayerVehicle( playerid );
            local vehicleModel = getVehicleModel( vehicleid );
            if(vehicleModel == 38) {
                    if(cargocars[vehicleid][0] == true) {
                        local vehPos = getVehiclePosition( vehicleid );
                        local check = isPointInCircle2D( vehPos[0], vehPos[1], 396.5, 98.0385, 4.0 );
                        if (check) {
                            local velocity = getVehicleSpeed( vehicleid );
                            if(fabs(velocity[0]) <= 0.5 && fabs(velocity[1]) <= 0.5) {
                                    job_cargo[playerid]["cargostatus"] = true;
                                    cargocars[vehicleid][0] = false;
                                    sendPlayerMessage( playerid, "Go to Derek office at City Port and take your money." );
                                    removePlayerFromVehicle( playerid );
                            } else { sendPlayerMessage( playerid, "You're driving. Please stop the truck.");    }
                        } else { sendPlayerMessage( playerid, "Go to Seagift to unload." );    }
                    } else { sendPlayerMessage( playerid, "Truck is empty. Go to Port to load." ); }
            } else { sendPlayerMessage( playerid, "This car isn't a fish truck." ); }
        } else { sendPlayerMessage( playerid, "You need a fish truck." ); }
    } else { sendPlayerMessage( playerid, "You're not a cargo delivery driver."); }
});


// working good, check
addCommandHandler("cargofinish", function ( playerid ) {
    if(players[playerid]["job"] == "cargodriver")    {
        if(job_cargo[playerid]["cargostatus"]) {
            local myPos = getPlayerPosition( playerid );
            local check = isPointInCircle2D( myPos[0], myPos[1], -348.071, -731.48, RADIUS_CARGO );  //cabinetDerek
            if (check) {
                    job_cargo[playerid]["cargostatus"] = false;
                    sendPlayerMessage( playerid, "Nice job, " + getPlayerName( playerid ) + "! Keep your $30." );
                    addMoneyToPlayer(playerid, 30);
            } else { sendPlayerMessage( playerid, "Go to Derek office at City Port." );    }
        } else { sendPlayerMessage( playerid, "Complete delivery." );   }
    } else { sendPlayerMessage( playerid, "You're not a cargo delivery driver."); }
});
