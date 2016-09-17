class Character extends ORM.Entity {
    
    static classname = "Character";
    static table = "tbl_characters";

    static fields = [
        ORM.Field.Integer({ name = "account_id" }), // relation to account
        ORM.Field.String({ name = "firstname" }), // character firstname and lastname
        ORM.Field.String({ name = "lastname" }), //     may be different from player ones
        ORM.Field.Integer({ name = "age", value = 35 }),
        ORM.Field.Float({ name = "money", value = 10.0 })
    ];

    // predefiend collections of fields
    static traits = [
        ORM.Trait.Positionable() // adds fields float x, float y, float z
    ];
}
