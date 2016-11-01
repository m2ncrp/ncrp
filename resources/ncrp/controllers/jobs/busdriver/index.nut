createVehicle(20, -436.205, 417.33, 0.908799, 45.8896, -0.100647, 0.237746);
createVehicle(20, -436.652, 427.656, 0.907598, 44.6088, -0.0841779, 0.205202);
createVehicle(20, -437.04, 438.027, 0.907163, 45.1754, -0.100916, 0.242581);
createVehicle(20, -410.198, 493.193, -0.21792, -179.657, -3.80509, -0.228946);  

local job_bus = {};

addEventHandler("onPlayerConnect", function(playerid, name, ip, serial ){
     job_bus[playerid] <- {};
     job_bus[playerid]["nextbusstop"] <- null;
     job_bus[playerid]["busready"] <- false;
});

local busstops = [
    ["Go to first bus station in Uptown near platform #3", -423.116, 440.924],
    ["Go to bus stop in West Side", -471.471, 10.2396],
    ["Go to bus stop in Midtown", -431.421, -299.824],
    ["Go to bus stop in SouthPort", -140.946, -472.49],
    ["Go to bus stop in Oyster Bay", 296.348, -315.252],
    ["Go to bus stop in Chinatown", 274.361, 355.601],
    ["Go to bus stop in East Little Italy", 475.215, 736.735],
    ["Go to bus station in Millville North (west platform)", 688.59, 873.993],
    ["Go to bus stop in Central Little Italy", 164.963, 832.472],
    ["Go to bus stop in Little Italy (Diamond Motors)", -170.596, 727.372],
    ["Go to bus stop in East Side", -101.08, 374.001],
    ["Go to bus station in Uptown near platform #3", -423.116, 440.924]
];


// working good, check
addCommandHandler("job_bus", function ( playerid ) {
    local myPos = getPlayerPosition( playerid );
        local check = isPointInCircle2D( myPos[0], myPos[1], -422.731, 479.462, 1.0 );
        if(check) {
            if(players[playerid]["job"] == "busdriver") {
                sendPlayerMessage( playerid, "You're busdriver already.");
                return;
            }   
            if(players[playerid]["job"] == null) {
                sendPlayerMessage( playerid, "You're a bus driver now! Congratulations!" );
                sendPlayerMessage( playerid, "Sit into bus." );
                setPlayerModel( playerid, 171 );
                players[playerid]["job"] = "busdriver";
            } else {
                sendPlayerMessage( playerid, "You already have a job: " + players[playerid]["job"]);
            }
        } else {
            sendPlayerMessage( playerid, "Let's go to bus station in Uptown (central door of the building)." );
        }
});


// working good, check
addCommandHandler("job_bus_leave", function ( playerid ) {
    local myPos = getPlayerPosition( playerid );
        local check = isPointInCircle2D( myPos[0], myPos[1], -422.731, 479.462, 1.0 );
        if(check) {
            if(players[playerid]["job"] == "busdriver") {
                sendPlayerMessage( playerid, "You leave this job." );
                setPlayerModel( playerid, 10 );
                players[playerid]["job"] = null;
            } else { sendPlayerMessage( playerid, "You're not a bus driver"); }
        } else { sendPlayerMessage( playerid, "Let's go to bus station in Uptown (central door of the building)." ); }
});


// working good, check
addCommandHandler("busready", function ( playerid ) {
    if(players[playerid]["job"] == "busdriver") {
        if( isPlayerInVehicle( playerid ) ) {
            local vehicleid    = getPlayerVehicle( playerid  );
            local vehicleModel = getVehicleModel ( vehicleid );
            if(vehicleModel == 20) {        
                if (job_bus[playerid]["busready"] == false) {
                    job_bus[playerid]["busready"] = true;
                    sendPlayerMessage( playerid, busstops[0][0] );
                    job_bus[playerid]["nextbusstop"] = 0;
                    return;
                } else { sendPlayerMessage( playerid, "You're ready already." ); }
            } else { sendPlayerMessage( playerid, "This car isn't a bus." ); }
        } else { sendPlayerMessage( playerid, "You need a bus." ); }
    } else { sendPlayerMessage( playerid, "You're not a bus driver"); } 
});

// working good, check
addCommandHandler("busstop", function ( playerid ) {
    if(players[playerid]["job"] == "busdriver") {
        if( isPlayerInVehicle( playerid ) ) {
            local vehicleid = getPlayerVehicle( playerid );
            local vehicleModel = getVehicleModel( vehicleid );
            if(vehicleModel == 20) {
                if (job_bus[playerid]["busready"] == true) {
                    local vehPos = getVehiclePosition( vehicleid );
                    local i = job_bus[playerid]["nextbusstop"];
                    local check = isPointInCircle2D( vehPos[0], vehPos[1], busstops[i][1], busstops[i][2], 5.0 );
                    // coords bus at bus station in Sand Island    -1597.05, -193.64, -19.9622,-89.79, 0.235025, 3.47667
                    // coords bus at bus station in Hunters Point    -1562.5, 105.709, -13.0123, 0.966663, -0.00153991, 0.182542
                    log(busstops[i][1] + ", " + busstops[i][2]);
                    if (check) {
                        local velocity = getVehicleSpeed( vehicleid );
                        if(fabs(velocity[0]) <= 0.5 && fabs(velocity[1]) <= 0.5) {
                            job_bus[playerid]["nextbusstop"] += 1;
                            if (busstops.len() == job_bus[playerid]["nextbusstop"]) {
                                sendPlayerMessage( playerid, "Nice job! You earned $10." );
                                job_bus[playerid]["busready"] = false;
                                addMoneyToPlayer(playerid, 10);
                                return;
                            }
                            sendPlayerMessage( playerid, "Good! " + busstops[i+1][0] );
                        } else { sendPlayerMessage( playerid, "You're driving. Please stop the bus.");  }
                    } else { sendPlayerMessage( playerid, busstops[i][0] ); }   
                } else { sendPlayerMessage( playerid, "You aren't ready." ); }
            } else { sendPlayerMessage( playerid, "This car isn't a bus." ); }
        } else { sendPlayerMessage( playerid, "You need a bus." ); }
    } else { sendPlayerMessage( playerid, "You're not a bus driver"); }     
});
