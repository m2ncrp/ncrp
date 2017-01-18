include("controllers/inventory/functions.nut");

const MAX_INVENTORY_SLOTS = 30;
const MAX_INVENTORY_WEIGHT = 10.0;

event("onServerPlayerStarted", function(playerid) {
    resetPlayerItems(playerid);

    local character = players[players];

    Item.Item.findBy({ type = ITEM_STATE.PLAYER_INV, parent = character.id }, function(err, items) {
        if (err || !items.len()) return;

        foreach (idx, item in items) {
            // item.itemid
            // item.amount
            // item.

            dbg("trying to add item with name", item.classname, "to player");
            trigger("onItemLoading", playerid, item.itemid, item.amount, item.slot);
        }
    });
});
