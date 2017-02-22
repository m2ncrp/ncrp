local storage = null;

event("onServerStarted", function() {
    storage = Container(ItemContainer);
});

event("onInventoryRegistred", function(inventory) {
    storage.set(inventory.id, inventory);
});

event("native:onPlayerMoveItem", function(playerid, id1, slot1, id2, slot2) {
    dbg("receiving moving item reueqst with ", id1, slot1, id2, slot2);

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
            } else {
                // we should just put item inside 2nd
                inventory2.set(slot2, item1);
                inventory1.remove(slot1);
            }
        }

        inventory1.sync();
        inventory2.sync();

    } else {
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
                } else {
                    inventory.set(slot2, inventory[slot1]);
                    inventory.remove(slot1);
                }
            }
        }

        inventory.sync();
    }
});
