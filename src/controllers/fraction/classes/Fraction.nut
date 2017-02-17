class Fraction extends ORM.Entity {

    static classname = "Fraction";
    static table = "tbl_fractions";

    static fields = [
        ORM.Field.String({ name = "type", value = "default" }),
        ORM.Field.String({ name = "title", value = "Default Fraction" }),
        ORM.Field.String({ name = "shortcut", value = null, nullable = true }),
        ORM.Field.Integer({ name = "parent" }),
        ORM.Field.Integer({ name = "created" }),
        ORM.Field.Float({ name = "money" }),
    ];

    roles = null;
    members = null;
    // __globalroles = null;

    constructor () {
        this.members = Container();
        this.members.__ref = FractionMember;

        this.roles = Container();
        this.roles.__ref = FractionRole;

        base.constructor();

        // this.__globalroles = Container();
        // this.__globalroles.__ref = FractionRole;
    }

    function exists(playerid) {
        return isPlayerLoaded(playerid) && this.members.exists(players[playerid].id);
    }

    function _get(key) {
        if (this.members && this.members.exists(key)) {
            return this.members.get(players[key].id);
        }

        return base.get(key);
    }

    function _set(key, object) {
        try {
            base.set(key, object);
        }
        catch (e) {
            if (isPlayerLoaded(key) && this.members) {
                this.members.add(players[key].id, object);
            }
        }
    }
}
