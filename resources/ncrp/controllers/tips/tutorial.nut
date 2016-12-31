local spawnHelperPositions = [
    [-557.706, 1698.31, -22.2408, "Paulo Matti"], // train station
    [ -342.6, -952.716, -21.7457, "Edgard Ross"], // port
];

local spawnHelperMessages = {};
local playerCache = {};

const TUTORIAL_AMOUNT_SOFT_LIMIT = 1000;
const TUTORIAL_RADIUS = 3.0;

translation("en", {
    "tutorial.continue" :  "(( Press E to continue... ))"
    "turorial.spawn.1"  :  "Hey there friend, i see you've just arrived there. If you need any help - i'll be glad to help."
    "tutorial.spawn.2"  :  "You are in the Empire Bay, city where you can make your own story. But in order to survive here - you need money."
    "tutorial.spawn.3"  :  "You can earn money in several ways. Some people choose legal jobs, but some are going dark ways."
    "tutorial.spawn.4"  :  "I would recommend you to work as a docker in port or station porter on railway terminal."
    "tutorial.spawn.5"  :  "To travel around the city you can use taxi and subway or you could rent a car."
    "tutorial.spawn.6"  :  "Oh, right! You can actually buy your own car. Not even one! But you have to work for it!"
    "tutorial.spawn.7"  :  "Anyways, thanks for stopping by. And i wish you luck!"
    "tutorial.spawn.8"  :  "Oh, you want me to tell you one more time? Sure!"
});

/**
 * Register texts
 */
event("onServerStarted", function() {
    // NOTE(inlife): dynamic comparing logic ahead
    foreach (lang, dict in  __translations) {
        spawnHelperMessages[lang] <- [];

        for (local i = 1; i < TUTORIAL_AMOUNT_SOFT_LIMIT; i++) {
            local key = "tutorial.spawn." + i;

            // copy translation key to this array
            if (key in dict && spawnHelperMessages[lang].find(key) == null) {
                spawnHelperMessages[lang].push(key);
            }
        }
    }

    // create helper text for peds
    foreach (idx, pos in spawnHelperPositions) {
        create3DText ( pos[0], pos[1], pos[2] + 0.20, "Press E to talk", CL_WHITE.applyAlpha(150), TUTORIAL_RADIUS );
        create3DText ( pos[0], pos[1], pos[2] + 1.0, "== TUTORIAL ==", CL_ROYALBLUE, 15.0);
    }
});

/**
 * Bind on key
 */
key("e", function(playerid) {
    foreach (idx, pos in spawnHelperPositions) {
        if (!isInRadius(playerid, pos[0], pos[1], pos[2], TUTORIAL_RADIUS)) {
            continue;
        }

        // player is near the spawn helper
        local playername = getPlayerName(playerid);

        // set default help message id
        if (!(playername in playerCache)) {
            playerCache[playername] <- 0;
        }

        local lang = getPlayerLocale(playerid);

        if (playerCache[playername] >= spawnHelperMessages[lang].len()) {
            playerCache[playername] = 0;
        }

        msg(playerid, "------------------------------------------------------------------------", CL_WHITE);
        msg(playerid, pos[3] + ":  " + plocalize(playerid, spawnHelperMessages[lang][playerCache[playername]++]), CL_EUCALYPTUS);

        if (playerCache[playername] == 1) {
            msg(playerid, "tutorial.continue");
        }

        msg(playerid, "");
    }
});
