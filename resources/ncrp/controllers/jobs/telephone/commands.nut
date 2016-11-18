cmd("phone", function(playerid) {
    local check = false;
    foreach (key, value in telephones) {
        if (isPlayerInValidPoint3D(playerid, value[0], value[1], value[2], 0.3)) {
        check = true;
        break;
        }
    }
    if(check) {
        msg(playerid, "Telephohe working");
    } else {
        msg(playerid, "Telephohe doesn't working");
    }
});


cmd("gotophone", function(playerid, phoneid) {
    local phoneid = phoneid.tointeger();
    setPlayerPosition( playerid, telephones[phoneid][0], telephones[phoneid][1], telephones[phoneid][2] );
});
