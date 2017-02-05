class TeleportPosition extends ORM.Entity
{
    static classname = "TeleportPosition";
    static table = "tbl_teleports";

    static fields = [
        ORM.Field.String({ name = "name" }),
    ];

    static traits = [
        ORM.Trait.Positionable()
    ];
}
