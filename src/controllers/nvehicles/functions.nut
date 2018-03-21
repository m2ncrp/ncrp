/**
 * Check if current connected player is have key from vehicleid
 *
 * @param  {Character}  playerid
 * @param  {Vehicle}  vehicleid
 * @return {Boolean}
 */
function isPlayerHaveNVehicleKey(player, vehicle) {
    local data = vehicle.getComponent(NVC.KeySwitch).data;

    return players[playerid].inventory
        .filter(@(item) (item instanceof Item.VehicleKey))
        .map(@(key) key.id == data.id && key.num == data.num)
        .reduce(@(a,b) a || b)
}
