chatcmd("fooc", function(playerid, message) {
    local fracs = fractions.getContaining(playerid);

    if (!fracs.len()) {
        return msg(playerid, "You are not fraction member.", CL_WARNING);
    }

    // for now take the first one
    local fraction = fracs[0];

    foreach (idx, targetid in fraction.getOnlineMembers()) {
        if (fraction[targetid].level < 5) {
            msg(targetid, format("[Fraction OOC] %s", message), CL_MING);
        }
    }
});
