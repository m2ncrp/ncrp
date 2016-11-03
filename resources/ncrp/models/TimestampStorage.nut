class TimestampStorage extends ORM.Entity
{
    static classname = "TimestampStorage";
    static table = "tbl_timestamp";

    static fields = [
        ORM.Field.Integer({ name = "timestamp" }),
        ORM.Field.Integer({ name = "operation", value = 0 })
    ];
}
