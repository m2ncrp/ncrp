class Property extends ORM.JsonEntity {

    static classname = "Property";
    static table = "tbl_property";

    static fields = [
        ORM.Field.String ({ name = "title" }),
        ORM.Field.String ({ name = "type" }),
        ORM.Field.String ({ name = "subtype" }),
        ORM.Field.String ({ name = "name" }),
        ORM.Field.Integer({ name = "ownerid" })
        ORM.Field.Float  ({ name = "basePrice" }),
        ORM.Field.Float  ({ name = "purchaseprice" }),
        ORM.Field.Float  ({ name = "salePrice" }),
        ORM.Field.String ({ name = "state" })
    ];

    inventory = null;
}
