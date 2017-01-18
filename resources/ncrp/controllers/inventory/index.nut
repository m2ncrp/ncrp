include("controllers/inventory/functions.nut");

const MAX_INVENTORY_SLOTS = 30;
const MAX_INVENTORY_WEIGHT = 10.0;

event("onServerPlayerStarted", function(playerid) {
    // resetPlayerItems(playerid);

    local character = players[playerid];

    Item.Item.findBy({ state = ITEM_STATE.PLAYER_INV, parent = character.id }, function(err, items) {
        //if (err || !items.len()) return;

        local slots = {};

        foreach (idx, item in items) {
            slots[item.slot] <- item;
        }

        for(local i = 0; i < MAX_INVENTORY_SLOTS; i++) {
            if (!(i in slots)) {
                slots[i] <- Item.None(i);
            }

            addPlayerItem(playerid, slots[i]);
        }
    });
});

event("onCharacterSave", function(playerid, character) {
    local items = getPlayerItems(playerid);

    foreach (idx, item in items) {
        item.save();
    }
});

key("i", function(playerid) {
    trigger(playerid, "onPlayerInventorySwitch");
});
