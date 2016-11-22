include("controllers/waypoints/3dtext.nut");
include("controllers/waypoints/blip.nut");

function createPlayerWaypoint(playerid, position, type, callback) {

}

// createPlayerWaypoint(0, pos, "#asdasd", ICON_STAR);

function createTextPlayerWaypoint(playerid) {

}

addEventHandlerEx("onServerStarted", function() {
    local text1 = create3DText(-419.275, 485.54, -0.0967727, "home of great inlufz", CL_LIGHTWISTERIA);
    local text1 = createBlip(-419.275, 485.54, ICON_STAR);
});

addEventHandler("onPlayerSpawn", function(playerid) {
    local text2 = createPrivate3DText(playerid, -419.275, 485.54, -0.5967727, "YAS YAS YAS BITCH", CL_BURNTORANGE);
});
