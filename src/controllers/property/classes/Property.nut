class Property extends ORM.Entity
{
    static classname = "Property";
    static table = "tbl_property";

    static fields = [
        ORM.Field.Integer({ name = "ownerid" }),
        ORM.Field.String ({ name = "title" }),
        ORM.Field.Integer({ name = "type" }),
        ORM.Field.String ({ name = "area", value = "" }),
        ORM.Field.String ({ name = "data", value = "" }),
        ORM.Field.Float  ({ name = "price", value = 0.0 }),
    ];

    static traits = [
        ORM.Trait.Positionable(),
    ];
}
