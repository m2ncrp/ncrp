class Vehicle extends ORM.Entity
{
    static classname = "Vehicle";
    static table     = "tbl_nvehicles";

    static State = {
        Loaded  = 0,
        Spawned = 1,
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

    constructor() {
        base.constructor();
        this.components = VehicleComponentContainer(this.components);
    }

    /**
     * Override hydration to parse custom values
     * @param  {Object} data
     * @return {Vehicle}
     */
    function hydrate(data) {
        local entity = base.hydrate(data);
        entity.components = VehicleComponentContainer(entity.components);
        return entity;
    }

    /**
     * Override default save method
     * to encode string serialize data to stirng
     * @return {Boolean}
     */
    function save() {
        local temp = this.components;
        this.components = this.components.serialize();
        base.save();
        this.components = temp;
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

            return (this.state == this.States.Spawned) ? setVehiclePosition(this.vehicleid, this.x, this.y, this.z) : false;
        }

        if (vargv[0] instanceof vector3) {
            this.x = vargv[0].x;
            this.y = vargv[0].y;
            this.z = vargv[0].z;

            return (this.state == this.States.Spawned) ? setVehiclePosition(this.vehicleid, this.x, this.y, this.z) : false;
        }

        return dbg("player", "setPosition", "arguments are invalid", vargv) && false;
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
        return vector3(this.x, this.y, this.z);
    }

    /**
     * Spawning vehicle from local object data
     * @return {Boolean}
     */
    function spawn() {
        local hull = this.components.findOne(VehicleComponent.Hull);

        if (!hull || !(hull instanceof VehicleComponent.Hull)) {
            return false && dbg("Vehicle: cannot spawn vehicle wihtout hull!");
        }

        this.vehicleid = createVehicle(hull.getModel(), this.x, this.y, this.z, this.rx, this.ry, this.rz);

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

        this.state = this.State.Spawned;
        this.vehicleid = -1;

        return true;
    }
}
