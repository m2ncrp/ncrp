class Contract extends ORM.JsonEntity {

    static classname = "Contract";
    static table = "tbl_contracts";

    static fields = [
        ORM.Field.Integer({ name = "ownerid" }),
        ORM.Field.Integer({ name = "contractorid" }),
        ORM.Field.Integer({ name = "created" }),
        ORM.Field.Integer({ name = "expired" }),
        ORM.Field.String ({ name = "status" })
    ];
}