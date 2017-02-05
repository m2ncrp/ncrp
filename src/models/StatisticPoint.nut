class StatisticPoint extends ORM.Entity {

    static classname = "StatisticPoint";
    static table = "stat_points";

    static fields = [
        ORM.Field.String({ name = "type", }),
        ORM.Field.String({ name = "additional", }),
        ORM.Field.String({ name = "created" })
    ];

    static traits = [
        ORM.Trait.Positionable()
    ];
}
