class Door extends ORM.Entity {

    static classname = "Door";
    static table = "tbl_door";

    static fields = [
        ORM.Field.String ({ name = "name" }),
        ORM.Field.String ({ name = "state" })
    ];
}
