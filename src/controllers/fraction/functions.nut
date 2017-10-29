local fmds = [];

function register_fmds() {
    return fmds.map(@(handle) handle.call(this));
}

/**
 * Add fraction command handler
 * @param  {Array|String} shortcuts array of strings of fractions shorcuts, single shortcut, or "*"
 * @param  {Array|String} permissions array of string of permissions needed to make this command work (via OR), or single permission
 * @param  {Array|String} patterns patterns for command to be written as or single string, where $f is fraction shortcut substitution
 * @param  {Function} callback will be called at command execution by fraction player with right permission
 *
 * Examples:
 *     - fmd("police", ["police.duty"], "$f duty on", function(fraction, character) { ...
 *     - fmd(["sanrea", "navarra"], ["gang.bank.rob"], "$f robbank", function(fraction, character) { ...
 *     - fmd("*", "money.add", ["$f money add", "$f addmoney"], function(fraction, character, amount) { ...
 *
 */
function fmd(shortcuts, permissions, patterns, callback) {
    fmds.push(function() {
        local fracts = [];

        if (shortcuts == "*") {
            fractions.map(function(fraction) {
                fracts.push(fraction);
            });
        }
        else {
            if (typeof shortcuts != "array") {
                shortcuts = [shortcuts];
            }

            fracts = shortcuts.map(function(shortcut) {
                return fractions.exists(shortcut) ? fractions[shortcut] : null;
            }).filter(function(fraction, key) {
                return fraction != null;
            });
        }

        if (typeof patterns != "array") {
            patterns =[patterns];
        }

        if (!fracts) {
            return dbg("fmd: cannot apply command to unknown fractions", shortcuts);
        }

        fracts.map(function(fraction) {
            patterns.map(function(pattern) {
                local command_parts = split(str_replace("\\$f", fraction.shortcut, pattern), " ");

                cmd(command_parts[0], command_parts.slice(1), function(...) {
                    local character = players[vargv[0]];

                    if (!fraction.members.exists(character)) {
                        return;
                    }

                    if (!fraction.members.get(character).permitted(permissions)) {
                        return msg(vargv[0], "fraction.permission.error", CL_ERROR);
                    }

                    local args = clone(vargv);

                    args.remove(0);
                    args.insert(0, getroottable());
                    args.insert(1, fraction);
                    args.insert(2, character);

                    try {
                        callback.acall(args);
                    }
                    catch (e) {
                        dbg(e);
                    }
                });
            });
        });
    });
}

function isVehicleInFraction(vehicle, fraction) {
    if (!(vehicle instanceof Vehicle)) {
        vehicle = __vehicles[vehicleid].entity;
    }

    return fraction.property.has(vehicle.id);
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

// @deprectated
function isPlayerVehicleInPlayerFraction(playerid) {

    local fracs = fractions.getContaining(players[playerid]);

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
