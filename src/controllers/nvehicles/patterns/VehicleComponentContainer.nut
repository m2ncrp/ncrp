class VehicleComponentContainer extends Container
{

    __parent = null;

    /**
     * Create new instance
     * @return {VehicleComponentContainer}
     */
    constructor( parent, jsondata) {
        base.constructor();
        this.__parent = parent;
        this.__interface = VehicleComponent;

        // TODO: Remove slashes
        local data = JSONParser.parse(str_replace("\\\\", "", jsondata));

        foreach (idx, component in data) {
            local entityClass = compilestring("return " + component.type + ";")();
            this.add(component.id, entityClass(component));
        }
    }

    /**
     * Override add method
     * checks if commpoent can be inserted into container
     * @param {Mixed} id
     * @param {VehicleCompoenent} component
     * @return {Boolean}
     */
    function add(id, component) {
        if (!component.insertable(this)) {
            throw "VehicleContainer: Cannot insert more entities of this type!";
        }

        component.id = id;
        component.parent = this.__parent;
        // NOTE: afte transformation form component to item instance the last one should've 0 decay
        component.decay = getTimestamp() + component.default_decay;

        return base.add(id, component);
    }

    function push(component) {
        return this.add(this.len(), component);
    }

    /**
     * Meta impelemtation for set
     * @param {Integer} name
     * @param {Object} value
     */
    function _set(playerid, value) {
        throw "PlayerContainer: you cant insert new data directly!";
    }

    /**
     * Serialize current container
     * content into json string
     * @return {String}
     */
    function serialize() {
        local data = [];

        foreach (idx, component in this) {
            data.push(component.serialize());
        }

        return JSONEncoder.encode(data);
    }

    /**
     * Try to find array of components by id or type
     * @param  {Mixed} idOrType
     * @return {Array}
     */
    function find(idOrType) {
        local results = [];

        if (typeof idOrType == "string") {
            foreach (idx, component in this) {
                if (idx == id || component.classname == idOrType) {
                    results.push(component);
                }
            }
        } else if (typeof(idOrType) == "class") {
            foreach (idx, component in this) {
                if (component instanceof idOrType) {
                    results.push(component);
                }
            }
        }

        return results;
    }

    /**
     * Try to find single component by
     * id or type, or null. Note: it will take 0 array element
     * if there are more than 1 components found
     * @param  {Mixed} idOrType
     * @return {VehicleCompoenent}
     */
    function findOne(idOrType) {
        local results = this.find(idOrType);
        return (results.len()) ? results[0] : null;
    }
}
