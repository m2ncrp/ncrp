cmd("f", "list", function(playerid) {
    local fracs = fractions.getManaged(playerid);

    if (!fracs.len()) {
        return msg(playerid, "You are not fraction admin.", CL_WARNING);
    }

    // for now take the first one
    local fraction = fracs[0];

    msg(playerid, "List of members in %s:", fraction.title, CL_INFO);

    local counter = 0;
    foreach (idx, role in fraction.getMembers()) {
        // skip duplicates for shortcuts
        // if (idx == role.shortcut) continue;

        local callback = function(err, character) {
            if (!xPlayers.has(idx)) {
                xPlayers.add(idx, character);
            }

            msg(playerid, format("#%d, Name: %s, Role: %s, Level: %d", counter++, character.firstname + " " + character.lastname, role.title, role.level));
        };

        if (xPlayers.has(idx)) {
            callback(null, xPlayers[idx]);
        } else {
            Character.findOneBy({ id = idx }, callback);
        }

        // local string = format("#%d, Title: %s, Level: %d", idx, role.title, role.level);
        // msg(playerid, string);
        // dbg(string);
    }
});


/**
 * Kick member from fraction
 * @param  {Integer} playerid
 * @param  {Integer} listid
 */
cmd("f", "kick", function(playerid, listid = -1) {
    local fracs = fractions.getManaged(playerid);
    listid = listid.tointeger();

    if (!fracs.len()) {
        return msg(playerid, "You are not fraction admin.", CL_WARNING);
    }

    // for now take the first one
    local fraction = fracs[0];

    local counter = 0;
    foreach (idx, role in fraction.getMembers()) {
        if (listid != counter++) continue;

        local callback = function(err, character) {
            if (!xPlayers.has(idx)) {
                xPlayers.add(idx, character);
            }

            // remove player
            fraction.remove(character.id, true);

            msg(playerid, format("You successfuly kicked member with name: %s and role: %s", character.firstname + " " + character.lastname, role.title), CL_SUCCESS);

            if (isPlayerLoaded(character.playerid)) {
                msg(character.playerid, format("You've been kicked from fraction %s with role %s", fraction.title, role.title), CL_WARNING);
            }
        };

        if (xPlayers.has(idx)) {
            return callback(null, xPlayers[idx]);
        } else {
            return Character.findOneBy({ id = idx }, callback);
        }
    }

    return msg(playerid, "You cannot kick member which is not in the fraction", CL_WARNING);
});


/**
 * Set member role
 * @param  {Integer} playerid
 * @param  {Integer} listid
 * @param  {Integer} roleid
 */
cmd("f", "setrole", function(playerid, listid = -1, roleid = -1) {
    local fracs = fractions.getManaged(playerid);
    roleid = roleid.tointeger();

    if (!fracs.len()) {
        return msg(playerid, "You are not fraction admin.", CL_WARNING);
    }

    // for now take the first one
    local fraction = fracs[0];

    local counter = 0;
    foreach (idx, role in fraction.getMembers()) {
        if (listid != counter++) continue;

        local callback = function(err, character) {
            if (!xPlayers.has(idx)) {
                xPlayers.add(idx, character);
            }

            if (!fraction.roles.has(roleid)) {
                return msg(playerid, "You cannot set member role to non-existant one", CL_ERROR);
            }

            // set member role
            fraction.set(character.id, fraction.roles.get(roleid), true);

            msg(playerid, format("You successfuly set role of %s to: %s", character.firstname + " " + character.lastname, role.title), CL_SUCCESS);

            if (isPlayerLoaded(character.playerid)) {
                msg(character.playerid, format("Your role in fraction %s has been changed to %s", fraction.title, role.title), CL_SUCCESS);
            }
        };

        if (xPlayers.has(idx)) {
            return callback(null, xPlayers[idx]);
        } else {
            return Character.findOneBy({ id = idx }, callback);
        }
    }

    return msg(playerid, "You cannot kick member which is not in the fraction", CL_WARNING);
});


// cmd("f", "leave", function(playerid) {
//     // local fracs
// });
