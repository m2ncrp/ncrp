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

/*

NOT WORKING

// usage: /help taxi
cmd("help", "taxi", function(playerid) {
    msg(playerid, "============== Help Taxi ===============", CL_WHITE);
    msg(playerid, "/taxi <your location> - Call a taxi from location", CL_WHITE);
});

// usage: /help taxi job
cmd("help", ["taxi", "job"], function(playerid) {
    msg(playerid, "========= Help Taxi Job Commands =========", CL_WHITE);
    msg(playerid, "/taxi job - Get taxi driver job", CL_WHITE);
    msg(playerid, "/taxi job leave - Leave from taxi driver job", CL_WHITE);
    msg(playerid, "/taxi on - Set status as ON air", CL_WHITE);
    msg(playerid, "/taxi off - Set status as OFF air", CL_WHITE);
    msg(playerid, "/taxi take <id> - Take call with <id>", CL_WHITE);
    msg(playerid, "/taxi refuse - Refuse the current taken call", CL_WHITE);
    msg(playerid, "/taxi ready - Report that the taxicar has arrived to the address", CL_WHITE);
    msg(playerid, "/taxi end <amount> - End trip and send invoice to pay <amount> dollars", CL_WHITE);
});

*/


// usage: /taxi help
cmd("taxi", "help", function(playerid) {
    msg(playerid, "============== Help Taxi ===============", CL_WHITE);
    msg(playerid, "/taxi <your location> - Call a taxi from location", CL_WHITE);
});

// usage: /taxi job help
cmd("taxi", ["job", "help"], function(playerid) {
    msg(playerid, "========= Taxi Job HELP Commands =========", CL_WHITE);
    msg(playerid, "/taxi job - Get taxi driver job", CL_WHITE);
    msg(playerid, "/taxi job leave - Leave from taxi driver job", CL_WHITE);
    msg(playerid, "/taxi on - Set status as ON air", CL_WHITE);
    msg(playerid, "/taxi off - Set status as OFF air", CL_WHITE);
    msg(playerid, "/taxi take <id> - Take call with <id>", CL_WHITE);
    msg(playerid, "/taxi refuse - Refuse the current taken call", CL_WHITE);
    msg(playerid, "/taxi ready - Report that the taxicar has arrived to the address", CL_WHITE);
    msg(playerid, "/taxi end <amount> - End trip and send invoice to pay <amount> dollars", CL_WHITE);
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
