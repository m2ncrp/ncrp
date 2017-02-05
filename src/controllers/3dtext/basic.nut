local __3dtexts = {};
local __3dtext__autoincrement = 0;

function create3DTextForPlayer(textid, playerid) {
    if (!(textid in __3dtexts)) {
        return dbg("[3dtext] tried to send non-existent 3dtext.");
    }

    local text = __3dtexts[textid];

    trigger(playerid,
        "onServer3DTextAdd",
        textid,
        text.x.tofloat(),
        text.y.tofloat(),
        text.z.tofloat(),
        text.value.tostring(),
        text.color.toHex().tostring(),
        text.distance.tofloat()
    );

    return textid;
}

function remove3DTextForPlayer(textid, playerid) {
    triggerClientEvent(playerid, "onServer3DTextDelete", textid);
    return true;
}

function create3DTextForPlayers(textid) {
    foreach (playerid, player in players) {
        create3DTextForPlayer(textid, playerid);
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
    local textid = md5("5" + (__3dtext__autoincrement++));
    __3dtexts[textid] <- { uid = textid, x = x.tofloat(), y = y.tofloat(), z = z.tofloat(), value = text, color = color, distance = distance.tofloat(), private = private };
    return textid;
}

event("onServerPlayerStarted", function(playerid) {
    foreach (textid, t3d in __3dtexts) {
        if (t3d.private == -1) { create3DTextForPlayer(textid, playerid); }
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
    return create3DTextForPlayers( instantiate3DText(x, y, z, text, color, distance, -1) );
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
    return create3DTextForPlayer( instantiate3DText(x, y, z, text, color, distance, playerid), playerid );
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

/**
 * Rename 3d text
 * @param  {String} textid
 * @param  {String} text
 * @return {Boolean}
 */
function rename3DText(textid, text) {
    if (!(textid in __3dtexts)) {
        return false;
    }

    __3dtexts[textid].value = text;

    if (__3dtexts[textid].private != -1) {
        remove3DTextForPlayer(textid, __3dtexts[textid].private);
        create3DTextForPlayer(textid, __3dtexts[textid].private);
    } else {
        remove3DTextForPlayers(textid);
        create3DTextForPlayers(textid);
    }

    return true;
}
