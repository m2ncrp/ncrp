const BATON_RADIUS = 6.0;

local batonBumps = {};

// stun nearest player for some time
key(["g"], function(playerid) {

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

    local targetid = playerList.nearestPlayer( playerid );

    // если игрок не определён || радиус большой || целевой игрок является офицером (защита от суеты) || целевой игрок в авто
    if ( targetid == null || !isBothInRadius(playerid, targetid, CUFF_RADIUS) || isOfficer(targetid) || isPlayerInVehicle(targetid) ) {
        return msg(playerid, "general.noonearound");
    }

    trigger("onBatonBitStart", playerid);

    local charid = getCharacterIdFromPlayerId(targetid);

    if(!(charid in batonBumps)) {
      batonBumps[charid] <- 0;
    }

    batonBumps[charid] += 1;
    local bumps = batonBumps[charid]

    local currentPlayerHealth = getPlayerHealth(targetid);
    local healthDamagePercent = random(20, 40);
    local nextPlayerHealth = currentPlayerHealth - healthDamagePercent * 0.01 * currentPlayerHealth;
    log(nextPlayerHealth.tostring());
    if(nextPlayerHealth < 10) nextPlayerHealth = 10;

    setPlayerHealth(targetid, nextPlayerHealth);

    trigger(targetid, "simpleShake", 1, (1000 - currentPlayerHealth) * 0.075, bumps * 30);
    trigger(targetid, "setPlayerDrunkLevel", 1);

    if(bumps >= 4) {
      local plaRot = getPlayerRotation(targetid);
      setPlayerRotation(targetid, -89.0, plaRot[1], plaRot[0]);
      freezePlayer(targetid, true);
      setPlayerState(targetid, "immobilized");

      msg( playerid, "police.baton.suspect-immobilized" );
      msg( targetid, "police.baton.immobilized" );
      msg(targetid, "police.cuff-baton.info", CL_LYNCH);
      return;
    }

    msg( playerid, "police.baton.betby", [getAuthor(targetid)] );
    msg( targetid, "police.baton.beenbet" );
});


alternativeTranslate({

  "en|police.baton.betby"    : "You bet %s by baton."
  "ru|police.baton.betby"    : "Вы ударили %s дубинкой."

  "en|police.baton.beenbet"  : "You's been bet by baton"
  "ru|police.baton.beenbet"  : "Вас оглушили дубинкой."

  "en|police.baton.suspect-immobilized"  : "Suspect is immobilized."
  "ru|police.baton.suspect-immobilized"  : "Подозреваемый обездвижен."

  "en|police.baton.immobilized"  : "You're immobilized."
  "ru|police.baton.immobilized"  : "Вы обездвижены."

});
