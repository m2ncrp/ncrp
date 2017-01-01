class PlayerContainer
{
    /**
     * Storage for all Character's
     * (basically all logined in players)
     * @type {Table}
     */
    __data = null;

    /**
     * Array of ordered keys for __data
     * @type {Array}
     */
    __keys = null;

    /**
     * Create new instance
     * @return {PlayerContainer}
     */
    constructor() {
        this.__data = {};
        this.__keys = [];
    }

    /**
     * Return plain data table
     * @return {Table}
     */
    function getAll() {
        return this.__data;
    }

    /**
     * @deprecated alias for getAll
     * @return {Table}
     */
    function getPlayers() {
        return this.getAll();
    }

    /**
     * Store new Character record inside
     * @param {Integer} playerid
     * @param {Character} character
     */
    function add(playerid, character) {
        if (!(character instanceof Character)) {
            throw "PlayerContainer: could not add non Character entity."
        }

        // store data
        this.__data[playerid] <- character;
        this.__keys.push(playerid);

        return true;
    }

    /**
     * Return if playerid is in the array
     * @param  {Integer} playerid
     * @return {Boolean}
     */
    function exists(playerid) {
        return (playerid in this.__data);
    }

    /**
     * Remove Character from storage by playerid
     * @param  {Integer} playerid
     * @return {Character} removed Character, or null
     */
    function remove(playerid)
    {
        // return null if no records
        if (!this.exists(playerid)) return null;

        // save temp and return data
        local temp = this[playerid];
        delete this.__data[playerid];

        // remove key
        this.__keys.remove(this.__keys.find(playerid));

        // return data
        return temp;
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
     * Alias for getting single Character or null
     * @param  {Integer} playerid
     * @return {Characer}
     */
    function get(playerid) {
        return this[playerid];
    }

    /**
     * Meta impelemtation for set
     * @param {Integer} name
     * @param {Character} value
     */
    function _set(playerid, value) {
        // if (!(name in this.__data)) {
        //     this.__data[playerid] <- value;
        // } else {
        //     this.__data[playerid] = value;
        // }
        throw "PlayerContainer: you cant insert new data directly!";
    }

    /**
     * Meta implementation for get
     * @param  {Integer} playerid
     * @return {Character}
     */
    function _get(playerid) {
        if (this.exists(playerid)) {
            return this.__data[playerid];
        }

        throw null;
    }

    /**
     * Meta method used for foreach loop
     * @param  {Integer} previd
     * @return {Integer} nextid
     */
    function _nexti(previd) {
        if (previd == null) {
            return this.__keys.len() ? this.__keys[0] : null;
        }

        // find next key index
        local key = this.__keys.find(previd) + 1;

        // chec if key is in array
        if (key in this.__keys) {
            return this.__keys[key];
        }

        // finish foreach
        return null;
    }

    /**
     * Deprecated
     * @param  {Integer} id
     * @return {Character}
     */
    function getPlayer(playerid) {
        return this.get(playerid);
    }

    /**
     * Trigger callback for all players
     * @param  {Function} callback
     * @param  {Boolean}  full should it only insert playerids, or character too
     */
    function each(callback, full = false) {
        foreach (playerid, character in this.__data) {
            if (full) callback(playerid, character); else callback(playerid);
        }
    }

    /**
     * Find nearest player id to particular player
     * @param  {Integer} playerid
     * @return {Integer}
     */
    function nearestPlayer(playerid) {
        local min = null;
        local closestid = null;

        // iterate over player, and calculate distance with each one
        foreach(targetid, data in this.getPlayers()) {
            local dist = getDistance(playerid, targetid);

            // compare with smallest, and if less - override smallest
            if ((dist < min || !min) && targetid != playerid) {
                min = dist;
                closestid = targetid;
            }
        }

        return closestid;
    }
}
