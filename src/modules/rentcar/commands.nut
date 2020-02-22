/*cmd("rent", function(playerid) {
    RentCar(playerid);
});
*/
cmd("rent", "refuse", function(playerid) {
    msg(playerid, "Use: /unrent", CL_RED);
});

cmd("unrent", function(playerid) {
    RentCarRefuse(playerid);
});


function rentcarHelp ( playerid ) {
    local title = "rentcar.help.title";
    local commands = [
        { name = "GUI",        desc = "rentcar.help.rent" },
        { name = "/unrent",    desc = "rentcar.help.refuse" }
    ];
    msg_help(playerid, title, commands);
}

cmd("help", "rent", rentcarHelp );




cmd("pped", function(playerid) {

    trigger(playerid, "createPedTaxiPassenger", getPlayerName(playerid), 145, -68.187, 370.748, -13.956, 0.0, 0.0, 0.0);
    trigger(playerid, "createPedTaxiPassenger", getPlayerName(playerid), 145, -66.187, 370.748, -13.956, 45.0, 0.0, 0.0);
    trigger(playerid, "createPedTaxiPassenger", getPlayerName(playerid), 145, -64.187, 370.748, -13.956, 90.0, 0.0, 0.0);
    trigger(playerid, "createPedTaxiPassenger", getPlayerName(playerid), 145, -62.187, 370.748, -13.956, 135.0, 0.0, 0.0);
    trigger(playerid, "createPedTaxiPassenger", getPlayerName(playerid), 145, -60.187, 370.748, -13.956, 180.0, 0.0, 0.0);

    trigger(playerid, "createPedTaxiPassenger", getPlayerName(playerid), 145, -68.187, 364.748, -13.956, 0.0, 0.0, 0.0);
    trigger(playerid, "createPedTaxiPassenger", getPlayerName(playerid), 145, -66.187, 364.748, -13.956, -45.0, 0.0, 0.0);
    trigger(playerid, "createPedTaxiPassenger", getPlayerName(playerid), 145, -64.187, 364.748, -13.956, -90.0, 0.0, 0.0);
    trigger(playerid, "createPedTaxiPassenger", getPlayerName(playerid), 145, -62.187, 364.748, -13.956, -135.0, 0.0, 0.0);
    trigger(playerid, "createPedTaxiPassenger", getPlayerName(playerid), 145, -60.187, 364.748, -13.956, -180.0, 0.0, 0.0);

});

cmd("unped", function(playerid) {
    trigger(playerid, "destroyPedTaxiPassenger", getPlayerName(playerid));
});
