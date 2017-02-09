cmd("taxi", function(playerid) {
    __commands["call"][COMMANDS_DEFAULT](playerid, "taxi");
});

// usage: /taxi job
cmd("taxi", "job", function(playerid) {
    taxiJob(playerid);
});

// usage: /taxi job leave
cmd("taxi", ["job", "leave"], function(playerid) {
    taxiJobLeave(playerid);
});

// usage: /taxi take 5
cmd("taxi", "take", function(playerid, call_id) {
    taxiCallTake(playerid, call_id.tointeger());
});

// usage: /taxi ready
cmd("taxi", "ready", function(playerid) {
    taxiCallReady(playerid);
});

//usage: /taxi refuse
cmd("taxi", "refuse", function(playerid) {
   taxiCallRefuse(playerid);
});

//usage: /taxi done 8.25
cmd("taxi", "done", function(playerid, amount = 3) {
    taxiCallDone(playerid, amount.tofloat());
});

//usage: /taxi end 8.25
cmd("taxi", "end", function(playerid, amount = 3) {
    taxiCallDone(playerid, amount.tofloat());
});

//usage: /taxi close
cmd("taxi", "close", function(playerid) {
    taxiCallClose(playerid);
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
    local title = "job.taxi.help.title";
    local commands = [
        { name = "/taxi job",              desc = "job.taxi.help.job" },
        { name = "/taxi job leave",        desc = "job.taxi.help.jobleave" },
        { name = "/taxi on",               desc = "job.taxi.help.onair" },
        { name = "/taxi off",              desc = "job.taxi.help.offair" },
        { name = "/taxi take ID",          desc = "job.taxi.help.take" },
        { name = "/taxi refuse",           desc = "job.taxi.help.refuse" },
        { name = "/taxi ready",            desc = "job.taxi.help.ready" },
        { name = "/taxi done AMOUNT",      desc = "job.taxi.help.done" },
        { name = "/taxi close",            desc = "job.taxi.help.close" }
    ];
    msg_help(playerid, title, commands);
}



/*

taxi  |   arg1   |  arg2   |
--------------------------------
taxi  |  'place' |         |       - called taxi to 'place'
taxi  |   take   |  'id'   |       - take a call with 'id'
taxi  |  ready   |         |       - Report that the taxicar has arrived to the address
taxi  |  refuse  |         |       - refuse the current call
taxi  |    end   |'amount' |       - end current call
      |          |         |
taxi  |   job    |         |       - get job taxi driver
taxi  |   job    |  leave  |       - leave job taxi driver
      |          |         |
taxi  |    on    |         |       - enter to the line   onair busy offair
taxi  |    off   |         |       - exit from the line

 * not ready function

*/


