class Government extends ORM.Entity {

    static classname = "Government";
    static table = "tbl_government";

    static fields = [
        ORM.Field.String({ name = "name" }),
        ORM.Field.String({ name = "desc" }),
        ORM.Field.String({ name = "unit" }),
        ORM.Field.Float({ name = "value" }),
        ORM.Field.Float({ name = "next" }),
        ORM.Field.Integer({ name = "until", value = 0 }),
    ];

}