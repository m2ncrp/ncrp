local guiRegister = {};

// reset data for new player
event("onServerPlayerStarted", function(playerid) {
    guiRegister[playerid] <- {};
});

event("onClientGuiAction", function(playerid, guiid, raw) {
    if (!isPlayerLogined(playerid)) {
        return;
    }

    if (!(guiid in guiRegister[playerid])) {
        return dbg("gui", "trying to interact with non-existent gui");
    }

    local object = {
        close = function() {
            trigger(playerid, "onServerGuiClosed", guiid);
        }
    };

    local data;

    try {
        data = JSONParser.parse(raw);
    } catch (e) {
        data = raw;
    }

    guiRegister[playerid][guiid].call(object, playerid, data);
});

function gui(name, playerid, data, callback) {
    local guiid = md5(name);
    guiRegister[playerid][guiid] <- callback;
    trigger(playerid, "onServerGuiRequested", guiid, name, JSONEncoder.encode(data))
    return guiid;
}
