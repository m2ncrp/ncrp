// usage: /help job fuel
cmd("help", ["job", "fuel"], function(playerid) {
    local title = "List of available commands for FUELDRIVER JOB:";
    local commands = [
        { name = "/job_fuel",       desc = "Get fueldriver job" },
        { name = "/job_fuel_leave", desc = "Leave fueldriver job" },
        { name = "/truckready",     desc = "Start delivery (make the truck ready)" },
        { name = "/loadfuel",       desc = "Load fuel into truck" },
        { name = "/unloadfuel",     desc = "Unload fuel to fuel station" },
        { name = "/truckpark",      desc = "Park the truck to Trago Oil parking" },
        { name = "/checkfuel",      desc = "Checking loading truck" },
        { name = "/routelist",      desc = "See list of route" }
    ];
    msg_help(playerid, title, commands);
});
