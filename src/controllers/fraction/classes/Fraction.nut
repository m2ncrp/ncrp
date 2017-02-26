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
    memberRoles = null;
    // __globalroles = null;

    constructor () {
        base.constructor();

        this.memberRoles = Container(FractionRole);
        this.roles       = Container(FractionRole);
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
     * or setting role for existant one
     * @param {Integer}  key
     * @param {FractionRole|Mixed} role
     * @param {Boolean} useplayerid (use player id or character id)
     */
    function set(key, role, useplayerid = true) {
        if (useplayerid) {
            if (isPlayerLoaded(key)) {
                key = players[key].id;
            } else {
                throw "Fraction: Cannot add non-existant player!";
            }
        }

        if (!(role instanceof FractionRole)) {
            if (roles.has(role)) {
                role = roles[role];
            } else {
                throw "Fraction: Cannot add member with non-existant role";
            }
        }

        local object;

        if (!this.memberRoles.has(key)) {
            object = FractionMember();
            object.created = getTimestamp();
            object.fractionid = this.id;
            object.characterid = key;
        } else {
            object = this.memberRoles.get(key);

            // check if we already have this role
            if (object.id == role.id) {
                return false;
            }
        }

        object.roleid = role.id;
        object.save();

        this.memberRoles.set(key, role);
        return true;
    }

    /**
     * Alias for set
     */
    function add(key, role, useplayerid = true) {
        return this.set(key, role, useplayerid);
    }

    /**
     * Remove player from fraction
     * @param  {Integer} key
     * @param  {Boolean} useplayerid (use player id or character id)
     */
    function remove(key = 0, useplayerid = true) {
        if (useplayerid) {
            if (isPlayerLoaded(key)) {
                key = players[key].id;
            } else {
                throw "Fraction: Cannot remove non-existant player!";
            }
        }

        if (!this.memberRoles.has(key)) {
            throw "Fraction: Cannot remove non-member from fraction!";
        }

        ORM.Query("delete from @FractionMember where fractionid = :fid and characterid = :cid")
            .setParameter("fid", this.id)
            .setParameter("cid", key)
            .execute();

        this.memberRoles.remove(key);
    }

    /**
     * Remove fraction
     */
    function removeFraction() {
        base.remove();
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

    function getMembers() {
        return this.memberRoles;
    }
}
