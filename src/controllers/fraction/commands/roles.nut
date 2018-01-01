fmd("*", [], "$f roles", function(fraction, character) {
    msg(character.playerid, "------------------------------------------------------------------------------", CL_RIPELEMON);
    msg(character.playerid, "fraction.roles.title", [ fraction.title ], CL_INFO);
    msg(character.playerid, "------------------------------------------------------------------------------", CL_RIPELEMON);

    foreach (idx, role in fraction.roles) {
        msg(character.playerid, "fraction.roles.item", [ role.shortcut, role.title ]);
    }
});
