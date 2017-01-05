include("controllers/admin/commands.nut");
include("controllers/admin/sqdebug.nut");
include("controllers/admin/teleport.nut");
include("controllers/admin/utils.nut");
include("controllers/admin/bans.nut");

local serverAdmins = {};

serverAdmins["CD19A5029AE81BB50B023291846C0DF3"] <- 1; // max
serverAdmins["940A9BF3DC69DC56BCB6BDB5450961B4"] <- 1; // dima
serverAdmins["E818234F219F14336D8FFD5C657B796C"] <- 1; // inlufz
serverAdmins["EBD8F16123FA9DE5C3C64D64FF844953"] <- 1; // inlufz 2
serverAdmins["68D6A6A2A380766FC30CA5C2B01F212F"] <- 1; // klo
serverAdmins["0B4856B787A508D58E3330A2DAB7914C"] <- 1; // zaklaus
serverAdmins["8721319F072CFE029B3CBB0E237D30B7"] <- 1;
    // add your serials there :p

function isPlayerAdmin(playerid) {
    return (getPlayerSerial(playerid) in serverAdmins);
}

function freezePlayer( targetid, value ) {
    togglePlayerControls( targetid.tointeger(), value );
    trigger( targetid.tointeger(), "onServerFreezePlayer", value );
}

function stopPlayerVehicle( targetid ) {
    if (isPlayerInVehicle( targetid )) {
        local vehicleid = getPlayerVehicle( targetid );
        setVehicleSpeed( vehicleid, 0.0, 0.0, 0.0 );
    }
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
        case "list": dbg("admin", "list", getPlayers()); break;
        case "adm": sendPlayerMessageToAll("[ADMIN] " + data, CL_MEDIUMPURPLE.r, CL_MEDIUMPURPLE.g, CL_MEDIUMPURPLE.b); dbg("[ADMIN] " + data); break;
        case "lang": compareTranslations(data.slice(0, 2), data.slice(3, 5)); break;
        case "tdmp": dumpTranslation(data.slice(0, 2)); break;
        case "test":
            local data = url_encode(base64_encode(format("%s: %s", "console", "testing...")));
            webRequest(HTTP_TYPE_GET, MOD_HOST, "/discord?type=test&data=" + data, function(a,b,c) {}, MOD_PORT);
        break;
        case "admin": handleAdminInput(split(data, " ")); break;
        case "migratedb": migrateSQLiteToMySQL(); break;
    }
});

// local a = null;
// acmd("tst", function(playerid, id) {
//     if (a) {
//         destroyVehicle(a);
//     }
//     local pos = getPlayerPosition( playerid );
//     a = createVehicle( id.tointeger(), pos[0] + 2.0, pos[1], pos[2] + 1.0, 0.0, 0.0, 0.0 );
// });
