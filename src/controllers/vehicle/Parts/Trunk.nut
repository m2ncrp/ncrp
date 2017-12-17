// include("controllers/vehicle/traits/Openable.nut");
include("controllers/vehicle/classes/Vehicle_hack.nut");

class VehicleComponent.Trunk extends VehicleComponent {
    static classname = "VehicleComponent.Trunk";

    // static traits = [
    //     Openable(),
    // ];

    partID = VEHICLE_PART_TRUNK; // ~ 1

    constructor (data) {
        base.constructor(data);

        // this.type      = "Engine";
        // this.subtype   = "Engine";
        // this.partID    = VEHICLE_PART_TRUNK; // ~ 1
    }

    function setState(state) {
        this.data.status = !this.data.status;
        this.correct();
    }

    function action() {
        this.data.status = !this.data.status; // if it's true so it was open. Become false
        this.correct(); // so it will be closed
    }

    function correct() {
        setVehiclePartOpen(this.parent.vehicleid, partID, this.data.status);
    }
}


key("e", function(playerid) {
    local vehicle = vehicles.nearestVehicle(playerid);
    if (vehicle == null) return;

    local trunk = vehicle.components.findOne(VehicleComponent.Trunk);
    local vid = vehicle.vehicleid;

    local v_pos = getVehiclePosition(vid);
    local v_ang = getVehicleRotation(vid);
    local p_pos = getPlayerPosition(playerid);

    local offsets = Vector3(0, -2.51, 0);
    local radius = 0.7;

    offsets = offsets.rotate(v_ang[0], v_ang[1], v_ang[2] );

    local x = v_pos[0] + offsets.z;
    local y = v_pos[1] + offsets.y;
    local z = v_pos[2] - offsets.x;

    dbg( "Vehicle " + vid + " position is " + v_pos[0] + ", " + v_pos[1] + ", " + v_pos[2] + "." );
    dbg( "Vehicle " + vid + " trunk position is " + x + ", " + y + ", " + z + "." );

    // if ( isInRadius(playerid, x, y, z, radius) ) {
    if ( checkDistanceXY(x, y, p_pos[0], p_pos[1], radius) ) {
        dbg( "Trunk status of " + vid  + " vehicle has been set to " + !trunk.data.status);
        if (!trunk.data.status) {
            msg(playerid, "Вы успешно открыли багажник " + vid + " машины. Грац!");
        } else {
            msg(playerid, "Вы успешно закрыли багажник " + vid + " машины. Грац!");
        }
        trunk.setState( !trunk.data.status );
        return true;
    }
    return false;
});

