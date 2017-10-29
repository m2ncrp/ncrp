include("controllers/inventory/classes");
include("controllers/inventory/inventories.nut");
include("controllers/inventory/translations.nut");
// include("controllers/inventory/functions.nut"); // refactor

local inventory_script;
local inventory_cache = {};

event("onServerStarted", function() {
    logger.log("starting inventory...");
});

/**
 * Try to load player inventory
 * on player connected
 */
event("onServerPlayerStarted", function(playerid) {
    local character = players[playerid];

    if (!(character.id in inventory_cache)) {
        local body = PlayerItemContainer(playerid);
        local hand = PlayerHandsContainer(playerid);

        ORM.Query("select * from tbl_items where parent = :id and state in (:states)")
            .setParameter("id", character.id)
            .setParameter("states", concat([Item.State.PLAYER, Item.State.PLAYER_HAND], ","), true)
            .getResult(function(err, items) {
                foreach (idx, item in items) {
                    if (item.state == Item.State.PLAYER_HAND) {
                        hand.set(item.slot, item);
                        continue;
                    }

                    body.set(item.slot, item);
                }
            });

        inventory_cache[character.id] <- {
            body = body, hand = hand
        };
    }
    else {
        inventory_cache[character.id].body.parent = character;
        inventory_cache[character.id].hand.parent = character;
    }

    character.inventory = inventory_cache[character.id].body;
    character.hands     = inventory_cache[character.id].hand;
});

event("native:inventory:loaded", function(playerid) {
    delayedFunction(1500, function() {
        players[playerid].hands.show(playerid);
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

key("i", function(playerid) {
    if (isPlayerAdmin(playerid)) return;

    if (!players[playerid].inventory.blocked) {
        players[playerid].inventory.toggle(playerid);
    }
});

key("tab", function(playerid) {
    if (!players[playerid].inventory.blocked) {
        players[playerid].inventory.toggle(playerid);
    }
});

