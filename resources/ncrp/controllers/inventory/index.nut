include("controllers/inventory/functions.nut");

const MAX_INVENTORY_SLOTS = 30;
const MAX_INVENTORY_WEIGHT = 10.0;



event("onPlayerConnect", function(playerid) {
    resetPlayerItems (playerid);
});


