class Fraction extends ORM.JsonEntity
{
    static classname = "Fraction";
    static table = "tbl_fractions";

    static fields = [
        ORM.Field.String({ name = "type", value = "default" }),
        ORM.Field.String({ name = "title", value = "Default Fraction" }),
        ORM.Field.String({ name = "shortcut", value = "" }),
        ORM.Field.Integer({ name = "parent" }),
        ORM.Field.Integer({ name = "created" }),
        // ORM.Field.String({ name = "data" }),
        ORM.Field.Float({ name = "money" }),
    ];

    roles = null;
    sroles = null;
    property = null;
    memberRoles = null;
    // __globalroles = null;

    constructor () {
        base.constructor();

        this.roles       = Container(FractionRole);
        this.sroles      = Container(FractionRole);
        this.memberRoles = Container(FractionRole);
        this.property    = Container(FractionProperty);
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
            if (this.roles.has(role)) {
                role = this.roles[role];
            } else {
                throw "Fraction: Cannot add member with non-existant role";
            }
        }

        // remove old member record
        if (this.memberRoles.has(key)) {
            local oldrole = this.memberRoles.get(key);

            // check if we already have this role
            if (oldrole.id == role.id) {
                return false;
            }

            this.remove(key, false);
        }

        local object = FractionMember();
        object.created = getTimestamp();
        object.fractionid = this.id;
        object.characterid = key;
        object.roleid = role.id;
        object.save();

        this.memberRoles.set(key, role);

        local mmrs = this.memberRoles;

        this.memberRoles.__keys.sort(function(a, b) {
            if (mmrs[a].level > mmrs[b].level) return 1;
            if (mmrs[a].level < mmrs[b].level) return -1;
            if (mmrs[a].id > mmrs[b].id) return 1;
            if (mmrs[a].id < mmrs[b].id) return -1;
            return 0;
        });

        return true;
    }

    /**
     * Alias for set
     */
    function add(key, role, useplayerid = true) {
        return this.set(key, role, useplayerid);
    }

    function len() {
        return this.memberRoles.len();
    }

    /**
     * Remove player from fraction
     * @param  {Integer} key
     * @param  {Boolean} useplayerid (use player id or character id)
     */
    function remove(key = -1, useplayerid = true) {
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

    function hasRole(role) {
        if (!(role instanceof FractionRole)) {
            if (roles.has(role)) {
                role = roles[role];
            } else {
                throw "Fraction: Cannot check non-existant role";
            }
        }

        foreach (idx, value in this.roles) {
            if (value.id == role.id) {
                return true;
            }
        }

        return false;
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

    /**
     * DEPREACTED
     * @return {[type]} [description]
     */
    function sortRoles() {
        local rls = this.roles;

        rls.__keys.sort(function(a, b) {
            if (rls[a].level > rls[b].level) return 1;
            if (rls[a].level < rls[b].level) return -1;
            return 0;
        });
    }

    /**
     * Get current members
     * @return {Container}
     */
    function getMembers() {
        return this.memberRoles;
    }

    /**
     * Return array of player ids
     * of online fraction members
     * @return {Array}
     */
    function getOnlineMembers() {
        local members = [];

        foreach (characterid, role in this.getMembers()) {
            if (!xPlayers.has(characterid)) {
                continue;
            }

            local character = xPlayers[characterid];

            if (::isPlayerLoaded(character.playerid)) {
                members.push(character.playerid);
            }
        }

        return members;
    }
}
