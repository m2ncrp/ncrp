include("controllers/admin/commands.nut");
include("controllers/admin/sqdebug.nut");
include("controllers/admin/teleport.nut");

local serverAdmins = [
    "CD19A5029AE81BB50B023291846C0DF3", // max
    "940A9BF3DC69DC56BCB6BDB5450961B4", // dima
    "E818234F219F14336D8FFD5C657B796C", // inlufz
    // add your serials there :p
];

function isPlayerAdmin(playerid) {
    return (serverAdmins.find(getPlayerSerial(playerid)) != null);
}

event("onPlayerTeleportRequested", function(playerid, x, y, z) {
    if (isPlayerAdmin(playerid)) {
        setPlayerPosition(playerid, x, y, z);
    }
});

event("onClientDebugToggle", function(playerid) {
    return (isPlayerAdmin(playerid)) ? trigger(playerid, "onServerDebugToggle") : null;
})

event("native:onConsoleInput", function(name, data) {
    switch (name) {
        case "list": dbg(getPlayers()); break;
        case "adm": sendPlayerMessageToAll("[ADMIN] " + data, CL_MEDIUMPURPLE.r, CL_MEDIUMPURPLE.g, CL_MEDIUMPURPLE.b); log("[ADMIN] " + data); break;
        case "lang": dumpTranslations(data.slice(0, 2), data.slice(3, 5)); break;
        case "test": dsdsd(); break;
    }
});

