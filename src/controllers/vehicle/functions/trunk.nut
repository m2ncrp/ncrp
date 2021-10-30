function setVehicleTrunkLocked(vehicleid, value) {
    local veh = getVehicleEntity(vehicleid);

    if(veh == null) return;

    local locked = veh.data.parts.trunk.locked;
    local opened = veh.data.parts.trunk.opened;

    if(locked == value) return;

    if(!value) {
        locked = false;
    } else {
        if(opened) {
            opened = false;

            if(veh.inventory == null) {
                    loadVehicleInventory(veh);
            }

            veh.inventory.hideForAll();
        }

        locked = true;
    }

    veh.data.parts.trunk.locked = locked;
    veh.data.parts.trunk.opened = opened;
    setVehiclePartOpen(vehicleid, 1, opened)
}

event("setVehicleTrunkLocked", function(playerid, vehicleid, value) {
    setVehicleTrunkLocked(vehicleid, value)
});