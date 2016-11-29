cmd( "repair", function( playerid ) {
    repairShopRepairCar (playerid);
});

cmd( "help" "repair", function( playerid ) {
    repairShopHelp (playerid);
});

function repairShopHelp ( playerid ) {
    local title = "shops.repairshop.help.title";
    local commands = [
        { name = "/repair",    desc = "shops.repairshop.help.repair" }
    ];
    msg_help(playerid, title, commands);
}
