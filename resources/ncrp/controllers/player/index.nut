include("controllers/player/classes/PlayerContainer.nut");
include("controllers/player/classes/Character.nut");
include("controllers/player/classes/SpawnPosition.nut");

include("controllers/player/functions.nut");
include("controllers/player/anticheat.nut");
include("controllers/player/afk.nut");
include("controllers/player/character.nut");
include("controllers/player/death.nut");
include("controllers/player/mute.nut");
include("controllers/player/positions.nut");
include("controllers/player/level.nut");
include("controllers/player/job.nut");
include("controllers/player/name.nut");
include("controllers/player/skin.nut");
include("controllers/player/falldown.nut");
include("controllers/player/commands.nut");

/**
 * Define player spawns
 * @type {Array}
 */
local defaultPlayerSpawns = [
    [-555.251,  1702.31, -22.2408], // railway
    [-344.028, -952.702, -21.7457], // new port
];

/**
 * Basic event for registraion
 * all aliases and containers
 */
event("onScriptInit", function() {
    // create storage for players
    players <- PlayerContainer();

    // register aliases (for old code)
    playerList  <- players;
    xPlayers    <- players;

    // create timer for player object "alive" check (not related to health in any way)
    timer(function() { players.each(function(pid) { trigger("onServerPlayerAlive", pid); }) }, 500, -1);
});

/**
 * Handle client pre-initialization
 */
event("onPlayerConnectInit", function(playerid, name, ip, serial) {
    setPlayerColour(playerid, 0x99FFFFFF); // whity
});

/**
 * Handle player starting
 */
event("onServerPlayerStarted", function(playerid) {
    local rednicks = [
        "Inlife", "Klo_Douglas"
    ];

    // admins
    if (rednicks.find(getAccountName(playerid)) != null) {
        setPlayerColour(playerid, 0x99FF3333);
    }

    // clear chat
    for (local i = 0;i < 14; i++) {
        msg(playerid, "", CL_BLACK);
    }
});

/**
 * Handle player initialization
 * (after player just logined or regitered)
 */
event("onPlayerInit", function(playerid) {
    Character.findOneBy({ name = getAccountName(playerid) }, function(err, character) {
        if (!character) {
            return trigger("onPlayerCharacterCreation", playerid);
        }

        // save player to storage
        players.add(playerid, character);

        // TODO(inlife): movo to character
        character.playerid = playerid;
        trigger("native:onPlayerSpawn", playerid);

        return trigger("onPlayerCharacterLoaded", playerid);
    });
});

/**
 * Handle player spawn event
 * Tirggers only for players which are already loaded (loaded character)
 */
event("native:onPlayerSpawn", function(playerid) {
    if (!isPlayerLoaded(playerid)) return;

    delayedFunction(calculateFPSDelay(playerid) + 1500, function() {
        screenFadeout(playerid, 1000);
    });

    // reset freeze and set default model
    freezePlayer(playerid, false);
    setPlayerModel(playerid, players[playerid].cskin);

    trigger("onPlayerSpawn", playerid);
    trigger("onPlayerSpawned", playerid);

    // set player position according to data
    setPlayerPosition(playerid, players[playerid].x, players[playerid].y, players[playerid].z);

    // maybe player spawned not far from spawn
    local isPlayerNearSpawn = isInRadius(playerid, DEFAULT_SPAWN_X, DEFAULT_SPAWN_Y, DEFAULT_SPAWN_Z, 5.0);

    // maybe position was not yet set or spanwed in 0, 0, 0
    if (players[playerid].getPosition().isNull() || isPlayerNearSpawn) {
        dbg("player", "spawn", getIdentity(playerid), "spawned on null or on spawn, warping to spawn...");

        // select random spawn
        local spawnID = random(0, defaultPlayerSpawns.len() - 1);

        local x = defaultPlayerSpawns[spawnID][0];
        local y = defaultPlayerSpawns[spawnID][1];
        local z = defaultPlayerSpawns[spawnID][2];

        setPlayerPosition(playerid, x, y, z);
        setPlayerHealth(playerid, 720.0);
    }
});

/**
 * Hnadle player exit
 */
event("native:onPlayerDisconnect", removePlayer);

/**
 * Save players on autoupdate
 * NOTE(inlife): better is to disable with high online
 */
event("onServerAutosave", function() {
    foreach (playerid, character in players) character.save();
});

/**
 * Increase player xp level (minutes)
 */
event("onServerMinuteChange", function() {
    foreach (playerid, character in players) character.xp++;
});

/**
 * Save player information
 * on some important events
 */
event([
    "onPlayerMoneyChanged",
    "onPlayerJobChanged",
    "onPlayerVehicleEnter",
    "onPlayerVehicleExit",
    "onPlayerStateChange",
],
function(playerid, a = null, b = null) {
    return isPlayerLogined(playerid) ? players[playerid].save() : false;
});

/**
 * Try to remove zombie objects
 * that might be left after some uptime for some reason
 */
event("onServerPlayerAlive", function(playerid) {
    if (!isPlayerConnected(playerid)) {
        players.remove(playerid);
    }

    if (!isPlayerLoaded(playerid)) return;

    // save in-memory pos
    // NOTE(inlife): might collide with other stuff
    // local pos = getPlayerPosition(playerid);
    // players[playerid].setPosition(pos[0], pos[1], pos[2]);
});






/**
 * OLD CODE LOWER
 */




// PlayerStates <- [
//     "free",   // 0
//     "cuffed", // 1
//     "tased"   // 2
// ];

// event("onPlayerInit", function(playerid, name, ip, serial) {
//     // reset screen data
//     trigger(playerid, "resetPlayerIntroScreen");

//     Character.findOneBy({ name = getPlayerName(playerid) }, function(err, char) {
//         if (err || !char) {
//             // create entity
//             char = Character();

//             // setup deafults
//             char.name    = getPlayerName(playerid);
//             char.spawnid = random(0, default_spawns.len() - 1);
//             char.money   = randomf(5.0, 10.0);
//             char.dskin   = defaultSkins[random(0, defaultSkins.len() - 1)];
//             char.cskin   = char.dskin;
//             char.health  = 720.0;

//             // save first-time created entity
//             char.save();
//         }

//         xPlayers[playerid] <- char;

//         // legacy data binding
//         // @deprecated
//         playerList.addPlayer(playerid, name, ip, serial);
//         players[playerid]                 <- {};
//         players[playerid]["request"]      <- {}; // need for invoice to transfer money
//         players[playerid]["job"]          <- (char.job.len() > 0) ? char.job : null;
//         players[playerid]["money"]        <- char.money;
//         players[playerid]["deposit"]      <- char.deposit;
//         players[playerid]["default_skin"] <- char.dskin;  // skin which buy by player
//         players[playerid]["skin"]         <- char.cskin;  // current skin
//         players[playerid]["spawn"]        <- char.spawnid;
//         players[playerid]["xp"]           <- char.xp;
//         players[playerid]["housex"]       <- char.housex;
//         players[playerid]["housey"]       <- char.housey;
//         players[playerid]["housez"]       <- char.housez;
//         players[playerid]["health"]       <- char.health;
//         players[playerid]["toggle"]       <- false;
//         players[playerid]["state"]        <- (char.state.len() > 0) ? char.state : "free";

//         // notify all that client connected (and data loaded)
//         trigger("onPlayerConnect", playerid, name, ip, serial);
//         trigger("native:onPlayerSpawn", playerid);

//         delayedFunction(1500, function() {
//             trigger("onServerPlayerStarted", playerid);
//             trigger(playerid, "onServerClientStarted", VERSION);
//             trigger(playerid, "onServerIntefaceCharacter", getLocalizedPlayerJob(playerid, "en"), getPlayerLevel(playerid) );
//             trigger(playerid, "onServerInterfaceMoney", getPlayerMoney(playerid));
//             screenFadeout(playerid, 500);

//             // try to undfreeze player
//             freezePlayer(playerid, false);
//             trigger(playerid, "resetPlayerIntroScreen");
//             delayedFunction(1000, function() { freezePlayer(playerid, false); });
//         });
//     });
// });

// function trySavePlayer(playerid) {
//     if (!(isPlayerLoaded(playerid)) || !(playerid in xPlayers)) {
//         return null;
//     }

//     // if player has crashed on spawn
//     if (isInRadius(playerid, DEFAULT_SPAWN_X, DEFAULT_SPAWN_Y, DEFAULT_SPAWN_Z, 5.0)) {
//         char.x = HOSPITAL_X;
//         char.y = HOSPITAL_Y;
//         char.z = HOSPITAL_Z;
//     }

//     // get instance
//     local char   = xPlayers[playerid];

//     // proxy data back to the model
//     char.money   = players[playerid]["money"];
//     char.deposit = players[playerid]["deposit"];
//     char.dskin   = players[playerid]["default_skin"];
//     char.cskin   = players[playerid]["skin"];
//     char.spawnid = players[playerid]["spawn"];
//     char.xp      = players[playerid]["xp"];
//     char.job     = (players[playerid]["job"]) ? players[playerid]["job"] : "";
//     char.health  = getPlayerHealth(playerid);
//     char.state   = getPlayerState(playerid);

//     // save it
//     char.save();
// }








