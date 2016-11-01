acmd("screen1", function(playerid) {
    sendPlayerMessage(playerid, "trying to fade in screen...");
    screenFadein(playerid, 1000, function() {
        sendPlayerMessage(playerid, "  -> done ?");
    });
});

acmd("screen2", function(playerid) {
    sendPlayerMessage(playerid, "trying to fade out screen...");
    screenFadeout(playerid, 1000, function() {
        sendPlayerMessage(playerid, "  -> done ?");
    });
});

acmd("screen3", function(playerid) {
    sendPlayerMessage(playerid, "trying to fade in-out screen...");
    screenFadeinFadeout(playerid, 2000, function() {
        sendPlayerMessage(playerid, "  -> done ?");
    });
});
