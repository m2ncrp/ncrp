class CarDealer extends ORM.JsonEntity {

    static classname = "CarDealer";
    static table = "car_dealer";

    static fields = [
        ORM.Field.Integer({ name = "vehicleid" }),
        ORM.Field.Float  ({ name = "price", value = 0.0 }),
        ORM.Field.Integer({ name = "ownerid" }),
        ORM.Field.String ({ name = "status" }),
        ORM.Field.Float  ({ name = "total_price", value = 0.0 }),
        ORM.Field.Integer({ name = "until" }),
        ORM.Field.Integer({ name = "created" }),
    ];
}
