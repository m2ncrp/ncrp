include("controllers/business/kiosks/coords.nut");
include("controllers/business/kiosks/commands.nut");

local KIOSK_PREFIX = "Kiosk-";
local coords = getKiosksCoords();

local kiosks = {};
local kiosksCache = {};

function loadKiosk(kiosk) {
    kiosks[kiosk.name] <- kiosk;
}

function getKiosks() {
    return kiosks;
}

function getKioskEntity(name) {
    return kiosks[name];
}

function isPlayerNearKiosk(playerid) {
    local res = false;
    foreach (key, kiosk in coords) {
        if (isPlayerInValidPoint3D(playerid, kiosk.public[0], kiosk.public[1], kiosk.public[2], 0.4)) {
            res = kiosks[format("Kiosk%02d", key + 1)];
            break;
        }
    }

    return res;
}

function getKioskPosition(id) {
    return id in coords ? coords[id] : null;
}

addEventHandlerEx("onServerStarted", function() {
    logStr("[biz] loading kiosks...");

    // foreach (idx, kiosk in coords) {
    //     createPlace(format("%s%d", KIOSK_PREFIX, idx), kiosk.public[0] - 6.0, kiosk.public[1] - 6.0, kiosk.public[0] + 6.0, kiosk.public[1] + 6.0);
    // }
});

event("onServerPlayerStarted", function( playerid ){
    //creating public 3dtext
    foreach (key, kiosk in coords) {
        createPrivate3DText ( playerid, kiosk.public[0], kiosk.public[1], kiosk.public[2]+0.35, plocalize(playerid, "NEWSSTAND"), CL_RIPELEMON, 6.0);
        // createPrivate3DText ( playerid, kiosk.public[0], kiosk.public[1], kiosk.public[2]+0.55, key.tostring(), CL_RIPELEMON, 6.0);
        createPrivate3DText ( playerid, kiosk.public[0], kiosk.public[1], kiosk.public[2]+0.20, plocalize(playerid, "3dtext.job.press.E"), CL_WHITE.applyAlpha(150), 0.4 );
    }
});

// event("onPlayerPlaceEnter", function(playerid, name) {
//     if (name.find(KIOSK_PREFIX) == null) {
//         return;
//     }
//
//     local station = getFuelStationEntity(name.slice(FUELSTATION_PREFIX.len()));
//     fuelStationCreatePrivateInteractions(playerid, station);
// });