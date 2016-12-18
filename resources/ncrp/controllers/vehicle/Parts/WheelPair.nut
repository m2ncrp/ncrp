class WheelPair extends BaseVehiclePart {
    number = null;

    constructor (vehicleID, pair_num, texture) {
        base.constructor(vehicleID, texture);
        setW(pair_num, texture);
    }

    function getW(pair_num) {
        return getVehicleWheelTexture( vehicleID, pair_num );
    }

    function setW(pair_num, to) {
        setVehicleWheelTexture( vehicleID, pair_num, to );
    }
}
