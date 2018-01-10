class VehicleComponent.Trunk extends VehicleComponent {
    static classname = "VehicleComponent.Trunk";

    partID = VEHICLE_PART_TRUNK; // ~ 1
    container = null;

    loaded = false;

    static Status = {
        locked = 0,
        opened = 1,
        closed = 2, // doors closed, but not locked with key
    }

    constructor (data = null, model = null) {
        base.constructor(data);

        if (data == null) {
            this.data = {
                status = this.Status.locked,
                code   = null,
                sizeX  = getTrunkDefaultSizeX(model),
                sizeY  = getTrunkDefaultSizeY(model),
                limit  = getTrunkDefaultWeightLimit(model),
            }
        }

        this.container = TrunkItemContainer(this.parent, this.data);
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

    function getStatus() {
        return this.data.status;
    }

    function setStatus(state) {
        this.data.status = state;
        this.correct();
    }

    function action() {
        this.data.status = !this.data.status; // if it's true so it was open. Become false
        this.correct(); // so it will be closed
    }

    function correct() {
        if (this.isLocked() || this.isClosed()) {
            setVehiclePartOpen(this.parent.vehicleid, partID, false);
        }
        if (this.isOpened()) {
            setVehiclePartOpen(this.parent.vehicleid, partID, true);
        }
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

    function _getHash() {
        return this.data.code;
    }

    function _setHash(value) {
        this.data.code = md5(value.tostring());
    }

    function isLocked() {
        return this.getStatus() == this.Status.locked;
    }

    function isClosed() {
        return this.getStatus() == this.Status.closed;
    }

    function isOpened() {
        return this.getStatus() == this.Status.opened;
    }
}


function _getTrunk(playerid) {
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

    if ( checkDistanceXY(x, y, p_pos[0], p_pos[1], radius) ) {
        return trunk;
    }
    return null;
}



key("e", function(playerid) {
    local trunk = _getTrunk(playerid);
    if (trunk == null) return;

    local charInventory = players[playerid].inventory;

    local hasKey = false;
    foreach (idx, item in players[playerid].inventory) {
        if ((item._entity == "Item.VehicleKey") && (item.data.id == trunk.data.code)) {
            hasKey = true;
            break;
        }
    }

    if ( trunk.isLocked() && hasKey ) {
        trunk.setStatus( VehicleComponent.Trunk.Status.opened );
        return msg(playerid, "Вы успешно отперли багажник " + trunk.parent.id + " машины. Грац!");
    }

    if ( trunk.isOpened() && hasKey ) {
        if (trunk.container.isOpenedBySomebody()){
            trunk.container.hideForAll();
        }
        trunk.setStatus( VehicleComponent.Trunk.Status.locked );
        charInventory.hide(playerid);
        return msg(playerid, "Вы успешно заперли багажник " + trunk.parent.id + " машины. Грац!");
    }

    if ( trunk.isClosed() && hasKey ) {
        if (trunk.container.isOpenedBySomebody()){
            trunk.container.hideForAll();
        }
        trunk.setStatus( VehicleComponent.Trunk.Status.locked );
        charInventory.hide(playerid);
        return msg(playerid, "Вы успешно заперли багажник " + trunk.parent.id + " машины. Грац!");
    }

    if ( trunk.isLocked() && !hasKey ) {
        trunk.setStatus( VehicleComponent.Trunk.Status.locked );
        return msg(playerid, "Вы дергаете за ручку багажника машины, но она не поддается!");
    }

    if ( trunk.isOpened() && !hasKey ) {
        if (trunk.container.isOpenedBySomebody()){
            trunk.container.hideForAll();
        }
        trunk.setStatus( VehicleComponent.Trunk.Status.closed );
        charInventory.hide(playerid);
        return msg(playerid, "Вы прикрыли багажник " + trunk.parent.id + " машины.");
    }

    if ( trunk.isClosed() && !hasKey ) {
        trunk.setStatus( VehicleComponent.Trunk.Status.opened );
        return msg(playerid, "Вы успешно открыли багажник " + trunk.parent.id + " машины. Он оказался не заперт. Грац!");
    }
});


key("tab", function(playerid) {
    local trunk = _getTrunk(playerid);
    if (trunk == null) return;

    local charInventory = players[playerid].inventory;

    if ( trunk.isOpened() ) {
        if (!trunk.isLoaded()) {
            trunk.load();
        }

        if (!trunk.container.isOpened(playerid)) {
            trunk.container.show(playerid);
            charInventory.hide(playerid);
        } else {
            trunk.container.hide(playerid);
        }
    }
});
