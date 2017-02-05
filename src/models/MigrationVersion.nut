class MigrationVersion extends ORM.Entity {

    static classname = "MigrationVersion";
    static table = "service_migration";

    static fields = [
        ORM.Field.Integer({ name = "current", })
    ];
}
