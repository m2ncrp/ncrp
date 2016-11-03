addCommandHandler("help_job", function(playerid) {
    local commands = [
        { name = "/job_bus",        desc = "Get busdriver job" },
        { name = "/job_bus_leave",  desc = "Leave busdriver job" },
        { name = "/busready",       desc = "Go to the route (make the bus ready)"},
        { name = "/busstop",        desc = "Check in bus stop" },
        { name = "/job_fuel",       desc = "Get fueldriver job" },
        { name = "/job_fuel_leave", desc = "Leave fueldriver job" },
        { name = "/truckready",     desc = "Start delivery (make the truck ready)" },
        { name = "/loadfuel",       desc = "Load fuel into truck" },
        { name = "/unloadfuel",     desc = "Unload fuel to fuel station" },
        { name = "/truckpark",      desc = "Park the truck to Trago Oil parking" },
        { name = "/checkfuel",      desc = "Checking loading truck" },
        { name = "/routelist",      desc = "See list of route" }
    ];

    sendPlayerMessage(playerid, "");
    sendPlayerMessage(playerid, "==================================", 200, 100, 100);
    sendPlayerMessage(playerid, "Here is list of available job commands:", 200, 200, 0);

    foreach (idx, cmd in commands) {
        local text = cmd.name + "   -   " + cmd.desc;
        if ((idx % 2) == 0) {
            sendPlayerMessage(playerid, text, 200, 230, 255);
        } else {
            sendPlayerMessage(playerid, text);
        }
    }
});

addCommandHandler("help_cargo", function(playerid) {
    local commands = [
        { name = "/job_cargo",        desc = "Get cargo delivery driver job" },
        { name = "/job_cargo_leave",  desc = "Leave cargo delivery driver job" },
        { name = "/loadcargo",       desc = "Load cargo into truck" },
        { name = "/unloadcargo",     desc = "Unload cargo" },
        { name = "/cargofinish",      desc = "Report to Derek and get money" }
    ];

    sendPlayerMessage(playerid, "");
    sendPlayerMessage(playerid, "==================================", 200, 100, 100);
    sendPlayerMessage(playerid, "Here is list of available job_cargo commands:", 200, 200, 0);

    foreach (idx, cmd in commands) {
        local text = cmd.name + "   -   " + cmd.desc;
        if ((idx % 2) == 0) {
            sendPlayerMessage(playerid, text, 200, 230, 255);
        } else {
            sendPlayerMessage(playerid, text);
        }
    }
});
