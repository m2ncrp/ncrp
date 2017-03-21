class CarDealer extends ORM.Entity {

    static classname = "CarDealer";
    static table = "car_dealer";

    static fields = [
        ORM.Field.Integer({ name = "vehicleid" }),
        ORM.Field.Float  ({ name = "price", value = 100.0 }),
        ORM.Field.Integer({ name = "ownerid" }),
        ORM.Field.Integer({ name = "sold", value = 0 }),
    ];
}
