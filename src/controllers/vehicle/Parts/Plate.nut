local platePrefixes = ["AZ", "ZX", "MV", "EB", "OI", "LA"];
// local plateRegistry = {};

local function random(min = 0, max = RAND_MAX) {
    return (rand() % ((max + 1) - min)) + min;
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
    // if (plate in plateRegistry) {
    //     return getRandomPlateNumber( prefix );
    // }

    // register plate
    // plateRegistry[plate] <- null;

    return plate;
}

class VehicleComponent.Plate extends VehicleComponent
{
    static classname = "VehicleComponent.Plate";

    constructor (data) {
        base.constructor(data);

        if (this.data == null) {
            this.data = {
                number = this.getRandomPlateNumber()
            }
        }
        // this.set(text);
        // plateRegistry[text] <- vehicleID;
    }

    function get() {
        return this.data.number;
    }

    function set(text) {
        if (text.len() > 6) return;
        this.data.number = text;
        return this.correct();
    }

    function correct() {
        setVehiclePlateText(this.parent.vehicleid, this.data.number);
    }
}
