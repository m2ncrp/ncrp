class Item.Abstract extends ORM.Entity
{
    static classname = "Item.Abstract";
    static table = "tbl_items";

    fields = [
        ORM.Field.Integer({ name = "type", value = 0 }),
        ORM.Field.Integer({ name = "state", value = Item.State.NONE }),
        ORM.Field.Integer({ name = "slot", value = 0 }),
        ORM.Field.Integer({ name = "decay", valie = 0 }),
        ORM.Field.Integer({ name = "parent", value = 0}),
        ORM.Field.Integer({ name = "amount", value = 0}),
        ORM.Field.Integer({ name = "created", value = 0 }),
        ORM.Field.String({ name = "data", value = ""}),
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

        this.data = {};
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

    function setData(name, value) {
        this.data[name] <- value;
    }

    function getData(name) {
        return name in this.data ? this.data[name] : null;
    }

    function hydrate(data) {
        local entity = base.hydrate(data);
        entity.data = JSONParser.parse(entity.data);
        return entity;
    }

    function save() {
        local temp = this.data;
        this.data = JSONEncoder.encode(temp);
        base.save();
        this.data = temp;
        return true;
    }

    static function getType() {
        return "Item.Abstract";
    }
}
