local registry = {};

/**
 * Create 3d text for all or for one player by name
 * @param  {Integer|String} playeridOrAll
 * @param  {String} name
 * @param  {...} 3d text agrumets
 */
function createText(playeridOrAll, name, ...) {
    if (!(name in registry)) {
        registry[name] <- {};
    }

    if (playeridOrAll in registry[name]) {
        return dbg("text", "creating", name, "already exists for", playeridOrAll);
    }

    vargv.insert(0, getroottable());

    if (playeridOrAll == "all") {
        foreach (playerid, value in players) {
            local args = clone(vargv);
            args.insert(1, playerid);
            args.insert(2, name);
            createText.acall(args);
        }
    } else {
        vargv.insert(1, playeridOrAll);
        registry[name][playeridOrAll] <- createPrivate3DText.acall(vargv);
    }
}

/**
 * Remove 3d text for all or for one player by name
 * @param  {Integer|String} playeridOrAll
 * @param  {String} name
 */
function removeText(playeridOrAll, name) {
    if (!(name in registry)) {
        return;
    }

    if (playeridOrAll != "all" && !(playeridOrAll in registry[name])) {
        return dbg("text", "removing", name, "doesnt exists for", playeridOrAll);
    }

    if (playeridOrAll == "all") {
        foreach (playerid, value in players) {
            removeText(playerid, name);
        }
    } else {
        remove3DText(registry[name][playeridOrAll]);
        delete registry[name][playeridOrAll];
    }
}

/**
 * Rename 3d text ofr all or for one player by name
 * @param  {Integer|String} playeridOrAll
 * @param  {String} name
 * @param  {String} text
 */
function renameText(playeridOrAll, name, text) {
    if (!(name in registry)) {
        return;
    }

    if (playeridOrAll != "all" && !(playeridOrAll in registry[name])) {
        return dbg("text", "renaming", name, "doesnt exists for", playeridOrAll);
    }

    if (playeridOrAll == "all") {
        foreach (playerid, value in players) {
            renameText(playerid, name, text);
        }
    } else {
        rename3DText(registry[name][playeridOrAll], text);
    }
}

/**
 * Check if exists 3d text ofr all or for one player by name
 * @param  {Integer|String} playeridOrAll
 * @param  {String} name
 * @param  {String} text
 */
function existsText(playeridOrAll, name) {
    return (name in registry && playeridOrAll in registry[name]);
}

event("onPlayerDisconnect", function(playerid, reason) {
    foreach (name, playerz in registry) {
        if (playerid in playerz) {
            removeText(playerid, name);
        }
    }
});
