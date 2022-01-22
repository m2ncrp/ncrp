// acmd("name", function(playerid, targetid) {
//     if (isPlayerConnected(playerid)) {
//         msg(playerid, "Инфо: " + getIdentity(targetid.tointeger()), CL_MEDIUMPURPLE);
//     } else {
//         msg(playerid, "Player is not connected", CL_MEDIUMPURPLE);
//     }
// });

acmd("list", function(playerid) {
    msg(playerid, "Список игроков онлайн:", CL_MEDIUMPURPLE);
    foreach (pid, value in getPlayers()) {
        msg(playerid, "Инфо: " + getIdentity(pid));
    }
});

mcmd(["admin.heal"], ["aheal"], function(playerid, playerSessionId = null) {
    local targetid = getTargetPlayerId(playerid, playerSessionId);
    setPlayerHealth(targetid, 720.0);
});

acmd(["freeze", "friz"], function(playerid, playerSessionId = null) {
    local targetid = getTargetPlayerId(playerid, playerSessionId);
    freezePlayer(targetid, true);
    // если игрок в автомобиле - остановить авто
    if(isPlayerInVehicle(targetid)) stopPlayerVehicle(targetid);
    msg(playerid, "Вы заморозили игрока "+getAuthor(targetid), CL_CHAT_MONEY_SUB);
});

acmd(["unfreeze", "unfriz"], function(playerid, playerSessionId = null) {
    local targetid = getTargetPlayerId(playerid, playerSessionId);
    freezePlayer(targetid, false);
    msg(playerid, "Вы разморозили игрока "+getAuthor(targetid), CL_CHAT_MONEY_ADD);
});

acmd(["die"], function( playerid, playerSessionId = null ) {
    local targetid = getTargetPlayerId(playerid, playerSessionId);
    setPlayerHealth(targetid, 0.0);
});

acmd(["mypos"], function( playerid ) {
    local pos = getPlayerPositionObj(playerid);
    msg(playerid, format("x = %.2f, y = %.2f, z = %.2f", pos.x, pos.y, pos.z), CL_OCEANGREEN);
});

acmd(["firstname"], function(playerid, playerSessionId = null, newname = null) {
    if (playerSessionId == null) {
        return msg(playerid, "ID игрока не указан! Формат: /firstname id имя", CL_ERROR);
    }

    local targetid = getPlayerIdByPlayerSessionId(playerSessionId.tointeger());

    if (targetid == null || !isPlayerConnected(targetid)) {
        return msg(playerid, "Такого игрока нет в сети! Формат: /firstname id имя", CL_ERROR);
    }

    if (newname == null || newname.len() == 0) {
        return msg(playerid, "Новое имя персонажа не указано! Формат: /firstname id имя", CL_ERROR);
    }

    players[targetid].firstname = newname;
    msg(playerid, format("Имя персонажа для игрока с ID %d изменено на %s.", playerSessionId, newname), CL_SUCCESS);

});

acmd(["lastname"], function(playerid, playerSessionId = null, newname = null) {
    if (playerSessionId == null) {
        return msg(playerid, "ID игрока не указан! Формат: /lastname id фамилия", CL_ERROR);
    }

    local targetid = getPlayerIdByPlayerSessionId(playerSessionId.tointeger());

    if (targetid == null || !isPlayerConnected(targetid)) {
        return msg(playerid, "ID игрока не указан! Формат: /lastname id фамилия", CL_ERROR);
    }

    if (newname == null || newname.len() == 0) {
        return msg(playerid, "Новая фамилия персонажа не указана! Формат: /lastname id фамилия", CL_ERROR);
    }

    players[targetid].lastname = newname;
    msg(playerid, format("Фамилия персонажа для игрока с ID %d изменена на %s.", playerSessionId, newname), CL_SUCCESS);

});

acmd(["verify"], function(playerid, playerSessionId = null) {
    if (playerSessionId == null) {
        return msg(playerid, "ID игрока не указан! Формат: /verify id", CL_ERROR);
    }

    local targetid = getPlayerIdByPlayerSessionId(playerSessionId.tointeger());

    if (targetid == null || !isPlayerConnected(targetid)) {
        return msg(playerid, "ID игрока не указан! Формат: /verify id", CL_ERROR);
    }

    players[targetid].setData("verified", true);
    msg(playerid, format("Персонаж %s верифицирован.", getPlayerName(targetid)), CL_SUCCESS);

    // for local player
    trigger(playerid, "onCharacterChangedVerified", targetid, players[targetid].data.verified );

    // for target players
    trigger(targetid, "onCharacterChangedVerified", targetid, players[targetid].data.verified );

    // for all players
    foreach (memberid, player in players) {
        //trigger(memberid, "onCharacterChangedVerified", playerid, ("verified" in players[playerid].data) ? players[playerid].data.verified : false ); // create name of current player for remote players
        trigger(memberid, "onCharacterChangedVerified", targetid, ("verified" in players[targetid].data) ? players[targetid].data.verified : false ); // create name of remote player for current player
    }

});

acmd(["unverify"], function(playerid, playerSessionId = null) {
    if (playerSessionId == null) {
        return msg(playerid, "ID игрока не указан! Формат: /unverify id", CL_ERROR);
    }

    local targetid = getPlayerIdByPlayerSessionId(playerSessionId.tointeger());

    if (targetid == null || !isPlayerConnected(targetid)) {
        return msg(playerid, "ID игрока не указан! Формат: /unverify id", CL_ERROR);
    }

    players[targetid].setData("verified", false);
    msg(playerid, format("Верификация персонажа %s отменена.", getPlayerName(targetid)), CL_SUCCESS);

    // for local player
    trigger(playerid, "onCharacterChangedVerified", targetid, players[targetid].data.verified );

    // for target players
    trigger(targetid, "onCharacterChangedVerified", targetid, players[targetid].data.verified );

    // for all players
    foreach (memberid, player in players) {
        //trigger(memberid, "onCharacterChangedVerified", playerid, ("verified" in players[playerid].data) ? players[playerid].data.verified : false ); // create name of current player for remote players
        trigger(memberid, "onCharacterChangedVerified", targetid, ("verified" in players[targetid].data) ? players[targetid].data.verified : false ); // create name of remote player for current player
    }

});



acmd("hs", "off", function(playerid, playerSessionId = null) {
    if (playerSessionId == null) {
        return msg(playerid, "ID игрока не указан! Формат: /hs off id", CL_ERROR);
    }

    local targetid = getPlayerIdByPlayerSessionId(playerSessionId.tointeger());

    if (targetid == null || !isPlayerConnected(targetid)) {
        return msg(playerid, "ID игрока не указан! Формат: /hs off id", CL_ERROR);
    }

    players[targetid].setData("handshake", "off");
    msg(playerid, format("Система знакомств для игрока с ID %d отключена.", targetid), CL_SUCCESS);
});

acmd("hs", "on", function(playerid, playerSessionId = null) {
    if (playerSessionId == null) {
        return msg(playerid, "ID игрока не указан! Формат: /hs on id", CL_ERROR);
    }

    local targetid = getPlayerIdByPlayerSessionId(playerSessionId.tointeger());

    if (targetid == null || !isPlayerConnected(targetid)) {
        return msg(playerid, "ID игрока не указан! Формат: /hs on id", CL_ERROR);
    }

    players[targetid].setData("handshake", "on");
    msg(playerid, format("Система знакомств для игрока с ID %d подключена.", targetid), CL_SUCCESS);

});

// acmd("skin", function(playerid, id, targetid = null ) {
//     if(!targetid) targetid = playerid;
//     setPlayerModel(targetid.tointeger(), id.tointeger(), true);
// });

//acmd(["skininc"], function ( playerid ) {
//    local skin = getPlayerModel(playerid);
//    if ( skin < 171) {
//        skin += 1;
//        setPlayerModel(playerid, skin, true);
//        msg( playerid,  "Skin model changed on " + skin );
//    } else {
//        msg( playerid,  "Skin top limit" );
//    }
//});

//acmd(["skindec"], function ( playerid ) {
//    local skin = getPlayerModel(playerid);
//    if ( skin > 0) {
//        skin -= 1;
//        setPlayerModel(playerid, skin, true);
//        msg( playerid,  "Skin model changed on " + skin );
//    } else {
//        msg( playerid,  "Skin lower limit" );
//    }
//});
//


// =====================================================================

key("i", function(playerid) {
    if (isPlayerAdmin(playerid)) {
        trigger(playerid, "onServerToggleBlip", "p");
        trigger(playerid, "onServerToggleNametags");
    }
});

key("back", function(playerid) {
    if (isPlayerAdmin(playerid)) {
        triggerClientEvent(playerid, "tabpanel:show");
    }
}, KEY_DOWN);

key("back", function(playerid) {
    if (isPlayerAdmin(playerid)) {
        triggerClientEvent(playerid, "tabpanel:hide");
    }
}, KEY_UP);

