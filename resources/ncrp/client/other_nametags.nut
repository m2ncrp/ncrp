event <- addEventHandler;

local players = array(MAX_PLAYERS, null);
local vectors = {};
local adminLimit = null;
local adminfScale = null;

// addEventHandler("onClientFramePreRender", function() {
//     for( local i = 0; i < MAX_PLAYERS; i++ ) {
//         if( i != getLocalPlayer() && isPlayerConnected(i) ) {
//             // Get the player position
//             local pos = getPlayerPosition( i );

//             // Get the screen position from the world
//             vectors[i] <- getScreenFromWorld( pos[0], pos[1], (pos[2] + 1.95) );
//         }
//     }
// });

local error = false;

event("onClientFrameRender", function(isGUIDrawn) {

    if (isGUIDrawn) return;

    for( local i = 0; i < MAX_PLAYERS; i++ )
    {
        if( i != getLocalPlayer() && isPlayerConnected(i) /* && isPlayerOnScreen(i) */ )
        {
            if (!(i in players) || !players[i]) continue;
            local limit     = adminLimit ? adminLimit : 12.0;
            local pos       = getPlayerPosition( i );
            local lclPos    = getPlayerPosition( getLocalPlayer() );
            local fDistance = getDistanceBetweenPoints3D( pos[0], pos[1], pos[2], lclPos[0], lclPos[1], lclPos[2] );
            if( fDistance <= limit /*&& i in vectors && vectors[i][2] <= 1.00005*/) {

                local fScale = adminfScale ? adminfScale : 1.05 - (((fDistance > limit) ? limit : fDistance) / limit);

                local color = adminLimit ? fromRGB(255, 255, 255, 213) : fromRGB(255, 255, 255, (50 + 125.0 * fScale).tointeger());
                if(adminLimit) {
                    local text = players[i] + " [" + i.tostring() + "]";
                    local dimensions = dxGetTextDimensions( text, fScale, "tahoma-bold" );
                    // dxDrawText( text, (vectors[i][0] - (dimensions[0] / 2))+1, vectors[i][1]+1, fromRGB(0, 0, 0, 255), false, "tahoma-bold", fScale );
                    // dxDrawText( text, (vectors[i][0] - (dimensions[0] / 2)), vectors[i][1]+1, color, false, "tahoma-bold", fScale );
                    dxDrawTextWorld(text, pos[0], pos[1], pos[2] + 1.95, color, M2NCRP_TAHOMA_BOLD, fScale);

                    continue;
                }
                local text = "[" + i.tostring() + "]";
                // local dimensions = dxGetTextDimensions( text, fScale, "tahoma-bold" );
                //dxDrawText( text, (vectors[i][0] - (dimensions[0] / 2)), vectors[i][1], color, false, "tahoma-bold", fScale );
                dxDrawTextWorld(text, pos[0], pos[1], pos[2] + 1.95, color, M2NCRP_TAHOMA_BOLD, fScale);
            }
        }
    }
});

event("onServerPlayerAdded", function(playerid, charname, isVerified) {
    players[playerid] = charname;
});

event("onClientPlayerDisconnect", function(playerid) {
    players[playerid] = null;
});

addEventHandler("onServerToggleNametags", function() {
    if (!adminLimit) {
        adminLimit = 4500.0;
        adminfScale = 1.0;
    } else {
        adminLimit = null;
        adminfScale = null;
    }
});
