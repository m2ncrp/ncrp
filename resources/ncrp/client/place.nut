local placeRegistry = {};
local ticker = null;

addEventHandler("onServerPlayerStarted", function() {
    ticker = timer(onPlayerTick, 100, -1);
});

addEventHandler("onServerPlaceAdded", function(id, x1, y1, x2, y2) {
    if (!(id in placeRegistry)) {
        placeRegistry[id] <- [{ x = x1, y = y1 }, { x = x2, y = y2 }];
    }
});

addEventHandler("onServerPlaceRemoved", function(id) {

});

addEventHandler("onClientScriptExit", function() {
    ticker.Kill();
    ticker = null;
});

function onPlayerTick() {

}
