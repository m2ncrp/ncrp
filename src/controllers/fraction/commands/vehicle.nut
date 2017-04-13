/**
 * Add car to the fraction
 * where player is seating in
 * @param  {Integer} playerid
 */
cmd("f", ["car", "add"], function(playerid) {
    local fracs = fractions.getContaining(playerid);

    if (!fracs.len()) {
        return msg(playerid, "fraction.notmember", CL_WARNING);
    }

    // for now take the first one
    local fraction = fracs[0];

    if (!isPlayerInVehicle(playerid)) {
        return msg(playerid, "fraction.vehicle.insidecar", CL_WARNING);
    }

    local vehicleid = getPlayerVehicle(playerid);

    if (!isPlayerVehicleOwner(playerid, vehicleid)) {
        return msg(playerid, "fraction.vehicle.addonlyown", CL_ERROR);
    }

    if (isPlayerVehicleInPlayerFraction(playerid)) {
        return msg(playerid, "fraction.vehicle.cannotaddagain", CL_WARNING);
    }

    local relation = FractionProperty();

    relation.fractionid = fraction.id;
    relation.type       = "vehicle";
    relation.created    = getTimestamp();
    relation.entityid   = __vehicles[vehicleid].entity.id;

    relation.save();

    fraction.property.add(relation.entityid, relation);

    return msg(playerid, "fraction.vehicle.added", CL_SUCCESS);
});

/**
 * Remove car from the fraction
 * where player is seating in
 * @param  {Integer} playerid
 */
cmd("f", ["car", "remove"], function(playerid) {
    local fracs = fractions.getContaining(playerid);

    if (!fracs.len()) {
        return msg(playerid, "fraction.notmember", CL_WARNING);
    }

    // for now take the first one
    local fraction = fracs[0];

    if (!isPlayerInVehicle(playerid)) {
        return msg(playerid, "fraction.vehicle.insidecar", CL_WARNING);
    }

    local vehicleid = getPlayerVehicle(playerid);

    if (!isPlayerVehicleOwner(playerid, vehicleid)) {
        return msg(playerid, "fraction.vehicle.removeonlyown", CL_ERROR);
    }

    if (!fraction.property.has(__vehicles[vehicleid].entity.id)) {
        return msg(playerid, "fraction.vehicle.cannotremove", CL_ERROR);
    }

    // remove car from fraction
    fraction.property.remove(__vehicles[vehicleid].entity.id).remove();

    return msg(playerid, "fraction.vehicle.removed", CL_SUCCESS);
});

/**
 * List current cars
 * added to the fraction
 */
cmd("f", "car", function(playerid) {
    local fracs = fractions.getContaining(playerid);

    if (!fracs.len()) {
        return msg(playerid, "fraction.notmember", CL_WARNING);
    }

    // for now take the first one
    local fraction = fracs[0];

    msg(playerid, "------------------------------------------------------------------------------", CL_RIPELEMON);
    msg(playerid, "fraction.vehicle.title", [ fraction.title ]);
    msg(playerid, "------------------------------------------------------------------------------", CL_RIPELEMON);

    foreach (idx, relation in fraction.property) {
        if (relation.type == "vehicle") {
            if (!(relation.entityid in __vehiclesR)) continue;
            local entity = __vehiclesR[relation.entityid];

            msg(playerid, "fraction.vehicle.item", [ getVehicleModelNameFromId(entity.model), entity.plate ] );
        }
    }

    msg(playerid, "fraction.vehicle.toadd", CL_INFO);
});

// cmd("f", "cars", cmdalias("f", "car"));
