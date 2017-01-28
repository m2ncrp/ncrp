/**
 * Declaration of any type ingame vehicles including trailers.
 * Some vehicle, e.g. trailers, couldn't be upgaded or don't have
 * lights so their parts are different.
 */
class NativeVehicle {
    id = 0;

    constructor(model, px, py, pz, rx = 0.0, ry = 0.0, rz = 0.0) {
        this.id = createVehicle(model, px, py, pz, rx, ry, rz);
    }

    function destructor() {
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
        return getVehicleFuel(id);
    }

    function setFuel( to ) {
        setVehicleFuel(id, to);
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
        return getVehicleEngineState(id);
    }

    function setEngineState(to) {
        setVehicleEngineState( id, to );
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

    function getTuning() {
        return getVehicleTuningTable(id);
    }

    function setTuning(to) {
        setVehicleTuningTable( id, to );
    }

    function getWheels(wheel_pair) {
        return getVehicleWheelTexture( id, wheel_pair );;
    }

    function setWheels(wheel_pair, to) {
        setVehicleWheelTexture( id, wheel_pair, to );
    }
}
