include("controllers/jobs/fuel/commands.nut");

local job_fuel = {};
local fuelcars = {};

local fuelname = [
    "Oyster Bay",                       // FuelStation Oyster Bay
    "West Side",                        // FuelStation
    "Little Italy (Diamond Motors)",    // FuelStation LittleItaly Diamond
    "Little Italy East",                // FuelStation LittleItaly East
    "East Side",                        // FuelStation EastSide
    "Sand Island",                      // FuelStation Sand Island
    "Greenfield",                       // FuelStation Greenfield
    "Dipton"                            // FuelStation Dipton
];

// for future consideration ^__^
local fuelVehModelID = 5;

// 788.288, -78.0801, -20.132   // coords of place to load fuel truck
// 551.762, -266.866, -20.1644  // coords of place to get job fueldriver

local fuelcoords = [
    [549.207, -0.0450191, -18.2822],    // FuelStation Oyster Bay
    [-632.54, -49.2751, 0.877252],      // FuelStation WestSide
    [-148.01, 610.752, -20.1982],       // FuelStation LittleItaly Diamond
    [336.611, 874.779, -21.3369],       // FuelStation LittleItaly East
    [112.749, 179.167, -20.0528],       // FuelStation EastSide
    [-1679.77, -234.395, -20.3644],     // FuelStation Sand Island
    [-1592.45, 944.839, -5.21593],      // FuelStation Greenfield
    [-708.044, 1762.78, -15.0323]       // FuelStation Dipton
];


addEventHandlerEx("onServerStarted", function() {
    log("[jobs] loading fuel job...");
    // fuelcars[i][0] - Truck ready: true/false
    // fuelcars[i][1] - Fuel load: integer
    fuelcars[createVehicle(5, 511.887, -277.5, -20.19, -179.464, -0.05, 0.1)]  <- [false, 0 ];
    fuelcars[createVehicle(5, 517.782, -277.5, -20.19, -177.742, -0.05, 0.1)]  <- [false, 0 ];
    fuelcars[createVehicle(5, 523.821, -277.5, -20.19, -176.393, -0.05, 0.1)]  <- [false, 0 ];
});

addEventHandler("onPlayerConnect", function(playerid, name, ip, serial) {
     job_fuel[playerid] <- {};
     job_fuel[playerid]["fuelstatus"] <- [false, false, false, false, false, false, false, false]; // see sequence of gas stations in variable fuelname
     job_fuel[playerid]["fuelcomplete"] <- 0;  // number of completed fuel stations. Default is 0
});


// working good, check
addCommandHandler("job_fuel", function ( playerid ) {
    local myPos = getPlayerPosition( playerid );
        local check = isPointInCircle2D( myPos[0], myPos[1], 551.762, -266.866, 2.0 );
        if(check) {
            if(players[playerid]["job"] == "fueldriver") {
                sendPlayerMessage( playerid, "You're fueldriver already.");
                return;
            }
            if(players[playerid]["job"] == null) {
                sendPlayerMessage( playerid, "You're a fuel truck driver now! Congratulations!" );
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


// working good, check
addCommandHandler("job_fuel_leave", function ( playerid ) {
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
addCommandHandler("truckready", function ( playerid ) {
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
addCommandHandler("loadfuel", function ( playerid ) {
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
addCommandHandler("unloadfuel", function ( playerid ) {
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
addCommandHandler("truckpark", function ( playerid ) {
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
addCommandHandler("routelist", function ( playerid ) {
    if(players[playerid]["job"] == "fueldriver")    {
        sendPlayerMessage( playerid, "========== List of route ==========", 247, 202, 24);
        foreach (key, value in job_fuel[playerid]["fuelstatus"]) {
            local i = key+1;
            if (value == true) {
                sendPlayerMessage( playerid, i + ". Gas station in " + fuelname[key] + " - completed", 38, 166, 91);
            } else {
                sendPlayerMessage( playerid, i + ". Gas station in " + fuelname[key] + " - waiting", 192, 57, 43);
            }
        }
    } else { sendPlayerMessage( playerid, "You're not a fuel truck driver"); }
});

// working good, check
addCommandHandler("checkfuel", function ( playerid ) {
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
