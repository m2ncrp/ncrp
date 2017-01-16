class Item extends ORM.Entity
{
    static classname = "Item";
    static table = "tbl_items";

    static fields = [
        ORM.Field.String({ name = "state" })
        ORM.Field.String({ name = "type", value = "default" }),
        ORM.Field.String({ name = "name", value = "Default Organization" }),
        ORM.Field.Integer({ name = "parent" }),
        ORM.Field.Integer({ name = "created" }),
    ];
}
