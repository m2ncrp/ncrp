local platePrefixes = ["AZ", "ZX", "MV", "EB", "OI", "LA"];
// local plateRegistry = {};
// 
local function random(min = 0, max = RAND_MAX) {
    return (rand() % ((max + 1) - min)) + min;
}

class Plate extends BaseVehiclePart {
    constructor (vehicleID, text) {
        base.constructor(vehicleID, text);
        this.set(text);
        plateRegistry[text] <- vehicleID;
    }
    
    function get() {
        return getVehiclePlateText( vehicleID );
    }

    function set(text) {
        local oldtext = this.get();

        if ( isPlateRegistered(oldtext) ) {
            removePlateText(oldtext);
        }

        plateRegistry[text] <- vehicleID;
        // id = text;
        return setVehiclePlateText(vehicleID, text);
    }

    /**
     * Function that creates random unique text plate
     *
     * @param  {String} prefix [optional] prefix to use for plate text
     * @return {String}        [description]
     */
    function getRandomPlateNumber(prefix = null) {
        if (!prefix) {
            prefix = platePrefixes[random(0, platePrefixes.len() - 1)];
        }

        // generate plate text
        local plate = format( "%s-%03d", prefix, random(0, 999) );

        // if exists - regenerate
        if (plate in plateRegistry) {
            return getRandomPlateNumber( prefix );
        }

        // register plate
        plateRegistry[plate] <- null;

        return plate;
    }

    /**
     * Remove provided text from the registry
     *
     * @param  {String} plateText
     * @return {Boolean} result
     */
    function removePlateText(plateText) {
        if (plateText in plateRegistry) {
            delete plateRegistry[plateText];
            return true;
        }
        return false;
    }

    /**
     * Check if vehicle plate is registered
     * @param  {string}  plateText [description]
     * @return {Boolean}           [description]
     */
    function isPlateRegistered(plateText) {
        return (plateText in plateRegistry);
    }
}
