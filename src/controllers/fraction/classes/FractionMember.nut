class FractionMember extends ORM.JsonEntity
{
    static classname = "FractionMember";
    static table = "tbl_fraction_members";

    static fields = [
        ORM.Field.Integer({ name = "fractionid" }),
        ORM.Field.Integer({ name = "roleid" }),
        ORM.Field.Integer({ name = "characterid" }),
        ORM.Field.Integer({ name = "updated" }),
        ORM.Field.Integer({ name = "created" }),
    ];

    role = null;
    character = null; // not implemented

    function save() {
        if (!this.created) {
            this.created = getTimestamp();
        }

        // prevent db saving if no actuall changes happend
        if (this.__modified.len() < 1) {
            return;
        }

        this.updated = getTimestamp();
        base.save();
    }

    /**
     * Try to find if particular permission is allowed for
     * current member role
     * @param  {Array|String} permissions
     * @return {Boolean}
     */
    function permitted(permissions) {
        if (!this.role) {
            return false;
        }

        if (typeof permissions != "array") {
            permissions = [permissions];
        }

        if (!permissions.len()) {
            return true;
        }

        local requiredPerms = [];

        if ("perms" in this.role.data) {
            requiredPerms = this.role.data.perms;
        }
        else if ("permissions" in this.role.data) {
            requiredPerms = this.role.data.permissions;
        }

        return permissions
            .map(@(perm) requiredPerms.find(perm) != null)
            .reduce(@(a, b) a || b)
        ;
    }
}
