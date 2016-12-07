class SportMember extends ORM.Entity {

    static classname = "SportMember";
    static table = "sport_members";

    static fields = [
        ORM.Field.String ({ name = "type" }),
        ORM.Field.String ({ name = "title" }),
        ORM.Field.Integer({ name = "wins" }),
        ORM.Field.Integer({ name = "total" }),
        ORM.Field.Float  ({ name = "modifier", value = 0.0 }),
    ];
}
