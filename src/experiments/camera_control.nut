acmd("camera", function(playerid, state) {
    if (state == "lock"){
        triggerClientEvent(playerid, "cameralock");
        } else {
        triggerClientEvent(playerid, "cameraunlock");
        }
    });
