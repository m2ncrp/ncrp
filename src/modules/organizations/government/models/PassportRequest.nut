class PassportRequest extends ORM.Entity {

    static classname = "PassportRequest";
    static table = "tbl_passport_requests";

    static fields = [
        ORM.Field.Integer({ name = "charid" }),
        ORM.Field.String({ name = "fio" }),
        ORM.Field.Integer({ name = "gender" }),
        ORM.Field.String({ name = "nationality" }),
        ORM.Field.String({ name = "birthdate" }),
        ORM.Field.Integer({ name = "hair" }),
        ORM.Field.Integer({ name = "eyes" }),
        ORM.Field.String({ name = "status" }),
        ORM.Field.String({ name = "reason", value = "" }),
        ORM.Field.String({ name = "examiner", value = "" }),
    ];

}