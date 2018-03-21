/**
 * Check if current connected player is have key from vehicleid
 *
 * @param  {integer}  playerid
 * @param  {integer}  vehicleid
 * @return {Boolean}
 */
function isPlayerHaveNVehicleKey(playerid, veh) {

    local vehicle = veh;
    if (typeof veh == "integer") {
        vehicle = vehicles_native[veh];
    }

    local canDrive = false;
    local engine = vehicle.getComponent(NVC.Engine);
    local keyswitch = vehicle.getComponent(NVC.KeySwitch);

    foreach (idx, item in players[playerid].inventory) {
        if ((item._entity == "Item.VehicleKey") && (item.data.id == keyswitch._getHash())) {
            canDrive = true;
            break;
        }
    }

    return canDrive;
}

