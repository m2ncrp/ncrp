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

        local perms = [];

        if ("perms" in this.role.data) {
            perms = this.role.data.perms;
        }
        else if ("permissions" in this.role.data) {
            perms = this.role.data.permissions;
        }

        return permissions
            .map(function(perm) {
                return perms.find(perm) != null;
            })
            .reduce(function(a, b) {
                return a || b;
            })
        ;
    }
}
