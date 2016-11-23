local __3dtexts = {};

function add3DTextForPlayer(textid, playerid) {
    if (!(textid in __3dtexts)) {
        return dbg("[3dtext] tried to send non-existent 3dtext.");
    }

    local text = __3dtexts[textid];
    triggerClientEvent(playerid, "onServer3DTextAdd", textid, text.x, text.y, text.z, text.value, text.color, text.distance);
    return textid;
}

function remove3DTextForPlayer(textid, playerid) {
    triggerClientEvent(playerid, "onServer3DTextDelete", textid);
    return true;
}

function add3DTextForPlayers(textid) {
    foreach (playerid, player in players) {
        add3DTextForPlayer(textid, playerid);
    }
    return textid;
}

function remove3DTextForPlayers(textid) {
    foreach (playerid, player in players) {
        remove3DTextForPlayer(textid, playerid);
    }
    return true;
}

function instantiate3DText(x, y, z, text, color, distance, private) {
    if (color instanceof Color) {
        color = color.toHex();
    }

    local textid = md5(time().tostring() + random(1111,9999).tostring());
    __3dtexts[textid] <- { uid = textid, x = x.tofloat(), y = y.tofloat(), z = z.tofloat(), value = text, color = color, distance = distance.tofloat(), private = private };
    return textid;
}

addEventHandler("onPlayerSpawn", function(playerid) {
    foreach (textid, t3d in __3dtexts) {
        if (!t3d.private) { add3DTextForPlayer(textid, playerid); }
    }
});

/**
 * Create 3d text in postion with text and color
 * returns created 3d text id
 *
 * @param  {Float}  x
 * @param  {Float}  y
 * @param  {Float}  z
 * @param  {String}  text
 * @param  {Color}  color
 * @param  {Float} distance
 * @return {Integer} textid
 */
function create3DText(x, y, z, text, color, distance = 35.0) {
    return add3DTextForPlayers( instantiate3DText(x, y, z, text, color, distance, false) );
}


/**
 * Create 3d text in postion with text and color for player
 * returns created 3d text id
 *
 * @param  {Integer} playerid
 * @param  {Float}  x
 * @param  {Float}  y
 * @param  {Float}  z
 * @param  {String}  text
 * @param  {Color}  color
 * @param  {Float} distance
 * @return {Integer} textid
 */
function createPrivate3DText(playerid, x, y, z, text, color, distance = 35.0) {
    return add3DTextForPlayer( instantiate3DText(x, y, z, text, color, distance, true), playerid );
}

/**
 * Remove 3d text by textid
 *
 * @param  {Integer} textid
 * @return {Boolean}
 */
function remove3DText(textid) {
    if (!(textid in __3dtexts)) {
        return dbg("[3dtext] tried to remove non-existent 3dtext.");
    }

    remove3DTextForPlayers(textid);
    delete __3dtexts[textid];
    return true;
}
