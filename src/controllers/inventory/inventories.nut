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

event("onPlayerVehicleEnter", function(playerid, vehicleid, seat) {
    if (!players[playerid].hands.isFree()) {
        local item = players[playerid].hands.remove(0);
        local pos  = getPlayerPositionObj(playerid);

        pos.x += randomf(-0.3, 0.3);
        pos.y += randomf(-0.3, 0.3);

        players[playerid].hands.sync();
        delayedFunction(150, function() {
            ground.push(item, pos);
        });

        item.drop(playerid, players[playerid].hands);
    }
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
                if (!inventory1.canBeInserted(inventory2[slot2])) return msg(playerid, "inventory.cannotinsert", CL_WARNING);
                if (!inventory2.canBeInserted(inventory1[slot1])) return msg(playerid, "inventory.cannotinsert", CL_WARNING);

                // we should swap items
                inventory1.set(slot1, inventory2[slot2]);
                inventory2.set(slot2, item1);

                inventory1.get(slot1).move(playerid, inventory1);
                inventory2.get(slot2).move(playerid, inventory2);
            } else {
                if (!inventory2.canBeInserted(inventory1[slot1])) return msg(playerid, "inventory.cannotinsert", CL_WARNING);

                // we should just put item inside 2nd
                inventory2.set(slot2, item1);
                inventory1.remove(slot1);

                inventory2.get(slot2).move(playerid, inventory2);
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

                    inventory.get(slot1).move(playerid, inventory);
                    inventory.get(slot2).move(playerid, inventory);
                } else {
                    inventory.set(slot2, inventory[slot1]);
                    inventory.remove(slot1);

                    inventory.get(slot2).move(playerid, inventory);
                }
            }
        }

        inventory.sync();
    }
});

key("e", function(playerid) {
    if (isPlayerInVehicle(playerid)) {
        return;
    }

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
        closest.pick(playerid, players[playerid].inventory);
        ground.remove(closest);
        return true;
    }
    else if (players[playerid].hands.push(closest)) {
        players[playerid].hands.sync();
        closest.pick(playerid, players[playerid].hands);
        ground.remove(closest);
        return true;
    }
    else {
        msg(playerid, "inventory.cannotinsert", CL_WARNING);
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
    if (isPlayerInVehicle(playerid)) return; // maybe add message
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

            item.drop(playerid, inventory);
        }
    }
});
