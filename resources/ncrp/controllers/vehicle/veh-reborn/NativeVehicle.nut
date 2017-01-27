/**
 * Declaration of any type ingame vehicles including trailers.
 * Some vehicle, e.g. trailers, couldn't be upgaded or doesn't have
 * lights so their parts are different.
 */
class NativeVehicle {
    id = 0;

    constructor(model, px, py, pz, rx, ry, rz) {
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
