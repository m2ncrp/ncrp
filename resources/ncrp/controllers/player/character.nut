const CHARACTER_LIMIT = 2;

/**
 * Compiled regex object for
 * validation of usernames
 * @type {Object}
 */
local REGEX_NAME = regexp("[A-Za-z]{2,16}");

translate("en", {
    "character.doesnotexist"        : "Character with provided data\ndoes not exist."
    "character.alreadymigrated"     : "Provided character has already\nbeen migrated."
    "character.limitexceeded"       : "You cant create more characters!"
    "character.alreadyregistered"   : "Character with provided firstname\nand lastname already exists.\nPlease use different!"
    "character.wrongname"           : "You provided non-valid firstname\nor lastname. Please,\ntry again using other name."
    "character.bannednames"         : "Provided firstname or lastname\nis banned. Please,\ntry again using other name."
});

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
 * @param  {Integer}    playerid
 * @param  {String}     firstname
 * @param  {String}     lastname
 * @param  {Integer}    race
 * @param  {Integer}    sex
 * @param  {String}     birthdate
 * @param  {Integer}    cskin
 * @param  {Integer}    migrateid
 */
event("onPlayerCharacterCreate", function(playerid, firstname, lastname, race, sex, birthdate, cskin, migrateid) {
    if (!isPlayerAuthed(playerid)) return dbg("character", "create with no auth", getIdentity(playerid));

    // are we migrating character
    if (migrateid != "0") {
        dbg("character", "migrating", migrateid, getIdentity(playerid), firstname, lastname, race, sex, birthdate, cskin);

        Character.findOneBy({ id = migrateid.tointeger(), name = getAccountName(playerid) }, function(err, character) {
            if (err || !character) {
                return alert(playerid, "character.doesnotexist");
            }

            if (character.firstname != "") {
                return alert(playerid, "character.alreadymigrated");
            }

            // try to update existing character
            return validateAndUpdateCharacter(playerid, character, firstname, lastname, race, sex, birthdate, cskin);
        });
    }

    // or we are creating new
    if(migrateid == "0") {
        dbg("character", "creating", null, getIdentity(playerid), firstname, lastname, race, sex, birthdate, cskin);

        Character.findBy({ name = getAccountName(playerid) }, function(err, characters) {
            if (err || characters.len() >= CHARACTER_LIMIT) {
                return alert(playerid, "character.limitexceeded");
            }

            // create emtpy character
            local character = Character();

            // override onspawn stuff (money, other shiet)
            character.money = randomf(1.75, 5.13);

            // try to create new character
            return validateAndUpdateCharacter(playerid, character, firstname, lastname, race, sex, birthdate, cskin);
        });
    }
});

/**
 * Event when player tries to load character
 */
event("onPlayerCharacterSelect", function(playerid, id) {
    if (!isPlayerAuthed(playerid)) return dbg("character", "select", "non-authed", getIdentity(playerid));

    dbg("selecting character with data", id.tointeger(), getAccountName(playerid));

    Character.findOneBy({ id = id.tointeger(), name = getAccountName(playerid) }, function(err, character) {
        if (err || !character) {
            return alert(playerid, "character.doesnotexist");
        }

        // load character
        trigger("onPlayerCharacterLoaded", playerid, character);
        dbg("character", "selected", getIdentity(playerid));
    });
});


/**
 * Main function that validates inputted data
 * and verifies if its acutally ok to udpate or create new
 * @param  {Integer}    playerid
 * @param  {Character}  character
 * @param  {String}     firstname
 * @param  {String}     lastname
 * @param  {Integer}    race
 * @param  {Integer}    sex
 * @param  {String}     birthdate
 * @param  {Integer}    cskin
 * @return {Boolean}
 */
function validateAndUpdateCharacter(playerid, character, firstname, lastname, race, sex, birthdate, cskin) {
    /**
     * Convert and validate string data
     */
    firstname = strip(firstname).slice(0, 1).toupper() + strip(firstname).slice(1).tolower();
    lastname  = strip(lastname ).slice(0, 1).toupper() + strip(lastname ).slice(1).tolower();

    if (!REGEX_NAME.match(firstname) || !REGEX_NAME.match(lastname)) {
        return alert(playerid, "character.wrongname");
    }

    /**
     * Check for name bans
     */
    local banned = false;
    local q = ORM.Query("select * from @BannedName where ((firstname like :firstname and lastname = '') or (firstname like :lastname and lastname = '') or (firstname like :firstname and lastname like :lastname))");

    q.setParameter("firstname", firstname);
    q.setParameter("lastname",  lastname );

    q.getResult(function(err, bans) {
        banned = (!err && bans.len() > 0);
    });

    if (banned) {
        return alert(playerid, "character.bannednames");
    }

    /**
     * Check for used names
     */
    Character.findBy({ firstname = firstname, lastname = lastname }, function(err, characters) {
        if (err || characters.len()) {
            return alert(playerid, "character.alreadyregistered");
        }

        // update data
        character.accountid = getAccountId(playerid);
        character.name      = getAccountName(playerid);
        character.firstname = firstname;
        character.lastname  = lastname;
        character.race      = race == 1 ? 1 : 0;
        character.sex       = sex  == 1 ? 1 : 0;
        character.birthdate = birthdate.tostring();
        character.cskin     = cskin.tointeger();
        character.dskin     = cskin.tointeger();

        // save char
        character.save();

        // add to container
        trigger("onPlayerCharacterLoaded", playerid, character);
    });

    return true;
}
