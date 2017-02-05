/**
 * Contain frags set by true if object wil be saved into database
 */
class SaveableVehicle extends RespawnableVehicle {
    static classname = "SaveableVehicle";
    saving = false;
    entity = null;

    constructor (DB_data, seats) {
        base.constructor(DB_data, seats);
        saving = false;
        entity = DB_data;
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

    function setEntity(entity) {
        this.entity = entity;
    }
}


event("native:onPlayerVehicleEnter", function( playerid, vehicleid, seat ) {
    local veh = __vehicles.get(vehicleid);
    veh.save();
});

event("native:onPlayerVehicleExit", function( playerid, vehicleid, seat ) {
    local veh = __vehicles.get(vehicleid);
    veh.save();
});
