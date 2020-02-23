include("controllers/admin/sqdebug.nut");

include("controllers/admin/commands/ban.nut");
include("controllers/admin/commands/kick.nut");
include("controllers/admin/commands/mute.nut");
include("controllers/admin/commands/warn.nut");
include("controllers/admin/commands/chat.nut");
include("controllers/admin/commands/help.nut");
include("controllers/admin/commands/item.nut");
include("controllers/admin/commands/vehicleKey.nut");
include("controllers/admin/commands/player.nut");
include("controllers/admin/commands/restart.nut");
include("controllers/admin/commands/teleport.nut");
include("controllers/admin/commands/tp.nut");
include("controllers/admin/commands/under-construction.nut");
include("controllers/admin/commands/vehicles.nut");
include("controllers/admin/commands/weapons.nut");
include("controllers/admin/translations.nut");

local serverAdmins = {};

//serverAdmins["CD19A5029AE81BB50B023291846C0DF3"] <- 1; // max
//serverAdmins["83CA98D93A29F5F548E65E4DBBA41379"] <- 1; // max 2
serverAdmins["940A9BF3DC69DC56BCB6BDB5450961B4"] <- 1; // dima
serverAdmins["D1E935B71230527DA46FDB0E4CB53157"] <- 1; // tom sanrea
//serverAdmins["E818234F219F14336D8FFD5C657B796C"] <- 1; // inlufz
//serverAdmins["EBD8F16123FA9DE5C3C64D64FF844953"] <- 1; // inlufz 2
//serverAdmins["7980C4CF5E2DAAF062DF7AE08B6DDE67"] <- 1; // Bertone
//serverAdmins["68D6A6A2A380766FC30CA5C2B01F212F"] <- 1; // kloO
//serverAdmins["0B4856B787A508D58E3330A2DAB7914C"] <- 1; // zaklaus
//serverAdmins["1896AD32EFA8A60BDD3CC2F6197F40DC"] <- 1; // member3
//serverAdmins["856BE506BCEAEEC908F3577ABEFF9171"] <- 1; // Oliver
//serverAdmins["981506EF83BF42095A62407C696A8515"] <- 1; // Franko


// add your serials there :p

function isPlayerServerAdmin(playerid) {
    return (getPlayerSerial(playerid) in serverAdmins);
}

function isPlayerAdmin(playerid) {

    if(!fractions.exists("admin") || !players.has(playerid)) {
        return false;
    }

    local character = players[playerid];
    if(!fractions.admin.members.exists(character)) {
        return false;
    }
    return true;
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
    return (isPlayerAdmin(playerid) && isPlayerInVehicle(playerid) == false) ? trigger(playerid, "onServerDebugToggle") : null;
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
