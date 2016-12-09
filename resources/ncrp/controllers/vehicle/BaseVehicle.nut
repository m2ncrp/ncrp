/**
 * Declaration of any type ingame vehicles including trailers.
 * Some vehicle, e.g. trailers, couldn't be upgaded or doesn't have
 * lights so their parts are different.
 */
class BaseVehicle {
    id = 0;

    // parts
    gabarites = null;
    fueltank = null;
    trunk = null;

    // visual
    tuning_level = null;
    front_wheels = null;
    back_wheels = null;
    
    constructor(model, px, py, pz, rx, ry, rz) {
        this.id = createVehicle(model, px, py, pz, rx, ry, rz);
        this.gabarites = Gabarites(id);
        this.fueltank = FuelTank(id, model);
        this.trunk = Trunk(id);

        this.tuning_level = getVehicleTuningTable( id );
        this.front_wheels = getVehicleWheelTexture( id, 0 );
        this.back_wheels = getVehicleWheelTexture( id, 1 );

        _vehicle_queue.push(this);
    }

    function getModel() {
        return getVehicleModel( id );
    }

    function getName() {
        local model = getModel();
        return vehicle_info[model][2];
    }

    function getFuel() {
        return getVehicleFuel(id);
    }

    function setFuel( to ) {
        this.fueltank.setCurrentLevel(to);
    }


    function getPos() {
        return getVehiclePosition(id);
    }

    function setPos(x,y,z) {
        setVehiclePosition( id, x, y, z );
    }

    function setPosVector(pos) {
        setVehiclePosition( id, pos[0], pos[1], pos[2] );
    }


    function getRot() {
        // Code
    }

    function setRot() {
        // Code
    }


    function getSpeed() {
        // Code
    }

    function setSpeed() {
        // Code
    }


    function getEngineState() {
        // Code
    }

    function setEngineState() {
        // Code
    }


    function getColor() {
        // Code
    }

    function setColor() {
        // Code
    }


    function getPlate () {
        // Code
    }

    function setPlate() {
        // Code
    }


    function getDirtLevel() {
        // Code
    }

    function setDirlLevel() {
        // Code
    }


    function getTuning() {
        // Code
    }

    function setTuning() {
        // Code
    }


    function gb_left() {
        gabarites.switchLeft();
    }

    function gb_right() {
        gabarites.switchRight();
    }

    function gb_both() {
        gabarites.switchBoth();
    }
}
