include("controllers/chat/functions.nut");
include("controllers/chat/commands.nut");

// settings
const NORMAL_RADIUS = 20.0;
const WHISPER_RADIUS = 4.0;
const SHOUT_RADIUS = 35.0;

// event handlers
addEventHandler("onPlayerChat", function(playerid, message) {
    inRadiusSendToAll(playerid, getAuthor( playerid ) + " says: " + message, NORMAL_RADIUS, CL_YELLOW);
    msg(playerid, message, CL_YELLOW);
    return false;
});
