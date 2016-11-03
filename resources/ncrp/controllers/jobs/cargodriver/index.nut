local job_cargo = {};
local cargocars = {};


local cargocoords = {};
cargocoords["PortChinese"] <- [-217.298, -724.771, -21.423]; // PortPlace P3 06 Chinese

local cargotext = {
    "job" : "cargodriver",
    "already" : "You're cargo delivery driver already." 
};



addEventHandlerEx("onServerStarted", function() {
    log("[jobs] loading cargo job...");
    // cargocars[i][0] - Truck ready: true/false
    // cargocars[i][1] - Fuel load: integer
    cargocars[createVehicle(38, 396.551, 101.977, -20.9432, -89.836, 0.40721, 0.0879066 )]  <- [false, false ]; // SeagiftTruck0
    cargocars[createVehicle(38, 396.315, 98.0385, -20.9359, -88.4165, 0.479715, -0.0220962)]  <- [false, false ];  //SeagiftTruck1
});

addEventHandler("onPlayerConnect", function(playerid, name, ip, serial) {
     job_cargo[playerid] <- {};
     //job_cargo[playerid]["fuelstatus"] <- [false, false, false, false, false, false, false, false]; // see sequence of gas stations in variable fuelname
     //job_cargo[playerid]["fuelcomplete"] <- 0;  // number of completed fuel stations. Default is 0
});


// working good, check
addCommandHandler("job_cargo", function ( playerid ) {
    local myPos = getPlayerPosition( playerid );
        local check = isPointInCircle2D( myPos[0], myPos[1], -350.47, -726.722, -15.4205 );  //cabinetDerek
        if(check) {
            if(players[playerid]["job"] == "cargodriver") {
                sendPlayerMessage( playerid, cargotext["already"]);
                return;
            }
            if(players[playerid]["job"] == null) {
                sendPlayerMessage( playerid, "You're a cargo driver now! Congratulations!" );
                sendPlayerMessage( playerid, "Sit into fuel truck." );
                setPlayerModel( playerid, 144 );
                players[playerid]["job"] = "fueldriver";

            } else {
                sendPlayerMessage( playerid, "You already have a job: " + players[playerid]["job"]);
            }
        } else {
            sendPlayerMessage( playerid, "Let's go to Trago Oil headquartered in Oyster Bay (right door at corner of the building) to become fuel truck driver." );
        }
});

/*
// working good, check
addCommandHandler("job_cargo_leave", function ( playerid ) {
    local myPos = getPlayerPosition( playerid );
        local check = isPointInCircle2D( myPos[0], myPos[1], 551.762, -266.866, 2.0 );
        if(check) {
            if(players[playerid]["job"] == "fueldriver")    {
                sendPlayerMessage( playerid, "You leave this job." );
                setPlayerModel( playerid, 10 );
                players[playerid]["job"] = null;
            } else { sendPlayerMessage( playerid, "You're not a fuel truck driver"); }
        } else { sendPlayerMessage( playerid, "Let's go to Trago Oil headquartered in Oyster Bay (right door at corner of the building)." ); }
});


// working good, check
addCommandHandler("cargoready", function ( playerid ) {
    if(players[playerid]["job"] == "fueldriver")    {
        if( isPlayerInVehicle( playerid ) ) {
            local vehicleid    = getPlayerVehicle( playerid  );
            local vehicleModel = getVehicleModel ( vehicleid );
            if(vehicleModel == 5) {
                if (fuelcars[vehicleid][0] == false) {
                    fuelcars[vehicleid][0] = true;
                    if(fuelcars[vehicleid][1] >= 4000) {
                        sendPlayerMessage( playerid, "The truck is ready. Truck is loaded to " + fuelcars[vehicleid][1] + " / 16000");
                    } else { sendPlayerMessage( playerid, "The truck is ready. Go to the warehouse of fuel in South Millville to load fuel truck." ); }
                } else { sendPlayerMessage( playerid, "The truck is ready already." ); }
            } else { sendPlayerMessage( playerid, "This car isn't a truck." ); }
        } else { sendPlayerMessage( playerid, "You need a fuel truck." ); }
    } else { sendPlayerMessage( playerid, "You're not a fuel truck driver"); }
});

// working good, check
addCommandHandler("loadcargo", function ( playerid ) {
    if(players[playerid]["job"] == "fueldriver")    {
        if( isPlayerInVehicle( playerid ) ) {
            local vehicleid = getPlayerVehicle( playerid );
            local vehicleModel = getVehicleModel( vehicleid );
            if(vehicleModel == 5) {
                if (fuelcars[vehicleid][0] == true) {
                    local vehPos = getVehiclePosition( vehicleid );
                    local check = isPointInCircle2D( vehPos[0], vehPos[1], 788.288, -78.0801, 5.0 );
                    if (check) {
                        local velocity = getVehicleSpeed( vehicleid );
                        if(fabs(velocity[0]) <= 0.5 && fabs(velocity[1]) <= 0.5) {
                            if(fuelcars[vehicleid][1] < 16000) {
                                fuelcars[vehicleid][1] = 16000;
                                sendPlayerMessage( playerid, "Fuel truck is loaded to 16000 / 16000. Deliver fuel to gas stations." );
                            } else { sendPlayerMessage( playerid, "Fuel truck already loaded." ); }
                        } else { sendPlayerMessage( playerid, "You're driving. Please stop the truck.");    }
                    } else { sendPlayerMessage( playerid, "Go to the warehouse of fuel in South Millville to load fuel truck." );   }
                } else { sendPlayerMessage( playerid, "The truck isn't ready." ); }
            } else { sendPlayerMessage( playerid, "This car isn't a truck." ); }
        } else { sendPlayerMessage( playerid, "You need a fuel truck." ); }
    } else { sendPlayerMessage( playerid, "You're not a fuel truck driver"); }
});

// working good, check
addCommandHandler("unloadcargo", function ( playerid ) {
    if(players[playerid]["job"] == "fueldriver")    {
        if( isPlayerInVehicle( playerid ) ) {
            local vehicleid = getPlayerVehicle( playerid );
            local vehicleModel = getVehicleModel( vehicleid );
            if(vehicleModel == 5) {
                if (fuelcars[vehicleid][0] == true) {
                    if(fuelcars[vehicleid][1] >= 4000) {
                        local vehPos = getVehiclePosition( vehicleid );
                        local check = false;
                        local i = -1;
                        foreach (key, value in fuelcoords) {
                            if (isPointInCircle2D( vehPos[0], vehPos[1], value[0], value[1], 5.0 )) {
                            check = true;
                            i = key;
                            break;
                            }
                        }
                        if (check) {
                            local velocity = getVehicleSpeed( vehicleid );
                            if(fabs(velocity[0]) <= 0.5 && fabs(velocity[1]) <= 0.5) {
                                if(job_fuel[playerid]["fuelstatus"][i] == false) {
                                    fuelcars[vehicleid][1] -= 4000;
                                    job_fuel[playerid]["fuelstatus"][i] = true;
                                    job_fuel[playerid]["fuelcomplete"] += 1;
                                    if (job_fuel[playerid]["fuelcomplete"] == 8) {
                                        sendPlayerMessage( playerid, "Nice job! Return the fuel truck to Trago Oil headquartered in Oyster Bay and take your money." );
                                    } else { 
                                        if (fuelcars[vehicleid][1] >= 4000) { sendPlayerMessage( playerid, "Unloading completed. Fuel truck is loaded to " + fuelcars[vehicleid][1] + " / 16000. Go to next gas station." ); 
                                        } else { sendPlayerMessage( playerid, "Unloading completed. Fuel is not enough. Go to the warehouse to load fuel truck." ); }
                                    }
                                } else { sendPlayerMessage( playerid, "You've already been here. Go to other gas station." ); }
                            } else { sendPlayerMessage( playerid, "You're driving. Please stop the truck.");    }
                        } else { sendPlayerMessage( playerid, "Go to gas station to unload fuel." );    }
                    } else { sendPlayerMessage( playerid, "Fuel is not enough. Go to the warehouse to load fuel truck." ); }
                } else { sendPlayerMessage( playerid, "The truck isn't ready." ); }
            } else { sendPlayerMessage( playerid, "This car isn't a truck." ); }
        } else { sendPlayerMessage( playerid, "You need a fuel truck." ); }
    } else { sendPlayerMessage( playerid, "You're not a fuel truck driver"); }
});


// working good, check
addCommandHandler("cargopark", function ( playerid ) {
    if(players[playerid]["job"] == "fueldriver")    {
        if( isPlayerInVehicle( playerid ) ) {
            local vehicleid = getPlayerVehicle( playerid );
            local vehicleModel = getVehicleModel( vehicleid );
            if(vehicleModel == 5) {
                if (fuelcars[vehicleid][0] == true) {
                        local vehPos = getVehiclePosition( vehicleid );
                        local check = isPointInCircle2D( vehPos[0], vehPos[1], 517.782, -277.5, 10.0 );
                        if (check) {
                            local velocity = getVehicleSpeed( vehicleid );
                            if(fabs(velocity[0]) <= 0.5 && fabs(velocity[1]) <= 0.5) {
                                    if (job_fuel[playerid]["fuelcomplete"] == 8) {
                                        job_fuel[playerid]["fuelcomplete"] = 0;
                                        fuelcars[vehicleid][0] = false;
                                        sendPlayerMessage( playerid, "Nice job! You earned $40." );
                                        addMoneyToPlayer(playerid, 40);
                                    } else {
                                        sendPlayerMessage( playerid, "Complete fuel delivery to all gas stations." );
                                    }
                            } else { sendPlayerMessage( playerid, "You're driving. Please stop the truck.");    }
                        } else { sendPlayerMessage( playerid, "Go to Trago Oil headquartered to park the fuel truck." );    }
                } else { sendPlayerMessage( playerid, "The truck isn't ready." ); }
            } else { sendPlayerMessage( playerid, "This car isn't a truck." ); }
        } else { sendPlayerMessage( playerid, "You need a fuel truck." ); }
    } else { sendPlayerMessage( playerid, "You're not a fuel truck driver"); }
});



// working good, check
addCommandHandler("checkcargo", function ( playerid ) {
    if(players[playerid]["job"] == "fueldriver")    {
        if( isPlayerInVehicle( playerid ) ) {
            local vehicleid = getPlayerVehicle( playerid );
            local vehicleModel = getVehicleModel( vehicleid );
            if(vehicleModel == 5) {
                if (fuelcars[vehicleid][0] == true) {
                    sendPlayerMessage( playerid, "Fuel truck is loaded to " + fuelcars[vehicleid][1] + " / 16000" );
                } else { sendPlayerMessage( playerid, "The truck isn't ready." ); }
            } else { sendPlayerMessage( playerid, "This car isn't a fuel truck." ); }
        } else { sendPlayerMessage( playerid, "You need a fuel truck." ); }
    } else { sendPlayerMessage( playerid, "You're not a fuel truck driver"); }
});

*/
