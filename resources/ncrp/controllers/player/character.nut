/**
 * Handle character loadeded event
 */
event("onPlayerCharacterLoaded", function(playerid) {
    // store player id for current player
    players[playerid].playerid = playerid;

    // trigger init events
    trigger("onPlayerConnect", playerid);
    trigger("native:onPlayerSpawn", playerid); // ?? moved to later

    // and trigger start events
    delayedFunction(1500, function() {
        trigger("onServerPlayerStarted", playerid);
        trigger(playerid, "onServerClientStarted", VERSION);
        trigger(playerid, "onServerIntefaceCharacter", getLocalizedPlayerJob(playerid, "en"), getPlayerLevel(playerid) );
        trigger(playerid, "onServerInterfaceMoney", getPlayerMoney(playerid));
        screenFadeout(playerid, 500);

        // try to undfreeze player
        freezePlayer(playerid, false);
        trigger(playerid, "resetPlayerIntroScreen");
        delayedFunction(1000, function() { freezePlayer(playerid, false); });
    });
});
