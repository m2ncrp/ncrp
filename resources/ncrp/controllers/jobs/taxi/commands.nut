// usage: /taxi Train Station
cmd("taxi", function(playerid, ...) {
    local place = concat(vargv);
    taxiCall(playerid, place);
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

//usage: /taxi end 8.25
cmd("taxi", "end", function(playerid, amount = 3) {
    taxiCallEnd(playerid, amount.tofloat());
});

//usage: /taxi onair
cmd("taxi", "on", function(playerid) {
    taxiGoOnAir(playerid);
});

//usage: /taxi offair
cmd("taxi", "off", function(playerid) {
    taxiGoOffAir(playerid);
});

// usage: /help taxi
cmd("help", "taxi", function(playerid) {
    msg(playerid, "============== Help Taxi ===============", CL_WHITE);
    msg(playerid, "/taxi <your location> - Call a taxi from location", CL_WHITE);
});

// usage: /help job taxi
cmd("help", ["job", "taxi"], function(playerid) {
    local title = "List of available commands for TAXI JOB:";
    local commands = [
        { name = "/taxi job",              desc = "Get taxi driver job" },
        { name = "/taxi job leave",        desc = "Leave from taxi driver job" },
        { name = "/taxi on",               desc = "Set status as ON air"},
        { name = "/taxi off",              desc = "Set status as OFF air" },
        { name = "/taxi take <id>",        desc = "Take call with <id>. Example: /taxi take 5" },
        { name = "/taxi refuse",           desc = "Refuse the current taken call" },
        { name = "/taxi ready",            desc = "Report that the taxicar has arrived to the address" },
        { name = "/taxi end <amount>",     desc = "End trip and send invoice to pay <amount> dollars. Example: /taxi end 1.25" }
    ];
    msg_help(playerid, title, commands);
});



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
