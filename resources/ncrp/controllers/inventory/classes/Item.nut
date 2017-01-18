class ShortIntTypeField extends ORM.Field.Integer {
    static size = 3;
}

class Item extends ORM.Entity
{
    static classname = "Item";
    static table = "tbl_items";

    static fields = [
        ShortIntTypeField({ name = "type",  ITEM_TYPE.NONE  }),
        ShortIntTypeField({ name = "state", ITEM_STATE.NONE }),
        ORM.Field.Integer("parent"),
        ORM.Field.Integer("created"),
        ORM.Field.String("data"),
    ];

    id          = 0;
    stackable   = false;
    maxstack    = 0;
    weight      = 1.0;
    name        = "Default Item"; // ?
    img         = "none.jpg";
}

class WeaponItem extends Item {
    capacity = 0;
}
