cmd("f", "list", function(playerid) {
    local fracs = fractions.getManaged(playerid);

    if (!fracs.len()) {
        return; // just silently close
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

cmd("f", "leave", function(playerid) {
    // todo ?
});

cmd("f", "kick", function(playerid) {
    // todo!
});

cmd("f", "setrole", function(playerid, targetid, role) {

});
