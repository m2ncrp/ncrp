class Property extends ORM.JsonEntity {

    static classname = "Property";
    static table = "tbl_property";

    static fields = [
        ORM.Field.String ({ name = "type" }),
        ORM.Field.String ({ name = "building" }),
        ORM.Field.String ({ name = "title" }),
        ORM.Field.String ({ name = "state" }),
    ];

    static State = {
        Free        = 0,
        Purchased   = 1,
    };


    temp = {};

    // constructor () {
    //     base.constructor();
    // }

    function hydrated() {
        log(this.title)
        //temp.text <- create3DText(this.data.coords.x, this.data.coords.y, this.data.coords.z, format("Property: %s", this.title), CL_CRUSTA);
    }

    // function clear() {
    //     if (this.temp && this.temp.text) {
    //         remove3DText(this.temp.text);
    //     }
    //
 }
