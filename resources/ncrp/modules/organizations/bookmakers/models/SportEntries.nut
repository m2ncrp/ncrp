class SportEntries extends ORM.Entity {

    static classname = "SportEntries";
    static table = "sport_entries";

    static fields = [
        ORM.Field.String ({ name = "type" }),
        ORM.Field.String ({ name = "title" }),
        ORM.Field.Integer({ name = "wins" }),
        ORM.Field.Integer({ name = "total" }),
        ORM.Field.Float  ({ name = "modifier", value = 0.0 }),
    ];
}
