/**
 * Define player spawns
 * @type {Array}
 */
local defaultPlayerSpawns = [
    [-555.251,  1702.31, -22.2408], // railway
    [-344.028, -952.702, -21.7457], // new port
];


local DEFAULT_SPAWN_PLACES = {
    greenfield = {
        position = [-1686.76,1092.44,1.35009],
        cam = [-1.0, -3.3, 1.9]
    }
}

const DEFAULT_SPAWN_PLACE = "greenfield";
const DEFAULT_SPAWN_SKIN = 1;

function getDefaultSpawn() {
    return DEFAULT_SPAWN_PLACES[DEFAULT_SPAWN_PLACE];
}

/**
 * Handle player spawn event
 * Triggers only for players which are already loaded (loaded character)
 */
function spawnPlayer(playerid) {
    if (!isPlayerLoaded(playerid)) {
        return setPlayerHealth(playerid, 720.0);
    }

    // draw default fadeout
    // screenFadeout(playerid, calculateFPSDelay(playerid) + 50000);

    // trigger native game fadeout to fix possible black screen
    // delayedFunction(calculateFPSDelay(playerid) + 1000, function() {
    //     nativeScreenFadeout(playerid, 100);
    //     screenFadeout(playerid, 250);
    // });

    // reset freeze and set default model
    freezePlayer(playerid, false);
    setPlayerModel(playerid, players[playerid].cskin);

    trigger("onPlayerSpawn", playerid);
    trigger("onPlayerSpawned", playerid);

    // set player position according to data
    setPlayerPosition(playerid, players[playerid].x, players[playerid].y, players[playerid].z);
    setPlayerHealth(playerid, players[playerid].health);

    local defaultSpawn = getDefaultSpawn();

    // maybe player spawned not far from spawn
    local isPlayerNearSpawn = (5.0 > getDistanceBetweenPoints3D (
        players[playerid].x, players[playerid].y, players[playerid].z
        defaultSpawn.position[0], defaultSpawn.position[1], defaultSpawn.position[2]
    ));

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

    // mark player as spawned
    // and available for saving coords
    players[playerid].spawned = true;
}

event("native:onPlayerSpawn", spawnPlayer)
