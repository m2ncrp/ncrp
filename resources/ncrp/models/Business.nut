class Business extends ORM.Entity {

    static classname = "Business";
    static table = "tbl_businesses";

    static fields = [
        ORM.Field.String  ({ name = "name",  value = "Business" }),
        ORM.Field.String  ({ name = "owner", value = "" }), // character owner name
        ORM.Field.Float   ({ name = "price", value = 10000.0 }),
        ORM.Field.Float   ({ name = "income",value = 15.0 }),
        ORM.Field.Integer ({ name = "type",  value = 0 }),
    ];

    // predefiend collections of fields
    static traits = [
        ORM.Trait.Positionable(), // adds fields float x, float y, float z
    ];

    text1 = null;
    text2 = null;
    text3 = null;
    blip  = null;
    servid = 0;
}
