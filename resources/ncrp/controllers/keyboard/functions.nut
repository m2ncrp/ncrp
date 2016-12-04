local __keyboard = {};

/**
 * Add key bind handler for client
 * using key and key state [up/down]
 * If key is pressed on client, callback will be triggered
 *
 * @param {string}   key - ["a", "f1", "tab", ...]
 * @param {string}   state - ["up", "down"]
 * @param {Function} callback -  only one argument of callback will be playerid
 */
function addKeyboardHandler(key, state, callback) {
    local name = key + "_" + state;

    if (!(name in __keyboard)) {
        __keyboard[name] <- { key = key, state = state, callbacks = [callback] };

        // playerList.each(function(playerid) {
        //     triggerClientEvent("onServerKeyboardRegistration", key, state);
        // });
    } else {
        __keyboard[name].callbacks.push(callback);
        // return dbg("[keyboard] already registered", key, state);
    }
}

/**
 * Remove all key bind handlers for client
 * using key and key state [up/down]
 *
 * @param {string}   key - ["a", "f1", "tab", ...]
 * @param {string}   state - ["up", "down"]
 */
function removeKeyboardHandler(key, state) {
    local name = key + "_" + state;

    if (name in __keyboard) {
        // playerList.each(function(playerid) {
        //     triggerClientEvent("onServerKeyboardUnregistration", __keyboard[name].key, __keyboard[name].state);
        // });

        // delete local info
        delete __keyboard[name];
    } else {
        return dbg("[keyboard] deleting unknown keybind", key, state);
    }
}

/**
 * Send registered keyboard events to player by id
 * @param  {int} playerid
 */
function sendKeyboardRegistration(playerid) {
    foreach (idx, value in __keyboard) {
        triggerClientEvent(playerid, "onServerKeyboardRegistration", value.key, value.state);
    }
}

/**
 * Send unregistering keyboard events to player by id
 * @param  {int} playerid
 */
function sendKeyboardUnregistration(playerid) {
    foreach (idx, value in __keyboard) {
        triggerClientEvent(playerid, "onServerKeyboardUnregistration", value.key, value.state);
    }
}

/**
 * Triggers callback for playerid by key and state
 *
 * @param  {int} playerid
 * @param  {string} key
 * @param  {string} state
 * @return {bool}
 */
function triggerKeyboardPress(playerid, key, state) {
    local name = key + "_" + state;

    if (name in __keyboard) {
        foreach (idx, __callback in __keyboard[name].callbacks) {
            __callback(playerid);
        }
    } else {
        return dbg("[keyboard] unknown keybind", key, state);
    }

    return true;
}

/**
 * (Shortcut)
 * Register keyboard event on key press (down state)
 *
 * @param  {Array|String} names
 * @param  {Function} callback
 * @return {Boolean}
 */
function key(names, callback) {
    if (typeof names != "array") {
        names = [names];
    }

    foreach (idx, value in names) {
        addKeyboardHandler(value, "down", callback);
    }

    return true;
}
