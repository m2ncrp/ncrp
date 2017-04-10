include("controllers/inventory/classes");
include("controllers/inventory/inventories.nut");
// include("controllers/inventory/functions.nut"); // refactor

local inventory_script;

event("onServerStarted", function() {
    logger.log("starting inventory...");

    delayedFunction(1, function() {
        inventory_script = fread("./resources/ncrp/client/gui_inventory.nut");
    });
});

event("onServerPlayerStarted", function(playerid) {
    dbg("sending inventory to", playerid, inventory_script.len());
    trigger(playerid, "onServerProxy", "gui_inventory", inventory_script);
});

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

event("native:inventory:loaded", function(playerid) {
    delayedFunction(2500, function() {
        players[playerid].hands.toggle(playerid);
        players[playerid].inventory.blocked = false;
    });
});

/**
 * Try to save player's items on character save
 */
event("onCharacterSave", function(playerid, character) {
    foreach (idx, item in character.inventory) item.save();
    foreach (idx, item in character.hands) item.save();
});

key(["tab", "i"], function(playerid) {
    if (!players[playerid].inventory.blocked) {
        players[playerid].inventory.toggle(playerid);
    }
});
