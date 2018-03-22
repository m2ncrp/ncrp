class NVC.Engine extends NVC
{
    static classname = "NVC.Engine";

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

    isTuneBeenSet = true;

    constructor (data = null) {
        // dbg("called engine creation");
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

    function getTune() {
        return this.data.tune;
    }

    function setTune(level) {
        switch (level) {
            case NVC.Engine.Tune.Basic:
                this.data.tune = level;
                isTuneBeenSet = true;
                break;
            case NVC.Engine.Tune.Sport:
                this.data.tune = level;
                isTuneBeenSet = true;
                break;
            case NVC.Engine.Tune.Supercharged:
                this.data.tune = level;
                isTuneBeenSet = true;
                break;
            default:

        }
        this.correct();
    }

    function beforeAction() {
        dbg("Engine Action method was called @line 21 Engine.nut");
    }

    function toggle() {
        this.data.status = !this.data.status;
        // stateSetter( this.parent.id, this.data.status );
        this.correct();
    }

    function correct() {
        // stateSetter( this.parent.id, this.data.status );
        if (isTuneBeenSet) {
            setVehicleTuningTable(this.parent.vehicleid, this.data.tune);
            isTuneBeenSet = false;
        }
        setVehicleEngineState(this.parent.vehicleid, this.data.status);
    }

    function setStatusTo(newStatus) {
        this.data.status = newStatus;
        setVehicleEngineState(this.parent.vehicleid, newStatus);
    }

    function getState() {
        return this.data.status;
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
    local character = players[playerid];
    if (!isPlayerInNVehicle(playerid)) return;

    local vehicle = getPlayerNVehicle(playerid);
    local keylock = vehicle.components.findOne(NVC.KeyLock);
    local engine  = vehicle.components.findOne(NVC.Engine);

    if (!keylock || keylock.isUnlockableBy(character)) {
        if (engine) engine.toggle();
    } else {
        msg(playerid, "you dont have a proper key")
    }
})
