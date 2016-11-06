/**
 * Return string "player_name[playerid]"
 * @param  {int} 	playerid
 * @return {string}
 */
function getAuthor( playerid ) {
	return getPlayerName( playerid.tointeger() ) + "[" + playerid.tostring() + "]";
}

/**
 * Return string "player_name(#playerid)"
 * @param  {int} 	playerid
 * @return {string}
 */
function getAuthor2( playerid ) {
    return getPlayerName( playerid.tointeger() ) + "(#" + playerid.tostring() + ")";
}

/**
 * Send message to all players in radius
 * @param  {int}        sender
 * @param  {string}     message
 * @param  {float}      radius
 * @param  {RGB object} color
 * @return {void}
 */
function inRadiusSendToAll(sender, message, radius, color = 0) {
    local players = playerList.getPlayers();
    foreach(player in players) {
        if ( isBothInRadius(sender, player, radius) ) {
            if (color) {
                msg(player, message, color);
            } else {
                msg(player, message);
            }
        }
    }
}
