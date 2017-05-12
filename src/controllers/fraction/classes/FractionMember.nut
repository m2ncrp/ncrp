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
}
