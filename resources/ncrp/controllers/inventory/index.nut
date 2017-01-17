include("controllers/inventory/functions.nut");

const MAX_INVENTORY_SLOTS = 30;
const MAX_INVENTORY_WEIGHT = 10.0;



event("onPlayerConnect", function(playerid) {
    resetPlayerItems (playerid);
    trigger("onItemLoading", playerid, 1, 1, 1);
    trigger("onItemLoading", playerid, 2, 1, 2);
});


