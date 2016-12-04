cmd("rent", function(playerid) {
    RentCar(playerid);
});

cmd("rent", "refuse", function(playerid) {
    RentCarRefuse(playerid);
});

function rentcarHelp ( playerid ) {
    local title = "rentcar.help.title";
    local commands = [
        { name = "/rent",           desc = "rentcar.help.rent" },
        { name = "/rent refuse",    desc = "rentcar.help.refuse" },
    ];
    msg_help(playerid, title, commands);
}

cmd("help", "rent", rentcarHelp );
