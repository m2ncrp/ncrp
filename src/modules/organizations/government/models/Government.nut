class Government extends ORM.Entity {

    static classname = "Government";
    static table = "tbl_government";

    static fields = [
        ORM.Field.String({ name = "name" }),
        ORM.Field.Float({ name = "value" }),
        ORM.Field.Float({ name = "next" }),
        ORM.Field.Integer({ name = "until", value = 0 }),
        ORM.Field.Integer({ name = "created", value = 0 }),
    ];

}