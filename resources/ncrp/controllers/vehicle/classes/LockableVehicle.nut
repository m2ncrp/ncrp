class LockableVehicle extends NativeVehicle
{
    isBlocked = null;

    constructor (model, px, py, pz, rx = 0.0, ry = 0.0, rz = 0.0) {
        base.constructor(model, px, py, pz, rx, ry, rz);
        block();
    }

    /**
     * Check if current vehicle is blocked
     * @return {Boolean}
     */
    function isVehicleBlocked() {
        return this.isBlocked;
    }

    /**
     * Block vehicle (it cannot be moved or driven)
     * @param int vehicleid
     * @return bool
     */
    function block() {
        this.setSpeed(0.0, 0.0, 0.0);
        this.setEngineState(false);
        this.setFuel(0.0);
        isBlocked = true;
    }

    /**
     * Unblock vehicle
     * @param {int} vehicleid
     * @param {float} fuel
     * @return {bool}
     */
    function unblock(fuel = VEHICLE_FUEL_DEFAULT) {
        if (isBlocked) {
            isBlocked = false;
            return this.setFuel(fuel);
        }
    }


}
