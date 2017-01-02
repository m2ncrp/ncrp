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
    local pos = getPlayerPosition(playerid);
    players[playerid].setPosition(pos[0], pos[1], pos[2]);
});
