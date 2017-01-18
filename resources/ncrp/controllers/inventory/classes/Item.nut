Item <- {};

class Item.Item extends ORM.Entity
{
    static classname = "Item.Item";
    static table = "tbl_items";

    fields = [
        ORM.Field.Integer({ name = "type",  value = ITEM_TYPE.NONE  }),
        ORM.Field.Integer({ name = "state", value = ITEM_STATE.NONE }),
        ORM.Field.Integer({ name = "slot",  value = 0 }),
        ORM.Field.Integer("parent"),
        ORM.Field.Integer("amount"),
        ORM.Field.Integer("created"),
        ORM.Field.String({ name = "data",   value = "{}"}),
    ];

    traits = [
        ORM.Trait.Positionable(),
    ];

    stackable   = false;
    maxstack    = 0;
    weight      = 1.0;
    name        = "Default Item"; // ?

    constructor () {
        base.constructor();

        if (this.created == 0) {
            this.created = getTimestamp();
        }
    }
}

class Item.None extends Item.Item {
    static classname = "Item.None";
    constructor (slot = 0) {
        base.constructor();
        this.slot = slot;
    }

    function save() {
        return;
    }
}
