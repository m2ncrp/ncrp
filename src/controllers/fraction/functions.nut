/**
 * Check whether or player can access fraction vehicle
 * @param  {Integer}  playerid
 * @param  {Integer}  vehicleid
 * @return {Boolean}
 */
function isPlayerVehicleFraction(playerid, vehicleid) {
    if (!(vehicleid in __vehicles)) {
        return false;
    }

    if (!isVehicleOwned(vehicleid)) {
        return false;
    }

    local vehicle = __vehicles[vehicleid];
    local entity  = vehicle.entity;

    if (!entity) {
        return false;
    }

    local fracts = fractions.getContaining(playerid);

    if (!fracts.len()) {
        return false;
    }

    foreach (idx, fraction in fracts) {
        foreach (idx, relation in fraction.property) {
            if (relation.type == "vehicle" && relation.entityid == entity.id) {
                return true;
            }
        }
    }

    return false;
}
