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