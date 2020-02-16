class Bank extends ORM.JsonEntity {

    static classname = "Bank";
    static table = "tbl_bank";

    static fields = [
        ORM.Field.Integer({ name = "ownerid" }),
        ORM.Field.String ({ name = "type" }),
        ORM.Field.Float  ({ name = "amount", value = 0.0 }),
        ORM.Field.Float  ({ name = "rate", value = 0.0 }),
        ORM.Field.Float  ({ name = "interest", value = 0.0 })
        // ORM.Field.Integer({ name = "until" }),
        // ORM.Field.Integer({ name = "created" }),
    ];

}