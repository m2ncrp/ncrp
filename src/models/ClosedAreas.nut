class ClosedAreas extends ORM.Entity
{
    static classname = "ClosedAreas";
    static table = "tbl_closed_areas";

    static fields = [
        ORM.Field.Integer({ name = "type" }),
        ORM.Field.Integer({ name = "parent" }),
        ORM.Field.String({ name = "name" }),
        ORM.Field.Integer({ name = "active" }),
        ORM.Field.String({ name = "data", value = "{}" }),
    ];
}
