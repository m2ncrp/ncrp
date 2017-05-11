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

    function save() {
        if (!this.created) {
            this.created = getTimestamp();
        }

        this.updated = getTimestamp();
        base.save();
    }
}
