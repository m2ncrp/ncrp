// 
// Should be independent module that loads data only from database 
// or include some by itself (if it's static in game data, such as subway stations).
// 


local bisnessies     <- {};
local jobs           <- {};
local fuelstations   <- {};
local carrents       <- {};
local carwashes      <- {};
local subwaystations <- {};


key(["m"], function(playerid) {
    // if map is just opened call onMapShowing event
    // othervise call onMapClosing
};


event("onMapShowing", function( playerid ) {
    // change all the icons distance draw to maximum
});


event("onMapClosing", function( playerid ) {
    // change all the icons distance draw back to normal
});
