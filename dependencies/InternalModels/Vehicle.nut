class Vehicle extends ORM.Entity {
    
    static classname = "Vehicle";
    static table = "tbl_vehicles";

    static fields = [
        ORM.Field.Integer({ name = "character_id" }), // character owner id
        ORM.Field.Integer({ name = "model", value = 35 }), // vehicle model
        ORM.Field.String({ name = "plate" }),
    ];

    // predefiend collections of fields
    static traits = [
        ORM.Trait.Positionable(), // adds fields float x, float y, float z
        ORM.Trait.Rotationable(), // adds fields float rx, float ry, float rz
        Colorable() // adds color_r, color_g, color_b
    ];
}
