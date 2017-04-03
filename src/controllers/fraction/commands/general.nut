cmd("f", function(playerid) {
    local fracs = fractions.getContaining(playerid);

    if (!fracs.len()) {
        return msg(playerid, "fraction.notmember", CL_WARNING);
    }

    // for now take only first
    local fraction = fracs[0];

    msg(playerid, "------------------------------------------------------------------------------", CL_RIPELEMON);
    msg(playerid, "fraction.info.title", [fraction.title] );
    msg(playerid, "------------------------------------------------------------------------------", CL_RIPELEMON);

    msg(playerid, "fraction.info.roles", [ fraction.roles.len() ] );
    msg(playerid, "fraction.info.members", [ fraction.len() ] );

    // only for admins
    if (fraction[playerid].level <= FRACTION_MONEY_PERMISSION) {
        msg(playerid, "fraction.info.money", [ fraction.money ]);
    }
});
