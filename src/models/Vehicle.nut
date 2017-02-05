class Vehicle extends ORM.Entity {

    static classname = "Vehicle";
    static table = "tbl_vehicles";

    static fields = [
        ORM.Field.String  ({ name = "owner",    value = "" }), // character owner name
        ORM.Field.Integer ({ name = "ownerid",   value = -1 }), // character owner name
        ORM.Field.Integer ({ name = "model",    value = 35 }), // vehicle model
        ORM.Field.String  ({ name = "plate",    value = "NCRP" }),
        ORM.Field.Integer ({ name = "tunetable", value = 0 }),
        ORM.Field.Float   ({ name = "dirtlevel", value = 0.0 }),
        ORM.Field.Float   ({ name = "fuellevel", value = 15.0 }),
        ORM.Field.Integer ({ name = "fwheel",   value = 0 }),
        ORM.Field.Integer ({ name = "rwheel",   value = 0 }),
    ];

    // predefiend collections of fields
    static traits = [
        ORM.Trait.Positionable(), // adds fields float x, float y, float z
        ORM.Trait.Rotationable(), // adds fields float rx, float ry, float rz
        ColorableA() // adds cra, cga, cba
        ColorableB() // adds crb, cgb, cbb
    ];
}
