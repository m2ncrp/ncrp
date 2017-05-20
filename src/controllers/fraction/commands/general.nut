fmd("*", [], "$f", function(fraction, character) {
    msg(character.playerid, "------------------------------------------------------------------------------", CL_RIPELEMON);
    msg(character.playerid, "fraction.info.title", [fraction.title] );
    msg(character.playerid, "------------------------------------------------------------------------------", CL_RIPELEMON);

    msg(character.playerid, "fraction.info.roles", [ fraction.roles.len() ] );
    msg(character.playerid, "fraction.info.members", [ fraction.members.len() ] );

    if (fraction.members.get(character).permitted("money.list")) {
        msg(character.playerid, "fraction.info.money", [ fraction.money ]);
    }
});
