/**
 * A Container is an object created to hold other objects that
 * are accessed, placed, and maintained with the class methods
 * of the container.
 */
class Container
{
    /**
     * Storage for all Objects
     * {all the data descibes by user}
     * @type {Table}
     */
    __data = null;

    /**
     * Array of ordered keys for __data
     * @type {Array}
     */
    __keys = null;

    /**
     * Reference to Class that'll be stored in Container
     * @type {[type]}
     */
    __ref  = null;



    /**
     * Create new instance
     * @return {Container}
     */
    constructor () {
        this.__data = {};
        this.__keys = [];

        this.__ref  = null;
    }

    /**
     * Return plain data table
     * @return {Table}
     */
    function getAll() {
        return this.__data;
    }

    /**
     * Alias for getting single Object or null
     * @param  {Integer} key
     * @return {Characer}
     */
    function get(key) {
        return this[key];
    }

    /**
     * Return if key is in the array
     * @param  {Integer} key
     * @return {Boolean}
     */
    function exists(key) {
        return (key in this.__data);
    }

    /**
     * Store new Object record inside
     * @param {Integer} key
     * @param {Object} Object
     */
    function add(key, object) {
        if (!(object instanceof __ref)) {
            throw "Container: could not add unexpected entity."
        }

        if (key in this.__data) {
            throw "Container: can't insert key. It's already exists."
        }

        // store data
        this.__data[key] <- object;
        this.__keys.push(key);

        return true;
    }

    /**
     * Remove Object from storage by key
     * @param  {Integer} key
     * @return {Object} Object which should be removed, or null
     */
    function remove(key)
    {
        // return null if no records
        if (!this.exists(key)) return null;

        // save temp and return data
        local temp = this[key];
        delete this.__data[key];

        // remove key
        this.__keys.remove(this.__keys.find(key));

        // return data
        return temp;
    }

    /**
     * Swap 2 elements, if they exist
     * @param  {Integer} key1
     * @param  {Integer} key2
     * @return {Boolean}
     */
    function swap(key1, key2)
    {
        // return null if no records
        if (!this.exists(key1) || !this.exists(key2)) return false;

        local indx1 = this.__keys.find(key1);
        local indx2 = this.__keys.find(key2);

        local temp        = this.__data[key1];
        this.__data[key1] = this.__data[key2];
        this.__data[key2] = temp;

        this.__keys.remove(indx1);
        this.__keys.insert(indx1, key2);
        this.__keys.remove(indx2);
        this.__keys.insert(indx2, key1);

        return true;
    }

    /**
     * Trigger callback for all objects
     * @param  {Function} callback
     * @param  {Boolean}  full true if only key should be inserted.
     *          Otherwise object itself also should be inserted too
     */
    function each(callback, full = false) {
        foreach (key, object in this.__data) {
            if (full) callback(key, object); else callback(key);
        }
    }

    /**
     * Override for default len method
     * Get size of current players array
     * @return {Integer}
     */
    function len() {
        return this.__data.len();
    }

    /**
     * Meta implementation for get
     * @param  {Integer} key
     * @return {Object}
     */
    function _get(key) {
        if (this.exists(key)) {
            return this.__data[key];
        }
        throw null;
    }

    /**
     * Meta impelemtation for set
     * @param {Integer} name
     * @param {Object} object
     */
    function _set(playerid, object) {
        if (!(object instanceof __ref)) {
            throw "Container: could not add unexpected entity."
        }

        if (!(name in this.__data)) {
            this.__data[playerid] <- object;
        } else {
            this.__data[playerid] = object;
        }

        return true;
    }

    /**
     * Meta method used for foreach loop
     * @param  {Integer} previous key
     * @return {Integer} next key
     */
    function _nexti(prev_key) {
        if (prev_key == null) {
            return this.__keys.len() ? this.__keys[0] : null;
        }

        // find next key index
        local key = this.__keys.find(prev_key) + 1;

        // chec if key is in array
        if (key in this.__keys) {
            return this.__keys[key];
        }

        // finish foreach
        return null;
    }
}