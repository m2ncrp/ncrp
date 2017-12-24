include("controllers/nvehicles/classes/Vehicle_hack.nut");

class Vehicle extends ORM.Entity
{
    static classname = "Vehicle";
    static table     = "tbl_nvehicles";

    static State = {
        Loaded  = 0,
        Spawned = 1,
    };

    static Type = {
        sedan = 0,
        hetch = 1,
        truck = 2,
        trailer = 3,
        bus = 4,
        semitrailertruck = 5,
    };

    static fields = [
        ORM.Field.Integer({ name = "ownerid",   value = -1 }),
        ORM.Field.Integer({ name = "state",     value = 0 }),
        ORM.Field.String( { name = "components",value = "[]" }),
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

    constructor( type = null ) {
        base.constructor();
        this.components = VehicleComponentContainer(this, this.components);

        if (type == null) {
            type = Vehicle.Type.sedan;
        }
        // common components
        this.components.push(VehicleComponent.Hull());
        this.components.push(VehicleComponent.FuelTank());
        this.components.push(VehicleComponent.Engine());
        this.components.push(VehicleComponent.Plate());
        this.components.push(VehicleComponent.WheelPair());
        this.components.push(VehicleComponent.Gabarites());
        switch (type) {
            case Type.sedan:
            case Type.truck:
            case Type.hetch:
                this.components.push(VehicleComponent.Trunk());
                this.components.push(VehicleComponent.Lights());
                break;
            case Type.trailer:
                this.components.push(VehicleComponent.Trunk());
                break;
            case Type.bus:
            case Type.semitrailertruck:
                this.components.push(VehicleComponent.Lights());
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
        entity.components = VehicleComponentContainer(entity, entity.components);
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
        local temp = this.components;
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
        local hull = this.components.findOne(VehicleComponent.Hull);

        if (!hull || !(hull instanceof VehicleComponent.Hull)) {
            throw "Vehicle: cannot spawn vehicle wihtout hull!";
        }

        this.vehicleid = createVehicle(hull.getModel(), this.x, this.y, this.z, this.rx, this.ry, this.rz);
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
     * @return {Boolean}
     */
    function despawn() {
        if (this.state != this.State.Spawned) {
            throw "Vehicle: trying to despawn non-spawned vehicle!";
        }

        destroyVehicle(this.vehicleid);

        delete vehicles_native[this.vehicleid];
        this.state = this.State.Spawned;
        this.vehicleid = -1;

        return true;
    }


    function correct() {
        if (this.state == this.State.Spawned) {
            foreach (idx, component in this.components) {
                component.correct();
            }
            return true;
        }
        return false;
    }

    function initAllComponents() {
        this.components.add(component.id, entityClass(component));
    }
}
