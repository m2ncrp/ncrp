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

    // 5 or lower - can driver cars
    local fracts = fractions.getManaged(playerid, FRACTION_VEHICLE_PERMISSION);

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

function fraction__Create(title, shortcut = "", type = "default", money = 0.0) {
    local f = Fraction();

    f.title     = title;
    f.shortcut  = shortcut;
    f.type      = type;
    f.money     = money;
    f.created   = getTimestamp();
    f.save();

    return f;
}

function fraction__Role(fraction, title, shortcut = "", level = 5, salary = 0.0) {
    local fr = FractionRole();

    fr.title        = title;
    fr.shortcut     = shortcut;
    fr.created      = getTimestamp();
    fr.level        = level;
    fr.fractionid   = fraction.id;
    fr.salary       = salary;
    fr.save();

    return fr;
}
