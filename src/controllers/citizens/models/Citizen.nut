class Citizen extends ORM.Entity {

    static classname = "Citizen";
    static table = "tbl_citizens";

    static fields = [
        ORM.Field.Float     ({ name = "health",     value = 720.0 }),
        ORM.Field.Float     ({ name = "money",      value = 0.0 }),
        ORM.Field.Float     ({ name = "hunger",     value = 100.0 }),
        ORM.Field.Float     ({ name = "thirst",     value = 100.0 }),
        ORM.Field.Float     ({ name = "mood",       value = 100.0 }),
        ORM.Field.String    ({ name = "next_action" }),
        ORM.Field.Integer    ({ name = "timestamp" }),
    ];
}
