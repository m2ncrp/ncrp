class Property extends ORM.JsonEntity {
    static classname = "Property";
    static table = "tbl_property";

    static fields = [
        ORM.Field.String({ name = "type" }),
        ORM.Field.String({ name = "building" }),
        ORM.Field.String({ name = "title" }),
        ORM.Field.String({ name = "state" }),
        ORM.Field.String({ name = "type" }),
    ];

    static State = {
        Free        = 0,
        Purchased   = 1,
    };
 }
