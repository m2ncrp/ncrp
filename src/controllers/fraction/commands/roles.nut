cmd("f", "roles", function(playerid) {
    local fracs = fractions.getManaged(playerid);

    if (!fracs.len()) {
        return msg(playerid, "You are not fraction admin.", CL_WARNING);
    }

    // for now take the first one
    local fraction = fracs[0];

    msg(playerid, "List of roles in %s:", fraction.title, CL_INFO);

    foreach (idx, role in fraction.roles) {
        // skip duplicates for shortcuts
        if (idx == role.shortcut) continue;

        msg(playerid, format("#%d, Title: %s, Level: %d", idx, role.title, role.level));
    }
});
