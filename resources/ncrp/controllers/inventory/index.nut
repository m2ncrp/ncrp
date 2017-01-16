include("controllers/inventory/functions.nut");

const MAX_INVENTORY_SLOTS = 30;



event("onPlayerConnect", function(playerid) {
    initPlayerItems(playerid);
    trigger("onItemLoading", playerid, 1, 0, 10);// add item to playerid with id 1, amount 0, in 10 slot;
});


