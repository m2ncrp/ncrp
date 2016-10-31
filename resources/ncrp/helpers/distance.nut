function getDistance( senderID, targetID )
{
    local p1 = getPlayerPosition( senderID );
    local p2 = getPlayerPosition( targetID );

    return getDistanceBetweenPoints3D(p1[0], p1[1], p1[2], p2[0], p2[1], p2[2]);
}

function inRadius(message, sender, radius, color = 0)
{
    local players = playerList.getPlayers();
    foreach(player in players) {
        if (getDistance(sender, player) <= radius) {
            if (color)
                sendPlayerMessage(player, message, color.r, color.g, color.b);
            else
                sendPlayerMessage(player, message);
        }
    }
}
