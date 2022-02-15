include("controllers/player/classes/BannedName.nut");

local BASIC_BANNED_NAMES = [
    "Adriano", "Akula", "Altair", "Andriano", "Angello", "Angelo", "Barbara", "Barbaro", "Beckham", "Belik", "Black Akula", "Black Shark", "Bruski", "Canon", "Capone", "Carleona", "Carleone", "Celentano", "Chelentano", "Chuck Norris", "Claus", "Clemenente", "Clemente", "Connor Kenway", "Corleone", "Danil", "David Beckham", "Denis", "Deniz", "denizodin", "Derek", "Desmond Mails", "Desmond Miles", "Don", "Don Corleone", "Don Scaletta", "English", "Ernesto Guevara", "Ezio Auditore", "Falcone", "Falkone", "falouut", "Flash", "Folcone", "Folkone", "Frank", "Frankie Potts", "fuck", "Galanta", "Galante", "Galanto", "Gordon Freeman", "Gordon Freemen", "Gordon Friman", "Gordon Frimen", "Guevara", "Gurino", "Hack", "HankB", "Ilya", "Ivan", "Ivliev", "Joe", "Joe Barbara", "Joe Barbaro", "Joe Barbera", "Joe Barbero", "Karleone", "KoT", "Leo", "Leo Galante", "Leo Scarper", "Luca Gurino", "Maks", "Marlboro", "Multiplayer", "Nico", "Norris", "Null", "Nya", "Pahom", "PANDA", "Papalardo", "Pappalardo", "Phone", "Player", "Popa", "PornoHub", "Santa", "Santa Claus", "Santa Klaus", "Scaleta", "Scaleto", "Scaletta", "Scalette", "Scaletto", "Sckalette", "Sergei", "Sicilia", "Skaleta", "Skaleto", "Skaletta", "Skaletto", "Skalleta", "Sobakin", "Spajsi", "Spam", "Tamasina", "Tom Angela", "Tom Angelo", "Tomas Angela", "Tomas Angelo", "Tomasina", "Tomasino", "Tommy Angela", "Tommy Angelo", "Vanya", "Vendetta", "Vinchi", "Vinci", "Vita", "Vitalik", "Vitalik Skaletta", "Vito", "Vito Scaletta", "Vitorio", "Vladones", "you", "Zidan", "Zidane", "Ruslan",
];

translate("en", {
    "character.invalid.rpname" : "Invalid (NON-RP) Character name. Character name will be resetted! Please create new one! Your money and other will be saved."
})

event("onServerStarted", function() {
    BannedName.findAll(function(err, bannednames) {
        if (bannednames.len() > 0) return;

        foreach (idx, value in BASIC_BANNED_NAMES) {
            local name = BannedName();
            local parts = split(value, " ");

            if (parts.len() == 2) {
                name.firstname = parts[0];
                name.lastname  = parts[1];
            } else {
                name.firstname = value;
            }

            name.created = time();
            name.save();
        }

        dbg("server", "bannednames", "saved " + BASIC_BANNED_NAMES.len() + " banned names.");
    });
});

/**
 * Command for banning player charcter name
 * by his id, and removing his character
 * Usage:
 *     /banname 15
 */
acmd("banname", function(playerid, sessionId, subject = 0) {
    local sessionId = sessionId.tointeger();
    local targetid = getPlayerIdByPlayerSessionId(sessionId);

    if (!isPlayerLoaded(targetid)) {
        return msg(playerid, "Player character is not yet loaded, wait!");
    }

    local fullName = getPlayerName(targetid);

    local parts = split(fullName, " ");

    if (parts.len() != 2) {
        return msg(playerid, "Could not parse name " + fullName);
    }

    if(subject == 0) {
        msg(playerid, "Вторым параметром необходимо указать некорректную часть:");
        msg(playerid, "  first - имя: %s", parts[0]);
        msg(playerid, "  last - фамилия: %s", parts[1]);
        msg(playerid, "  both - отдельно имя: %s, отдельно фамилия: %s", [parts[0], parts[1]]);
        msg(playerid, "  pair - имя и фамилия вместе: %s", fullName);
        return msg(playerid, "Например: /banname 9 last");
    }

    local ban = BannedName();

    // Badname: Durak Johnson
    if(subject == "first") {
        ban.firstname = parts[0];
        msg(playerid, "Будет заблокировано: %s", parts[0]);
    }

    // Badname: James Durak
    if(subject == "last") {
        ban.firstname = parts[1];
        msg(playerid, "Будет заблокировано: %s", parts[1]);
    }

    // Badname: Durak Mudak
    if(subject == "both") {
        ban.firstname = parts[0];
        msg(playerid, "Будет заблокировано: %s и %s", [parts[0], parts[1]]);

        local ban2   = BannedName();
        ban2.firstname = parts[1];
        ban2.created   = time();
        ban2.save();
    }

    // Badname: Chuck Norris
    if(subject == "pair") {
        ban.firstname = parts[0];
        ban.lastname  = parts[1];
        msg(playerid, "Будет заблокировано: %s", fullName);
    }

    ban.created   = time();
    ban.save();

    local character = players[targetid];
    kick(playerid, targetid, plocalize(targetid, "character.invalid.rpname"));
    delayedFunction(1000, function() {
        dbg("admin", "player", "bannedname", "removing character", character.firstname + " " character.lastname);
        character.firstname = "";
        character.lastname  = "";
        character.save();
        msg(playerid, "Успешно!", CL_SUCCESS);
    });
});
