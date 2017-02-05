class Treasury extends ORM.Entity {

    static classname = "Treasury";
    static table = "tbl_treasury";

    static fields = [
        ORM.Field.Float({ name = "amount" }),
        ORM.Field.Float({  name = "tax_roads" }),
        ORM.Field.Float({  name = "tax_salary" }),
    ];

}
