class Property extends ORM.Entity
{
    static classname = "Property";
    static table = "tbl_property";

    static fields = [
        ORM.Field.Integer({ name = "ownerid" }),
        ORM.Field.String ({ name = "title" }),
        ORM.Field.Integer({ name = "state" }),
        ORM.Field.Integer({ name = "type" }),
        ORM.Field.String ({ name = "area", value = "" }),
        ORM.Field.String ({ name = "data", value = "" }),
        ORM.Field.Float  ({ name = "price", value = 0.0 }),
    ];

    static State = {
        Free        = 0,
        Purchased   = 1,
    };

    static traits = [
        ORM.Trait.Positionable(),
    ];

    temp = null;

    // constructor () {
    //     base.constructor();
    // }

    function hydrated() {
        this.temp = {
            text = create3DText(this.x, this.y, this.z, format("Property: %s", this.title), CL_CRUSTA);
        };
    }

    function clear() {
        if (this.temp && this.temp.text) {
            remove3DText(this.temp.text);
        }
    }
}
