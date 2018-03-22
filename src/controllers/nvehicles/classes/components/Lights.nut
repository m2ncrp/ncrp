class NVC.Lights extends NVC {

    static classname = "NVC.Lights";

    constructor (data = null) {
        base.constructor(data);

        if (this.data == null) {
            this.data = {
                status = false
            }
        }
    }

    function getState() {
        // log( status.tostring() +"~"+ getVehicleLightState(vehicleID).tostring() );
        local native = getVehicleLightState(this.parent.vehicleid);
        return native || status;
    }

    function setState(to) {
        this.data.status = to;
        this.correct();
    }

    /**
     * Return true if lights visually broken on server side.
     * @return {Boolean}
     */
    function isBroken() {
        return false;
    }

    function correct() {
        setVehicleLightState( this.parent.vehicleid, this.data.status);
    }
}

key("r", function(playerid) {
    if (!original__isPlayerInVehicle(playerid)) {
        return;
    }

    // check if vehicle is NVehicle Object or not
    if (!(original__getPlayerVehicle(playerid) in vehicles_native)) return;

    local vehicle = getPlayerNVehicle(playerid);
    local lights = vehicle.components.findOne(NVC.Lights);
    return lights.setState( !lights.data.status );
});
