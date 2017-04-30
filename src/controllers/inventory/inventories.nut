local storage = null;
local ground  = null;

event("onServerStarted", function() {
    ground  = GroundItems();
    storage = Container(ItemContainer);

    Item.findBy({ state = Item.State.GROUND }, function(err, items) {
        ground.extend(items);
    });
});

event(["onServerStopping", "onServerAutosave"], function() {
    ground.map(function(item) { item.save() });
});

event("onInventoryRegistred", function(inventory) {
    storage.set(inventory.id, inventory);
});

event("onServerPlayerStarted", function(playerid) {
    delayedFunction(2501, function() {
        ground.sync(playerid);
    });
});

event("onServerMinuteChange", function() {
    ground.calculate_decay();
});

event("native:onPlayerMoveItem", function(playerid, id1, slot1, id2, slot2) {
    // dbg("receiving moving item reueqst with ", id1, slot1, id2, slot2);

    if (id1 != id2) {
        // operations on different inventories
        if (!storage.exists(id1)) return;
        if (!storage.exists(id2)) return;

        local inventory1 = storage.get(id1);
        local inventory2 = storage.get(id2);

        if (inventory1.isOpened(playerid) && inventory2.isOpened(playerid)) {
            if (!inventory1.exists(slot1)) {
                return;
            }

            local item1 = inventory1[slot1];

            if (inventory2.exists(slot2)) {
                // we should swap items
                inventory1.set(slot1, inventory2[slot2]);
                inventory2.set(slot2, item1);

                trigger("onPlayerMovedItem", playerid, inventory1.get(slot1));
                trigger("onPlayerMovedItem", playerid, inventory2.get(slot2));
            } else {
                // we should just put item inside 2nd
                inventory2.set(slot2, item1);
                inventory1.remove(slot1);

                trigger("onPlayerMovedItem", playerid, inventory2.get(slot2));
            }
        }

        inventory1.sync();
        inventory2.sync();
    }
    else {
        // operations in same inventory
        if (!storage.exists(id1)) return;

        local inventory = storage.get(id1);

        if (inventory.isOpened(playerid)) {
            if (inventory.exists(slot1)) {
                if (inventory.exists(slot2)) {
                    inventory.swap(slot1, slot2);
                    // local item1 = inventory[slot1];
                    // inventory.remove(slot1);
                    // inventory.set(slot1, inventory[slot2]);
                    // inventory.set(slot2, item1);
                    trigger("onPlayerMovedItem", playerid, inventory.get(slot1));
                    trigger("onPlayerMovedItem", playerid, inventory.get(slot2));
                } else {
                    inventory.set(slot2, inventory[slot1]);
                    inventory.remove(slot1);

                    trigger("onPlayerMovedItem", playerid, inventory.get(slot2));
                }
            }
        }

        inventory.sync();
    }
});

key("e", function(playerid) {
    local radius = 0.75;
    local pos = getPlayerPositionObj(playerid);

    local items = ground.filter(function(i, item) {
        return (abs(pos.x - item.x) < radius) && (abs(pos.y - item.y) < radius) && (abs(pos.z - item.z) < radius);
    });

    if (!items.len()) {
        return;
    }

    local closest = items.reduce(function(curr, next) {
        if (
            getDistanceBetweenPoints3D(pos.x, pos.y, pos.z, next.x, next.y, next.z) <
            getDistanceBetweenPoints3D(pos.x, pos.y, pos.z, curr.x, curr.y, curr.z)
        ) {
            return next;
        }

        return curr;
    });

    if (players[playerid].inventory.push(closest)) {
        players[playerid].inventory.sync();
        ground.remove(closest);
        msg(playerid, "Вы подобрали предмет.", CL_SUCCESS);
        return true;
    } else {
        msg(playerid, "Вы не можете столько унести.", CL_WARNING);
        return false;
    }
});

event("native:onPlayerUseItem", function(playerid, id, slot) {
    if (!storage.exists(id)) return;

    local inventory = storage.get(id);

    if (inventory.isOpened(playerid)) {
        if (inventory.exists(slot)) {
            inventory.get(slot).use(playerid, inventory);
        }
    }
});

event("native:onPlayerDropItem", function(playerid, id, slot) {
    if (!storage.exists(id)) return;

    local inventory = storage.get(id);

    if (inventory.isOpened(playerid)) {
        if (inventory.exists(slot)) {
            local item = inventory.remove(slot);
            local pos  = getPlayerPositionObj(playerid);

            pos.x += randomf(-0.3, 0.3);
            pos.y += randomf(-0.3, 0.3);

            inventory.sync();
            delayedFunction(150, function() {
                ground.push(item, pos);
            });

            msg(playerid, "Вы выбросили предмет.", CL_SUCCESS);
        }
    }
});
