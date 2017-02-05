local platePrefixes = "ABCDEFGHJKLMNPQRSTUVWXYZ";
local plateRegistry = {};

local old__setVehiclePlateText = setVehiclePlateText;
local old__getVehiclePlateText = getVehiclePlateText;

/**
 * Function that creates random unique text plate
 *
 * @param  {String} prefix [optional] prefix to use for plate text
 * @return {[type]}        [description]
 */
function getRandomVehiclePlate(prefix = null) {
    if (!prefix) {
        prefix =
            platePrefixes[random(0, platePrefixes.len() - 1)].tochar() +
            platePrefixes[random(0, platePrefixes.len() - 1)].tochar()
        ;
    }

    // generate plate text
    local plate = format( "%s-%03d", prefix, random(0, 999) );

    // if exists - regenerate
    if (plate in plateRegistry) {
        return getRandomVehiclePlate( prefix );
    }

    // register plate
    plateRegistry[plate] <- null;

    return plate;
}

/**
 * Set custom vehicle plate text
 * And save it to the registry
 *
 * @param {Integer} vehicleid
 * @param {String}  plateText
 * @return {Boolean}
 */
function setVehiclePlateText(vehicleid, plateText) {
    local oldtext = getVehiclePlateText(vehicleid);

    if (isVehilclePlateRegistered(oldtext)) {
        removeVehiclePlateText(oldtext);
    }

    plateRegistry[plateText] <- vehicleid;
    return old__setVehiclePlateText(vehicleid, plateText);
}

/**
 * Get vehicle plate text by vehicle id
 *
 * @param  {Integer} vehicleid
 * @return {String} or null
 */
function getVehiclePlateText(vehicleid) {
    foreach (plateText, id in plateRegistry) {
        if (vehicleid == id) return plateText;
    }

    // if not found, call old method
    return old__getVehiclePlateText(vehicleid);
}

/**
 * Remove provided text from the registry
 *
 * @param  {String} plateText
 * @return {Boolean} result
 */
function removeVehiclePlateText(plateText) {
    if (plateText in plateRegistry) {
        delete plateRegistry[plateText];
        return true;
    }

    return false;
}

/**
 * Check if vehicle plate is registered
 * @param  {[type]}  plateText [description]
 * @return {Boolean}           [description]
 */
function isVehilclePlateRegistered(plateText) {
    return (plateText in plateRegistry);
}

/**
 * Try to get vehicleid by provided plate text
 * or null if vehicle is not found
 *
 * @param  {String} plateText
 * @return {Integer} or null
 */
function getVehicleByPlateText(plateText) {
    return (isVehilclePlateRegistered(plateText)) ? plateRegistry[plateText] : null;
}

/**
 * Return table with platenumber -> vehicleid
 * @return {Table}
 */
function getRegisteredVehiclePlates() {
    return plateRegistry;
}
