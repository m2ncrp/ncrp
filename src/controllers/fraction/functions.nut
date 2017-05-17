local fmds = [];

function register_fmds() {
    return fmds.map(@(handle) handle());
}

function fmd(shortcuts, permissions, pattern, callback) {
    fmds.push(function() {
        local fracts = [];

        if (shortcuts == "*") {
            fractions.each(function(fraction) {
                fracts.push(fraction);
            });
        }
        else {
            if (typeof shortcuts != "array") {
                shortcuts = [shortcuts];
            }

            fracts = shortcuts.map(function(shortcut) {
                return fractions.exists(shortcut) ? fractions.get(shortcut) : null;
            }).filter(function(fraction, key) {
                return fraction != null;
            });
        }

        if (!fracts) {
            return dbg("fmd: cannot apply command to unknown fractions", shortcuts);
        }

        foreach (idx, fraction in fracts) {
            cmd(str_replace("$f", fraction.shortcut, pattern), function(...) {
                local character = players[vargv[0]];

                if (!fraction.members.exists(character)) {
                    return;
                }

                if (!fraction.mebmers.get(character).permitted(permissions)) {
                    return; // todo(inlife): maybe information to user about no permisison?
                }

                local args = clone(vargv);

                args.remove(0);
                args.insert(0, getroottable());
                args.insert(1, character);
                args.insert(2, fraction);

                callback.acall(args);
            });
        }
    });
}

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

/**
 * Check if this vehicle is fraction vehicle
 * @param  {Integer}  vehicleid
 * @return {Boolean}
 */
function isVehicleFraction(vehicleid) {
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

    foreach (idx, fraction in fractions) {
        foreach (idx, relation in fraction.property) {
            if (relation.type == "vehicle" && relation.entityid == entity.id) {
                return true;
            }
        }
    }

    return false;
}

function isPlayerVehicleInPlayerFraction(playerid) {

    local fracs = fractions.getContaining(playerid);

    if (!fracs.len()) {
        return false;
    }

    // for now take the first one
    local fraction = fracs[0];

    if (!isPlayerInVehicle(playerid)) {
        return false;
    }

    local vehicleid = getPlayerVehicle(playerid);

    if (!isPlayerVehicleOwner(playerid, vehicleid)) {
        return false;
    }

    if (fraction.property.has(__vehicles[vehicleid].entity.id)) {
        return true;
    } else {
        return false;
    }
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
