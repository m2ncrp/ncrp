key("e", function(playerid) {
    washStationsWashCar (playerid);
});

cmd( "help" "wash", function( playerid ) {
    washStationsHelp (playerid);
});

function washStationsHelp ( playerid ) {
    local title = "shops.washstations.help.title";
    local commands = [
        { name = "/wash",    desc = "shops.washstations.help.repair" }
    ];
    msg_help(playerid, title, commands);
}
