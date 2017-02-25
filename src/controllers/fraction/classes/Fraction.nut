class Fraction extends ORM.Entity
{
    static classname = "Fraction";
    static table = "tbl_fractions";

    static fields = [
        ORM.Field.String({ name = "type", value = "default" }),
        ORM.Field.String({ name = "title", value = "Default Fraction" }),
        ORM.Field.String({ name = "shortcut", value = "" }),
        ORM.Field.Integer({ name = "parent" }),
        ORM.Field.Integer({ name = "created" }),
        ORM.Field.Float({ name = "money" }),
    ];

    roles = null;
    members = null;
    memberRoles = null;
    // __globalroles = null;

    constructor () {
        base.constructor();

        this.memberRoles = Container(FractionRole);
        this.roles       = Container(FractionRole);
        this.members     = Container(null);
    }

    /**
     * Check if player exists inside fraction
     * @param  {Integer} playerid
     * @return {Boolean}
     */
    function exists(playerid) {
        return ::isPlayerLoaded(playerid) && this.memberRoles.exists(players[playerid].id);
    }

    /**
     * Adding new member to the fraction
     * @param {Integer}  key
     * @param {FractionRole}  value
     * @param {Boolean} useplayerid
     */
    function add(key, value, useplayerid = true) {
        if (useplayerid) {
            if (isPlayerLoaded(key)) {
                key = players[playerid].id;
            } else {
                throw "Fraction: Cannot add non-existant player!";
            }
        }

        this.memberRoles.set(key, value);
    }

    /**
     * Try to get fraction value
     * then try to find member by key(playerid)
     * @param  {Mixed} key
     * @return {Mixed}
     */
    function get(key) {
        if (key in this.__data) {
            return this.__data[key];
        }

        if (this.exists(key)) {
            return this.memberRoles.get(players[key].id);
        }

        throw null;
    }

    /**
     * Try to set fraction value
     * then (if not found) try to set member by playerid
     * @param {Mixed} key
     * @param {Mixed} value
     */
    function set(key, value) {
        if (base.set(key, value) == null) {
            if (::isPlayerLoaded(key) && this.memberRoles.add(players[key].id, value)) {
                return true;
            }

            throw null;
        }
    }

    function getMembers() {
        return this.memberRoles;
    }
}
