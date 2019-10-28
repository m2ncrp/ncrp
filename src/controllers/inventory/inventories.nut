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
    if (players[playerid].hands.exists(0)) {
        local item = players[playerid].hands.remove(0);

        if(item.destroyOnDrop) {
            inventory.sync();
            item.remove();
        } else {
          local pos  = getPlayerPositionObj(playerid);

          pos.x += randomf(-0.1, 0.1);
          pos.y += randomf(-0.1, 0.1);

          players[playerid].hands.sync();
          delayedFunction(150, function() {
              ground.push(item, pos);
          });
        }

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

            // cannot insert handsOnly item in inventory
            if (inventory1[slot1].handsOnly && !(inventory2 instanceof PlayerHandsContainer) ) return msg(playerid, "inventory.cannotinsert", CL_WARNING);

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
    if (!closest.handsOnly && players[playerid].inventory.push(closest)) {
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

event("native:onPlayerTransferItem", function(playerid, id, slot) {
    if (!storage.exists(id)) return;

    local inventory = storage.get(id);

    if (inventory.isOpened(playerid)) {
        if (inventory.exists(slot)) {

            local targetid = null;

            delayedFunction(12000, function() {
                if (targetid == null) {
                    msg(playerid, "inventory.transfer.canceled");
                }
            });

            msg(playerid, "inventory.transfer.enter");

            trigger(playerid, "hudCreateTimer", 12.0, true, true);

            requestUserInput(playerid, function(playerid, text) {
                trigger(playerid, "hudDestroyTimer");

                if (!text || !isNumeric(text)) {
                    targetid = -1;
                    return msg(playerid, "inventory.transfer.provide", CL_THUNDERBIRD);
                }
                targetid = text.tointeger();

                if (playerid == targetid) {
                    return msg(playerid, "inventory.transfer.yourself");
                }

                if ( !isPlayerConnected(targetid) ) {
                    return msg(playerid, "inventory.transfer.noplayer");
                }

                if (!checkDistanceBtwTwoPlayersLess(playerid, targetid, 2.0)) {
                    return msg(playerid, "inventory.transfer.largedistance");
                }

                if(!players[targetid].hands.isFreeSpace(1)) {
                           msg(playerid, "inventory.transfer.targethandsbusy", getKnownCharacterNameWithId(playerid, targetid), CL_THUNDERBIRD);
                    return msg(targetid, "inventory.transfer.handsbusy", getKnownCharacterNameWithId(targetid, playerid), CL_THUNDERBIRD);
                }

                local item = inventory.remove(slot);
                inventory.sync();

                players[targetid].hands.push( item );
                item.save();

                players[targetid].hands.sync();

                item.transfer(playerid, inventory, targetid);

            }, 12);

        }
    }
});

event("native:onPlayerDestroyItem", function(playerid, id, slot) {
    if (!storage.exists(id)) return;

    local inventory = storage.get(id);

    if (inventory.isOpened(playerid)) {
        if (inventory.exists(slot)) {

            if (!inventory[slot].canBeDestroyed()) return msg(playerid, "inventory.cannotdestroy", CL_WARNING);

            local item = inventory.remove(slot);
            inventory.sync();
            item.destroy(playerid, inventory);
            item.remove();
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

            if(item.destroyOnDrop) {
              inventory.sync();
              item.remove();
            } else {
              local pos  = getPlayerPositionObj(playerid);

              pos.x += randomf(-0.3, 0.3);
              pos.y += randomf(-0.3, 0.3);

              inventory.sync();
              delayedFunction(150, function() {
                  ground.push(item, pos);
              });
            }

            item.drop(playerid, inventory);
        }
    }
});

event("native:onPlayerCloseInventory", function(playerid, id) {
    if (!storage.exists(id)) return;

    local inventory = storage.get(id);

    if (inventory.isOpened(playerid)) {
        inventory.hide(playerid);
    }
});
