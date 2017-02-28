cmd("f", function(playerid) {
    local fracs = fractions.getContaining(playerid);

    if (!fracs.len()) {
        return msg(playerid, "You are not a member of any fraction", CL_WARNING);
    }

    // for now take only first
    local fraction = fracs[0];

    msg(playerid, "-------------------------------------------------------------", CL_RIPELEMON);
    msg(playerid, format("- Information about fraction %s", fraction.title));
    msg(playerid, "-------------------------------------------------------------", CL_RIPELEMON);

    msg(playerid, format("- Current amount of roles: %d. To list, write: /f roles", fraction.roles.len()));
    msg(playerid, format("- Current amount of members %d. To list, write: /f list", fraction.len()));

    // only for admins
    if (fraction[playerid].level == 0) {
        msg(playerid, format("- Current money amount: %.2f", fraction.money));
    }
});
