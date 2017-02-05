/**
 * Declaration of any type ingame vehicles including trailers.
 * Some vehicle, e.g. trailers, couldn't be upgaded or don't have
 * lights so their parts are different.
 */
class NativeVehicle extends CustomVehicle {
    static classname = "NativeVehicle";
    // Vehicle ID on the server
    vid = 0;
    link = null;
    constructor(DB_data) {
        base.constructor();
        this.vid = createVehicle(DB_data.model,
                                 DB_data.x,
                                 DB_data.y,
                                 DB_data.z,
                                 DB_data.rx,
                                 DB_data.ry,
                                 DB_data.rz);

        this.setColor( DB_data.cra, DB_data.cga, DB_data.cba, DB_data.crb, DB_data.cgb, DB_data.cbb );
        this.setPlate( DB_data.plate );
        this.setTuning( DB_data.tunetable );
        this.setFuel( DB_data.fuellevel );
        this.setDirlLevel( DB_data.dirtlevel );

        this.link = DB_data;
    }

    function destructor() {
        destroyVehicle(vid);
    }

    function respawn() {
        respawnVehicle(vid);
    }

    function getModel() {
        return getVehicleModel( vid );
    }

    function getName() {
        local model = getModel();
        return vehicle_info[model][2];
    }

    function getFuel() {
        return getVehicleFuel(vid);
    }

    function setFuel( to ) {
        setVehicleFuel(vid, to);
    }


    function getPos() {
        return getVehiclePosition(vid);
    }

    function setPos(x,y,z) {
        setVehiclePosition( vid, x, y, z );
    }

    function setPosVector(vector3d) {
        setVehiclePosition( vid, vector3d[0], vector3d[1], vector3d[2] );
    }


    function getRot() {
        return getVehicleRotation(vid);
    }

    function setRot(xr, yr, zr) {
        setVehicleRotation( vid, xr, yr, zr );
    }


    function getSpeed() {
        return getVehicleSpeed( vid );
    }

    function setSpeed(xs, ys, zs) {
        setVehicleSpeed( vid, xs, ys, zs );
    }


    function getEngineState() {
        return getVehicleEngineState(vid);
    }

    function setEngineState(to) {
        setVehicleEngineState( vid, to );
    }


    function getColor() {
        return getVehicleColour(vid);
    }

    function setColor(pr, pg, pb, sr, sg, sb) {
        setVehicleColour( vid, pr, pg, pb, sr, sg, sb );
    }


    function getPlate() {
        return getVehiclePlateText(vid);
    }

    function setPlate(to) {
        setVehiclePlateText( vid, to );
    }


    function getDirtLevel() {
        return getVehicleDirtLevel(vid);
    }

    function setDirlLevel(to) {
        setVehicleDirtLevel( vid, to );
    }

    function getTuning() {
        return getVehicleTuningTable(vid);
    }

    function setTuning(to) {
        setVehicleTuningTable( vid, to );
    }

    function getWheels(wheel_pair) {
        return getVehicleWheelTexture( vid, wheel_pair );;
    }

    function setWheels(wheel_pair, to) {
        setVehicleWheelTexture( vid, wheel_pair, to );
    }

    function repair() {
        repairVehicle(vid);
    }

    function explode() {
        explodeVehicle(vid);
    }
}
