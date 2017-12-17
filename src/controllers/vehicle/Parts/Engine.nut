class VehicleComponent.Engine extends VehicleComponent
{
    static classname = "VehicleComponent.Engine";

    static Tune = {
        Basic = 1,
        Sport = 2,
        Supercharged = 3,
    }

    limit = 1;
    // Just an alias to handle M2O API changes real quick
    stateSetter = function(vehicleid, state) {
        return setVehicleEngineState(vehicleid, state);
    }
    // Prevent developer from mistakes
    // setVehicleEngineState = null;

    constructor (data) {
        dbg("called engine creation");
        base.constructor(data);

        if (this.data == null) {
            this.data = {
                status = false,
                tune = Tune.Basic,
                consumption = {
                    idle = 0.005,
                    move = 0.010
                }
            }
        }
    }

    function beforeAction() {
        dbg("Engine Action method was called @line 21 Engine.nut");
    }

    function action() {
        this.data.status = !this.data.status;
        // stateSetter( this.parent.id, this.data.status );
        this.correct();
    }

    function correct() {
        // stateSetter( this.parent.id, this.data.status );
        setVehicleEngineState(this.parent.id-1, this.data.status);
    }

    function setStatusTo(newStatus) {
        this.data.status = newStatus;
        setVehicleEngineState(this.parent.vehicleid, newStatus);
    }

    /**
     * Returns how many gallons particular
     * engine will take fuel from fueltank
     * when vehicle is stands still.
     * @return {float} gallons
     */
    function getConsumptionInIDLE() {
        return this.data.consumption.idle;
    }

    /**
     * Returns how mane gallons particular
     * engine will take fuel from fueltank
     * when vehicle is moving.
     * @return {float} gallons
     */
    function getConsumptionInMOVE() {
        return this.data.consumption.move;
    }

    function setConsumptionInIDLE(value) {
        this.data.consumption.idle = value;
    }

    function setConsumptionInMOVE(value) {
        this.data.consumption.move = value;
    }
}


key("q", function(playerid) {
    if (!isPlayerInVehicle(playerid)) {
        return;
    }

    local vehicleid = getPlayerVehicle(playerid);
    vehicleid = vehicles_native[vehicleid].id;
    local eng = vehicles[vehicleid].components.findOne(VehicleComponent.Engine);
    // dbg(eng);

    // if engine is in its place and has expected obj type
    if ((eng || (eng instanceof VehicleComponent.Engine))) {
        eng.action();
    }
});
