class SportEvents extends ORM.Entity {

    static classname = "SportEvents";
    static table = "sport_events";

    static fields = [
        ORM.Field.String ({ name = "type" }),
        ORM.Field.Integer({ name = "team1" }),
        ORM.Field.Integer({ name = "team2" }),
        ORM.Field.String ({ name = "date" }),
    ];
}
