/**
 * Contain frags set by true if object wil be saved into database
 */
class SaveableVehicle extends RespawnableVehicle {
    static classname = "SaveableVehicle";
    saving = false;

    constructor (model, seats, px, py, pz, rx = 0.0, ry = 0.0, rz = 0.0) {
        base.constructor(model, seats, px, py, pz, rx, ry, rz);

        saving = false;
    }



    /**
     * Set if vehicle can be automatically saved
     * @param  {Boolean} value
     * @return {Boolean}
     */
    function setSaveable(value) {
        return this.saving = value;
    }

    /**
     * Get if vehicle is automatically saved
     * @return {Boolean}
     */
    function isSaveable() {
        return this.saving;
    }
}
