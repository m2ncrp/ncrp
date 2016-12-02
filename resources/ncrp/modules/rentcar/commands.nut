cmd("rent", function(playerid) {
    RentCar(playerid);
});

cmd("rent", "refuse", function(playerid) {
    RentCarRefuse(playerid);
});

function rentcarHelp ( playerid ) {
    local title = "List of available commands for Car Rental";
    local commands = [
        { name = "/rent",           desc = "Rent this car (need to be in a car)" },
        { name = "/rent refuse",    desc = "Refuse from all rented cars" },
    ];
    msg_help(playerid, title, commands);
}

cmd("help", "rent", rentcarHelp );
