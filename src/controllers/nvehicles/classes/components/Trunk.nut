class NVC.Trunk extends NVC {
    static classname = "NVC.Trunk";

    partID    = VEHICLE_PART_TRUNK; // ~ 1
    container = null;
    loaded    = false;

    static LockStatus = {
        unlocked = 0,
        locked   = 1,
    }

    static OpenStatus = {
        closed = 0,
        opened = 1,
    }

    constructor (data = null, model = null) {
        base.constructor(data);

        if (data == null) {
            this.data = {
                locked = this.LockStatus.unlocked,
                status = this.OpenStatus.closed,
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

    function lock() {
        if (this.isUnlocked()) {
            this.close();
            this.data.locked = this.LockStatus.locked;
        }
    }

    function unlock() {
        this.data.locked = this.LockStatus.unlocked;
    }

    function open() {
        if (!this.isOpened()) {
            this.data.status = this.OpenStatus.opened;
            this.correct()
        }
    }

    function close() {
        if (this.isOpened()) {
            this.data.status = this.OpenStatus.closed;
            this.container.hideForAll();
            this.correct()
        }
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

    function isLocked() {
        return this.data.locked == this.LockStatus.locked;
    }

    function isUnlocked() {
        return this.data.locked == this.LockStatus.unlocked;
    }

    function isClosed() {
        return this.data.status == this.OpenStatus.closed;
    }

    function isOpened() {
        return this.data.status == this.OpenStatus.opened;
    }
}


function _getTrunkPlayerIsNear(playerid) {
    if (isPlayerInNVehicle(playerid)) return;
    local vehicle = vehicles.nearestVehicle(playerid);
    if (vehicle == null || vehicle.getType() == Vehicle.Type.semitrailertruck || vehicle.getType() == Vehicle.Type.bus) return null;

    local model = vehicle.getComponent(NVC.Hull).getModel();
    local trunk = vehicle.getComponent(NVC.Trunk);

    local v_pos = getVehiclePosition(vehicle.vehicleid);
    local v_ang = getVehicleRotation(vehicle.vehicleid);
    // local p_pos = getPlayerPosition(playerid);
    local p_pos = players[playerid].getPosition();

    local radius = 0.7;
    local offsets = getVehicleTruckPosition(model);//Vector3(0, -2.51, 0);

    if (offsets == null) return null;

    local d_pos = Matrix([offsets.x, offsets.y, offsets.z]) * EulerAngles(v_ang);

    offsets.x = v_pos[0] + d_pos._data[0][0];
    offsets.y = v_pos[1] + d_pos._data[0][1];
    offsets.z = v_pos[2] + d_pos._data[0][2] / 2.0;

    if ( checkDistanceXY( offsets.x, offsets.y, p_pos.x, p_pos.y, radius) ) {
        msg(playerid, "Your are staning on Trunk trigger");
        return trunk;
    }

    return null;



    // offsets = offsets.rotate(v_ang[0], v_ang[1], v_ang[2] );

    // local x = v_pos[0] + offsets.z;
    // local y = v_pos[1] + offsets.y;
    // local z = v_pos[2] - offsets.x;

    // if ( checkDistanceXY(x, y, p_pos[0], p_pos[1], radius) ) {
    //     return trunk;
    // }
}

/**
 * Lock/unlock the trunk
 */
key("q", function(playerid) {
    local trunk = _getTrunkPlayerIsNear(playerid);

    /* if we are not near a trunk or vehicle doesnt have a keylock - exit */
    if (!trunk || !trunk.parent.components.findOne(NVC.KeyLock)) return;
    local keylock = trunk.parent.components.findOne(NVC.KeyLock);

    if (trunk.isLocked()) {
        if (keylock.isUnlockableBy(players[playerid])) {
            trunk.unlock();
            msg(playerid, "Вы успешно отперли багажник " + trunk.parent.id + " машины. Грац!");
        } else {
            msg(playerid, "Вы дергаете за ручку багажника машины, но она не поддается!");
        }
    } else {
        if (keylock.isUnlockableBy(players[playerid])) {
            trunk.lock();
            msg(playerid, "Вы успешно заперли багажник " + trunk.parent.id + " машины. Грац!");
        } else {
            msg(playerid, "Вы не можете запереть багажник этим ключем!");
        }
    }
});

/**
 * Open/close trunk
 */
key("e", function(playerid) {
    /* if we are not near a trunk or vehicle doesnt have trunk - exit */
    local trunk   = _getTrunkPlayerIsNear(playerid); if (!trunk) return;
    local keylock = trunk.parent.components.findOne(NVC.KeyLock);

    /* correct the possibly opened trunk by client */
    trunk.correct();

    if (trunk.isOpened()) {
        trunk.close();
        msg(playerid, "Вы прикрыли багажник " + trunk.parent.id + " машины.");
    } else {
        if (!keylock || trunk.isUnlocked()) {
            trunk.open();
            msg(playerid, "Вы успешно открыли багажник " + trunk.parent.id + " машины. Грац!");
        } else {
            msg(playerid, "Вы дергаете за ручку багажника машины, но она не поддается (заперт)!");
        }
    }
});

/**
 * Show/hide trunk inventory
 */
key("tab", function(playerid) {
    /* if we are not near a trunk or vehicle doesnt have trunk - exit */
    local trunk = _getTrunkPlayerIsNear(playerid); if (!trunk) return;
    local character = players[playerid]

    // if trunk not opened - exit, else
    // load the content of the trunk (from database)
    if (!trunk.isOpened()) return;
    if (!trunk.isLoaded()) trunk.load();

    if (!trunk.container.isOpened(playerid)) {
        trunk.container.show(playerid);

        // this is a HACK
        // if inventory is opened, we gonna hide it
        // however it will be opened again, by other TAB handler
        if (character.inventory.isOpened(playerid)) {
            character.inventory.hide(playerid);
        }
    } else {
        trunk.container.hide(playerid);
    }
});
