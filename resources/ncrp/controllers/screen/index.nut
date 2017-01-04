include("controllers/screen/commands.nut");

local __fpsdata = {};

/**
 * Calcualte FPS delay
 *
 * @param  {Integer} playerid
 * @param  {Integer} Minumum delay
 * @return {Integer}
 */
function calculateFPSDelay(playerid, minimum = 150) {
    local fps = 30;

    if (playerid in __fpsdata) {
        fps = __fpsdata[playerid];
    }

    if (fps > 60) {
        fps = 60;
    }

    return  (-20 * fps) + 1200 + minimum;
}

addEventHandler("onClientSendFPSData", function(playerid, fps) {
    __fpsdata[playerid] <- fps.tointeger();
});

/**
 * Send message to player, to fade in his screen
 * transparent -> black
 *
 * @param {int} playerid
 * @param {int} time in ms
 * @param {Function} callback (optional)
 */
function screenFadein(playerid, time, callback = null) {
    return screenFadeinEx(playerid, time + 500, callback);
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
    return screenFadeoutEx(playerid, time + 500, callback);
}

/**
 * Send message to player, to fade in and then fade out his screen
 * using half of time for each
 * transparent -> black -> wait >1000ms -> transparent
 *
 * @param {int} playerid
 * @param {int} time in ms
 * @param {Function} callback1 (optional) will be called at "black"
 * @param {Function} callback2 (optional) will be called at finish
 */
function screenFadeinFadeout(playerid, time, callback1 = null, callback2 = null) {
    return screenFadeinFadeoutEx(playerid, time, 1000, callback1, callback2);
}


/**
 * Fadein Ex
 * transparent -> black
 *
 * @param {int} playerid
 * @param {int} fadetime in ms
 * @param {Function} callback (optional)
 */
function screenFadeinEx(playerid, fadetime, callback = null) {
    trigger(playerid, "onServerFadeScreen", fadetime, "in");
    return callback ? delayedFunction(fadetime, callback) : null;
}

/**
 * Fadeout Ex
 * black -> transparent
 *
 * @param {int} playerid
 * @param {int} fadetime in ms
 * @param {Function} callback (optional)
 */
function screenFadeoutEx(playerid, fadetime, callback = null) {
    trigger(playerid, "onServerFadeScreen", fadetime, "out");
    return callback ? delayedFunction(fadetime, callback) : null;
}

/**
 * For run code between fadein and fadeout
 * transparent -> black -> wait <pause> ms -> transparent
 *
 * @param {int} playerid
 * @param {int} fadetime in ms (for fadein and fadeout separately) (recommended value: 250, min: 100)
 * @param {int} pause in ms (need value min: 150)
 * @param {Function} callback1 (optional) will be called at "black"
 * @param {Function} callback2 (optional) will be called at finish
 */
function screenFadeinFadeoutEx(playerid, fadetime, pause, callback1 = null, callback2 = null) {
    screenFadeinEx(playerid, fadetime, function() {
        // run first callback
        if (callback1) callback1();

        // start fadeout
        delayedFunction(calculateFPSDelay(playerid, pause), function(){
            screenFadeoutEx(playerid, fadetime, function() {
                return callback2 ? callback2() : null;
            });
        })
    });
}

key("p", function(playerid) {
    trigger(playerid, "onServerToggleHudDrawing")
});

/**
 * Create GUI alertbox for player with
 * specified translated text
 * @param  {Integer} playerid
 * @param  {String}  message
 * @param  {Array}   params optional
 * @return {Boolean}
 */
function alert(playerid, message, params = []) {
    if (DEBUG) dbg("alert", getIdentity(playerid), plocalize(playerid, message, params));
    return trigger(playerid, "onAlert", plocalize(playerid, message, params))
}
