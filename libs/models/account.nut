class Account extends ORM.Entity {
    
    static classname = "Account";
    static table = "tbl_accounts";

    static fields = [
        ORM.Field({ name = "username", type = "string", size = 255 }),
        ORM.Field({ name = "password", type = "string", size = 255 })
    ];
}
