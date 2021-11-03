nativeSetPlayerModel <- setPlayerModel;
nativeGetPlayerModel <- getPlayerModel;

/**
 * Set temp (visual) player model
 * also, if pass false as 3rd parameter
 * it will set this skin as default (after job exiting or whatever)
 *
 * @param {Integer}  playerid
 * @param {Integer}  skin
 * @param {Boolean}  forced
 */

local skinData = {
    "39" : {"race": 1, "sex": 0},
    "40" : {"race": 1, "sex": 0},
    "41" : {"race": 1, "sex": 0},
    "42" : {"race": 1, "sex": 0},
    "43" : {"race": 1, "sex": 0},
    "44" : {"race": 1, "sex": 0},
    "45" : {"race": 1, "sex": 0},
    "47" : {"race": 1, "sex": 1},
    "48" : {"race": 2, "sex": 0},
    "49" : {"race": 2, "sex": 0},
    "50" : {"race": 2, "sex": 0},
    "51" : {"race": 2, "sex": 0},
    "52" : {"race": 2, "sex": 0},
    "53" : {"race": 2, "sex": 0},
    "53" : {"race": 2, "sex": 1},
    "56" : {"race": 2, "sex": 1},
    "57" : {"race": 2, "sex": 1},
    "58" : {"race": 2, "sex": 1},
    "59" : {"race": 2, "sex": 1},
    "70" : {"race": 2, "sex": 1},
    "71" : {"race": 0, "sex": 0},
    "72" : {"race": 0, "sex": 0},
    "73" : {"race": 0, "sex": 0},
    "74" : {"race": 0, "sex": 0},
    "77" : {"race": 2, "sex": 0},
    "78" : {"race": 1, "sex": 0},
    "79" : {"race": 2, "sex": 0},
    "80" : {"race": 0, "sex": 0},
    "81" : {"race": 0, "sex": 0},
    "82" : {"race": 0, "sex": 0},
    "83" : {"race": 0, "sex": 0},
    "84" : {"race": 0, "sex": 0},
    "85" : {"race": 0, "sex": 0},
    "86" : {"race": 0, "sex": 0},
    "87" : {"race": 0, "sex": 0},
    "88" : {"race": 0, "sex": 0},
    "89" : {"race": 0, "sex": 0},
    "90" : {"race": 0, "sex": 0},
    "91" : {"race": 0, "sex": 0},
    "92" : {"race": 0, "sex": 0},
    "93" : {"race": 0, "sex": 0},
    "94" : {"race": 0, "sex": 0},
    "95" : {"race": 0, "sex": 0},
    "96" : {"race": 0, "sex": 0},
    "97" : {"race": 0, "sex": 0},
    "98" : {"race": 0, "sex": 0},
    "99" : {"race": 0, "sex": 0},
    "100" : {"race": 0, "sex": 0},
    "101" : {"race": 0, "sex": 0},
    "102" : {"race": 0, "sex": 0},
    "103" : {"race": 0, "sex": 0},
    "104" : {"race": 0, "sex": 0},
    "105" : {"race": 0, "sex": 0},
    "106" : {"race": 0, "sex": 0},
    "107" : {"race": 0, "sex": 0},
    "108" : {"race": 0, "sex": 0},
    "109" : {"race": 0, "sex": 0},
    "110" : {"race": 0, "sex": 0},
    "111" : {"race": 0, "sex": 0},
    "117" : {"race": 0, "sex": 0},
    "118" : {"race": 0, "sex": 1},
    "119" : {"race": 0, "sex": 1},
    "120" : {"race": 0, "sex": 1},
    "121" : {"race": 0, "sex": 1},
    "122" : {"race": 0, "sex": 1},
    "123" : {"race": 0, "sex": 0},
    "124" : {"race": 0, "sex": 0},
    "125" : {"race": 0, "sex": 0},
    "126" : {"race": 0, "sex": 0},
    "127" : {"race": 0, "sex": 0},
    "129" : {"race": 1, "sex": 0},
    "131" : {"race": 0, "sex": 0},
    "134" : {"race": 0, "sex": 0},
    "135" : {"race": 0, "sex": 1},
    "137" : {"race": 0, "sex": 1},
    "138" : {"race": 0, "sex": 1},
    "139" : {"race": 0, "sex": 1},
    "140" : {"race": 0, "sex": 1},
    "141" : {"race": 0, "sex": 1},
    "142" : {"race": 0, "sex": 1},
    "143" : {"race": 0, "sex": 1},
    "147" : {"race": 0, "sex": 0},
    "148" : {"race": 0, "sex": 0},
    "149" : {"race": 0, "sex": 0},
    "162" : {"race": 0, "sex": 0},
    "163" : {"race": 1, "sex": 0},
    "164" : {"race": 2, "sex": 0}
}

function getSkinData(id) {
    return skinData[id.tostring()];
}

function getSkinsData() {
    return skinData;
}

function setPlayerModel(playerid, skin, forced = false) {
    nativeSetPlayerModel(playerid, skin.tointeger());

    if (isPlayerLoaded(playerid)) {
        // save temp skin
        players[playerid].cskin = skin.tointeger();

        // if not temp, set also main skin
        if (forced) players[playerid].dskin = skin.tointeger();
    }

    return true;
}

/**
 * Reload player model forcing player to appear
 * @param  {Integer} playerid
 */
function reloadPlayerModel(playerid) {
    local oldmodel = getPlayerModel(playerid);
    setPlayerModel(playerid, 10);

    delayedFunction(1000, function() {
        setPlayerModel(playerid, oldmodel);
    });
}

/**
 * Restore player model to default skin
 * @param  {Integer} playerid
 * @return {Boolean} result of execution
 */
function restorePlayerModel(playerid) {
    return (isPlayerLoaded(playerid)) ? setPlayerModel(playerid, players[playerid].dskin) : false;
}

/**
 * Get default player model
 * @param  {Integer} playerid
 * @return {Integer}
 */
function getDefaultPlayerModel(playerid) {
    return isPlayerLoaded(playerid) ? players[playerid].dskin : 0;
}

/**
 * Get current player model
 * @param  {Integer} playerid
 * @return {Integer}
 */
function getPlayerModel(playerid) {
    return isPlayerLoaded(playerid) ? players[playerid].cskin : 0;
}

/**
 * Register aliases
 */
setPlayerSkin <- setPlayerModel;
getPlayerSkin <- getPlayerModel;
getDefaultPlayerSkin <- getDefaultPlayerModel;
