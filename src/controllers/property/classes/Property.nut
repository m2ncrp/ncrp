class Property extends ORM.JsonEntity {
    static classname = "Property";
    static table = "tbl_property";

    static fields = [
        ORM.Field.String ({ name = "type" }),
        ORM.Field.String ({ name = "building" }),
        ORM.Field.String ({ name = "title" }),
        ORM.Field.Integer({ name = "state" }),
        ORM.Field.Integer({ name = "type" }),
        ORM.Field.String ({ name = "area", value = "" }),
        ORM.Field.Float  ({ name = "price", value = 0.0 }),
    ];

    static State = {
        Free        = 0,
        Purchased   = 1,
    };
 }
