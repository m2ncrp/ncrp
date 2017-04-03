cmd("f", "list", function(playerid) {
    local fracs = fractions.getContaining(playerid);

    if (!fracs.len()) {
        return msg(playerid, "fraction.notmember", CL_WARNING);
    }

    // for now take the first one
    local fraction = fracs[0];
    msg(playerid, "------------------------------------------------------------------------------", CL_RIPELEMON);
    msg(playerid, "fraction.members.title", [ fraction.title ], CL_INFO);
    msg(playerid, "------------------------------------------------------------------------------", CL_RIPELEMON);
    local counter = 0;
    foreach (idx, role in fraction.getMembers()) {
        local callback = function(err, character) {
            if (!xPlayers.has(idx)) {
                xPlayers.add(idx, character);
            }

            msg(playerid, "fraction.members.item", [ counter++, character.firstname + " " + character.lastname, role.title ] );
        };

        if (xPlayers.has(idx)) {
            callback(null, xPlayers[idx]);
        } else {
            Character.findOneBy({ id = idx }, callback);
        }
    }
});


/**
 * Kick member from fraction
 * @param  {Integer} playerid
 * @param  {Integer} listid
 */
cmd("f", "kick", function(playerid, listid = -1) {
    local fracs = fractions.getManaged(playerid, FRACTION_ROLESET_PERMISSION);

    if (!fracs.len()) {
        return msg(playerid, "fraction.member.notadmin", CL_WARNING);
    }

    // for now take the first one
    local fraction = fracs[0];

    listid = listid.tointeger();

    local counter = 0;
    foreach (idx, role in fraction.getMembers()) {
        if (listid != counter++) continue;

        local callback = function(err, character) {
            if (!xPlayers.has(idx)) {
                xPlayers.add(idx, character);
            }

            // check for ability to change role of player which has same or bigger role
            if (fraction.memberRoles[character.id].level <= fraction[playerid].level) {
                // and we are not same person
                if (character.id != players[playerid].id) {
                    return msg(playerid, "fraction.member.higherrole", CL_WARNING);
                }
            }

            // remove player
            fraction.remove(character.id, false);

            msg(playerid, "fraction.member.kick", [ character.firstname + " " + character.lastname ], CL_SUCCESS);

            if (isPlayerLoaded(character.playerid)) {
                msg(character.playerid, "fraction.member.kicked", [ fraction.title ], CL_WARNING);
            }
        };

        if (xPlayers.has(idx)) {
            return callback(null, xPlayers[idx]);
        } else {
            return Character.findOneBy({ id = idx }, callback);
        }
    }

    return msg(playerid, "fraction.member.doesntexist", CL_WARNING);
});


/**
 * Set member role
 * @param  {Integer} playerid
 * @param  {Integer} listid
 * @param  {Integer} roleid
 */
cmd("f", "setrole", function(playerid, listid = -1, roleid = -1) {
    local fracs = fractions.getManaged(playerid, FRACTION_ROLESET_PERMISSION);

    if (!fracs.len()) {
        return msg(playerid, "fraction.member.notadmin", CL_WARNING);
    }

    // for now take the first one
    local fraction = fracs[0];

    listid = listid.tointeger();
    roleid = roleid.tointeger();

    local counter = 0;
    foreach (idx, role in fraction.getMembers()) {
        if (listid != counter++) continue;

        local callback = function(err, character) {
            if (!xPlayers.has(idx)) {
                xPlayers.add(idx, character);
            }

            // check for ability to change role of player which has same or bigger role
            if (fraction.memberRoles[character.id].level <= fraction[playerid].level) {
                // and we are not same person
                if (character.id != players[playerid].id) {
                    return msg(playerid, "fraction.member.higherrole", CL_WARNING);
                }
            }

            if (!fraction.roles.has(roleid)) {
                return msg(playerid, "fraction.member.needrole", CL_ERROR);
            }

            local newrole = fraction.roles.get(roleid);

            // set member role
            fraction.set(character.id, newrole, false);

            msg(playerid, "fraction.member.setrolecomplete", [ character.firstname + " " + character.lastname, newrole.title ], CL_SUCCESS);

            if (isPlayerLoaded(character.playerid)) {
                msg(character.playerid, "fraction.member.changedrole", [ fraction.title, newrole.title ], CL_SUCCESS);
            }
        };

        if (xPlayers.has(idx)) {
            return callback(null, xPlayers[idx]);
        } else {
            return Character.findOneBy({ id = idx }, callback);
        }
    }

    return msg(playerid, "fraction.member.doesntexist", CL_WARNING);
});


// cmd("f", "leave", function(playerid) {
//     // local fracs
// });
