function getPropertyEntity(propertyId) {
    return properties.has(propertyId) ? properties[propertyId] : null;
}

function getNearestPropertyForPlayer(playerid, private = false, returnObject = false, limit = 3.0) {
    local min = limit;
    local res = -1;

    foreach (propertyid, value in properties) {
        if(!value) continue;
        local pos = private ? value.data.coords.private : value.data.coords.public;
        local dis = getDistanceToPoint(playerid, pos.x, pos.y, pos.z);

        if (dis < min) {
            min = dis;
            res = returnObject ? value : propertyid;
        }
    }

    return res;
}

function getNearestPropertyIdByPrivateForPlayer(playerid) {

    if (isPlayerInVehicle(playerid)) return false;

    local propertyId = getNearestPropertyForPlayer(playerid, true, false, 0.5);
    if(propertyId == -1) {
        return false;
    }

    return propertyId;
}

function getNearestPropertyIdByPublicForPlayer(playerid) {

    if (isPlayerInVehicle(playerid)) return false;

    local propertyId = getNearestPropertyForPlayer(playerid, false, true, 0.5);
    if(propertyId == -1) {
        return false;
    }

    return propertyId;
}

function loadPropertyInventory(entity) {

    entity.inventory <- PropertyInventoryItemContainer(entity);

    ORM.Query("select * from tbl_items where parent = :id and state = :states")
        .setParameter("id", entity.id)
        .setParameter("states", Item.State.PROPERTY_INV, true)
        .getResult(function(err, items) {
            foreach (idx, item in items) {
                entity.inventory.set(item.slot, item);
            }
        });
}
