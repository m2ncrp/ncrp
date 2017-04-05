cmd("f", "roles", function(playerid) {
    local fracs = fractions.getContaining(playerid);

    if (!fracs.len()) {
        return msg(playerid, "fraction.notmember", CL_WARNING);
    }

    // for now take the first one
    local fraction = fracs[0];
    msg(playerid, "------------------------------------------------------------------------------", CL_RIPELEMON);
    msg(playerid, "fraction.roles.title", [ fraction.title ], CL_INFO);
    msg(playerid, "------------------------------------------------------------------------------", CL_RIPELEMON);
    // fraction.sortRoles();

    // local counter = 0;
    foreach (idx, role in fraction.roles) {
        // skip duplicates for shortcuts
        if (idx == role.shortcut) continue;

        msg(playerid, "fraction.roles.item", [ idx, role.title ]);
    }
});
