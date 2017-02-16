class FractionRole extends ORM.Entity {

    static classname = "FractionRole";
    static table = "tbl_fraction_roles";

    static fields = [
        ORM.Field.Integer({ name = "fractionid" }),
        ORM.Field.String({ name = "title" }),
        ORM.Field.String({ name = "shortcut", value = null, nullable = true }),
        ORM.Field.Integer({ name = "created" }),
        ORM.Field.Integer({ name = "level", value = 0 }),
    ];
}
