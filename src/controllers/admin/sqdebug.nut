/**
 * Squirrel in-game debugger
 * @author Inlife
 */

/**
 * Run string of code and return result
 * @param  {string} code
 * @return {mixed}
 */
function squirrelRun(code) {
    dbg("squirrelRun: " + code);
    return compilestring(format("return %s;", code))();
}

/**
 * Run code provided in args parameter (can be array)
 * on Server side
 * and print result to player console (by playerid)
 * and to server log
 *
 * @param  {int} playerid
 * @param  {array} args
 */
function squirrelDebugOnServer(playerid, args) {
    local result = JSONEncoder.encode(squirrelRun(concat(args)));
    if (isPlayerConnected(playerid)) msg(playerid, result, CL_CARIBBEANGREEN);
    dbg(result);
}

/**
 * Run code provided in args parameter (can be array)
 * on Client side
 * and print result to player console (by playerid)
 * and to server log
 *
 * @param  {int} playerid
 * @param  {array} args
 */
function squirrelDebugOnClient(playerid, args) {
    triggerClientEvent(playerid, "onServerScriptEvaluate", concat(args));
}


// add error handler
event("onClientScriptError", function(playerid, code) {
    msg(playerid, JSONEncoder.encode(code), CL_CHESTNUT);
    dbg(code);
});

event("native:onConsoleInput", function(name, ...) {
    if (name == "sq") {
        squirrelDebugOnServer(-1, vargv);
    }
});


/**
 * Squirrel inline debug commands
 */
acmd("sq", function(playerid, ...) {
    squirrelDebugOnServer(playerid, vargv);
});

acmd("sq", ["s"], function(playerid, ...) {
    squirrelDebugOnServer(playerid, vargv);
});

acmd("sq", ["c"], function(playerid, ...) {
    squirrelDebugOnClient(playerid, vargv);
});

acmd("sq", ["b"], function(playerid, ...) {
    squirrelDebugOnServer(playerid, vargv);
    squirrelDebugOnClient(playerid, vargv);
});

