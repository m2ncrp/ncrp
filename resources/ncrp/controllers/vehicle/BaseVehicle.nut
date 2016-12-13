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
    
    constructor(model, px, py, pz, rx, ry, rz) {
        this.id = createVehicle(model, px, py, pz, rx, ry, rz);
        this.gabarites = Gabarites(id);
        this.fueltank = FuelTank(id, model);
        this.trunk = Trunk(id);

        _vehicle_queue.push(this);
    }

    function destructor() {
        // _vehicle_queue.remove(id); // too much to reorganize
        destroyVehicle(id);
    }

    function getModel() {
        return getVehicleModel( id );
    }

    function getName() {
        local model = getModel();
        return vehicle_info[model][2];
    }

    function getFuel() {
        return this.fueltank.getFuel();
    }

    function setFuel( to ) {
        this.fueltank.setFuel(to);
    }


    function getPos() {
        return getVehiclePosition(id);
    }

    function setPos(x,y,z) {
        setVehiclePosition( id, x, y, z );
    }

    function setPosVector(vector3d) {
        setVehiclePosition( id, vector3d[0], vector3d[1], vector3d[2] );
    }


    function getRot() {
        return getVehicleRotation(id);
    }

    function setRot(xr, yr, zr) {
        setVehicleRotation( id, xr, yr, zr );
    }


    function getSpeed() {
        return getVehicleSpeed( id );
    }

    function setSpeed(xs, ys, zs) {
        setVehicleSpeed( vehicleid, xs, ys, zs );
    }


    function getEngineState() {
        return this.engine.getState();
    }

    function setEngineState(to) {
        this.engine.setState(to);
    }


    function getColor() {
        return getVehicleColour(id);
    }

    function setColor(pr, pg, pb, sr, sg, sb) {
        setVehicleColour( id, pr, pg, pb, sr, sg, sb );
    }


    function getPlate () {
        return getVehiclePlateText(id);
    }

    function setPlate(to) {
        setVehiclePlateText( id, to );
    }


    function getDirtLevel() {
        return getVehicleDirtLevel(id);
    }

    function setDirlLevel(to) {
        setVehicleDirtLevel( id, to );
    }
}


class Vehicle extends BaseVehicle {
    lights = null;
    hood = null;
    engine = null;
    horn = null;

    // visual
    tuning_level = null;
    front_wheels = null;
    back_wheels = null;

    seats = {};
    distance = null;
    
    constructor(model, px, py, pz, rx, ry, rz) {
        base.constructor(model, px, py, pz, rx, ry, rz);
        this.lights = Lights(id);
        this.hood = Hood(id);
        this.engine = Engine(id);
        this.horn = Horn(id);

        this.distance = 0; // load from DB
        this.tuning_level = getTuning();
        this.front_wheels = getVehicleWheelTexture( id, 0 );
        this.back_wheels = getVehicleWheelTexture( id, 1 );
    }

    function getTuning() {
        return getVehicleTuningTable(id);
    }

    function setTuning(to) {
        setVehicleTuningTable( id, to );
    }

    function getWheels() {
        local result = array(2);
        result[0] = getVehicleWheelTexture( id, 0 );
        result[1] = getVehicleWheelTexture( id, 1 );
        return result;
    }

    function setWheels(to) {
        setVehicleWheelTexture( id, 0, to );
        setVehicleWheelTexture( id, 1, to );
    }

    function setFrontWheels(to) {
        setVehicleWheelTexture( id, 0, to );
    }

    function setBackWheels(to) {
        setVehicleWheelTexture( id, 1, to );
    }

    function getDistance() {
        return distance;
    }

    // Check every minute
    function calculateDistance(startPoint, endPoint) {
        local x = endPoint[0] - startPoint[0];
        local y = endPoint[1] - startPoint[1];
        local z = endPoint[2] - startPoint[2];
        distance += sqrt( x*x + y*y + z*z );
    }
}
