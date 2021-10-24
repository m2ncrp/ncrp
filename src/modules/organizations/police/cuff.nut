const CUFF_RADIUS = 6.0;

// cuff nearest stunned player
/*
key(["v"], function(playerid) {

    // если игрок в авто
    if (isPlayerInVehicle(playerid)) {
        return;
    }

    // если игрок не офицер
    if (!isOfficer(playerid)) {
        return;
    }

    // если игрок не на смене
    if (!isOfficerOnDuty(playerid)) {
        return msg( playerid, "organizations.police.duty.not" );
    }

    if (getPoliceRank(playerid) < 1) {
        return msg(playerid, "organizations.police.lowrank", CL_ERROR);
    }

    local targetid = playerList.nearestPlayer( playerid );

    // если игрок не определён || радиус большой || целевой игрок является офицером (защита от суеты) || целевой игрок в авто
    if ( targetid == null || !isBothInRadius(playerid, targetid, CUFF_RADIUS) || isOfficer(targetid) || isPlayerInVehicle(targetid) ) {
        return msg(playerid, "general.noonearound");
    }

    if(getPlayerMoveState(targetid) == 2) {
        return msg(playerid, "police.cuff.suspect-running");
    }

    freezePlayer(targetid, true);
    setPlayerState(targetid, "cuffed");

    msg(targetid, "police.cuff.beencuffed", [ getKnownCharacterNameWithId(targetid, playerid) ]);
    msg(targetid, "police.cuff-baton.info", CL_LYNCH);

    msg(playerid, "police.cuff.cuffed", [ getKnownCharacterNameWithId(playerid, targetid) ]);

});
*/

cmd(["uncuff"], function(playerid, targetid) {

    // если игрок в авто
    if ( isPlayerInVehicle(playerid) ) {
        return;
    }

    // если игрок не офицер
    if ( !isOfficer(playerid) ) {
        return;
    }

    // если игрок не на смене
    if ( !isOfficerOnDuty(playerid) ) {
        return msg( playerid, "police.duty.off" );
    }

    if (targetid == null) return msg(playerid, "USE: /uncuff id");

    targetid = targetid.tointeger();

    if (!isBothInRadius(playerid, targetid, CUFF_RADIUS) ) {
        return msg(playerid, "general.noonearound");
    }

    if ( getPlayerState(targetid) != "cuffed" ) {
        return msg(playerid, "police.cuff.notcuffed", [ getKnownCharacterNameWithId(playerid, targetid) ]);
    }

    freezePlayer(targetid, false );
    setPlayerState(targetid, "free");

    msg(targetid, "police.cuff.beenuncuffed", [ getKnownCharacterNameWithId(targetid, playerid) ] );
    msg(playerid, "police.cuff.uncuffed", [ getKnownCharacterNameWithId(playerid, targetid) ] );
});


alternativeTranslate({

    "en|police.arrested"               : "You are arrested."
    "ru|police.arrested"               : "Вы арестованы."

    "en|police.cuff.beencuffed"           : "You've been cuffed by %s."
    "ru|police.cuff.beencuffed"           : "%s надел на вас наручники."

    "en|police.cuff.cuffed"               : "You cuffed %s."
    "ru|police.cuff.cuffed"               : "Вы арестовали %s."

    "en|police.cuff.beenuncuffed"         : "You've been uncuffed by %s"
    "ru|police.cuff.beenuncuffed"         : "%s снял с вас наручники."

    "en|police.cuff.uncuffed"             : "You uncuffed %s"
    "ru|police.cuff.uncuffed"             : "Вы сняли наручники с %s."

    "en|police.cuff.notcuffed"            : "%s not handcuffed."
    "ru|police.cuff.notcuffed"            : "%s не в наручниках."

    "en|police.cuff.fail"                 : "Cuffing has been failed."
    "ru|police.cuff.fail"                 : "Не удалось надеть наручники"

    "en|police.cuff.suspect-running"      : "Suspect is running away."
    "ru|police.cuff.suspect-running"      : "Подозреваемый убегает."

    "en|police.cuff-baton.info"           : "You'll automatically go to jail if you leave the game."
    "ru|police.cuff-baton.info"           : "Вы автоматически попадёте в тюрьму, если выйдите из игры."
});
