class Character extends ORM.Entity {

    static classname = "Character";
    static table = "tbl_characters";

    static fields = [
        ORM.Field.String({  name = "name" }),
        ORM.Field.Float({   name = "money" }),
        ORM.Field.Integer({ name = "dskin" }),
        ORM.Field.Integer({ name = "cskin" }),
        ORM.Field.Integer({ name = "spawnid" }),
        ORM.Field.String({  name = "job" }),
        ORM.Field.Float({   name = "housex", value = 0.0 }),
        ORM.Field.Float({   name = "housey", value = 0.0 }),
        ORM.Field.Float({   name = "housez", value = 0.0 }),
        ORM.Field.Integer({ name = "xp", value = 0 })
        ORM.Field.Float({   name = "deposit", value = 0.0 }),
        ORM.Field.String({  name = "locale", value = "en" }),
    ];

    request = null;
}
