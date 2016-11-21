local __3dtexts = [];

function add3DTextForPlayer(textid, playerid) {
    if (!(textid in __3dtexts)) {
        return dbg("[3dtext] tried to send non-existent 3dtext.");
    }

    local text = __3dtexts[textid];
    return triggerClientEvent(playerid, "onServer3DTextAdd", textid, text.x, text.y, text.z, text.value, text.color, text.shadow);
}

function remove3DTextForPlayer(textid, playerid) {
    return triggerClientEvent(playerid, "onServer3DTextDelete", textid);
}

function add3DTextForPlayers(textid) {
    foreach (playerid, player in players) {
        add3DTextForPlayer(textid, playerid);
    }
}

function remove3DTextForPlayers(textid) {
    foreach (playerid, player in players) {
        remove3DTextForPlayer(textid, playerid);
    }
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
 * @param  {Boolean} shadow
 * @return {Integer} textid
 */
function create3DText(x, y, z, text, color, shadow = false) {
    if (color instanceof Color) {
        color = color.toHex();
    }

    __3dtexts.push({ x = x, y = y, z = z, value = text, color = color, shadow = shadow, private = false });
    local textid = __3dtexts.len() - 1;
    add3DTextForPlayers(textid);
    return textid;
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
 * @param  {Boolean} shadow
 * @return {Integer} textid
 */
function createPrivate3DText(playerid, x, y, z, text, color, shadow = false) {
    if (color instanceof Color) {
        color = color.toHex();
    }

    __3dtexts.push({ x = x, y = y, z = z, value = text, color = color, shadow = shadow, private = true });
    local textid = __3dtexts.len() - 1;
    add3DTextForPlayer(textid, playerid);
    return textid;
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

    __3dtexts.remove(textid);
    remove3DTextForPlayers(textid);
    return true;
}
