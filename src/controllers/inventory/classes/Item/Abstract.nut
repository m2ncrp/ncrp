class Item.Abstract extends ORM.Entity
{
    static classname = "Item.Abstract";
    static table = "tbl_items";

    fields = [
        ORM.Field.Integer({ name = "type",  value = 0 }),
        ORM.Field.Integer({ name = "state", value = Item.State.NONE }),
        ORM.Field.Integer({ name = "slot",  value = 0 }),
        ORM.Field.Integer({ name = "decay", valie = 0 }),
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
    weight      = 0.0;
    default_decay = 600;

    static name = "Default Item"; // ?

    constructor () {
        base.constructor();

        if (this.created == 0) {
            this.created = getTimestamp();
        }
    }

    function use(playerid, inventory) {
        dbg("classes/Item.nut: trying to use item. Make sure you've overriden this method for your item", this.classname, getIdentity(playerid));
    }

    function calculateWeight() {
        return this.weight;
    }

    function serialize() {
        local data = {
            classname   = this.classname,
            type        = this.getType(),
            slot        = this.slot,
            amount      = this.amount,
            weight      = this.calculateWeight(),
            id          = this.id,
        };

        if (this.x != 0.0 || this.y != 0.0 || this.z != 0.0) {
            data.x <- this.x;
            data.y <- this.y;
            data.z <- this.z;
        }

        return data;
        // return JSONEncoder.encode(data);
    }

    static function getType() {
        return "Item.Abstract";
    }
}
