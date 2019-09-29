class Handshake extends ORM.Entity {

    static classname = "Handshake";
    static table = "tbl_handshakes";

    static fields = [
        ORM.Field.Integer({ name = "char" }),
        ORM.Field.Integer({ name = "target" }),
        ORM.Field.String ({ name = "text" }),
    ];
}
