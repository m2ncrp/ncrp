class Account extends ORM.Entity {

    static classname = "Account";
    static table = "tbl_accounts";

    static fields = [
        ORM.Field.String({ name = "username" }),
        ORM.Field.String({ name = "password" }),
        ORM.Field.String({ name = "ip" }),
        ORM.Field.String({ name = "serial" }),
        ORM.Field.Float ({ name = "money" }),
        ORM.Field.String({ name = "locale", value = "en" }),
        ORM.Field.String({ name = "layout", value = "qwerty" }),
        ORM.Field.Integer({ name = "created", value = 0 }),
        ORM.Field.Integer({ name = "logined", value = 0 }),
        ORM.Field.String ({ name = "email", value = "" }),
        ORM.Field.Integer({ name = "moderator", value = 0 }), // moderator access level
        ORM.Field.Integer({ name = "warns", value = 0 }), //the number of player warnings
        ORM.Field.Integer({ name = "blocks", value = 0 }) //the number of player blocks
    ];
}
