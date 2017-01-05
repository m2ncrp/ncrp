ICON_RED          <- [0 ,  1];
ICON_YELLOW       <- [0 ,  2];
ICON_STAR         <- [0 ,  3];
ICON_CROSS        <- [0 ,  5];
ICON_MIC          <- [0 ,  6];
ICON_MASK         <- [0 ,  7];
ICON_GRAY         <- [0 ,  8];
ICON_CUP          <- [0 ,  9];
ICON_KNUCKLES     <- [0 , 10];
ICON_MAFIA        <- [0 , 11];
ICON_MAP          <- [0 , 12];
ICON_BURGER       <- [1 ,  4];
ICON_CLOTH        <- [2 ,  4];
ICON_BRUSKI       <- [3 ,  4];
ICON_WEAPON       <- [4 ,  4];
ICON_ARMY         <- [5 ,  4];
ICON_HOME         <- [6 ,  4];
ICON_GEAR         <- [7 ,  4];
ICON_FUEL         <- [9 ,  4];
ICON_BAR          <- [11,  4];
ICON_PHONE        <- [12,  4];
ICON_LOCK         <- [13,  4];
ICON_REPAIR       <- [14,  4];
ICON_TARGET       <- [17,  0];
ICON_LOGO_GREEN   <- [21,  0];
ICON_LOGO_YELLOW  <- [22,  0];
ICON_LOGO_RED     <- [23,  0];
ICON_LOGO_PINK    <- [24,  0];
ICON_LOGO_BLACK   <- [25,  0];

ICON_RANGE_FULL   <- 4000.0;

local __blips = {};
local __blip__autoincrement = 0;

function addBlipForPlayer(blipid, playerid) {
    if (!(blipid in __blips)) {
        return dbg("[blip] tried to send non-existent blip.");
    }

    local blip = __blips[blipid];
    triggerClientEvent(playerid, "onServerBlipAdd", blipid, blip.x, blip.y, blip.distance, blip.library, blip.icon);
    return blipid;
}

function removeBlipForPlayer(blipid, playerid) {
    triggerClientEvent(playerid, "onServerBlipDelete", blipid);
    return true;
}

function addBlipForPlayers(blipid) {
    foreach (playerid, player in players) {
        addBlipForPlayer(blipid, playerid);
    }
    return blipid;
}

function removeBlipForPlayers(blipid) {
    foreach (playerid, player in players) {
        removeBlipForPlayer(blipid, playerid);
    }
    return true;
}

function instantiateBlip(x, y, icon, distance, private) {
    local blipid = md5("5" + (__blip__autoincrement++));
    __blips[blipid] <- { uid = blipid, x = x.tofloat(), y = y.tofloat(), library = icon[0], icon = icon[1], distance = distance.tofloat(), private = private };
    return blipid;
}


event("onServerPlayerStarted", function(playerid) {
    foreach (blipid, blip in __blips) {
        if (!blip.private) { addBlipForPlayer(blipid, playerid); }
    }
});

/**
 * Create blip in postion with blip and color
 * returns created 3d blip id
 *
 * @param  {Float}  x
 * @param  {Float}  y
 * @param  {Icon}  icon
 * @param  {Float} distance
 * @return {Integer} blipid
 */
function createBlip(x, y, icon, distance = 75.0) {
    return addBlipForPlayers( instantiateBlip(x, y, icon, distance, false) );
}


/**
 * Create blip in postion with blip and color for player
 * returns created 3d blip id
 *
 * @param  {Integer} playerid
 * @param  {Float}  x
 * @param  {Float}  y
 * @param  {Icon}  icon
 * @param  {Float} distance
 * @return {Integer} blipid
 */
function createPrivateBlip(playerid, x, y, icon, distance = 75.0) {
    return addBlipForPlayer( instantiateBlip(x, y, icon, distance, true), playerid );
}

/**
 * Remove blip by blipid
 *
 * @param  {Integer} blipid
 * @return {Boolean}
 */
function removeBlip(blipid) {
    if (!(blipid in __blips)) {
        return dbg("[blip] tried to remove non-existent blip.");
    }

    removeBlipForPlayers(blipid);
    delete __blips[blipid];
    return true;
}

