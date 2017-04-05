include("controllers/inventory/classes");
include("controllers/inventory/inventories.nut");
// include("controllers/inventory/functions.nut"); // refactor

/**
 * Try to load player inventory
 * on player connected
 */
event("onPlayerConnect", function(playerid) {
    local character = players[playerid];
    local inventory = PlayerItemContainer(playerid);

    Item.findBy({ state = Item.State.PLAYER, parent = character.id }, function(err, items) {

        foreach (idx, item in items) {
            inventory.set(item.slot, item);
        }

        // save inv, add fill in empty slots
        // character.inventory.fillInEmpty();
    });

    character.inventory = inventory;
});

/**
 * Try to save player's items on character save
 */
event("onCharacterSave", function(playerid, character) {
    local items = character.inventory;

    foreach (idx, item in items) {
        item.save();
    }
});

key("i", function(playerid) {
    players[playerid].inventory.toggle(playerid);
});
