include("controllers/inventory/classes");
// include("controllers/inventory/functions.nut"); // refactor

/**
 * Try to load player inventory
 * on player connected
 */
event("onPlayerConnect", function(playerid) {
    local character = players[playerid];

    // Item.findBy({ state = Item.State.PLAYER, parent = character.id }, function(err, items) {
    //     local inventory = PlayerItemContainer(playerid);

    //     foreach (idx, item in items) {
    //         inventory.add(item.slot, item);
    //     }

    //     // save inv, add fill in empty slots
    //     character.inventory = inventory;
    //     character.inventory.fillInEmpty();
    // });
});

/**
 * Try to save player's items on character save
 */
event("onCharacterSave", function(playerid, character) {
    // local items = character.inventory;

    // foreach (idx, item in items) {
    //     item.save();
    // }
});

key("i", function(playerid) {
    if (!isPlayerLoaded(playerid)) return;
    players[playerid].inventory.toggle(playerid);
});
