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
    local hands     = PlayerHandsContainer(playerid);


    ORM.Query("select * from tbl_items where parent = :id and state in (:states)")
    .setParameter("id", character.id)
    .setParameter("states", concat([Item.State.PLAYER, Item.State.PLAYER_HAND], ","), true)
    .getResult(function(err, items) {
        foreach (idx, item in items) {
            if (item.state == Item.State.PLAYER_HAND) {
                hands.set(item.slot, item);
                continue;
            }

            inventory.set(item.slot, item);
        }
    });

    character.inventory = inventory;
    character.hands     = hands;
});

event("onServerPlayerStarted", function(playerid) {
    players[playerid].hands.toggle(playerid);
});

/**
 * Try to save player's items on character save
 */
event("onCharacterSave", function(playerid, character) {
    foreach (idx, item in character.inventory) item.save();
    foreach (idx, item in character.hands) item.save();
});

key(["tab", "i"], function(playerid) {
    players[playerid].inventory.toggle(playerid);
});
