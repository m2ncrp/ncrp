include("controllers/organizations/hobos/commands.nut");

local spawnID = 1;
const DIG_RADIUS = 1.5;
const HOBO_MODEL = 153;

const maxCouldFind = 0.1;
const minCouldFind = 0.01; 

hobos_points <- [
    [-2.9767,   1634.28, -20.0881], // at spawn
    [-156.04,   1652.85, -20.5015],
    [-141.525,  1704.43, -18.8222],
    [-136.286,  1599.79, -23.4949],
    [-67.6329,  1630.46, -20.9530], // out of Bruski
    [-65.0767,  1639.13, -20.7715], // out of Bruski
    [-232.637,  1724.4,  -22.8568],
    [-266.9,    1713.32, -22.3107],
    [-376.078,  1612.63, -23.5604], // near railway station
    [-488.75,   1589.41, -23.7143],
    [-493.919,  1609.92, -23.8160],
    [-503.599,  1601.46, -23.6392],
    [-496.597,  1631.0,  -23.8915],
    [-499.549,  1641.31, -23.8815],
    [-780.195,  1426.05, -7.11043],
    [-849.077,  1417.16, -9.11326]
];


function isHobos(playerid) {
    return players[playerid]["spawn"] == spawnID;
}

function isNearTrash(playerid) {
    foreach (point in hobos_points) {
        if ( isInRadius(playerid, point[0], point[1], point[2], DIG_RADIUS) ) {
            return true;
        }
    }
    msg(playerid, "You are too far from any trash!", CL_YELLOW);
    return false;
}

addEventHandlerEx("onPlayerConnect", function(playerid, name, ip, serial) {
    if ( isHobos(playerid) ) {
        players[playerid]["skin"] <- HOBO_MODEL;
        players[playerid]["digtime"] <- null;
    }    
});

addEventHandler ( "onPlayerSpawn", function( playerid ) {
    setPlayerModel( playerid, players[playerid]["skin"] );
});


function isTimeToDig(playerid) {
    if (players[playerid]["digtime"] == null) {
        return true;
    }

    if (getTimestamp() > (players[playerid]["digtime"] + 150)) {
        return true;
    }

    return false;
}
