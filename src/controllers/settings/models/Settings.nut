class Settings extends ORM.Entity {

    static classname = "Settings";
    static table = "adm_settings";

    static fields = [
        ORM.Field.String({ name = "name" }),
        ORM.Field.String({ name = "value" }),
    ];

}