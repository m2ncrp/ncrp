/**
 * Add car to the fraction
 * where player is seating in
 * @param  {Integer} playerid
 */
cmd("f", ["car", "add"], function(playerid) {
    local fracs = fractions.getContaining(playerid);

    if (!fracs.len()) {
        return msg(playerid, "You are not fraction member.", CL_WARNING);
    }

    // for now take the first one
    local fraction = fracs[0];

    if (!isPlayerInVehicle(playerid)) {
        return msg(playerid, "You suppposed to be inside car to add it to the fraction!", CL_WARNING);
    }

    local vehicleid = getPlayerVehicle(playerid);

    if (!isPlayerVehicleOwner(playerid, vehicleid)) {
        return msg(playerid, "You can add to fraction only your own vehicles!", CL_ERROR);
    }

    if (isPlayerVehicleInPlayerFraction(playerid)) {
        return msg(playerid, "You cannot add vehicle to this fraction again.", CL_WARNING);
    }

    local relation = FractionProperty();

    relation.fractionid = fraction.id;
    relation.type       = "vehicle";
    relation.created    = getTimestamp();
    relation.entityid   = __vehicles[vehicleid].entity.id;

    relation.save();

    fraction.property.add(relation.entityid, relation);

    return msg(playerid, "You successfuly added car to the fraction!", CL_SUCCESS);
});

/**
 * Remove car from the fraction
 * where player is seating in
 * @param  {Integer} playerid
 */
cmd("f", ["car", "remove"], function(playerid) {
    local fracs = fractions.getContaining(playerid);

    if (!fracs.len()) {
        return msg(playerid, "You are not fraction member.", CL_WARNING);
    }

    // for now take the first one
    local fraction = fracs[0];

    if (!isPlayerInVehicle(playerid)) {
        return msg(playerid, "You suppposed to be inside car to remove it from the fraction!", CL_WARNING);
    }

    local vehicleid = getPlayerVehicle(playerid);

    if (!isPlayerVehicleOwner(playerid, vehicleid)) {
        return msg(playerid, "You can remove only your own vehicles from the fraction!", CL_ERROR);
    }

    if (!fraction.property.has(__vehicles[vehicleid].entity.id)) {
        return msg(playerid, "You canont remove vehicle from the fraction which is not added!", CL_ERROR);
    }

    // remove car from fraction
    fraction.property.remove(__vehicles[vehicleid].entity.id).remove();

    return msg(playerid, "You successfuly removed car from the fraction!", CL_SUCCESS);
});

/**
 * List current cars
 * added to the fraction
 */
cmd("f", "car", function(playerid) {
    local fracs = fractions.getContaining(playerid);

    if (!fracs.len()) {
        return msg(playerid, "You are not fraction member.", CL_WARNING);
    }

    // for now take the first one
    local fraction = fracs[0];

    msg(playerid, "----------------------------------------------------", CL_RIPELEMON);
    msg(playerid, "List of current vehicles added to this fraction:");
    msg(playerid, "----------------------------------------------------", CL_RIPELEMON);

    foreach (idx, relation in fraction.property) {
        if (relation.type == "vehicle") {
            if (!(relation.entityid in __vehiclesR)) continue;
            local entity = __vehiclesR[relation.entityid];

            msg(playerid, format("Vehicle model: %s, Plate number: %s", getVehicleModelNameFromId(entity.model), entity.plate));
        }
    }

    msg(playerid, "To add a new car, seat inside it, and write /f car add", CL_INFO);
});

// cmd("f", "cars", cmdalias("f", "car"));
