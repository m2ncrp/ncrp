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
    local vehicleid = vehicles.nearestVehicle(playerid)+1;
    if (vehicleid == -1) return;

    local trunk = vehicles[vehicleid].components.findOne(VehicleComponent.Trunk);

    local v_pos = getVehiclePosition(vehicleid);
    local v_ang = getVehicleRotation(vehicleid);
    local p_pos = getPlayerPosition(playerid);

    // local offsets = Vector3(0, -2.51, 0);
    local trunk_offset_x = 0;
    local trunk_offset_y = -2.51;
    local trunk_offset_z = 0;

    local radius = 0.7;

    local t_v3 = Vector3(trunk_offset_x, trunk_offset_y, trunk_offset_z);
    t_v3 = t_v3.rotate(v_ang[0], v_ang[1], v_ang[2] );
    // dbg(t_v3); dbg();

    local x = v_pos[0] + t_v3.z;
    local y = v_pos[1] + t_v3.y;
    local z = v_pos[2] - t_v3.x;

        // setPlayerPosition(playerid, x, y, z);

    dbg( "Vehicle " + vehicleid + " position is " + v_pos[0] + ", " + v_pos[1] + ", " + v_pos[2] + "." );
    dbg( "Vehicle " + vehicleid + " trunk position is " + x + ", " + y + ", " + z + "." );

    // if ( isInRadius(playerid, x, y, z, radius) ) {
    if ( checkDistanceXY(x, y, p_pos[0], p_pos[1], radius) ) {
        dbg( "Trunk status of " + vehicleid  + " vehicle has been set to " + !trunk.data.status);
        trunk.setState( !trunk.data.status );
        sendPlayerMessage(playerid, "Вы успешно открыли багажник " vehicleid + " машины. Грац!");
        return true;
    }
    return false;
});

