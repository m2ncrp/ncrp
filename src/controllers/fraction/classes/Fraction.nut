class Fraction extends ORM.JsonEntity
{
    static classname = "Fraction";
    static table = "tbl_fractions";

    static fields = [
        ORM.Field.String({ name = "type", value = "default" }),
        ORM.Field.String({ name = "title", value = "Default Fraction" }),
        ORM.Field.String({ name = "shortcut", value = "" }),
        ORM.Field.Integer({ name = "parent" }),
        ORM.Field.Integer({ name = "created" }),
        ORM.Field.Float({ name = "money", value = null }),
    ];

    roles    = null;
    members  = null;
    property = null;

    constructor () {
        base.constructor();

        this.roles      = ContainerFractionRoles();
        this.members    = ContainerFractionMembers();
        this.property   = Container(FractionProperty);
    }
}
