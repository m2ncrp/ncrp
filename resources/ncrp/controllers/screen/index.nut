include("controllers/screen/commands.nut");

/**
 * Send message to player, to fade in his screen
 * transparent -> black
 *
 * @param {int} playerid
 * @param {int} time in ms
 * @param {Function} callback (optional)
 */
function screenFadein(playerid, time, callback = null) {
    triggerClientEvent(playerid, "onServerFadeScreen", time.tostring(), false);
    return callback ? delayedFunction(time + 500, callback) : null;
}

/**
 * Send message to player, to fade out his screen
 * black -> transparent
 *
 * @param {int} playerid
 * @param {int} time in ms
 * @param {Function} callback (optional)
 */
function screenFadeout(playerid, time, callback = null) {
    triggerClientEvent(playerid, "onServerFadeScreen", time.tostring(), true);
    return callback ? delayedFunction(time + 500, callback) : null;
}

/**
 * Send message to player, to fade in and then fade out his screen
 * using half of time for each
 * transparent -> black -> wait 1000ms -> transparent
 *
 * @param {int} playerid
 * @param {int} time in ms
 * @param {Function} callback1 (optional) will be called at "black"
 * @param {Function} callback2 (optional) will be called at finish
 */
function screenFadeinFadeout(playerid, time, callback1 = null, callback2 = null) {
    screenFadein(playerid, time, function() {
        // run first callback
        if (callback1) callback1();

        // start fadeout
        delayedFunction(1000, function(){
            screenFadeout(playerid, time, function() {
                return callback2 ? callback2() : null;
            });
        })
    });
}
