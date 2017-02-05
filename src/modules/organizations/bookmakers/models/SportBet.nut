class SportBet extends ORM.Entity {

    static classname = "SportBet";
    static table = "sport_bets";

    static fields = [
        ORM.Field.String({  name = "name" }),
        ORM.Field.Integer({ name = "participant" }),
        ORM.Field.Float  ({ name = "amount" }),
        ORM.Field.Float  ({ name = "fraction" }),
    ];

}
