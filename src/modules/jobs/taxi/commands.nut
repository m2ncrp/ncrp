cmd("taxi", function(playerid) {
    __commands["call"][COMMANDS_DEFAULT](playerid, "taxi");
});


// usage: /help taxi
cmd("help", "taxi", function(playerid) {
    msg(playerid, "==================================", CL_HELP_LINE);
    msg(playerid, "taxi.help.title", CL_HELP_TITLE);
    msg(playerid, "taxi.help.taxi", CL_WHITE);
});

// usage: /help job taxi
cmd("help", ["job", "taxi"], function(playerid) {
    taxiJobHelp ( playerid );
});

// usage: /help taxi job
cmd("help", ["taxi", "job"], function(playerid) {
    taxiJobHelp ( playerid );
});

function taxiJobHelp ( playerid ) {
    local title = "taxi.help.title";
    local commands = [
        { name = "job.taxi.help.job",          desc = "job.taxi.help.jobtext" },
        { name = "job.taxi.help.jobleave",     desc = "job.taxi.help.jobleavetext" },
        { name = "job.taxi.help.button1",      desc = "job.taxi.help.button1text" },
        { name = "job.taxi.help.button2",      desc = "job.taxi.help.button2text" }
    ];
    msg_help(playerid, title, commands);
}



/* KEY BUTTONS ***************************************************************************************************************************************************** */

key("e", function(playerid) {
    taxiJobGet ( playerid );
}, KEY_UP);

key("q", function(playerid) {
    taxiJobRefuseLeave( playerid );
}, KEY_UP);

key("1", function(playerid) {
    taxiSwitchAir(playerid);
}, KEY_UP);

key("2", function(playerid) {
    taxiCallStartNew( playerid );
}, KEY_UP);

key("3", function(playerid) {
    taxiCallFinishForPlayer( playerid );
}, KEY_UP);
