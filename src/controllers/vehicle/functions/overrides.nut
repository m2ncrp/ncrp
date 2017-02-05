local vehicleOverrides = {};

/**
 * Can be used to add override callbacks
 * on vehicle spawn event
 * (for example setting default colors or numberplates)
 *
 * @param {array|int}   range modelid, or array of modelid to aplly callback to
 * @param {Function} callback
 */
function addVehicleOverride(range, callback) {
    if (typeof range != "array") {
        range = [range];
    }

    return range.map(function(item) {
        vehicleOverrides[item] <- callback;
    });
}

/**
 * Used internally on vehicle spawn event
 * @param  {[type]} vehicleid [description]
 * @param  {[type]} modelid   [description]
 * @return {[type]}           [description]
 */
function getVehicleOverride(vehicleid, modelid) {
    if (modelid in vehicleOverrides) {
        vehicleOverrides[modelid](vehicleid);
    }
}
