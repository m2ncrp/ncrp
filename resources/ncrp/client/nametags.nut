event <- addEventHandler;

local players = array(MAX_PLAYERS, null);
local vectors = {};

addEventHandler("onClientFramePreRender", function() {
    for( local i = 0; i < MAX_PLAYERS; i++ ) {
        if( i != getLocalPlayer() && isPlayerConnected(i) ) {
            // Get the player position
            local pos = getPlayerPosition( i );

            // Get the screen position from the world
            vectors[i] <- getScreenFromWorld( pos[0], pos[1], (pos[2] + 1.95) );
        }
    }
});


event("onClientFrameRender", function(isGUIDrawn) {
    if (isGUIDrawn) return;

    for( local i = 0; i < MAX_PLAYERS; i++ )
    {
        if( i != getLocalPlayer() && isPlayerConnected(i) && isPlayerOnScreen(i) )
        {
            if (!(i in players) || !players[i]) continue;

            local limit     = 40.0;
            local pos       = getPlayerPosition( i );
            local lclPos    = getPlayerPosition( getLocalPlayer() );
            local fDistance = getDistanceBetweenPoints3D( pos[0], pos[1], pos[2], lclPos[0], lclPos[1], lclPos[2] );

            if( fDistance <= 40.0 && i in vectors && vectors[i][2] < 1) {
                local fScale = 1.05 - (((fDistance > limit) ? limit : fDistance) / limit);

                local text = players[i] + " [" + i.tostring() + "]";
                local dimensions = dxGetTextDimensions( text, fScale, "tahoma-bold" );

                dxDrawText( text, (vectors[i][0] - (dimensions[0] / 2)), vectors[i][1], fromRGB(255, 255, 255, (125.0 * fScale).tointeger()), false, "tahoma-bold", fScale );
            }
        }
    }
});

event("onServerPlayerAdded", function(playerid, charname) {
    players[playerid] = charname;
});

event("onClientPlayerDisconnect", function(playerid) {
    players[playerid] = null;
});
