class Account extends ORM.Entity {
    
    static classname = "Account";
    static table = "tbl_accounts";

    static fields = [
        ORM.Field.String({ name = "username" }),
        ORM.Field.String({ name = "password" })
    ];
}
