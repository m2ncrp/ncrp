class LockableVehicle extends NativeVehicle
{
    static classname = "LockableVehicle";
    isBlocked = null;

    constructor (DB_data) {
        base.constructor(DB_data);
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
        // this.setFuel(0.0);
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
            // return this.setFuel(fuel);
        }
    }


}
