const CHARACTER_LIMIT = 2;

/**
 * Handle character loadeded event
 */
event("onPlayerCharacterLoaded", function(playerid, character) {
    //Hide character creation gui
    trigger(playerid, "hideCharacterCreation");

    // store player id for current player
    character.playerid = playerid;
    players.add(playerid, character);

    // trigger init events
    trigger("onPlayerConnect", playerid);
    trigger("native:onPlayerSpawn", playerid); // ?? move to later

    // and trigger start events
    delayedFunction(1500, function() {
        if (DEBUG) dbg("player", "started", getIdentity(playerid));
        trigger("onServerPlayerStarted", playerid);
        trigger(playerid, "onServerClientStarted", VERSION);
        trigger(playerid, "onServerIntefaceCharacter", getLocalizedPlayerJob(playerid, "en"), getPlayerLevel(playerid) );
        trigger(playerid, "onServerInterfaceMoney", getPlayerMoney(playerid));

        // try to undfreeze player
        freezePlayer(playerid, false);
        trigger(playerid, "resetPlayerIntroScreen");
        delayedFunction(1000, function() { freezePlayer(playerid, false); });
    });
});

// event("onPlayer")

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
event("onPlayerCharacterCreate", function(playerid, firstname, lastname, race, sex, birthdate, cskin, migrateid) {
    if (!isPlayerAuthed(playerid)) return dbg("character", "create with no auth", getIdentity(playerid));

    // are we migrating character
    if (migrateid) {
        dbg("character", "migrating", migrateid, getIdentity(playerid), firstname, lastname, race, sex, birthdate, cskin);

        Character.findOneBy({ id = migrateid, name = getAccountName(playerid) }, function(err, character) {
            if (err || !character) {
                return alert(playerid, "character.doesnotexist");
            }

            if (character.firstname != "") {
                return alert(playerid, "character.alreadymigrated");
            }

            // TODO(inlife): add data validation

            // update data
            character.accountid = getAccountId(playerid);
            character.name      = getAccountName(playerid);
            character.firstname = firstname;
            character.lastname  = lastname;
            character.race      = race;
            character.sex       = sex;
            character.birthdate = birthdate;
            character.cskin     = cskin;
            character.dskin     = cskin;

            // save char
            character.save();

            // add to container
            trigger("onPlayerCharacterLoaded", playerid, character);
        });
    }

    // or we are creating new
    if(!migrateid) {
        dbg("character", "creating", null, getIdentity(playerid), firstname, lastname, race, sex, birthdate, cskin);

        Character.findBy({ name = getAccountName(playerid) }, function(err, characters) {
            if (err || characters.len() >= CHARACTER_LIMIT) {
                return alert(playerid, "character.limitexceeded");
            }

            Character.findBy({ firstname = firstname, lastname = lastname }, function(err, characters) {
                if (err || characters.len()) {
                    return alert(playerid, "character.alreadyregistered");
                }

                // TODO(inlife): add data validation
                local character = Character();

                // update data
                character.accountid = getAccountId(playerid);
                character.name      = getAccountName(playerid);
                character.firstname = firstname;
                character.lastname  = lastname;
                character.race      = race;
                character.sex       = sex;
                character.birthdate = birthdate;
                character.cskin     = cskin;
                character.dskin     = cskin;

                // override onspawn stuff (money, other shiet)
                character.money     = randomf(1.75, 5.13);

                // save char
                character.save();

                // add to container
                trigger("onPlayerCharacterLoaded", playerid, character);
            });
        });
    }
});

/**
 * Event when player tries to load character
 */
event("onPlayerCharacterSelect", function(playerid, id) {
    if (!isPlayerAuthed(playerid)) return dbg("character", "select", "non-authed", getIdentity(playerid));

    dbg("selecting character with data", id, getAccountName(playerid));

    Character.findOneBy({ id = id, name = getAccountName(playerid) }, function(err, character) {
        if (err || !character) {
            return alert(playerid, "character.doesnotexist");
        }

        // load character
        trigger("onPlayerCharacterLoaded", playerid, character);
        dbg("character", "selected", getIdentity(playerid));
    });
});
