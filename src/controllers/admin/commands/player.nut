acmd("name", function(playerid, targetid) {
    if (isPlayerConnected(playerid)) {
        msg(playerid, "Инфо: " + getIdentity(targetid.tointeger()), CL_MEDIUMPURPLE);
    } else {
        msg(playerid, "Player is not connected", CL_MEDIUMPURPLE);
    }
});

acmd("list", function(playerid) {
    msg(playerid, "Список игроков онлайн:", CL_MEDIUMPURPLE);
    foreach (pid, value in getPlayers()) {
        msg(playerid, "Инфо: " + getIdentity(pid));
    }
});

mcmd(["admin.heal"], ["heal"], function( playerid, targetid = null ) {
    targetid = targetid ? targetid.tointeger() : playerid;
    setPlayerHealth( targetid, 720.0 );
});

acmd(["freeze", "friz"], function( playerid, targetid = null ) {
    targetid = targetid ? targetid.tointeger() : playerid;
    freezePlayer( targetid, true );
    // если игрок в автомобиле - остановить авто
    if(isPlayerInVehicle(targetid)) stopPlayerVehicle( targetid );
    msg(playerid, "Вы заморозили игрока "+getAuthor(targetid), CL_CHAT_MONEY_SUB);
});

acmd(["unfreeze", "unfriz"], function( playerid, targetid = null ) {
    targetid = targetid ? targetid.tointeger() : playerid;
    freezePlayer( targetid, false );
    msg(playerid, "Вы разморозили игрока "+getAuthor(targetid), CL_CHAT_MONEY_ADD);
});

acmd(["die"], function( playerid, targetid = null ) {
    targetid = targetid ? targetid.tointeger() : playerid;
    setPlayerHealth( targetid, 0.0 );
});

acmd(["firstname"], function(playerid, targetid = null, newname = null) {

    if (targetid == null || !isPlayerConnected(targetid.tointeger())) {
        return msg(playerid, "ID игрока не указан! Формат: /firstname id имя", CL_ERROR);
    }

    if (newname == null || newname.len() == 0) {
        return msg(playerid, "Новое имя персонажа не указано! Формат: /firstname id имя", CL_ERROR);
    }

    targetid = targetid.tointeger();

    players[targetid].firstname = newname;
    msg(playerid, format("Имя персонажа для игрока с ID %d изменено на %s.", targetid, newname), CL_SUCCESS);

});

acmd(["lastname"], function(playerid, targetid = null, newname = null) {

    if (targetid == null || !isPlayerConnected(targetid.tointeger())) {
        return msg(playerid, "ID игрока не указан! Формат: /lastname id фамилия", CL_ERROR);
    }

    if (newname == null || newname.len() == 0) {
        return msg(playerid, "Новая фамилия персонажа не указана! Формат: /lastname id фамилия", CL_ERROR);
    }

    targetid = targetid.tointeger();

    players[targetid].lastname = newname;
    msg(playerid, format("Фамилия персонажа для игрока с ID %d изменена на %s.", targetid, newname), CL_SUCCESS);

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
