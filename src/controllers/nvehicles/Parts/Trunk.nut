class VehicleComponent.Trunk extends VehicleComponent {
    static classname = "VehicleComponent.Trunk";

    partID = VEHICLE_PART_TRUNK; // ~ 1
    container = null;

    loaded = false;

    constructor (data = null, model = null) {
        base.constructor(data);
        this.container = TrunkItemContainer(this.parent, model);

        if (data == null) {
            this.data = {
                status = false,
            }
        }
    }

    function setParent(parent) {
        this.container.parent = parent;
        return base.setParent(parent);
    }

    function save() {
        foreach (idx, item in this.container) {
            item.parent = this.parent.id;
            item.save();
        }
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

    function load() {
        local self = this;
        ORM.Query("select * from tbl_items where parent = :id and state = :states")
            .setParameter("id", this.parent.id)
            .setParameter("states", Item.State.TRUNK, true)
            .getResult(function(err, items) {
                foreach (idx, item in items) {
                    self.container.set(item.slot, item);
                }
            });

        this.loaded = true;
    }

    function isLoaded() {
        return this.loaded;
    }
}


key("e", function(playerid) {
    if (isPlayerInNVehicle(playerid)) return;
    local vehicle = vehicles.nearestVehicle(playerid);
    if (vehicle == null) return;

    local trunk = vehicle.getComponent(VehicleComponent.Trunk);
    local vid = vehicle.id;



    local v_pos = getVehiclePosition(vehicle.vehicleid);
    local v_ang = getVehicleRotation(vehicle.vehicleid);
    local p_pos = getPlayerPosition(playerid);

    local offsets = Vector3(0, -2.51, 0);
    local radius = 0.7;

    offsets = offsets.rotate(v_ang[0], v_ang[1], v_ang[2] );

    local x = v_pos[0] + offsets.z;
    local y = v_pos[1] + offsets.y;
    local z = v_pos[2] - offsets.x;

    // dbg( "Vehicle " + vid + " position is " + v_pos[0] + ", " + v_pos[1] + ", " + v_pos[2] + "." );
    // dbg( "Vehicle " + vid + " trunk position is " + x + ", " + y + ", " + z + "." );

    // if ( isInRadius(playerid, x, y, z, radius) ) {
    if ( checkDistanceXY(x, y, p_pos[0], p_pos[1], radius) ) {
        // dbg( "Trunk status of " + vid  + " vehicle has been set to " + !trunk.data.status);
        if (!trunk.data.status) {
            msg(playerid, "Вы успешно открыли багажник " + vid + " машины. Грац!");
            if (!trunk.isLoaded()) {
                trunk.load();
            }

            trunk.container.show(playerid);
        } else {
            msg(playerid, "Вы успешно закрыли багажник " + vid + " машины. Грац!");
            trunk.container.hide(playerid);
        }
        trunk.setState( !trunk.data.status );
        return true;
    }
    return false;
});
