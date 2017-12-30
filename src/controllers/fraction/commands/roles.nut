fmd("*", [], "$f roles", function(fraction, character) {
    msg(character.playerid, "------------------------------------------------------------------------------", CL_RIPELEMON);
    msg(character.playerid, "fraction.roles.title", [ fraction.title ], CL_INFO);
    msg(character.playerid, "------------------------------------------------------------------------------", CL_RIPELEMON);

    local counter = 0;

    foreach (idx, role in fraction.roles) {
        msg(character.playerid, "fraction.roles.item", [ ++counter, role.title ]);
    }
});
