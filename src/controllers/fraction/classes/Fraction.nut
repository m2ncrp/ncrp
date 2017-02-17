class Fraction extends ORM.Entity {

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
        this.memberRoles = Container();
        this.memberRoles.__ref = FractionRole;

        this.roles = Container();
        this.roles.__ref = FractionRole;

        base.constructor();

        // this.__globalroles = Container();
        // this.__globalroles.__ref = FractionRole;
    }

    function exists(playerid) {
        return isPlayerLoaded(playerid) && this.memberRoles.exists(players[playerid].id);
    }

    function add(key, value) {
        dbg(value);
        return this.memberRoles.add(key, value);
    }

    function get(key) {
        if (base.get(key) != null) {
            return base.get(key);
        } else {
            if (this.exists(key)) {
                return this.memberRoles.get(key);
            }

            throw null;
        }
    }

    function set(key, value) {
        if (base.set(key, value) == null) {
            if (this.memberRoles.add(key, value)) {
                return true;
            }

            throw null;
        }
    }

    // function _get(key) {
    //     if (this.memberRoles && this.exists(key)) {
    //         return this.memberRoles.get(players[key].id);
    //     }

    //     try {
    //         base.get(key);
    //     }
    //     catch (e) {
    //         throw null;
    //     }
    // }

    // function _set(key, object) {
    //     try {
    //         base.set(key, object);
    //     }
    //     catch (e) {
    //         if (isPlayerLoaded(key) && this.memberRoles) {
    //             this.memberRoles.add(players[key].id, object);
    //         }
    //     }
    // }
}
