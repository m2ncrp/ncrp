class FractionProperty extends ORM.Entity
{
    static classname = "FractionProperty";
    static table = "tbl_fraction_property";

    static fields = [
        ORM.Field.Integer   ({ name = "fractionid"  }),
        ORM.Field.Integer   ({ name = "created"     }),
        ORM.Field.String    ({ name = "type",       value = "" }),
        ORM.Field.Integer   ({ name = "entityid",   value = -1 }),
    ];
}
