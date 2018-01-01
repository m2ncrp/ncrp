fmd("*", [], "$f roles", function(fraction, character) {
    msg(character.playerid, "------------------------------------------------------------------------------", CL_RIPELEMON);
    msg(character.playerid, "fraction.roles.title", [ plocalize(character.playerid, fraction.title) ], CL_INFO);
    msg(character.playerid, "------------------------------------------------------------------------------", CL_RIPELEMON);

    foreach (idx, role in fraction.roles) {
        msg(character.playerid, "fraction.roles.item", [ plocalize(character.playerid, role.title), role.shortcut ]);
    }
});


