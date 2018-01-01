fmd("*", ["members.list"], ["$f list", "$f members"], function(fraction, character) {
    msg(character.playerid, "------------------------------------------------------------------------------", CL_RIPELEMON);
    msg(character.playerid, "fraction.members.title", [ plocalize(character.playerid, fraction.title) ], CL_INFO);
    msg(character.playerid, "------------------------------------------------------------------------------", CL_RIPELEMON);

    local counter = 0;
    foreach (characterid, member in fraction.members) {
        local callback = function(err, target_character) {
            if (!xPlayers.has(characterid)) {
                xPlayers.add(characterid, target_character);
            }

            msg(character.playerid, "fraction.members.item", [ counter++, target_character.firstname + " " + target_character.lastname, plocalize(character.playerid, member.role.title) ] );
        };

        if (xPlayers.has(characterid)) {
            callback(null, xPlayers[characterid]);
        } else {
            Character.findOneBy({ id = characterid }, callback);
        }
    }
});


/**
 * Kick member from fraction
 */
fmd("*", ["members.remove"], ["$f kick", "$f members remove"], function(fraction, character, listid = -1) {
    listid = listid.tointeger();

    local counter = 0;
    foreach (characterid, member in fraction.members) {
        if (listid != counter++) continue;

        local callback = function(err, target) {
            if (!xPlayers.has(characterid)) {
                xPlayers.add(characterid, target);
            }

            // check for ability to change role of player which has same or bigger role
            if (fraction.members[target].role.level < fraction.members[character].role.level) {
                // and we are not same person
                if (target.id != character.id) {
                    return msg(character.playerid, "fraction.member.higherrole", CL_WARNING);
                }
            }

            // remove player
            fraction.members.remove(target).remove();

            //todo: remove after all jobs to fractions update [1]
            if (fraction.shortcut == "police") { target.job = ""; target.save(); }

            msg(character.playerid, "fraction.member.kick", [ target.getName() ], CL_SUCCESS);

            if (isPlayerLoaded(target.playerid)) {
                msg(target.playerid, "fraction.member.kicked", [ fraction.title ], CL_WARNING);

                //todo: remove after all jobs to fractions update [2]
                if(fraction.shortcut == "police") setPlayerJob(target.playerid, null);
            }
        };

        if (xPlayers.has(characterid)) {
            return callback(null, xPlayers[characterid]);
        } else {
            return Character.findOneBy({ id = characterid }, callback);
        }
    }

    return msg(character.playerid, "fraction.member.doesntexist", CL_WARNING);
});


/**
 * Set member role
 */
fmd("*", ["members.setrole"], ["$f setrole"], function(fraction, character, listid = -1, role_shortcut = -1) {
    listid = listid.tointeger();

    local counter = 0;
    foreach (characterid, member in fraction.members) {
        if (listid != counter++) continue;

        local callback = function(err, target) {
            if (!xPlayers.has(characterid)) {
                xPlayers.add(characterid, target);
            }

            // check for ability to change role of player which has same or bigger role
            if (fraction.members[target].role.level < fraction.members[character].role.level) {
               // and we are not same person
               if (target.id != character.id) {
                   return msg(character.playerid, "fraction.member.higherrole", CL_WARNING);
               }
            }

            if (!fraction.roles.has(role_shortcut)) {
                return msg(character.playerid, "fraction.member.needrole", CL_ERROR);
            }

            local newrole = fraction.roles.get(role_shortcut);

            // set member role
            fraction.members.set(target.id, newrole);

            //todo: remove after all fractions update [1]
            if (fraction.shortcut == "police") { target.job = newrole.shortcut; target.save(); }

            msg(character.playerid, "fraction.member.setrolecomplete", [ target.getName(), newrole.title ], CL_SUCCESS);

            if (isPlayerLoaded(target.playerid)) {
                msg(target.playerid, "fraction.member.changedrole", [ fraction.title, newrole.title ], CL_SUCCESS);

                //todo: remove after all fractions update [2]
                if(fraction.shortcut == "police") setPlayerJob(target.playerid, newrole.shortcut);
            }
        };

        if (xPlayers.has(characterid)) {
            return callback(null, xPlayers[characterid]);
        } else {
            return Character.findOneBy({ id = characterid }, callback);
        }
    }

    return msg(character.playerid, "fraction.member.doesntexist", CL_WARNING);
});


// cmd("f", "leave", function(playerid) {
//     // local fracs
// });
