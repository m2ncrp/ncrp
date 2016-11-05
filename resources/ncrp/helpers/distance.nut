/**
 * Return distance between two players by their ids
 * 
 * @param  {int}    senderID    id who call command
 * @param  {int}    targetID    id distance to who need to know
 * @return {float}  distance
 */
function getDistance( senderID, targetID ) {
    local p1 = getPlayerPosition( senderID );
    local p2 = getPlayerPosition( targetID );

    return getDistanceBetweenPoints3D(p1[0], p1[1], p1[2], p2[0], p2[1], p2[2]);
}

/**
 * Call function if player in radius
 * 
 * @param  {int}      playerid
 * @param  {int}      targetid
 * @param  {float}    radius   
 * @param  {Function} callback 
 * @return {void}
 */
function intoRadiusDo(playerid, targetid, radius, callback) {
    if (targetid == null) {
        msg(playerid, "There's no such player.", CL_RED);
        return;
    }
    if (callback != null && getDistance(playerid, targetid) <= radius)
        callback();
}

/**
 * Call function if player out of radius
 * 
 * @param  {int}      playerid
 * @param  {int}      targetid
 * @param  {float}    radius   
 * @param  {Function} callback 
 * @return {void}
 */
function outofRadiusDo(playerid, targetid, radius, callback) {
    if ( targetid == null ) {
        msg(playerid, "There's no such player.", CL_RED);
        return;
    }
    if (callback != null && getDistance(playerid, targetid) > radius)
        callback();
}

/**
 * Send message to all players in radius
 * 
 * @param  {int}        sender  
 * @param  {string}     message 
 * @param  {float}      radius  
 * @param  {RGB object} color   
 * @return {void}       
 */
function inRadiusSendToAll(sender, message, radius, color = 0) {
    local players = playerList.getPlayers();
    foreach(player in players) {
        intoRadiusDo(sender, player, radius, function() {
            if (color) {
                msg(player, message, color);
            } else {
                msg(player, message);
            }
        });
    }
}
