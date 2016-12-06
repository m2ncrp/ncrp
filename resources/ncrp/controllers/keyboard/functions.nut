const KEY_UP    = "up";
const KEY_DOWN  = "down";
const KEY_BOTH  = "both";

local __keyboard = {};
local __layouts  = {};
local __playerLayouts = {};

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
    local name = key.tolower() + "_" + state.tolower();

    if (!(name in __keyboard)) {
        __keyboard[name] <- { key = key.tolower(), state = state.tolower(), callbacks = [callback] };

        // playerList.each(function(playerid) {
        //     triggerClientEvent("onServerKeyboardRegistration", key, state);
        // });
    } else {
        __keyboard[name].callbacks.push(callback);
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
    local name = key.tolower() + "_" + state.tolower();

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
        triggerClientEvent(playerid, "onServerKeyboardRegistration", getPKey(value.key, playerid), value.state);
    }
}

/**
 * @deprecated
 * Send unregistering keyboard events to player by id
 * @param  {int} playerid
 */
function sendKeyboardUnregistration(playerid) {
    foreach (idx, value in __keyboard) {
        triggerClientEvent(playerid, "onServerKeyboardUnregistration", getPKey(value.key, playerid), value.state);
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
    local name = getRKey(key, playerid) + "_" + state;

    if (name in __keyboard) {
        foreach (idx, __callback in __keyboard[name].callbacks) {
            __callback(playerid);
        }
    } else {
        // return dbg("[keyboard] unknown keybind", key, state);
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
function key(names, callback, state = KEY_DOWN) {
    if (typeof names != "array") {
        names = [names];
    }

    foreach (idx, value in names) {
        if (state == KEY_UP || state == KEY_DOWN) {
            addKeyboardHandler(value, state, callback);
        } else if (state == KEY_BOTH) {
            addKeyboardHandler(value, KEY_UP  , callback);
            addKeyboardHandler(value, KEY_DOWN, callback);
        }
    }

    return true;
}

/**
 * Register new layout mapping by given name
 * @param {String} name
 * @param {Table} mapping
 */
function addKeyboardLayout(name, mapping) {
    local reverse = {};

    foreach (idx, value in mapping) {
        reverse[value] <- idx;
    }

    return __layouts[name] <- {
        straight = mapping,
        reverse  = reverse
    };
}

/**
 * Get array with registered layout names
 * @return {Array}
 */
function getKeyboardLayouts() {
    local keys = [];

    foreach (idx, value in __layouts) {
        keys.push(idx);
    }

    return keys;
}

/**
 * Set player layout name to given one
 * @param {Integer} playerid
 * @param {String} name
 * @return {Boolean}
 */
function setPlayerLayout(playerid, name, resend = true) {
    if (!(name in __layouts)) {
        return false;
    }

    // if (resend) {
    //     sendKeyboardUnregistration(playerid);
    // }

    // just change
    __playerLayouts[playerid] <- name;

    Account.getSession(playerid, function(err, account) {
        if (err || !account) return;
        account.layout = name;
        account.save();
    });

    // should resend new mappings ?
    if (resend) {
        sendKeyboardRegistration(playerid);
    }

    return true;
}

/**
 * Get registered player layout name
 * @param  {Integer} playerid
 * @return {String}
 */
function getPlayerLayout(playerid) {
    if (!(playerid in __playerLayouts)) {
        return "qwerty";
    }

    return __playerLayouts[playerid];
}

/**
 * Apply mapping substitution for key
 * with give layout name
 *
 * @param  {String} key
 * @param  {String} name layout
 * @return {String}
 */
function applyLayoutMapping(key, name) {
    if (!(name in __layouts)) {
        name = "qwerty";
    }

    return (key in __layouts[name].straight) ? __layouts[name].straight[key] : key;
}

/**
 * Apply reverse mapping substitution for key
 * with give layout name
 *
 * @param  {String} key
 * @param  {String} name layout
 * @return {String}
 */
function applyReverseLayoutMapping(key, name) {
    if (!(name in __layouts)) {
        name = "qwerty";
    }

    return (key in __layouts[name].reverse) ? __layouts[name].reverse[key] : key;
}

/**
 * Get substituded key
 * registered for particular player using his layout
 *
 * @param  {String} key
 * @param  {Integer} playerid
 * @return {String}
 */
function getPKey(key, playerid) {
    return applyLayoutMapping(key.tolower(), getPlayerLayout(playerid))
}

/**
 * Get reverse substituded key
 * registered for particular player using his layout
 *
 * @param  {String} key
 * @param  {Integer} playerid
 * @return {String}
 */
function getRKey(key, playerid) {
    return applyReverseLayoutMapping(key.tolower(), getPlayerLayout(playerid))
}
