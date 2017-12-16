class VehicleComponent.Lights extends VehicleComponent {

    static classname = "VehicleComponent.Lights";

    constructor (data) {
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
    local vehicleid = vehicles.nearestVehicle(playerid);
    local lights = vehicles[vehicleid].components.findOne(VehicleComponent.Lights);
    return lights.setState( !lights.data.status );
});
