Item <- {};
ItemList <- {};

class Item.Item extends ORM.Entity
{
    static classname = "Item.Item";
    static table = "tbl_items";

    static fields = [
        ORM.Field.Integer({ name = "type",  value = ITEM_TYPE.NONE  }),
        ORM.Field.Integer({ name = "state", value = ITEM_STATE.NONE }),
        ORM.Field.Integer({ name = "slot",  value = 0 }),
        ORM.Field.Integer("parent"),
        ORM.Field.Integer("amount"),
        ORM.Field.Integer("created"),
        ORM.Field.String("data"),
    ];

    itemid      = 0;
    stackable   = false;
    maxstack    = 0;
    weight      = 1.0;
    name        = "Default Item"; // ?
    img         = "none.jpg"; // ?
}
