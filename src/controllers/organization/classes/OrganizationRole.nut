// Organization.types ??

class Organization extends ORM.Entity {

    static classname = "Organization";
    static table = "tbl_organizations";

    static fields = [
        ORM.Field.String({ name = "type", value = "default" }),
        ORM.Field.String({ name = "name", value = "Default Organization" }),
        ORM.Field.Integer({ name = "parent" }),
        ORM.Field.Integer({ name = "created" }),
    ];
}
