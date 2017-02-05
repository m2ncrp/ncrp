class StatisticText extends ORM.Entity {

    static classname = "StatisticText";
    static table = "stat_texts";

    static fields = [
        ORM.Field.String({ name = "type" }),
        ORM.Field.String({ name = "author", value = "" }),
        ORM.Field.Text  ({ name = "content" }),
        ORM.Field.String({ name = "additional", value = "" }),
        ORM.Field.String({ name = "created" })
    ];

    static traits = [
        ORM.Trait.Positionable()
    ];
}
