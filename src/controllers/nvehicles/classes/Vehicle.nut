class Vehicle extends ORM.Entity
{
    static classname = "Vehicle";
    static table     = "tbl_nvehicles";

    /**
     * if veh parked in garage with some visual contact assign 2
     * if not just despawn it to make room for someone else veh to be spawed
     */
    static State = {
        Loaded  = 0,
        Spawned = 1,
        Parked  = 2,
    };

    /**
     * if owner is player row in db linked with player's db id
     * if company - business id its owned
     */
    static Owner = {
        Player  = 0,
        Company = 1,
    };

    static Type = {
        sedan   = 0,
        hetch   = 1,
        truck   = 2,
        trailer = 3,
        bus     = 4,
        semitrailertruck = 5,
    };

    static fields = [
        ORM.Field.Integer({ name = "ownerid",   value = -1 }),
        ORM.Field.Integer({ name = "state",     value = 0 }),
        ORM.Field.String ({ name = "components", value = "[]", escaping = false }),
    ];

    static traits = [
        ORM.Trait.Positionable(),
        ORM.Trait.Rotationable(),
    ];

    /**
     * Id of created vehicle on server
     * @type {Integer}
     */
    vehicleid = -1;
    passengers = null;

    hack = null;

    constructor( model = 0 ) {
        base.constructor();

        local seats = getVehicleSeatsNumberByModelId(model);

        this.components = NVCContainer(this, this.components);
        this.passengers = array(seats, null);

        // common components
        this.components.push(NVC.Hull());
        this.getComponent(NVC.Hull).setDefaultModel(model);

        this.components.push(NVC.FuelTank({
            volume    = getDefaultVehicleFuelForModel(model),
            fuellevel = getDefaultVehicleFuelForModel(model),
        }));

        this.components.push(NVC.Engine());
        this.components.push(NVC.Plate());
        this.components.push(NVC.WheelPair());
        this.components.push(NVC.Gabarites());

        switch ( getModelType(model) ) {
            case Type.sedan:
            case Type.truck:
            case Type.hetch:
                this.components.push(NVC.Trunk(null, model));
                this.components.push(NVC.Lights());
                this.components.push(NVC.GloveCompartment());
                break;
            case Type.trailer:
                this.components.push(NVC.Trunk(null, model));
                break;
            case Type.bus:
            case Type.semitrailertruck:
                this.components.push(NVC.Lights());
                break;
        }
    }

    /**
     * Override hydration to parse custom values
     * @param  {Object} data
     * @return {Vehicle}
     */
    function hydrate(data) {
        local entity = base.hydrate(data);
        entity.components = NVCContainer(entity, entity.components);
        // dbg(this);
        return entity;
    }

    /**
     * Override default save method
     * to encode string serialize data to stirng
     * @return {Boolean}
     */
    function save() {
        // due to refresh our local position in DB
        this.getPosition();
        this.getRotation();
        local temp = clone this.components;
        this.components = this.components.serialize();
        base.save();
        this.components = temp;

        this.components.map( function(component) {component.save();});
        return true;
    }

    /**
     * Try to set virtual position, and if vehicle is Spawned
     * call native setVehiclePosition
     * Can be passed either number sequence or vector3 object
     *
     * @param {Float} x
     * @param {Float} y
     * @param {Float} z
     * or
     * @param {vector3} position
     *
     * @return {Boolean}
     */
    function setPosition(...) {
        if (vargv.len() == 3) {
            this.x = vargv[0].tofloat();
            this.y = vargv[1].tofloat();
            this.z = vargv[2].tofloat();

            if (this.state == this.State.Spawned)
                setVehiclePosition(this.vehicleid, this.x, this.y, this.z);

            return this;
        }

        if (vargv[0] instanceof Vector3) {
            this.x = vargv[0].x;
            this.y = vargv[0].y;
            this.z = vargv[0].z;

            if (this.state == this.State.Spawned)
                setVehiclePosition(this.vehicleid, this.x, this.y, this.z);
            return this;
        }

        dbg("vehicle", "setPosition", "arguments are invalid", vargv);
        return this;
    }

    /**
     * Return current player position
     * @return {vector3}
     */
    function getPosition() {
        if (this.state == this.State.Spawned) {
            local position = getVehiclePosition(this.vehicleid);

            this.x = position[0];
            this.y = position[1];
            this.z = position[2];
        }

        // todo: refactor
        return Vector3(this.x, this.y, this.z);
    }

    function setRotation(...) {
        if (vargv.len() == 3) {
            this.rx = vargv[0].tofloat();
            this.ry = vargv[1].tofloat();
            this.rz = vargv[2].tofloat();

            if (this.state == this.State.Spawned)
                setVehicleRotation(this.vehicleid, this.rx, this.ry, this.rz);

            return this;
        }

        if (vargv[0] instanceof Vector3) {
            this.rx = vargv[0].x;
            this.ry = vargv[0].y;
            this.rz = vargv[0].z;

            if (this.state == this.State.Spawned)
                setVehicleRotation(this.vehicleid, this.rx, this.ry, this.rz);
            return this;
        }

        dbg("vehicle", "setRotation", "arguments are invalid", vargv);
        return this;
    }


    function getRotation() {
        if (this.state == this.State.Spawned) {
            local rotation = getVehicleRotation(this.vehicleid);

            this.rx = rotation[0];
            this.ry = rotation[1];
            this.rz = rotation[2];
        }

        // todo: refactor
        return Vector3(this.rx, this.ry, this.rz);
    }


    /**
     * Spawning vehicle from local object data
     * @return {Boolean}
     */
    function spawn() {
        local hull = this.components.findOne(NVC.Hull);

        if (!hull || !(hull instanceof NVC.Hull)) {
            throw "Vehicle: cannot spawn vehicle wihtout hull!";
        }

        this.vehicleid = original__createVehicle(hull.getModel(), this.x, this.y, this.z, this.rx, this.ry, this.rz);
        vehicles_native[this.vehicleid] <- this;

        if (this.vehicleid < 0) {
            throw "Vehicle: cannot spawn vehicle with provided data!";
        }

        // fix to prevent wrong rotation at spawn-time
        setVehicleRotation(this.vehicleid, this.rx, this.ry, this.rz);

        foreach (idx, component in this.components) {
            component.setParent(this);
            component.correct();
        }

        this.state = this.State.Spawned;
        this.hack = DirtyHack(this);

        return true;
    }

    /**
     * Despawning (destryoing) created vehicles
     * @param {Boolean} light - if true it will only destroy a
     *     car w/o changing the state (used for removing vehicle before stopping server)
     * @return {Boolean}
     */
    function despawn(light = false) {
        if (this.state != this.State.Spawned) {
            throw "Vehicle: trying to despawn non-spawned vehicle!";
        }

        destroyVehicle(this.vehicleid);
        delete vehicles_native[this.vehicleid];

        if (!light) {
            this.state = this.State.Loaded;
            this.vehicleid = -1;
        }

        return true;
    }

    function correct() {
        if (this.state == this.State.Spawned) {
            this.components.map(function(comp) { comp.correct() })

            if (this.isEmpty()) {
                setVehicleSpeed(this.vehicleid, 0.0, 0.0, 0.0);
                this.setPosition(this.getPosition())
                this.setRotation(this.getRotation())
            }

            return true;
        }

        return false;
    }

    function onMinute() {
        this.correct();

        // update Passengers
        foreach (seat, character in this.passengers) {
            if (character && !isPlayerConnected(character.playerid)) {
                this.passengers[seat] = null;
            }
        }

        this.components.map(function(comp) { comp.onMinute() });
    }

    function onEnter(character, seat) {
        log(character.getName() + " #" + character.playerid + " JUST ENTERED VEHICLE with ID=" + this.id.tostring() + " (seat: " + seat.tostring() + ")." );

        // correct state of all the vehicle components
        this.hack.onEnter(seat);

        // add player as a vehicle passenger
        this.passengers[seat] = character;
        this.components.map(function(comp) { comp.onEnter(character, seat) });
    }

    function onExit(character, seat) {
        log(character.getName() + " #" + character.playerid + " JUST LEFT VEHICLE with ID=" + this.id.tostring() + " (seat: " + seat.tostring() + ")." );

        // remove player as a vehicle passenger
        this.passengers[seat] = null;

        // correct state of all the vehicle components
        this.hack.onExit(seat);
        this.components.map(function(comp) { comp.onExit(character, seat) });
    }

    function getPassengers() {
        local table = {};

        foreach (seat, character in this.passengers) {
            if (character == null) continue;
            table[seat] <- character;
        }

        return table;
    }

    function getPassengersCount() {
        return this.getPassengers().len();
    }

    function isEmpty() {
        return (this.getPassengersCount() < 1);
    }

    function getPlayerSeat(character) {
        if (!(character instanceof Character)) {
            throw "Vehicle.getPlayerSeat( Character ) : Character object should be provided, not playerid!"
        }

        foreach (seat, target in this.passengers) {
            if (target.id == character.id) return seat;
        }

        return null;
    }

    function isPlayerOnSeat(character, seat) {
        return getPlayerSeat(character) == seat;
    }

    function isPlayerDriver(character) {
        return isPlayerOnSeat(character, 0);
    }

    function getDriver() {
        if (this.getPassengers()) {
            return this.passengers[0];
        }

        return null;
    }

    function isMoving(minimalspeed = 0.5) {
        local velocity = getVehicleSpeed(this.vehicleid);
        return (fabs(velocity[0]) > minimalspeed || fabs(velocity[1]) > minimalspeed);
    }

    function getType() {
        local model = this.getComponent(NVC.Hull).getModel();
        return getModelType(model);
    }

    /**
     * Check if there's given component in vehicle data field.
     * Return NVC tobj is it's exist otherwise throw an exception
     * @param  {Mixed} idOrType
     * @return {NVC}
     */
    function getComponent(idOrType) {
        local c = this.components.findOne(idOrType);

        if (!c) {
            throw "Vehicle: cannot find " + idOrType.classname + "!";
        }

        return c;
    }

    function getSpeed() {
        return getVehicleSpeed(this.vehicleid);
    }

    function setSpeed(v = Vector3(0.0, 0.0, 0.0) ) {
        setVehicleSpeed(this.vehicleid, v.x, v.y, v.z);
        return this;
    }
}




local door_test = false;
local door_radius = 0.7;

function drawVehicleDoorPositions(playerid, doors) {
    foreach (idx, door in doors) {
        if (door == null) continue;
        create3DText ( door.x, door.y, door.z, "TRIGGER: "+idx, CL_ROYALBLUE );
    }
}

// // print to console
// key("f", function(playerid) {
//     local vehicle = vehicles.nearestVehicle(playerid);
//     if ( vehicle.getType() != Vehicle.Type.bus ) return;

//     local model = vehicle.getComponent(NVC.Hull).getModel();
//     local doors = getVehicleDoorsPosition(model);

//     local character = players[playerid];
//     local p_pos = character.getPosition();

//     // dbg(doors);

//     calcTriggerPositions(playerid, vehicle.vehicleid, doors);
// });


// // print and draw
// key("g", function(playerid) {
//     local vehicle = vehicles.nearestVehicle(playerid);
//     if ( vehicle.getType() != Vehicle.Type.bus ) return;

//     local model = vehicle.getComponent(NVC.Hull).getModel();
//     local doors = getVehicleDoorsPosition(model);

//     local character = players[playerid];
//     local p_pos = character.getPosition();

//     dbg(doors);

//     doors = calcTriggerPositions(playerid, vehicle.vehicleid, doors);
//     drawVehicleDoorPositions(playerid, doors);
// });


// print and draw
key("h", function(playerid) {
    local vehicle = vehicles.nearestVehicle(playerid);
    // if ( vehicle.getType() != Vehicle.Type.bus ) return;

    local model = vehicle.getComponent(NVC.Hull).getModel();
    local doors = getVehicleTriggersPosition(model);

    local character = players[playerid];
    local p_pos = character.getPosition();

    // dbg(doors);

    doors = calcTriggerPositions(playerid, vehicle.vehicleid, doors);
    drawVehicleDoorPositions(playerid, doors);
});
