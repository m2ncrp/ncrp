class VehicleComponent.Gabarites extends VehicleComponent
{
    static classname = "VehicleComponent.Gabarites";

    static Gabarite_States = {
        both_off = 0,
        left_on = 1,
        right_on = 2,
        both_on = 3,
    }

    constructor (data = null) {
        base.constructor(data);

        if (this.data == null) {
            this.data = {
                status = Gabarite_States.both_off
            }
        }
    }

    function switchBoth() {
        if( this.data.status == Gabarite_States.both_on) {
            this.data.status = Gabarite_States.both_off;
            this.correct();
        } else {
            data.status = Gabarite_States.both_on;
            this.correct();
        }
    }

    function switchLeft() {
        if (this.data.status == Gabarite_States.both_on) {
            this.data.status = Gabarite_States.left_on;
            this.correct();
            return;
        }

        if (this.data.status == Gabarite_States.both_off) {
            this.data.status = Gabarite_States.left_on;
            this.correct();
            return;
        }

        if (this.data.status == Gabarite_States.right_on) {
            this.data.status = Gabarite_States.left_on;
            this.correct();
            return;
        }

        if(this.data.status == Gabarite_States.left_on) {
            this.data.status = Gabarite_States.both_off;
            this.correct();
            return;
        }
    }

    function switchRight() {
        if (this.data.status == Gabarite_States.both_on) {
            this.data.status = Gabarite_States.right_on;
            this.correct();
            return;
        }

        if (this.data.status == Gabarite_States.both_off) {
            this.data.status = Gabarite_States.right_on;
            this.correct();
            return;
        }

        if(this.data.status == Gabarite_States.left_on) {
            this.data.status = Gabarite_States.right_on;
            this.correct();
            return;
        }

        if (this.data.status == Gabarite_States.right_on) {
            this.data.status = Gabarite_States.both_off;
            this.correct();
            return;
        }
    }


    function correct() {
        if (this.data.status == Gabarite_States.both_on) {
            setIndicatorLightState(this.parent.vehicleid, INDICATOR_LEFT, true);
            setIndicatorLightState(this.parent.vehicleid, INDICATOR_RIGHT, true);
        }

        if (this.data.status == Gabarite_States.both_off) {
            setIndicatorLightState(this.parent.vehicleid, INDICATOR_LEFT, false);
            setIndicatorLightState(this.parent.vehicleid, INDICATOR_RIGHT, false);
        }

        if(this.data.status == Gabarite_States.left_on) {
            setIndicatorLightState(this.parent.vehicleid, INDICATOR_RIGHT, false);
            setIndicatorLightState(this.parent.vehicleid, INDICATOR_LEFT, true);
        }

        if (this.data.status == Gabarite_States.right_on) {
            setIndicatorLightState(this.parent.vehicleid, INDICATOR_LEFT, false);
            setIndicatorLightState(this.parent.vehicleid, INDICATOR_RIGHT, true);
        }
    }
}


key("z", function(playerid) {
    if (!isPlayerInVehicle(playerid)) {
        return;
    }

    // check if vehicle is NVehicle Object or not
    if (!(getPlayerVehicle(playerid) in vehicles_native)) return;

    local vehicleid = getPlayerVehicleid(playerid);
    local gabs = vehicles[vehicleid].components.findOne(VehicleComponent.Gabarites);

    // if engine is in its place and has expected obj type
    if ((gabs || (gabs instanceof VehicleComponent.Gabarites))) {
        gabs.switchLeft();
        triggerClientEvent(playerid, "indicator_check", gabs.parent.vehicleid, gabs.data.status);
    }
});


key("x", function(playerid) {
    if (!isPlayerInVehicle(playerid)) {
        return;
    }

    // check if vehicle is NVehicle Object or not
    if (!(getPlayerVehicle(playerid) in vehicles_native)) return;

    local vehicleid = getPlayerVehicleid(playerid);
    local gabs = vehicles[vehicleid].components.findOne(VehicleComponent.Gabarites);

    // if engine is in its place and has expected obj type
    if ((gabs || (gabs instanceof VehicleComponent.Gabarites))) {
        gabs.switchBoth();
        triggerClientEvent(playerid, "indicator_check", gabs.parent.vehicleid, gabs.data.status);
    }
});


key("c", function(playerid) {
    if (!isPlayerInVehicle(playerid)) {
        return;
    }

    // check if vehicle is NVehicle Object or not
    if (!(getPlayerVehicle(playerid) in vehicles_native)) return;

    local vehicleid = getPlayerVehicleid(playerid);
    local gabs = vehicles[vehicleid].components.findOne(VehicleComponent.Gabarites);

    // if engine is in its place and has expected obj type
    if ((gabs || (gabs instanceof VehicleComponent.Gabarites))) {
        gabs.switchRight();
        triggerClientEvent(playerid, "indicator_check", gabs.parent.vehicleid, gabs.data.status);
    }
});
