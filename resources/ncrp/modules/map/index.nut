// 
// Should be independent module that loads data only from database 
// or include some by itself (if it's static in game data, such as subway stations).
// 
// PROBLEM: if there's no TRAIT on mod module won't work at all
// 

local bisnessies     = {};
local jobs           = {};
local fuelstations   = {};
local carrents       = {};
local carwashes      = {};
local subwaystations = {};


event("onServerStarted", function() {
    log("[MAP] loading all data...");
    Business.findAll(function(err, results) {
        foreach (idx, business in results) {
            // Fill da bisnessies
        }
    });

    // Load jobs pos
    // 
    // Load fuel station pos
    // 
    // Load car rent pos
    // 
    // Load car washes pos
    // 
    // Load subway station pos
});


event("onMapShowing", function( playerid ) {
    // change all the icons distance draw to maximum
});


event("onMapClosing", function( playerid ) {
    // change all the icons distance draw back to normal
});

key(["m"], function(playerid) {
    // if map is just opened call onMapShowing event
    // othervise call onMapClosing
});
