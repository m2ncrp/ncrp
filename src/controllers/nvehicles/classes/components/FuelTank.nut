class NVC.FuelTank extends NVC
{
    static classname = "NVC.FuelTank";

    isFillingUp = false;

    constructor (data = null) {
        base.constructor(data);

        if (this.data == null) {
            this.data = {
                volume = 50.0,
                fuellevel = 50.0,
            }
        }
    }

    // Returns fuel level by the Server
    function _getNativeFuelLevel() {
        return getVehicleFuel(this.parent.vehicleid);
    }

    // how much do you need to fuel up it to max
    function getFuelToFillup() {
        return round(this.data.volume - this.data.fuellevel, 2);
    }

    // Returns fuel level by the Script
    function getCurrentFuelLevel() {
        return this.data.fuellevel;
    }

    function setFuel( to ) {
        this.data.fuellevel = to;
        this.parent.correct();
    }

    function setFuelToMax() {
        setFuel(this.data.volume);
    }

    function setFuelToMin() {
        setFuel(0.0);
    }

    function correct() {
        local eng = this.parent.components.findOne(NVC.Engine);
        local hull = this.parent.getComponent(NVC.Hull);

        if (eng.data.status) {
            setVehicleFuel(this.parent.vehicleid, this.data.fuellevel.tofloat() );
            eng.correct();
            return true;
        }
        setVehicleFuel(this.parent.vehicleid, 0.0 );
        return false;
    }
}



key("q", function(playerid) {
    if (!original__isPlayerInVehicle(playerid)) {
        return;
    }
    // // check if vehicle is NVehicle Object or not
    if (!(original__getPlayerVehicle(playerid) in vehicles_native)) return;

    local vehicle = getPlayerNVehicle(playerid);
    local fuelTank = vehicle.components.findOne(NVC.FuelTank);

    if  ((fuelTank || (fuelTank instanceof NVC.FuelTank))) {
        delayedFunction(10, function () {
            fuelTank.correct();
        });
    }
});

/**
 * Fuel manipulation here.
 */
event("onServerMinuteChange", function() {
    foreach (vehicle in vehicles) {
        local eng = vehicle.components.findOne(NVC.Engine);
        local hull = vehicle.components.findOne(NVC.Hull);
        local tank = vehicle.components.findOne(NVC.FuelTank);

        if (!hull || !(hull instanceof NVC.Hull)) {
            throw "Vehicle: cannot find hull!";
        }

        if (!eng || !(eng instanceof NVC.Engine)) {
            throw "Vehicle: cannot find engine!";
        }

        if (!eng.data.status) continue;

        local speed = getVehicleSpeed(vehicle.vehicleid);
        speed = sqrt(speed[0]*speed[0] + speed[1]*speed[1] + speed[2]*speed[2]);
        dbg(speed);
        dbg("Model is " + hull.getModel());

        local level = tank.data.fuellevel;

        if (vehicle.state && tank.data.fuellevel >= 0) {
            local consumption;
            if (speed > 0) {
                consumption = eng.data.consumption.move * getDefaultVehicleFuelForModel( hull.getModel() );
                dbg("Veh is on the run. Consump: " + consumption);
            } else {
                consumption = eng.data.consumption.idle * getDefaultVehicleFuelForModel( hull.getModel() );
                dbg("Veh is stand still. Consump: " + consumption);
            }

            if (tank.data.fuellevel >= consumption) {
                tank.data.fuellevel -= consumption;
            } else {
                tank.data.fuellevel = 0.0;
                eng.setStatusTo(false);
            }
        }

        setVehicleFuel(vehicle.vehicleid, tank.data.fuellevel);

        dbg("Fuel level has been set for id[" + vehicle.vehicleid + "] vehicle. Now its: " + tank.data.fuellevel);
    }
});