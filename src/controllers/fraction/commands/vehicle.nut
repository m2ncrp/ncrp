/**
 * List current cars
 * added to the fraction
 */
fmd("*", ["vehicles.list"], ["$f car", "$f cars", "$f vehicles"], function(fraction, character) {
    msg(character.playerid, "------------------------------------------------------------------------------", CL_RIPELEMON);
    msg(character.playerid, "fraction.vehicle.title", [ fraction.title ]);
    msg(character.playerid, "------------------------------------------------------------------------------", CL_RIPELEMON);

    foreach (idx, relation in fraction.property) {
        if (relation.type == "vehicle") {
            if (!(relation.entityid in __vehiclesR)) continue;
            local entity = __vehiclesR[relation.entityid];

            msg(character.playerid, "fraction.vehicle.item", [ getVehicleModelNameFromId(entity.model), entity.plate ] );
        }
    }

    msg(character.playerid, "fraction.vehicle.toadd", [fraction.shortcut], CL_INFO);
});

/**
 * Add car to the fraction
 * where player is seating in
 */
fmd("*", ["vehicles.add"], ["$f car add", "$f cars add"], function(fraction, character) {
    if (!isPlayerInVehicle(character.playerid)) {
        return msg(character.playerid, "fraction.vehicle.insidecar", CL_WARNING);
    }

    local vehicleid = getPlayerVehicle(character.playerid);

    if (!isPlayerVehicleOwner(character.playerid, vehicleid)) {
        return msg(character.playerid, "fraction.vehicle.addonlyown", CL_ERROR);
    }

    if (isVehicleInFraction(vehicleid, fraction)) {
        return msg(character.playerid, "fraction.vehicle.cannotaddagain", CL_WARNING);
    }

    local relation = FractionProperty();

    relation.fractionid = fraction.id;
    relation.type       = "vehicle";
    relation.created    = getTimestamp();
    relation.entityid   = __vehicles[vehicleid].entity.id;

    relation.save();

    fraction.property.add(relation.entityid, relation);

    return msg(character.playerid, "fraction.vehicle.added", CL_SUCCESS);
});

/**
 * Remove car from the fraction
 * where player is seating in
 */
fmd("*", ["vehicles.remove"], ["$f car remove", "$f cars remove"], function(fraction, character) {
    if (!isPlayerInVehicle(character.playerid)) {
        return msg(playerid, "fraction.vehicle.insidecar", CL_WARNING);
    }

    local vehicleid = getPlayerVehicle(character.playerid);

    if (!isPlayerVehicleOwner(character.playerid, vehicleid)) {
        return msg(character.playerid, "fraction.vehicle.removeonlyown", CL_ERROR);
    }

    if (!isVehicleInFraction(vehicleid, fraction)) {
        return msg(character.playerid, "fraction.vehicle.cannotremove", CL_ERROR);
    }

    // remove car from fraction
    fraction.property.remove(__vehicles[vehicleid].entity.id).remove();

    return msg(character.playerid, "fraction.vehicle.removed", CL_SUCCESS);
});
