const CHARACTER_LIMIT = 1;

/**
 * Compiled regex object for
 * validation of usernames
 * @type {Object}
 */
local REGEX_FIRSTNAME = regexp("[A-Z][a-z]{1,16}");
local REGEX_LASTNAME = regexp("[A-Z][a-z]{1,16}");

translate("en", {
    "character.doesnotexist"        : "Character with provided data\ndoes not exist."
    "character.alreadymigrated"     : "Provided character has already\nbeen migrated."
    "character.limitexceeded"       : "You cant create more characters!"
    "character.alreadyregistered"   : "Character with provided firstname and lastname\nalready exists. Please use different!\n\nIt's forbidden to use all the Slavic, Turkish,\nAzerbaijan, Czech, Slovak names and surnames,\nmost popular names such as Tom, Tommy, Joe, Vito,\nHenry, John, and surnames such as Johnson, Angelo,\nScaletta, Barbaro, Corleone, Capone etc,\nnames and surnames of politicians, famous actors, \nmusical performers, athletes, heroes of popular games\nand any other known personalities.\n\nBe original and creative!"
    "character.wrongname"           : "You provided non-valid firstname or lastname.\nPlease, try again using other name.\n\nIt's forbidden to use all the Slavic, Turkish,\nAzerbaijan, Czech, Slovak names and surnames,\nmost popular names such as Tom, Tommy, Joe, Vito,\nHenry, John, and surnames such as Johnson, Angelo,\nScaletta, Barbaro, Corleone, Capone etc,\nnames and surnames of politicians, famous actors, \nmusical performers, athletes, heroes of popular games\nand any other known personalities.\n\nBe original and creative!"
    "character.bannednames"         : "Provided firstname or lastname is banned.\nPlease, try again using other name.\n\nIt's forbidden to use all the Slavic, Turkish,\nAzerbaijan, Czech, Slovak names and surnames,\nmost popular names such as Tom, Tommy, Joe, Vito,\nHenry, John, and surnames such as Johnson, Angelo,\nScaletta, Barbaro, Corleone, Capone etc,\nnames and surnames of politicians, famous actors, \nmusical performers, athletes, heroes of popular games\nand any other known personalities.\n\nBe original and creative!"
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

    // cache player character (replace)
    xPlayers.set(character.id, character);

    // trigger init events
    trigger("onPlayerConnect", playerid);
    trigger("native:onPlayerSpawn", playerid); // ?? move to later

    // and trigger start events
    delayedFunction(1500, function() {
        if (!isPlayerLoaded(playerid)) return;
        if (DEBUG) dbg("player", "started", getIdentity(playerid));
        trigger("onServerPlayerStarted", playerid);
        trigger(playerid, "onServerClientStarted", VERSION);
        trigger(playerid, "onServerIntefaceCharacter", getLocalizedPlayerJob(playerid), getPlayerLevel(playerid) );
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
 * @param  {String}     nationality
 * @param  {Integer}    race
 * @param  {Integer}    sex
 * @param  {String}     birthdate
 * @param  {Integer}    cskin
 * @param  {Integer}    migrateid
 */
event("onPlayerCharacterCreate", function(playerid, firstname, lastname, nationality, race, sex, birthdate, cskin, migrateid) {

    if (!isPlayerAuthed(playerid)) return dbg("character", "create with no auth", getIdentity(playerid));

    // are we migrating character
    if (migrateid != "0") {
        dbg("character", "migrating", migrateid, getIdentity(playerid), firstname, lastname, nationality, race, sex, birthdate, cskin);

        Character.findOneBy({ id = migrateid.tointeger(), name = getAccountName(playerid) }, function(err, character) {
            if (err || !character) {
                return alert(playerid, "character.doesnotexist");
            }

            if (character.firstname != "") {
                return alert(playerid, "character.alreadymigrated");
            }

            // try to update existing character
            return validateAndUpdateCharacter(playerid, character, firstname, lastname, nationality, race, sex, birthdate, cskin);
        });
    }

    // or we are creating new
    if(migrateid == "0") {

        dbg("character", "creating", null, getIdentity(playerid), firstname, lastname, nationality, race, sex, birthdate, cskin);

        Character.findBy({ name = getAccountName(playerid) }, function(err, characters) {
            if (err || characters.len() >= CHARACTER_LIMIT) {
                return alert(playerid, "character.limitexceeded");
            }

            // create emtpy character
            local character = Character();

            // override onspawn stuff (money, other shiet)
            local money = randomf(getSettingsValue("startedIncomeMin"), getSettingsValue("startedIncomeMax"));
            character.money = money;
            subWorldMoney(money);

            // try to create new character
            return validateAndUpdateCharacter(playerid, character, firstname, lastname, nationality, race, sex, birthdate, cskin);
        });
    }
});

/**
 * Event when player tries to load character
 */
event("onPlayerCharacterSelect", function(playerid, id) {
    if (!isPlayerAuthed(playerid)) return dbg("character", "select", "non-authed", getIdentity(playerid));

    dbg("selecting character with data", id.tointeger(), getAccountName(playerid));

    Character.findOneBy({ id = id.tointeger() }, function(err, character) {
        if (err || !character) {
            return alert(playerid, "character.doesnotexist");
        }

        // load character
        trigger("onPlayerCharacterLoaded", playerid, character);
        triggerClientEvent(playerid, "showPlayerModel");
        triggerClientEvent(playerid, "onPlayerInitMoney", character.money.tofloat());
        dbg("character", "selected", getIdentity(playerid));
    });
});


function validateCharacterName(firstname, lastname) {
    /**
     * Convert and validate string data
     */
    firstname = strip(firstname).slice(0, 1).toupper() + strip(firstname).slice(1).tolower();

    local regexpBadLastname = regexp(@"(nin|nina|ov|ova|ev|eva|off|iy|aya|zyan|nyan|dze|ko|da|lya|chuk|ik)$").search(lastname);

    if (!REGEX_FIRSTNAME.match(firstname) || !REGEX_LASTNAME.match(lastname) || firstname == lastname || regexpBadLastname) {
        return false;
    }

    return true;
}

function isCharacterNameBanned(firstname, lastname) {
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

    return banned;
}

// isCharacterNameAlreadyRegistered("Paolo", "Guerra")
function isCharacterNameAlreadyRegistered(firstname, lastname) {    /**
     * Check for used names
     */

    local found = false;
    Character.findBy({ firstname = firstname, lastname = lastname }, function(err, characters) {
        if (err || characters.len()) {
            found = true
        }
    });

    return found;
}

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
function validateAndUpdateCharacter(playerid, character, firstname, lastname, nationality, race, sex, birthdate, cskin) {

    if(!validateCharacterName(firstname, lastname)) {
        return alert(playerid, "character.wrongname", [], 10);
    }

    if(isCharacterNameBanned(firstname, lastname)) {
        return alert(playerid, "character.bannednames", [], 10);
    }

    if(isCharacterNameAlreadyRegistered(firstname, lastname)) {
        return alert(playerid, "character.alreadyregistered", [], 10);
    }

    // update data
    character.accountid   = getAccountId(playerid);
    character.name        = getAccountName(playerid);
    character.firstname   = firstname;
    character.lastname    = lastname;
    character.nationality = nationality;
    character.race        = race;
    character.sex         = sex == "1" ? 1 : 0;
    character.birthdate   = birthdate.tostring();
    character.cskin       = cskin.tointeger();
    character.dskin       = cskin.tointeger();

    // save char
    character.save();

    // add to container
    trigger("onPlayerCharacterLoaded", playerid, character);

    nano({
        "path": "discord-newcomers",
        "server": "ncrp",
        "channel": "newcomers",
        "name": format("%s %s", firstname, lastname)
    })
    nano({
        "path": "discord-newchar",
        "server": "ncrp",
        "channel": "admin",
        "text": format("Создан персонаж для аккаунта **%s**:\n%s %s", getAccountName(playerid), firstname, lastname)
    })

    return true;
}

function getOfflineCharacter(characterid, callbackFn) {
    local callback = function(err, target_character) {
        if (!xPlayers.has(characterid)) {
            xPlayers.add(characterid, target_character);
        }

        callbackFn(target_character)
    };

    if (xPlayers.has(characterid)) {
        callback(null, xPlayers[characterid]);
    } else {
        Character.findOneBy({ id = characterid }, callback);
    }
}


/*

    local qc = ORM.Query("select * from tbl_items where _entity = 'Item.Passport' and data->'$.fio' = concat(:firstname, ' ', :lastname) and STR_TO_DATE(data->'$.expires','\"%d.%m.%Y\"') >= STR_TO_DATE(:date, '%d.%m.%Y')");

    qc.setParameter("firstname", firstname);
    qc.setParameter("lastname",  lastname );
    qc.setParameter("date",  getDate() );

    qc.getResult(function(err, characters) {
        if (err || characters.len()) {
            return alert(playerid, "character.alreadyregistered", [], 10);
        }

        // альтернативный вариант проверки имён по наличию действующего паспорта.
    })
 */