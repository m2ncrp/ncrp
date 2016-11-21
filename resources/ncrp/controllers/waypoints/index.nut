include("controllers/waypoints/3dtext.nut");
include("controllers/waypoints/blip.nut");

ICON_RED        <- [0, 1];
ICON_YELLOW     <- [0, 2];
ICON_STAR       <- [0, 3];
/// do more

function createPlayerWaypoint(playerid, position, type, callback) {

}

// createPlayerWaypoint(0, pos, "#asdasd", ICON_STAR);

function createTextPlayerWaypoint(playerid) {

}

addEventHandlerEx("onServerStarted", function() {
    local text1 = create3DText(-419.275, 485.54, -0.0967727, "home of great inlufz", CL_LIGHTWISTERIA);
});

addEventHandler("onPlayerSpawn", function(playerid) {
    local text2 = createPrivate3DText(playerid, -419.275, 485.54, -0.5967727, "YAS YAS YAS BITCH", CL_BURNTORANGE);
});
