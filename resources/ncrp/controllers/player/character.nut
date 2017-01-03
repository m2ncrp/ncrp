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

/**
 * Event when player tries to create character
 * @param  {[type]} playerid  [description]
 * @param  {[type]} firstname [description]
 * @param  {[type]} lastname  [description]
 * @param  {[type]} race      [description]
 * @param  {[type]} sex       [description]
 * @param  {[type]} birthdate [description]
 * @param  {[type]} money     [description]
 * @param  {[type]} deposit   [description]
 * @return {[type]}           [description]
 */
event("onPlayerCharacterCreate", function(playerid, firstname, lastname, race, sex, birthdate, money, deposit, cskin) {
    dbg("trying to create character with", firstname, lastname, race, sex, birthdate, money, deposit, cskin);
});

/**
 * Event when player tries to load character
 */
event("onPlayerCharacterSelect", function(playerid, id) {
    Character.findOneBy({ id = id }, function(err, character) {
        if (err || !character) return trigger(playerid, "onPlayerCharacterError", "no char");

        // load characters
        players.add(playerid, character);
        return trigger("onPlayerCharacterLoaded", playerid)
    });
});
