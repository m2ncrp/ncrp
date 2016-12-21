class Ban extends ORM.Entity {

    static classname = "Ban";
    static table = "adm_bans";

    static fields = [
        ORM.Field.String({ name = "type", value = "default" }),
        ORM.Field.String({ name = "name", value = "" }),
        ORM.Field.String({ name = "serial", value = "" }),
        ORM.Field.String({ name = "reason", value = "" }),
        ORM.Field.Integer({ name = "amount" }),
        ORM.Field.Integer({ name = "until" }),
        ORM.Field.Integer({ name = "created" }),
    ];

    constructor (...) {
        base.constructor();

        if (!vargv.len()) return;

        // put data
        this.name    = vargv[0];
        this.serial  = vargv[1];
        this.created = getTimestamp();
        this.until   = getTimestamp() + vargv[2];
        this.amount  = vargv[2];
        this.reason  = vargv[3];
    }
}
