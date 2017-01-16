include("controllers/inventory/functions.nut");

const MAX_INVENTORY_SLOTS = 30;



event("onPlayerConnect", function(playerid) {
    initPlayerItems(playerid);
    trigger("onItemLoading", playerid, 1, 0, 1);
    trigger("onItemLoading", playerid, 2, 0, 2);
});


