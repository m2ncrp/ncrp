fmd("*", [], "$f", function(fraction, character) {
    msg(character.playerid, "------------------------------------------------------------------------------", CL_RIPELEMON);
    msg(character.playerid, "fraction.info.title", [fraction.title] );
    msg(character.playerid, "------------------------------------------------------------------------------", CL_RIPELEMON);

    msg(character.playerid, "fraction.info.roles", [ fraction.roles.len(), fraction.shortcut ] );
    msg(character.playerid, "fraction.info.members", [ fraction.members.len(), fraction.shortcut  ] );
    msg(character.playerid, "fraction.info.vehicles", [ fraction.property.len(), fraction.shortcut  ] );

    if (fraction.members.get(character).permitted("money.list")) {
        msg(character.playerid, "fraction.info.money", [ fraction.money ]);
    }
});

cmd("f", function(playerid, a = -1, b = -1, c = -1, d = -1) {
    local character = players[playerid];

    msg(playerid, "fraction.list.title", [fractions.getContaining(character).len()]);

    foreach (idx, fraction in fractions.getContaining(character)) {
        msg(playerid, "fraction.list.entry", [fraction.title, fraction.members[character].role.title, fraction.shortcut], CL_INFO);
    }
});
