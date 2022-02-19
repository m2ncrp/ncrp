class SnowplowNode extends ORM.Entity {

    static classname = "SnowplowNode";
    static table = "tbl_snowplow_nodes";

    static fields = [
        ORM.Field.Integer({ name = "timestamp" }),
    ];
}
