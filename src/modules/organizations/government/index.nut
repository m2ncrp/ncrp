// nothing there yet :p
local coords = [-122.331, -62.9116, -12.041];

event("onServerStarted", function() {
    log("[organizations] government...");

    create3DText ( coords[0], coords[1], coords[2]+0.35, "SECRETARY OF GOVERNMENT", CL_ROYALBLUE, 4.0 );
    create3DText ( coords[0], coords[1], coords[2]+0.20, "/gov", CL_WHITE.applyAlpha(100), 2.0 );

    createBlip  ( coords[0], coords[1], [ 24, 0 ], 4000.0 );
});
